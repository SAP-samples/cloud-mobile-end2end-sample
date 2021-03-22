//
// Mahlwerk-iOS-ProxyProject
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 26/09/19
//

import Foundation

enum CollectionType: String {
    case materialPositionSet = "MaterialPositionSet"
    case stepSet = "StepSet"
    case toolSet = "ToolSet"
    case toolPositionSet = "ToolPositionSet"
    case materialSet = "MaterialSet"
    case addressSet = "AddressSet"
    case userSet = "UserSet"
    case orderEventsSet = "OrderEventsSet"
    case orderSet = "OrderSet"
    case taskSet = "TaskSet"
    case machineSet = "MachineSet"
    case customerSet = "CustomerSet"
    case jobSet = "JobSet"
    case none = ""
    static let all = [materialPositionSet, stepSet, toolSet, toolPositionSet, materialSet, addressSet, userSet, orderEventsSet, orderSet, taskSet, machineSet, customerSet, jobSet]
}
