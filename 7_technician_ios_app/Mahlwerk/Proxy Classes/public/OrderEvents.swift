// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class OrderEvents: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var date_: Property = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "Date")

    private static var orderEventTypeID_: Property = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "OrderEventTypeID")

    private static var orderEventsID_: Property = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "OrderEventsID")

    private static var orderID_: Property = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "OrderID")

    private static var text_: Property = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "Text")

    private static var order_: Property = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "Order")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.orderEvents)
    }

    open class func array(from: EntityValueList) -> [OrderEvents] {
        return ArrayConverter.convert(from.toArray(), [OrderEvents]())
    }

    open func copy() -> OrderEvents {
        return CastRequired<OrderEvents>.from(self.copyEntity())
    }

    open class var date: Property {
        get {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                return OrderEvents.date_
            }
        }
        set(value) {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                OrderEvents.date_ = value
            }
        }
    }

    open var date: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: OrderEvents.date))
        }
        set(value) {
            self.setOptionalValue(for: OrderEvents.date, to: value)
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(orderEventsID: Int64?) -> EntityKey {
        return EntityKey().with(name: "OrderEventsID", value: LongValue.of(optional: orderEventsID))
    }

    open var old: OrderEvents {
        return CastRequired<OrderEvents>.from(self.oldEntity)
    }

    open class var order: Property {
        get {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                return OrderEvents.order_
            }
        }
        set(value) {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                OrderEvents.order_ = value
            }
        }
    }

    open var order: Order? {
        get {
            return CastOptional<Order>.from(self.optionalValue(for: OrderEvents.order))
        }
        set(value) {
            self.setOptionalValue(for: OrderEvents.order, to: value)
        }
    }

    open class var orderEventTypeID: Property {
        get {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                return OrderEvents.orderEventTypeID_
            }
        }
        set(value) {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                OrderEvents.orderEventTypeID_ = value
            }
        }
    }

    open var orderEventTypeID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: OrderEvents.orderEventTypeID))
        }
        set(value) {
            self.setOptionalValue(for: OrderEvents.orderEventTypeID, to: LongValue.of(optional: value))
        }
    }

    open class var orderEventsID: Property {
        get {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                return OrderEvents.orderEventsID_
            }
        }
        set(value) {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                OrderEvents.orderEventsID_ = value
            }
        }
    }

    open var orderEventsID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: OrderEvents.orderEventsID))
        }
        set(value) {
            self.setOptionalValue(for: OrderEvents.orderEventsID, to: LongValue.of(optional: value))
        }
    }

    open class var orderID: Property {
        get {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                return OrderEvents.orderID_
            }
        }
        set(value) {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                OrderEvents.orderID_ = value
            }
        }
    }

    open var orderID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: OrderEvents.orderID))
        }
        set(value) {
            self.setOptionalValue(for: OrderEvents.orderID, to: LongValue.of(optional: value))
        }
    }

    open class var text: Property {
        get {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                return OrderEvents.text_
            }
        }
        set(value) {
            objc_sync_enter(OrderEvents.self)
            defer { objc_sync_exit(OrderEvents.self) }
            do {
                OrderEvents.text_ = value
            }
        }
    }

    open var text: String? {
        get {
            return StringValue.optional(self.optionalValue(for: OrderEvents.text))
        }
        set(value) {
            self.setOptionalValue(for: OrderEvents.text, to: StringValue.of(optional: value))
        }
    }
}
