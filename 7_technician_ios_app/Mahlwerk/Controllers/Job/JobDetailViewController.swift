//
//  JobDetailViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 24.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPFioriFlows
import SAPOData
import SAPOfflineOData

enum JobDetailSegmentedControlState {
    case steps
}

class JobDetailViewController: UITableViewController, NavigationBarSegmentedControl {
    
    var segmentedControlState = JobDetailSegmentedControlState.steps
    private var _job: Job?
    var job: Job {
        get {
            if _job == nil {
                return Job(withDefaults: true)
            }
            return _job!
        }
        set {
            _job = newValue
        }
    }
    var taskStatus: TaskStatus?
    
    var odataService: OdataService<OfflineODataProvider>?
    var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Steps", "Materials"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        createObjectHeader()
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.odataService = odataService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    private func configureNavigationBar() {
        if let navbar = self.navigationController?.navigationBar {
            navbar.setValue(true, forKey: "hidesShadow")
        }
        
        addSegmentedControlToNavigationBar()
        
        if let jobStatus = JobStatus.init(rawValue: job.jobStatusID!) {
            if self.taskStatus == .active && jobStatus != .done && !job.suggested! {
                let changeStatusButton = UIBarButtonItem(image: FUIIconLibrary.app.changeStatus, style: .plain,
                                                         target: self,
                                                         action: #selector(changeStatusButtonClicked(sender:)))
                self.navigationItem.rightBarButtonItem = changeStatusButton
            }
        }
    }
    
    private func createObjectHeader() {
        let header = FUIObjectHeader(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 200))
        self.tableView.tableHeaderView = header
        header.headlineText = "\(job.title ?? "")"
        header.subheadlineText = "Machine: \(job.task?.machine?.name ?? "")"
        header.footnoteText = "Predicted Time: \(job.predictedWorkHours ?? 0) hrs"
        if let jobStatus = JobStatus.init(rawValue: job.jobStatusID!) {
            header.tags = [FUITag(title: "Status: \(jobStatus.text)")]
        }
    }
    
    func handleSegmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedControlState = .steps
        } 
        self.tableView.reloadData()
    }
    
    @objc func changeStatusButtonClicked(sender: UIButton) {
        let alert = UIAlertController(title: "Change Status", message: "Change Status of Job to \(JobStatus.done.text)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.job.jobStatusID = JobStatus.done.id
            self.odataService?.updateEntity(self.job, completionHandler: { (error) in
                if error == nil {
                    self.odataService?.provider.upload(completionHandler: { (error) in
                    })
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControlState {
        case .steps:
            return job.step.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControlState {
        case .steps:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControlState {
        case .steps:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "StepCell")!
            cell.textLabel?.text = job.step[indexPath.row].name ?? ""
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch segmentedControlState {
        case .steps:
            return 0.1

        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch segmentedControlState {
        case .steps:
            return nil
        }
    }
}
