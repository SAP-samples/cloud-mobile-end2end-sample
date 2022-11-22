//
//  LocationCell.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 24.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class LocationCell: FUIObjectTableViewCell {

    @IBOutlet weak var streetLabel: FUILabel!
    @IBOutlet weak var townLabel: FUILabel!
    @IBOutlet weak var countryLabel: FUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var address: Address? {
        didSet {
            guard let address = address else { return }
            streetLabel.text = "\(address.street ?? "street") \(address.houseNumber ?? "houseNumber")"
            townLabel.text = "\(address.town ?? "town"), \(address.postalCode ?? "postalCode")"
            countryLabel.text = "\(address.country ?? "country")"
        }
    }

}
