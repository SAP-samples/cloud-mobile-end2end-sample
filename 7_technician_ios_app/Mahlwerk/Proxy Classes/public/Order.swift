// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Order: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var customerID_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "CustomerID")

    private static var description_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "Description")

    private static var dueDate_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "DueDate")

    private static var orderID_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "OrderID")

    private static var orderStatusID_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "OrderStatusID")

    private static var title_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "Title")

    private static var customer_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "Customer")

    private static var machineConfiguration_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "MachineConfiguration")

    private static var orderEvents_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "OrderEvents")

    private static var task_: Property = OdataServiceMetadata.EntityTypes.order.property(withName: "Task")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.order)
    }

    open class func array(from: EntityValueList) -> [Order] {
        return ArrayConverter.convert(from.toArray(), [Order]())
    }

    open func copy() -> Order {
        return CastRequired<Order>.from(self.copyEntity())
    }

    open class var customer: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.customer_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.customer_ = value
            }
        }
    }

    open var customer: Customer? {
        get {
            return CastOptional<Customer>.from(self.optionalValue(for: Order.customer))
        }
        set(value) {
            self.setOptionalValue(for: Order.customer, to: value)
        }
    }

    open class var customerID: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.customerID_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.customerID_ = value
            }
        }
    }

    open var customerID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Order.customerID))
        }
        set(value) {
            self.setOptionalValue(for: Order.customerID, to: LongValue.of(optional: value))
        }
    }

    open class var description: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.description_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.description_ = value
            }
        }
    }

    open var description: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Order.description))
        }
        set(value) {
            self.setOptionalValue(for: Order.description, to: StringValue.of(optional: value))
        }
    }

    open class var dueDate: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.dueDate_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.dueDate_ = value
            }
        }
    }

    open var dueDate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Order.dueDate))
        }
        set(value) {
            self.setOptionalValue(for: Order.dueDate, to: value)
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(orderID: Int64?) -> EntityKey {
        return EntityKey().with(name: "OrderID", value: LongValue.of(optional: orderID))
    }

    open class var machineConfiguration: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.machineConfiguration_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.machineConfiguration_ = value
            }
        }
    }

    open var machineConfiguration: MachineConfiguration? {
        get {
            return CastOptional<MachineConfiguration>.from(self.optionalValue(for: Order.machineConfiguration))
        }
        set(value) {
            self.setOptionalValue(for: Order.machineConfiguration, to: value)
        }
    }

    open var old: Order {
        return CastRequired<Order>.from(self.oldEntity)
    }

    open class var orderEvents: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.orderEvents_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.orderEvents_ = value
            }
        }
    }

    open var orderEvents: [OrderEvents] {
        get {
            return ArrayConverter.convert(Order.orderEvents.entityList(from: self).toArray(), [OrderEvents]())
        }
        set(value) {
            Order.orderEvents.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class var orderID: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.orderID_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.orderID_ = value
            }
        }
    }

    open var orderID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Order.orderID))
        }
        set(value) {
            self.setOptionalValue(for: Order.orderID, to: LongValue.of(optional: value))
        }
    }

    open class var orderStatusID: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.orderStatusID_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.orderStatusID_ = value
            }
        }
    }

    open var orderStatusID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Order.orderStatusID))
        }
        set(value) {
            self.setOptionalValue(for: Order.orderStatusID, to: LongValue.of(optional: value))
        }
    }

    open class var task: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.task_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.task_ = value
            }
        }
    }

    open var task: Task? {
        get {
            return CastOptional<Task>.from(self.optionalValue(for: Order.task))
        }
        set(value) {
            self.setOptionalValue(for: Order.task, to: value)
        }
    }

    open class var title: Property {
        get {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                return Order.title_
            }
        }
        set(value) {
            objc_sync_enter(Order.self)
            defer { objc_sync_exit(Order.self) }
            do {
                Order.title_ = value
            }
        }
    }

    open var title: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Order.title))
        }
        set(value) {
            self.setOptionalValue(for: Order.title, to: StringValue.of(optional: value))
        }
    }
}
