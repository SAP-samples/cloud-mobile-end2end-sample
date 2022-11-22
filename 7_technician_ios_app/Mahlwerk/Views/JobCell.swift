//
//  JobCell.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 18.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class JobCell: FUIBaseTableViewCell {
    
    @IBOutlet weak var titleLabel: FUILabel!
    @IBOutlet weak var predictionLabel: FUILabel!
    @IBOutlet weak var statusLabel: FUILabel!
    
    var job: Job? {
        didSet {
            guard let job = job else { return }
            titleLabel.text = job.title
            predictionLabel.text = "Predicted Time: \(job.predictedWorkHours ?? 0) hrs"
            if let jobStatus = JobStatus.init(rawValue: job.jobStatusID!) {
                if (job.suggested)! {
                    statusLabel.alpha = 0
                } else {
                    statusLabel.alpha = 1
                    statusLabel.text = jobStatus.text
                    statusLabel.textColor = jobStatus.color
                }
                switch jobStatus {
                case .done:
                    titleLabel.textColor = UIColor.preferredFioriColor(forStyle: FUIColorStyle.tertiaryLabel)
                    predictionLabel.textColor = UIColor.preferredFioriColor(forStyle: FUIColorStyle.tertiaryLabel)
                default:
                    break
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
