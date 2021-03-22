//
//  OrderCell.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 29.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class OrderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var order: Order? {
        didSet {
            guard let order = order else { return }
            titleLabel.text = order.title
            //TODO use order location
            //locationLabel.text = order.address? ..
            if let address = order.customer?.address {
                locationLabel.text = "\(address.town ?? ""), \(address.street ?? "") \(address.houseNumber ?? "")"
            }
            
            if let orderStatus = OrderStatus.init(rawValue: order.orderStatusID!) {
                statusLabel.text = orderStatus.text
                statusLabel.textColor = orderStatus.color
            }
        }
    }
    
}
