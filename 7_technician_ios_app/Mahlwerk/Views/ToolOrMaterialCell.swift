//
//  MaterialsPopoverCell.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 23.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

class ToolOrMaterialCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            nameLabel.text = name
        }
    }
    
    var amount: String? {
        didSet {
            guard let amount = amount else { return }
            amountLabel.text = "\(amount) x"
        }
    }
    
    var tool: Tool? {
        didSet {
            guard let tool = tool else { return }
            nameLabel.text = tool.name
            amountLabel.text = ""
        }
    }
    
    var material: Material? {
        didSet {
            guard let material = material else { return }
            nameLabel.text = material.name
            amountLabel.text = "\(material.materialPosition.count) x"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
