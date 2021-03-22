//
//  MaterialsPopoverController.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 22.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class MaterialsPopoverController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var materialsAndToolsTable: UITableView!
    
    private var sortedMaterials: [Int64?: [MaterialPosition]] = [:]
    private var sortedTools: [Int64?: [ToolPosition]] = [:]
    
    var materials: [MaterialPosition] = [] {
        didSet {
            sortedMaterials = self.materials.group(by: \.materialID)
        }
    }
    var tools: [ToolPosition] = [] {
        didSet {
            sortedTools = self.tools.group(by: \.toolID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.preferredFioriColor(forStyle: .header)
        self.materialsAndToolsTable.dataSource = self
        self.materialsAndToolsTable.delegate = self
        self.materialsAndToolsTable.tableFooterView = UIView()
        materialsAndToolsTable.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        materialsAndToolsTable.reloadData()
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MaterialsPopoverController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sortedTools.count
        } else {
            return sortedMaterials.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.style = .title
        view.selectionStyle = .none
        
        switch section {
        case 0:
            view.titleLabel.text = "Tools"
        case 1:
            view.titleLabel.text = "Materials"
        default:
            return nil
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolOrMaterialCell", for: indexPath) as! ToolOrMaterialCell
        if indexPath.section == 0 {
            let toolGroup = Array(sortedTools)[indexPath.row].value
            cell.name = toolGroup[0].tool?.name
        } else {
            let materialGroup = Array(sortedMaterials)[indexPath.row].value
            cell.name = materialGroup[0].material?.name
            cell.amount = "\(materialGroup.map({$0.quantity!}).sum())"
        }
        return cell
    }
    
}
