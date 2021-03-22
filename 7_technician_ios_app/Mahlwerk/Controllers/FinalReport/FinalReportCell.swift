//
//  FinalReportCell.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 11.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

class FinalReportCell: UITableViewCell {

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
            self.jobTitleLabel.text = newValue.title
            self.durationLabel.text = "\(newValue.actualWorkHours ?? 0) hrs"
        }
    }
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var materialsTableView: UITableView! {
        didSet {
            materialsTableView.delegate = self
            materialsTableView.dataSource = self
        }
    }
}

extension FinalReportCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.job.materialPosition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinalReportMaterialCell") as! FinalReportMaterialCell
        cell.materialPosition = self.job.materialPosition[indexPath.row]
        return cell
    }
}

extension FinalReportCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24
    }
}
