//
//  TasksViewController.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 16.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import Foundation
import SAPFoundation
import SAPFiori
import SAPFioriFlows
import SAPOData
import SAPOfflineOData

class TasksViewController: FUIFormTableViewController, UISearchResultsUpdating, UISearchBarDelegate,
UIPopoverPresentationControllerDelegate, Refreshable, SAPFioriLoadingIndicator {
    
    var tasks = [Task]()
    var openTasks = [Task]()
    var activeTasks = [Task]()
    var filteredTasks = [Task]()
    
    let searchController = FUISearchController(searchResultsController: nil)
    var loadTasks: ((_ completionHandler: @escaping ([Task]?, Error?) -> Void) -> Void)?
    var loadTaskSubset: ((Bool, _ completionHandler: @escaping ([Task]?, Error?) -> Void) -> Void)?
    var loadTask: ((Int64, _ completionHandler: @escaping (Task?, Error?) -> Void) -> Void)?
    
    var offlineODataService : OdataService<OfflineODataProvider>!
    var odataService: OdataService<OnlineODataProvider>!
    
    var loadingIndicator: FUILoadingIndicatorView? = FUILoadingIndicatorView()
    var myRefreshControl: UIRefreshControl = UIRefreshControl()
    
    enum Section: Int, CaseIterable {
        case mapButton, myTasks, openTasks, historyButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        self.tableView.register(UINib.init(nibName: "MapButtonCell", bundle: nil), forCellReuseIdentifier: "MapButtonCell")
        self.tableView.tableFooterView = UIView()
    
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .header)
       
        
        self.tabBarController?.tabBar.items?[0].image = FUIIconLibrary.system.check
        self.tabBarController?.tabBar.items?[1].image = FUIIconLibrary.system.listView
        
        self.navigationItem.leftBarButtonItem?.image = FUIIconLibrary.system.me
        self.navigationItem.rightBarButtonItem?.image = FUIIconLibrary.docType.table
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.offlineODataService = odataService
        
        // load all tasks
        func fetchTaskSet(_ completionHandler: @escaping ([Task]?, Error?) -> Void) {
            let query = DataQuery().selectAll().expand(Task.address, Task.machine).expand(Task.order, withQuery: DataQuery().expand(Order.customer)).expand(Task.job, withQuery: DataQuery().expand(Job.materialPosition, withQuery: DataQuery().expand( MaterialPosition.material, withQuery: DataQuery().expand(Material.materialPosition))).expand(Job.toolPosition, withQuery: DataQuery().expand(ToolPosition.tool, withQuery: DataQuery().expand(Tool.toolPosition))))
            do {
                offlineODataService.fetchTaskSet(matching: query, completionHandler: completionHandler)
            }
        }
        // load open/my tasks
        func fetchTaskSubset(openTasks: Bool, _ completionHandler: @escaping ([Task]?, Error?) -> Void) {
            let query = DataQuery().selectAll().expand(Task.address, Task.machine).expand(Task.order, withQuery: DataQuery().expand(Order.customer)).expand(Task.job, withQuery: DataQuery().expand(Job.materialPosition, withQuery: DataQuery().expand( MaterialPosition.material, withQuery: DataQuery().expand(Material.materialPosition))).expand(Job.toolPosition, withQuery: DataQuery().expand(ToolPosition.tool, withQuery: DataQuery().expand(Tool.toolPosition))))
            do {
                offlineODataService.fetchTaskSet(matching: query.where(openTasks ? Task.taskStatusID.equal(TaskStatus.open.id) : !Task.taskStatusID.equal(TaskStatus.open.id)), completionHandler: completionHandler)
            }
        }
        // load single task
        func fetchTask(taskID: Int64, _ completionHandler: @escaping (Task?, Error?) -> Void) {
            let query = DataQuery().expand(Task.address, Task.machine).expand(Task.order, withQuery: DataQuery().expand(Order.customer)).expand(Task.job, withQuery: DataQuery().expand(Job.materialPosition, withQuery: DataQuery().expand( MaterialPosition.material, withQuery: DataQuery().expand(Material.materialPosition))).expand(Job.toolPosition, withQuery: DataQuery().expand(ToolPosition.tool, withQuery: DataQuery().expand(Tool.toolPosition))))
            do {
                offlineODataService.fetchTaskWithKey(taskID: taskID, query: query, headers: nil, options: nil, completionHandler: completionHandler)
            }
        }
        loadTasks = fetchTaskSet
        loadTaskSubset = fetchTaskSubset
        loadTask = fetchTask
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTable()
        configureSearchbar()
        if ConnectivityUtils.isConnected() {
            self.showFioriLoadingIndicator()
            self.offlineODataService.provider.download(
                withSubset: [OfflineODataDefiningQuery.init(name: "TaskSet", query: DataQuery().selectAll().where(Task.taskStatusID.equal(TaskStatus.open.id
                )), automaticallyRetrievesStreams: false)]) { (error) in
                    DispatchQueue.main.async {
                        self.hideFioriLoadingIndicator()
                    }
                    if error == nil {
                        self.loadTaskSubset!(true) { tasks, error in
                            if error == nil {
                                self.openTasks = tasks!
                                self.tasks.append(contentsOf: self.openTasks)
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        self.displayMessageBar(text: "Unable to download Open Tasks.")
                    }
            }
        } else {
            self.displayMessageBar(text: "Unable to download Open Tasks.")
        }
    }
    
    func handleRefresh(_ sender: Any) {
        if ConnectivityUtils.isConnected() {
            self.offlineODataService?.provider.download(completionHandler: { (error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.displayMessageBar(text: "Unable to download Open Tasks.")
                    }
                }
                self.loadData(subSet: false) {
                    DispatchQueue.main.async {
                        self.endRefreshing()
                    }
                }
            })
        } else {
            self.displayOfflineMessageBar()
            DispatchQueue.main.async {
                self.endRefreshing()
            }
        }
    }
    
    func updateTable() {
        DispatchQueue.global().async {
            self.loadData(subSet: true) {
                
            }
        }
    }
    
    private func loadData(subSet: Bool, completionHandler: @escaping () -> Void) {
        self.requestTasks(subSet: subSet) { error in
            defer {
                completionHandler()
            }
            if let error = error {
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
                return
            }
            DispatchQueue.main.async {
                self.activeTasks = self.tasks.filter({ (task) -> Bool in
                    let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!)
                    return taskStatus != TaskStatus.done && taskStatus != TaskStatus.open
                }).sorted(by: { (a, b) -> Bool in
                    a.taskStatusID! > b.taskStatusID!
                })
                self.openTasks = self.tasks.filter({ (task) -> Bool in
                    let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!)
                    return taskStatus == TaskStatus.open
                })
                self.tableView.reloadData()
            }
        }
    }
    
    private func requestTasks(subSet: Bool, completionHandler: @escaping (Error?) -> Void) {
        if subSet {
            self.loadTaskSubset!(false) { tasks, error in
                if let error = error {
                    completionHandler(error)
                    return
                }
                self.tasks = tasks!
                completionHandler(nil)
            }
        } else {
            self.loadTasks! { tasks, error in
                if let error = error {
                    completionHandler(error)
                    return
                }
                self.tasks = tasks!
                completionHandler(nil)
            }
        }
    }
    
    private func configureSearchbar() {
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTasks = tasks.filter({ (task) -> Bool in
            (task.title!.lowercased().contains(searchController.searchBar.text!.lowercased()))
        })
        filteredTasks.append(contentsOf: openTasks.filter({ (task) -> Bool in
            (task.title!.lowercased().contains(searchController.searchBar.text!.lowercased()))
        }))
        self.tableView.reloadData()
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func showMap() {
        let mapStoryboard = UIStoryboard(name: "Map", bundle: nil)
        let mapNavigationViewController = mapStoryboard.instantiateInitialViewController() as! UINavigationController
        let mapViewController = mapNavigationViewController.visibleViewController as! MapViewController
        mapViewController.tasks = self.tasks
        self.present(mapNavigationViewController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching() {
            return 1
        }
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return filteredTasks.count
        }
        
        switch Section(rawValue: section) {
        case .mapButton:
            return 1
        case .myTasks:
            return activeTasks.count
        case .openTasks:
            return openTasks.count
        case .historyButton:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FUIBaseTableViewCell {
        let task: Task?
        if isSearching() {
            task = filteredTasks[indexPath.row]
            let cell = returnTaskCell(task: task!, indexPath: indexPath)
            return cell
        }
        switch Section(rawValue: indexPath.section) {
        case .mapButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapButtonCell", for: indexPath) as! MapButtonCell
            cell.setAnnotations(tasks: self.activeTasks + self.openTasks)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickOnMap))
            cell.mapView.addGestureRecognizer(tapGestureRecognizer)
            return cell
        case .myTasks:
            task = activeTasks[indexPath.row]
            let cell = returnTaskCell(task: task!, indexPath: indexPath)
            
            return cell

        case .openTasks:
            task = openTasks[indexPath.row]
            let cell = returnTaskCell(task: task!, indexPath: indexPath)
            return cell
        case .historyButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! FUIObjectTableViewCell
            cell.headlineText = "Tasks History"
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return FUIBaseTableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! FUIObjectTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching() {
            return 0.01
        }
        
        if Section(rawValue: section) == .mapButton || Section(rawValue: section) == .historyButton {
            return 0.01
        }
        return 35.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isSearching() {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
            view.style = .title
            view.selectionStyle = .none
            
            switch Section(rawValue: section) {
            case .myTasks:
                view.titleLabel.text = "My tasks"
            case .openTasks:
                view.titleLabel.text = "Open tasks"
            default:
                return nil
            }
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskDetailStoryboard = UIStoryboard(name: "TaskDetail", bundle: nil)
        let taskDetailViewController = taskDetailStoryboard.instantiateInitialViewController() as! TaskDetailViewController
        
        var task: Task = Task()
        if isSearching() {
            task = filteredTasks[indexPath.row]
        } else {
            switch Section(rawValue: indexPath.section) {
            case .mapButton:
                self.showMap()
            case .myTasks:
                task = activeTasks[indexPath.row]
            case .openTasks:
                task = openTasks[indexPath.row]
            default:
                return
            }
            if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
                if taskStatus == .open {
                    // download selected open task to offline store
                    if ConnectivityUtils.isConnected() {
                        self.showFioriLoadingIndicator()
                        self.view.isUserInteractionEnabled = false
                        self.offlineODataService.provider.download(
                            withSubset: [
                                OfflineODataDefiningQuery.init(name: "TaskSet",
                                                               query: DataQuery().selectAll().where(Task.taskID.equal(task.taskID!)),
                                                               automaticallyRetrievesStreams: false)]) { (error) in
                                                                DispatchQueue.main.async {
                                                                    self.hideFioriLoadingIndicator()
                                                                    self.view.isUserInteractionEnabled = true
                                                                }
                                                                if error != nil {
                                                                    self.displayMessageBar(text: "Unable to download Open Task.")
                                                                    return
                                                                }
                                                                // check if downloaded open task is still open
                                                                self.loadTask!(task.taskID!) { (newTask, error) in
                                                                    if error != nil {
                                                                        self.displayMessageBar(text: "Unable to download Open Task.")
                                                                        return
                                                                    }
                                                                    if let newTask = newTask {
                                                                        task = newTask
                                                                        if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
                                                                            if taskStatus != .open {
                                                                                self.displayMessageBar(text: "This Task is already assigned.")
                                                                                self.loadData(subSet: false, completionHandler: { })
                                                                                return
                                                                            }
                                                                        }
                                                                    }
                                                                    taskDetailViewController.task = task
                                                                    DispatchQueue.main.async {
                                                                        self.navigationController?.pushViewController(taskDetailViewController, animated: true)
                                                                    }
                                                                }
                        }
                    } else {
                        self.displayOfflineMessageBar()
                        return
                    }
                } else {
                    taskDetailViewController.task = task
                    self.navigationController?.pushViewController(taskDetailViewController, animated: true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch Section(rawValue: indexPath.section) {
        case .myTasks:
            if let taskStatus = TaskStatus.init(rawValue: activeTasks[indexPath.row].taskStatusID!) {
                switch taskStatus {
                case .active:
                    let doneAction = UITableViewRowAction(style: .normal, title: "Set Done", handler: { (action, index) in
                        self.activeTasks[indexPath.row].taskStatusID = TaskStatus.done.id
                        self.offlineODataService?.updateEntity(self.activeTasks[indexPath.row], completionHandler: { (error) in
                            if error != nil {
                                self.updateTable()
                                DispatchQueue.main.async {
                                    self.offlineODataService?.provider.upload(completionHandler: { (error) in })
                                }
                            } else {
                                self.displayMessageBar(text: "Unable to set Task to Done.")
                            }
                        })
                    })
                    doneAction.backgroundColor = TaskStatus.done.color
                    return [doneAction]
                case .scheduled:
                    let activeAction = UITableViewRowAction(style: .normal, title: "Set Active", handler: { (action, index) in
                        // check if there is an active task
                        for task in self.activeTasks {
                            let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!)
                            if taskStatus == .active {
                                let alert = UIAlertController(title: "Error", message: "Please finish your active Task until you start a new one!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                        }
                        self.activeTasks[indexPath.row].taskStatusID = TaskStatus.active.id
                        self.offlineODataService?.updateEntity(self.activeTasks[indexPath.row], completionHandler: { (error) in
                            if error != nil {
                                self.updateTable()
                                DispatchQueue.main.async {
                                    self.offlineODataService?.provider.upload(completionHandler: { (error) in })
                                }
                            } else {
                                self.displayMessageBar(text: "Unable to set Task to Active.")
                            }
                        })
                    })
                    activeAction.backgroundColor = TaskStatus.active.color
                    return [activeAction]
                default:
                    return nil
                }
            }
        case .openTasks:
            let scheduleAction = UITableViewRowAction(style: .normal, title: "Schedule") { (action, index) in
                if ConnectivityUtils.isConnected() {
                    self.showFioriLoadingIndicator()
                    do {
                        let task = self.openTasks[indexPath.row]
                        task.taskStatusID = TaskStatus.scheduled.id
                        try self.offlineODataService.updateEntity(task)
                        self.offlineODataService.provider.upload(completionHandler: { (error) in
                            // expect error from backend when task is already scheduled/assigned
                            DispatchQueue.main.async {
                                self.hideFioriLoadingIndicator()
                            }
                            if let error = error {
                                self.displayMessageBar(text: error.message!)
                                return
                            }
                            self.loadData(subSet: false) { }
                        })
                    } catch {
                        self.displayMessageBar(text: "Unable to schedule Task.")
                        return
                    }
                } else {
                    self.displayOfflineMessageBar()
                }
            }
            scheduleAction.backgroundColor = TaskStatus.scheduled.color
            return [scheduleAction]
        default:
            return nil
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskHistorySegue" {
            let viewController = segue.destination as! TaskHistoryViewController
            viewController.historyTasks = tasks.filter({ (task) -> Bool in
                let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!)
                return taskStatus == .done
            })
        }
    }
    
    func returnTaskCell(task: Task, indexPath: IndexPath) -> FUIObjectTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! FUIObjectTableViewCell
        cell.headlineText = task.title
    
        if let address = task.address {
            cell.descriptionText = "\(address.town ?? ""), \(address.street ?? "") \(address.houseNumber ?? "")"
        }
        let taskStatus = TaskStatus.init(rawValue: (task.taskStatusID)!)
        cell.statusText = taskStatus?.text
        cell.statusLabel.textColor = taskStatus?.color
        cell.footnoteText = "Due on \(task.order?.dueDate?.utc()?.format() ?? "")"

        cell.showDescriptionInCompact = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    @objc func clickOnMap(_ sender: UITapGestureRecognizer) {
        self.showMap()
    }
}
