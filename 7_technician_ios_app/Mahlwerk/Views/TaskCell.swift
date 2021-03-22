//
//  TaskCell.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 17.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
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
            dateLabel.text = "Due on \(task.order?.dueDate?.utc()!.format() ?? "")"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
