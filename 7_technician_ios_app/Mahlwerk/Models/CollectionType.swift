//
// Mahlwerk
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 05/08/19
//

import Foundation

enum CollectionType: String {
    case materialPositionSet = "MaterialPositionSet"
    case jobSet = "JobSet"
    case orderEventsSet = "OrderEventsSet"
    case userSet = "UserSet"
    case machineSet = "MachineSet"
    case orderSet = "OrderSet"
    case materialSet = "MaterialSet"
    case taskSet = "TaskSet"
    case customerSet = "CustomerSet"
    case toolPositionSet = "ToolPositionSet"
    case stepSet = "StepSet"
    case addressSet = "AddressSet"
    case toolSet = "ToolSet"
    case none = ""
    static let all = [materialPositionSet, jobSet, orderEventsSet, userSet, machineSet, orderSet, materialSet, taskSet, customerSet, toolPositionSet, stepSet, addressSet, toolSet]
}
