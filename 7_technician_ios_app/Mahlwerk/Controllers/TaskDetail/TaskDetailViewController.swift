//
//  TaskDetailViewController.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 17.07.19.
//  Copyright © 2019 SAP. All rights reserve
//

import UIKit
import SAPFiori
import SAPOData
import SAPOfflineOData
import SAPFioriFlows
import SAPFoundation

enum TaskDetailSegmentedControlState: Int {
    case information = 0
    case jobs = 1
}

class TaskDetailViewController: UITableViewController, Refreshable, NavigationBarSegmentedControl, SAPFioriLoadingIndicator {
    
    var segmentedControlState = TaskDetailSegmentedControlState.information
    private var _task: Task?
    var task: Task {
        get {
            if _task == nil {
                return Task(withDefaults: true)
            }
            return _task!
        }
        set {
            _task = newValue
        }
    }
    var tasks = [Task]()
    var loadTask: ((_ completionHandler: @escaping (Error?) -> Void) -> Void)?
    
    var jobs = [Job]()
    var suggestedJobs = [Job]()
  
    private var sortedTools: [Int64?: [ToolPosition]] = [:]
    
    var tools: [ToolPosition] = [] {
        didSet(newValue) {
            sortedTools = newValue.group(by: \.toolID)
        }
    }
    
    var odataService: OdataService<OfflineODataProvider>?
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var header: FUIObjectHeader?
    var myRefreshControl: UIRefreshControl = UIRefreshControl()
    var loadingIndicator: FUILoadingIndicatorView? = FUILoadingIndicatorView()
    var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Information", "Jobs"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl(tintColor: UIColor.white)
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        self.tableView.register(FUINoteFormCell.self, forCellReuseIdentifier: FUINoteFormCell.reuseIdentifier)
        
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        
        configureNavigationBar(updating: false)
        createObjectHeader()
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.odataService = odataService
        func fetchTask(_ completionHandler: @escaping (Error?) -> Void) {
            do {
                odataService.loadProperty(Task.machine, into: task, completionHandler: completionHandler)
            }
        } 
        loadTask = fetchTask
        
        if let order = task.order {
            do {
                try self.odataService?.loadProperty(Order.task, into: order, query: DataQuery().expand(Task.machine)
                    .expand(Task.job, withQuery: DataQuery().expand(Job.materialPosition, withQuery:
                        DataQuery().expand(MaterialPosition.material, withQuery:
                            DataQuery().expand(Material.materialPosition)))))
                loadData {
                    
                }
            } catch { }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData {
            
        }
    }
    
