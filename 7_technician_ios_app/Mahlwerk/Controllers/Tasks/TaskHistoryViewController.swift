//
//  TaskHistoryViewController.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 19.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskHistoryViewController: FUIFormTableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var historyTasks: [Task] = []
    var filteredTasks = [Task]()
    
    let searchController = FUISearchController(searchResultsController: nil)
    var forceSearchBarVisibleOnLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .header)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    private func configureSearchbar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return filteredTasks.count
        } else {
            return historyTasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FUIBaseTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        if isSearching() {
            cell.task = filteredTasks[indexPath.row]
        } else {
            cell.task = historyTasks[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskDetailStoryboard = UIStoryboard(name: "TaskDetail", bundle: nil)
        let taskDetailViewController = taskDetailStoryboard.instantiateInitialViewController() as! TaskDetailViewController
        
        if isSearching() {
            taskDetailViewController.task = filteredTasks[indexPath.row]
        } else {
            taskDetailViewController.task = historyTasks[indexPath.row]
        }

        navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTasks = historyTasks.filter({ (task) -> Bool in
            (task.title!.lowercased().contains(searchController.searchBar.text!.lowercased()))
        })
        self.tableView.reloadData()
    }

}
