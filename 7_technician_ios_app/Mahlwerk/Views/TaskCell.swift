//
//  TaskCell.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 17.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskCell: FUIBaseTableViewCell {
    
    @IBOutlet weak var titleLabel: FUILabel!
    @IBOutlet weak var addressLabel: FUILabel!
    @IBOutlet weak var dateLabel: FUILabel!
    @IBOutlet weak var statusLabel: FUILabel!
    
    
    
    var task: Task? {
        didSet {
            guard let task = task else { return }
            let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!)
            
            titleLabel.text = "\(task.title ?? "")"
            if let address = task.address {
                addressLabel.text = "\(address.town ?? ""), \(address.street ?? "") \(address.houseNumber ?? "")"
            }
            statusLabel.text = taskStatus?.text
            statusLabel.textColor = taskStatus?.color
            dateLabel.text = "Due on \(task.order?.dueDate?.utc()?.format() ?? "")"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