    private func configureNavigationBar(updating: Bool) {
        if let navbar = self.navigationController?.navigationBar {
            navbar.setValue(true, forKey: "hidesShadow")
        }
        
        if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
            if taskStatus != .done && taskStatus != .active {
                let changeStatusButton = UIBarButtonItem(image: FUIIconLibrary.app.changeStatus, style: .plain,
                                                         target: self,
                                                         action: #selector(changeStatusButtonClicked(sender:)))
                self.navigationItem.rightBarButtonItem = changeStatusButton
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        
        if !updating {
            addSegmentedControlToNavigationBar()
        }
    }
    
    private func createObjectHeader() {
        header = FUIObjectHeader(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 200))
        if let header = header {
            header.headlineLabel.text = "\(task.title ?? "taskTitle")"
            header.subheadlineText = "Machine: \(task.machine?.name ?? "machineName")"
            let taskStatus = TaskStatus.init(rawValue: task.taskStatusID ?? 0)
            header.tags = [FUITag(title: "Status: \(taskStatus?.text ?? "taskStatus")")]
            var predictedHours = 0
            for job in task.job {
                predictedHours += job.predictedWorkHours ?? 0
            }
            header.footnoteText = "Predicted Time: \(predictedHours) hrs"
            self.tableView.tableHeaderView = header
        }
    }
    
    func handleRefresh(_ sender: Any) {
        self.odataService?.provider.download(completionHandler: { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayOfflineMessageBar()
                }
            }
            self.loadData {
                DispatchQueue.main.async {
                    self.endRefreshing()
                }
            }
        })
    }
    
    func handleSegmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedControlState = .information
        } else if sender.selectedSegmentIndex == 1 {
            segmentedControlState = .jobs
        }

        self.tableView.reloadData()
    }
    
    func updateTable() {
        DispatchQueue.global().async {
            self.loadData {
                
            }
        }
    }
    
    private func loadData(completionHandler: @escaping () -> Void) {
        self.requestTask { error in
            defer {
                completionHandler()
            }
            if let error = error {
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
                return
            }
            DispatchQueue.main.async {
                self.jobs = self.task.job.filter({ (job) -> Bool in
                    !(job.suggested ?? false)
                }).sorted(by: { (a, b) -> Bool in
                    a.jobStatusID! < b.jobStatusID!
                })
                self.suggestedJobs = self.task.job.filter({ (job) -> Bool in
                    job.suggested ?? false
                })
                self.tools = self.jobs.flatMap({$0.toolPosition})
                
                self.configureNavigationBar(updating: true)
                self.createObjectHeader()
                self.tableView.reloadData()
            }
        }
    }
    
    private func requestTask(completionHandler: @escaping (Error?) -> Void) {
        self.loadTask!() { error in
            if let error = error {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    
    @objc func changeStatusButtonClicked(sender: UIButton) {
        if let taskStatus = TaskStatus.init(rawValue: self.task.taskStatusID!) {
            if let targetStatus = TaskStatus.init(rawValue: taskStatus.id+1) {
                let alert = UIAlertController(title: "Change Status", message: "Change Status of Task to \(targetStatus.text)?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    switch taskStatus {
                    case .active:
                        return
                    case .done:
                        return
                    default:
                        self.task.taskStatusID = targetStatus.id
                    }
                    
                    if taskStatus == .open {
                        if ConnectivityUtils.isConnected() {
                            self.showFioriLoadingIndicator()
                            self.odataService?.updateEntity(self.task, completionHandler: { (error) in
                                if let error = error {
                                    self.displayMessageBar(text: error.localizedDescription)
                                    return
                                }
                                self.odataService?.provider.upload(completionHandler: { (error) in
                                    DispatchQueue.main.async {
                                        self.hideFioriLoadingIndicator()
                                    }
                                    if let error = error {
                                        self.displayMessageBar(text: error.message!)
                                        // navigate back if scheduling open task failed
                                        self.navigationController?.popViewController(animated: true)
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        self.updateUI()
                                    }
                                })
                            })
                        } else {
                            self.task.taskStatusID = TaskStatus.open.id
                            self.displayOfflineMessageBar()
                            return
                        }
                    } else {
                        self.odataService?.updateEntity(self.task, completionHandler: { (error) in
                            if error == nil {
                                if ConnectivityUtils.isConnected() {
                                    self.odataService?.provider.upload(completionHandler: { (error) in })
                                }
                            }
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func updateUI() {
        if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
            self.header?.tags = [FUITag(title: "Status: \(taskStatus.text)")]
            if taskStatus == .active || taskStatus == .done {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControlState {
        case .information:
            return 3
        case .jobs:
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.style = .title
        view.selectionStyle = .none
        
        switch segmentedControlState {
        case .jobs:
            switch section {
            case 0:
                view.titleLabel.text = "Jobs"
            case 1:
                view.titleLabel.text = "Suggested Jobs"
            default:
                return nil
            }
            return view
        case .information:
            switch section {
            case 0:
                view.titleLabel.text = "Location"
            case 1:
                view.titleLabel.text = "Notes"
            default:
                return nil
            }
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch segmentedControlState {
        case .jobs:
            return 35
        case .information:
            if section == 0 || section == 1 {
                return 35
            } else {
                return 0.1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControlState {
        case .jobs:
            if section == 0 {
                return jobs.count
            } else {
                return suggestedJobs.count
            }
        case .information:
                return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentedControlState == .information && indexPath.section == 0 {
            return 85
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch segmentedControlState {
        case .jobs:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobCell
            if section == 0 {
                let job = jobs[indexPath.row]
                cell.job = job
                return cell
            } else {
                let job = suggestedJobs[indexPath.row]
                cell.job = job
                return cell
            }
        case .information:
            if indexPath.section == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
                cell.address = task.address
                return cell
            } else if indexPath.section == 1 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: FUINoteFormCell.reuseIdentifier)
                    as! FUINoteFormCell
                cell.valueTextView.text = "\(task.notes ?? "notes")"
                cell.valueTextView.doneAccessory = true
                if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
                    cell.isEditable = taskStatus == .active || taskStatus == .scheduled || taskStatus == .done
                }
                cell.onChangeHandler = { [unowned self] newValue in
                    self.task.notes = newValue
                    self.odataService?.updateEntity(self.task, completionHandler: { (error) in
                        if error != nil {
                            self.displayMessageBar(text: "Unable to update Notes.")
                            return
                        }
                        self.odataService?.provider.upload(completionHandler: { (error) in })
                    })
                }
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomerCell")!
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControlState {
        case .jobs:
            self.tableView.deselectRow(at: indexPath, animated: false)
            break
        case .information:
            if indexPath.section == 0 {
                let mapStoryboard = UIStoryboard(name: "Map", bundle: nil)
                let mapNavigationViewController = mapStoryboard.instantiateInitialViewController() as! UINavigationController
                let mapViewController = mapNavigationViewController.visibleViewController as! MapViewController
                mapViewController.displayTask(task: self.task)
                self.present(mapNavigationViewController, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customerSegue" {
            let customerViewController = segue.destination as! CustomerViewController
            customerViewController.customer = task.order!.customer!
        }
    }
}

