// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

public class OdataServiceMetadata {
    private static var document_: CSDLDocument = OdataServiceMetadata.resolve()

    public static let lock: MetadataLock = MetadataLock()

    public static var document: CSDLDocument {
        get {
            objc_sync_enter(OdataServiceMetadata.self)
            defer { objc_sync_exit(OdataServiceMetadata.self) }
            do {
                return OdataServiceMetadata.document_
            }
        }
        set(value) {
            objc_sync_enter(OdataServiceMetadata.self)
            defer { objc_sync_exit(OdataServiceMetadata.self) }
            do {
                OdataServiceMetadata.document_ = value
            }
        }
    }

    private static func resolve() -> CSDLDocument {
        try! OdataServiceFactory.registerAll()
        OdataServiceMetadataParser.parsed.hasGeneratedProxies = true
        return OdataServiceMetadataParser.parsed
    }

    public class EntityTypes {
        private static var address_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Address")

        private static var customer_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Customer")

        private static var job_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Job")

        private static var machine_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Machine")

        private static var machineConfiguration_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.MachineConfiguration")

        private static var material_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Material")

        private static var materialPosition_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.MaterialPosition")

        private static var order_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Order")

        private static var orderEvents_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.OrderEvents")

        private static var part_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Part")

        private static var partsToChange_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.PartsToChange")

        private static var step_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Step")

        private static var task_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Task")

        private static var tool_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.Tool")

        private static var toolPosition_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.ToolPosition")

        private static var user_: EntityType = OdataServiceMetadataParser.parsed.entityType(withName: "com.sap.odata.User")

        public static var address: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.address_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.address_ = value
                }
            }
        }

        public static var customer: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.customer_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.customer_ = value
                }
            }
        }

        public static var job: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.job_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.job_ = value
                }
            }
        }

        public static var machine: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.machine_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.machine_ = value
                }
            }
        }

        public static var machineConfiguration: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.machineConfiguration_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.machineConfiguration_ = value
                }
            }
        }

        public static var material: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.material_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.material_ = value
                }
            }
        }

        public static var materialPosition: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.materialPosition_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.materialPosition_ = value
                }
            }
        }

        public static var order: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.order_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.order_ = value
                }
            }
        }

        public static var orderEvents: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.orderEvents_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.orderEvents_ = value
                }
            }
        }

        public static var part: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.part_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.part_ = value
                }
            }
        }

        public static var partsToChange: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.partsToChange_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.partsToChange_ = value
                }
            }
        }

        public static var step: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.step_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.step_ = value
                }
            }
        }

        public static var task: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.task_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.task_ = value
                }
            }
        }

        public static var tool: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.tool_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.tool_ = value
                }
            }
        }

        public static var toolPosition: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.toolPosition_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.toolPosition_ = value
                }
            }
        }

        public static var user: EntityType {
            get {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    return OdataServiceMetadata.EntityTypes.user_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntityTypes.self) }
                do {
                    OdataServiceMetadata.EntityTypes.user_ = value
                }
            }
        }
    }

    public class EntitySets {
        private static var addressSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "AddressSet")

        private static var customerSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "CustomerSet")

        private static var jobSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "JobSet")

        private static var machineConfigurationSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "MachineConfigurationSet")

        private static var machineSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "MachineSet")

        private static var materialPositionSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "MaterialPositionSet")

        private static var materialSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "MaterialSet")

        private static var orderEventsSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "OrderEventsSet")

        private static var orderSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "OrderSet")

        private static var partSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "PartSet")

        private static var partsToChangeSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "PartsToChangeSet")

        private static var stepSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "StepSet")

        private static var taskSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "TaskSet")

        private static var toolPositionSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "ToolPositionSet")

        private static var toolSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "ToolSet")

        private static var userSet_: EntitySet = OdataServiceMetadataParser.parsed.entitySet(withName: "UserSet")

        public static var addressSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.addressSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.addressSet_ = value
                }
            }
        }

        public static var customerSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.customerSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.customerSet_ = value
                }
            }
        }

        public static var jobSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.jobSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.jobSet_ = value
                }
            }
        }

        public static var machineConfigurationSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.machineConfigurationSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.machineConfigurationSet_ = value
                }
            }
        }

        public static var machineSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.machineSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.machineSet_ = value
                }
            }
        }

        public static var materialPositionSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.materialPositionSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.materialPositionSet_ = value
                }
            }
        }

        public static var materialSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.materialSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.materialSet_ = value
                }
            }
        }

        public static var orderEventsSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.orderEventsSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.orderEventsSet_ = value
                }
            }
        }

        public static var orderSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.orderSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.orderSet_ = value
                }
            }
        }

        public static var partSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.partSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.partSet_ = value
                }
            }
        }

        public static var partsToChangeSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.partsToChangeSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.partsToChangeSet_ = value
                }
            }
        }

        public static var stepSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.stepSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.stepSet_ = value
                }
            }
        }

        public static var taskSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.taskSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.taskSet_ = value
                }
            }
        }

        public static var toolPositionSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.toolPositionSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.toolPositionSet_ = value
                }
            }
        }

        public static var toolSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.toolSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.toolSet_ = value
                }
            }
        }

        public static var userSet: EntitySet {
            get {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    return OdataServiceMetadata.EntitySets.userSet_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(OdataServiceMetadata.EntitySets.self) }
                do {
                    OdataServiceMetadata.EntitySets.userSet_ = value
                }
            }
        }
    }

    public class FunctionImports {
        private static var createJobByPredictiveMaintenance_: DataMethod = OdataServiceMetadataParser.parsed.dataMethod(withName: "createJobByPredictiveMaintenance")

        public static var createJobByPredictiveMaintenance: DataMethod {
            get {
                objc_sync_enter(OdataServiceMetadata.FunctionImports.self)
                defer { objc_sync_exit(OdataServiceMetadata.FunctionImports.self) }
                do {
                    return OdataServiceMetadata.FunctionImports.createJobByPredictiveMaintenance_
                }
            }
            set(value) {
                objc_sync_enter(OdataServiceMetadata.FunctionImports.self)
                defer { objc_sync_exit(OdataServiceMetadata.FunctionImports.self) }
                do {
                    OdataServiceMetadata.FunctionImports.createJobByPredictiveMaintenance_ = value
                }
            }
        }
    }
}
