//
//  TaskDetailMaterialsViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 26.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskDetailMaterialsViewController: UITableViewController {

    var tools = SampleData.getTools()
    var materials = SampleData.getMaterials()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                        forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tools.count
        } else {
            return materials.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ToolOrMaterialCell") as! ToolOrMaterialCell
        if indexPath.section == 0 {
            cell.tool = tools[indexPath.row]
        } else {
            cell.material = materials[indexPath.row]
        }
        return cell
    }

}
