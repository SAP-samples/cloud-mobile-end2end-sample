//
//  OrderDetailViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 05.08.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import Messages
import SAPOData
import SAPOfflineOData
import SAPFioriFlows

class OrderDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    private var _order: Order?
    var order: Order {
        get {
            if _order == nil {
                return Order(withDefaults: true)
            }
            return _order!
        }
        set {
            _order = newValue
        }
    }
    
    @IBOutlet weak var orderDetailTable: OrderDetailTableViewController!
    @IBOutlet weak var messageTextField: UITextField!
    
    var offlineOdataService: OdataService<OfflineODataProvider>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        //TODO hide orderDetailTable if order is not assigned to user
        configureNavigationBar()
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.offlineOdataService = odataService
    }
    
    private func configureNavigationBar() {
        if let navbar = self.navigationController?.navigationBar {
            navbar.setValue(true, forKey: "hidesShadow")
        }
        
        let customerButton = UIBarButtonItem(image: FUIIconLibrary.system.me, style: .plain,
                                             target: self,
                                             action: #selector(customerButtonClicked(sender:)))
        self.navigationItem.rightBarButtonItem = customerButton
    }
    
    @objc func customerButtonClicked(sender: UIButton) {
        let customerStoryboard = UIStoryboard(name: "Customer", bundle: nil)
        let customerViewController = customerStoryboard.instantiateInitialViewController()
            as! CustomerViewController
        customerViewController.customer = order.customer!
        self.navigationController!.pushViewController(customerViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // set bottom constraint of stackview to keyboard frame
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            // check if keyboard frame is visible
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightConstraint?.constant = 5.0
            } else {
                self.keyboardHeightConstraint?.constant = (endFrame?.size.height)! - (self.tabBarController?.tabBar.frame.height)! + 5
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded()
                            // scroll to bottom after keyboard is shown
                            if endFrameY < UIScreen.main.bounds.size.height {
                                self.orderDetailTable.tableView.scrollToRow(at: IndexPath(row: self.order.orderEvents.count-1, section: 0), at: .bottom, animated: true)
                            }
            },
                           completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let orderDetailTable as OrderDetailTableViewController:
            self.orderDetailTable = orderDetailTable
            orderDetailTable.order = self.order
        default:
            break
        }
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        if let text = messageTextField.text {
            if text.count > 0 {
                let newOrderEvent = OrderEvents(withDefaults: false)
                newOrderEvent.orderEventTypeID = OrderEventType.message.id
                newOrderEvent.date = LocalDateTime.now()
                newOrderEvent.order = self.order
                newOrderEvent.orderID = self.order.orderID!
                newOrderEvent.text = "\(text)"
                self.order.orderEvents.append(newOrderEvent)
                self.offlineOdataService?.createEntity(newOrderEvent, completionHandler: { (error) in
                    if error == nil {
                        self.messageTextField.text = ""
                        //TODO fix duplicate key
                        //TODO scroll down after tableview reload
                        self.offlineOdataService?.loadProperty(Order.orderEvents, into: self.order, completionHandler: { (error) in
                            self.order.orderEvents.sort(by: { (a, b) -> Bool in
                                return a.date!.utc()! < b.date!.utc()!
                            })
                            self.orderDetailTable.tableView.reloadData()
                            self.orderDetailTable.tableView.scrollToRow(at: IndexPath(row: self.order.orderEvents.count-1, section: 0), at: .bottom, animated: true)
                        })
                        self.offlineOdataService?.provider.upload(completionHandler: { (error) in
                            
                        })
                    }
                })
            }
        }
    }
    
}


class OrderDetailTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, Refreshable {
    
    private var _order: Order?
    var order: Order {
        get {
            if _order == nil {
                return Order(withDefaults: true)
            }
            return _order!
        }
        set {
            _order = newValue
            order.orderEvents.sort(by: { (a, b) -> Bool in
                return a.date!.utc()! < b.date!.utc()!
            })
        }
    }
    
