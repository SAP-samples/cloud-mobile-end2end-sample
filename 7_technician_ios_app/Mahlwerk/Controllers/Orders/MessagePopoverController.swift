//
//  MessagePopoverController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 05.08.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

class MessagePopoverController: UIViewController {

    var message: String = ""
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.preferredFioriColor(forStyle: .navigationBar)
        textField.text = message
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
