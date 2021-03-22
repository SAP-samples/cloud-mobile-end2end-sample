// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Task: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var addressID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "AddressID")

    private static var finalReportStatusID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "FinalReportStatusID")

    private static var machineID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "MachineID")

    private static var notes_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "Notes")

    private static var orderID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "OrderID")

    private static var scheduledDate_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "ScheduledDate")

    private static var taskID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "TaskID")

    private static var taskStatusID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "TaskStatusID")

    private static var title_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "Title")

    private static var userID_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "UserID")

    private static var address_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "Address")

    private static var job_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "Job")

    private static var machine_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "Machine")

    private static var order_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "Order")

    private static var user_: Property = OdataServiceMetadata.EntityTypes.task.property(withName: "User")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.task)
    }

    open class var address: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.address_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.address_ = value
            }
        }
    }

    open var address: Address? {
        get {
            return CastOptional<Address>.from(self.optionalValue(for: Task.address))
        }
        set(value) {
            self.setOptionalValue(for: Task.address, to: value)
        }
    }

    open class var addressID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.addressID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.addressID_ = value
            }
        }
    }

    open var addressID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.addressID))
        }
        set(value) {
            self.setOptionalValue(for: Task.addressID, to: LongValue.of(optional: value))
        }
    }

    open class func array(from: EntityValueList) -> [Task] {
        return ArrayConverter.convert(from.toArray(), [Task]())
    }

    open func copy() -> Task {
        return CastRequired<Task>.from(self.copyEntity())
    }

    open class var finalReportStatusID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.finalReportStatusID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.finalReportStatusID_ = value
            }
        }
    }

    open var finalReportStatusID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.finalReportStatusID))
        }
        set(value) {
            self.setOptionalValue(for: Task.finalReportStatusID, to: LongValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class var job: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.job_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.job_ = value
            }
        }
    }

    open var job: [Job] {
        get {
            return ArrayConverter.convert(Task.job.entityList(from: self).toArray(), [Job]())
        }
        set(value) {
            Task.job.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class func key(taskID: Int64?) -> EntityKey {
        return EntityKey().with(name: "TaskID", value: LongValue.of(optional: taskID))
    }

    open class var machine: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.machine_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.machine_ = value
            }
        }
    }

    open var machine: Machine? {
        get {
            return CastOptional<Machine>.from(self.optionalValue(for: Task.machine))
        }
        set(value) {
            self.setOptionalValue(for: Task.machine, to: value)
        }
    }

    open class var machineID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.machineID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.machineID_ = value
            }
        }
    }

    open var machineID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.machineID))
        }
        set(value) {
            self.setOptionalValue(for: Task.machineID, to: LongValue.of(optional: value))
        }
    }

    open class var notes: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.notes_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.notes_ = value
            }
        }
    }

    open var notes: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Task.notes))
        }
        set(value) {
            self.setOptionalValue(for: Task.notes, to: StringValue.of(optional: value))
        }
    }

    open var old: Task {
        return CastRequired<Task>.from(self.oldEntity)
    }

    open class var order: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.order_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.order_ = value
            }
        }
    }

    open var order: Order? {
        get {
            return CastOptional<Order>.from(self.optionalValue(for: Task.order))
        }
        set(value) {
            self.setOptionalValue(for: Task.order, to: value)
        }
    }

    open class var orderID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.orderID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.orderID_ = value
            }
        }
    }

    open var orderID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.orderID))
        }
        set(value) {
            self.setOptionalValue(for: Task.orderID, to: LongValue.of(optional: value))
        }
    }

    open class var scheduledDate: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.scheduledDate_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.scheduledDate_ = value
            }
        }
    }

    open var scheduledDate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Task.scheduledDate))
        }
        set(value) {
            self.setOptionalValue(for: Task.scheduledDate, to: value)
        }
    }

    open class var taskID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.taskID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.taskID_ = value
            }
        }
    }

    open var taskID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.taskID))
        }
        set(value) {
            self.setOptionalValue(for: Task.taskID, to: LongValue.of(optional: value))
        }
    }

    open class var taskStatusID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.taskStatusID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.taskStatusID_ = value
            }
        }
    }

    open var taskStatusID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.taskStatusID))
        }
        set(value) {
            self.setOptionalValue(for: Task.taskStatusID, to: LongValue.of(optional: value))
        }
    }

    open class var title: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.title_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.title_ = value
            }
        }
    }

    open var title: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Task.title))
        }
        set(value) {
            self.setOptionalValue(for: Task.title, to: StringValue.of(optional: value))
        }
    }

    open class var user: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.user_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.user_ = value
            }
        }
    }

    open var user: User? {
        get {
            return CastOptional<User>.from(self.optionalValue(for: Task.user))
        }
        set(value) {
            self.setOptionalValue(for: Task.user, to: value)
        }
    }

    open class var userID: Property {
        get {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                return Task.userID_
            }
        }
        set(value) {
            objc_sync_enter(Task.self)
            defer { objc_sync_exit(Task.self) }
            do {
                Task.userID_ = value
            }
        }
    }

    open var userID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Task.userID))
        }
        set(value) {
            self.setOptionalValue(for: Task.userID, to: LongValue.of(optional: value))
        }
    }
}
