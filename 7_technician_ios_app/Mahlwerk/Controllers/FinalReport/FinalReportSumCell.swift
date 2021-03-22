//
//  FinalReportSumCell.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 16.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

class FinalReportSumCell: UITableViewCell {
    
    @IBOutlet weak var sumLabel: UILabel!

    private var _jobs: [Job]?
    var jobs: [Job] {
        get {
            if _jobs == nil {
                return []
            }
            return _jobs!
        }
        set {
            _jobs = newValue
            var sumWorkingHours = 0
            for job in _jobs! {
                sumWorkingHours += job.actualWorkHours ?? 0
            }
            sumLabel.text = "Sum: \(sumWorkingHours) hrs"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
