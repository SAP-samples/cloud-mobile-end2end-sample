//
//  FinalReportMaterialCell.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 12.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

class FinalReportMaterialCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var materialPosition: MaterialPosition? {
        didSet {
            guard let materialPosition = materialPosition else { return }
            nameLabel.text = materialPosition.material?.name
            amountLabel.text = "\(materialPosition.quantity ?? 0) x"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
