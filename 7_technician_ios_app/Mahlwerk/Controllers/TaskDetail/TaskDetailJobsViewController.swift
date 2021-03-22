//
//  TaskDetailJobsTableViewController.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 18.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskDetailJobsViewController: UITableViewController {

    var jobs: [DemoJob] = SampleData.getJobs()
    var suggestedJobs: [DemoJob] = SampleData.getSuggestedJobs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButton(nil, animated: true)
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        self.tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return jobs.count
        } else {
            return suggestedJobs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.style = .title
        view.selectionStyle = .none
        //view.setBackgroundColor(UIColor.preferredFioriColor(forStyle: FUIColorStyle.line))
        
        switch section {
        case 0:
            view.titleLabel.text = "Jobs"
        case 1:
            view.titleLabel.text = "Suggested Jobs"
        default:
            break
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobCell
        
        let section = indexPath.section
        if section == 0 {
            let job = jobs[indexPath.row]
            cell.job = job
            
            return cell
        } else {
            let job = suggestedJobs[indexPath.row]
            cell.job = job
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