    var loadOrder: ((_ completionHandler: @escaping (Order?, Error?) -> Void) -> Void)?
    var offlineOdataService: OdataService<OfflineODataProvider>?
    var myRefreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FUITimelineCell.self, forCellReuseIdentifier: FUITimelineCell.reuseIdentifier)
        tableView.register(FUITimelineMarkerCell.self, forCellReuseIdentifier: FUITimelineMarkerCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
        addRefreshControl(tintColor: UIColor.white)
        configureNavigationBar()
        createObjectHeader()
        
        guard let offlineOdataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.offlineOdataService = offlineOdataService
        func fetchOrder(_ completionHandler: @escaping (Order?, Error?) -> Void) {
            let query = DataQuery().expand(Order.orderEvents).expand(Order.customer, withQuery:
                            DataQuery().expand(Customer.address, Customer.order))
            do {
                offlineOdataService.fetchOrderWithKey(orderID: self.order.orderID, query: query, completionHandler: completionHandler)
            }
        }
        loadOrder = fetchOrder
    }
    
    private func configureNavigationBar() {
        if let navbar = self.navigationController?.navigationBar {
            navbar.setValue(true, forKey: "hidesShadow")
        }
    }
    
    private func createObjectHeader() {
        let header = FUIObjectHeader()
        header.headlineText = "\(order.customer?.companyName ?? ""): \(order.title ?? "")"
        header.subheadlineText = "Machine: \(order.task?.machine?.name ?? "")"
        header.descriptionText = order.description
        header.footnoteText = "Due on \(order.dueDate?.utc()!.format() ?? "")"
        if let orderStatus = OrderStatus.init(rawValue: order.orderStatusID!) {
            header.tags = [FUITag(title: "Status: \(orderStatus.text)")]
        }
        self.tableView.tableHeaderView = header
    }
    
    func handleRefresh(_ sender: Any) {
        self.offlineOdataService?.provider.download(completionHandler: { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayOfflineMessageBar()
                }
            }
            self.loadData {
                DispatchQueue.main.async {
                    self.endRefreshing()
                }
            }
        })
    }
    
    private func loadData(completionHandler: @escaping () -> Void) {
        self.requestOrder { error in
            defer {
                completionHandler()
            }
            if let error = error {
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!",
                                                                 comment: "XTIT: Title of loading data error pop up."),
                                         error: error, viewController: self)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func requestOrder(completionHandler: @escaping (Error?) -> Void) {
        self.loadOrder!() { order, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.order = order!
            completionHandler(nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.orderEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderEvent = order.orderEvents[indexPath.row]
        if let orderEventType = OrderEventType.init(rawValue: orderEvent.orderEventTypeID!) {
            //TODO use order data
            switch orderEventType {
            case .create:
                return getOrderCreatedTimelineCell(orderEvent: orderEvent)
            case .open:
                return getOrderOpenedTimelineCell(orderEvent: orderEvent)
            case .inProgress:
                return getOrderInProgressTimelineCell(orderEvent: orderEvent)
            case .reportSent:
                return getOrderFinalReportSentTimelineCell(orderEvent: orderEvent)
            case .reportApproved:
                return getOrderFinalReportApprovedTimelineCell(orderEvent: orderEvent)
            case .done:
                return getOrderDoneTimelineCell(orderEvent: orderEvent)
            case .message:
                return getMessageTimelineCell(orderEvent: orderEvent)
            }
        }
        return UITableViewCell()
    }
    
    func getOrderCreatedTimelineCell(orderEvent: OrderEvents) -> FUITimelineMarkerCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier)
            as! FUITimelineMarkerCell
        cell.titleText = "Order Created"
        cell.nodeType = .start
        cell.timestampText = self.getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        return cell
    }
    
    func getOrderOpenedTimelineCell(orderEvent: OrderEvents) -> FUITimelineMarkerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            FUITimelineMarkerCell.reuseIdentifier) as! FUITimelineMarkerCell
        cell.titleText = "Status changed to Open"
        cell.timestampText = getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        cell.nodeType = .default
        cell.nodeColor = UIColor.preferredFioriColor(forStyle: .chart1)
        cell.timelineBackground.backgroundColor = .groupTableViewBackground
        cell.cardBackground.backgroundColor = .groupTableViewBackground
        return cell
    }
    
    func getOrderInProgressTimelineCell(orderEvent: OrderEvents) -> FUITimelineMarkerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier)
            as! FUITimelineMarkerCell
        cell.titleText = "Status changed to In Progress"
        cell.timestampText = getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        cell.nodeType = .default
        cell.nodeColor = UIColor.preferredFioriColor(forStyle: .critical)
        cell.timelineBackground.backgroundColor = .groupTableViewBackground
        cell.cardBackground.backgroundColor = .groupTableViewBackground
        return cell
    }
    
    func getOrderFinalReportSentTimelineCell(orderEvent: OrderEvents) -> FUITimelineCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineCell.reuseIdentifier) as! FUITimelineCell
        cell.type = .finalReport
        cell.headlineText = "Final Report sent"
        cell.timestampText = getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        cell.nodeType = .open
        cell.timelineBackground.backgroundColor = .white
        cell.cardBackground.backgroundColor = .white
        return cell
    }
    
    func getOrderFinalReportApprovedTimelineCell(orderEvent: OrderEvents) -> FUITimelineMarkerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier)
            as! FUITimelineMarkerCell
        cell.titleText = "Final Report approved"
        cell.timestampText = getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        cell.nodeType = .end
        return cell
    }
    
    func getOrderDoneTimelineCell(orderEvent: OrderEvents) -> FUITimelineMarkerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier)
            as! FUITimelineMarkerCell
        cell.titleText = "Status changed to Done"
        cell.timestampText = getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        cell.nodeType = .default
        cell.nodeColor = UIColor.preferredFioriColor(forStyle: .primary3)
        cell.timelineBackground.backgroundColor = .groupTableViewBackground
        cell.cardBackground.backgroundColor = .groupTableViewBackground
        return cell
    }
    
    func getMessageTimelineCell(orderEvent: OrderEvents) -> FUITimelineCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineCell.reuseIdentifier) as! FUITimelineCell
        cell.type = .message
        cell.headlineText = "Message"
        cell.subheadlineText = "\(orderEvent.text ?? "")"
        cell.timestampText = getTimelineFormattedDate(date: (orderEvent.date?.utc())!)
        cell.nodeType = .open
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timelineCell = tableView.cellForRow(at: indexPath) as? FUITimelineCell
        if let timelineCell = timelineCell {
            switch timelineCell.type {
            case .message:
                showMessagePopover(message: timelineCell.subheadlineText!, date: timelineCell.timestampText!)
            case .finalReport:
                let finalReportStoryboard = UIStoryboard(name: "FinalReport", bundle: nil)
                let finalReportViewController = finalReportStoryboard.instantiateInitialViewController()
                    as! FinalReportViewController
                finalReportViewController.order = self.order
                /*
                 do {
                 try self.odataService?.loadProperty(Order.task, into: order, query:
                 DataQuery().expand(Task.machine).expand(Task.job, withQuery:
                 DataQuery().expand(Job.materialPosition, withQuery:
                 DataQuery().expand(MaterialPosition.material, withQuery:
                 DataQuery().expand(Material.materialPosition)))))
                 } catch {
                 
                 }
                 */
                self.navigationController!.pushViewController(finalReportViewController, animated: true)
                /*
                 let customerStoryboard = UIStoryboard(name: "Customer", bundle: nil)
                 let customerViewController = customerStoryboard.instantiateInitialViewController()
                 as! CustomerViewController
                 customerViewController.customer = order.customer!
                 self.navigationController!.pushViewController(customerViewController, animated: true)
                 */
            }
        }
    }
    
    private func showMessagePopover(message: String, date: String) {
        let popover = storyboard?.instantiateViewController(withIdentifier: "messagePopover") as! MessagePopoverController
        
        popover.modalPresentationStyle = UIModalPresentationStyle.popover
        popover.popoverPresentationController?.delegate = self
        
        popover.popoverPresentationController?.sourceView = self.view
        popover.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY - (self.navigationController?.navigationBar.bounds.height)!, width: 0, height: 0)
        popover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popover.preferredContentSize = CGSize(width: 300, height: 250)
        
        popover.message = message
        self.present(popover, animated: true)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    private func getTimelineFormattedDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: date)
    }
}
