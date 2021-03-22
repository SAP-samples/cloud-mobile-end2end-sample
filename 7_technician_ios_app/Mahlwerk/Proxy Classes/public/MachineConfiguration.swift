// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class MachineConfiguration: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var color_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "Color")

    private static var machineConfigurationID_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "MachineConfigurationID")

    private static var machineID_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "MachineID")

    private static var orderID_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "OrderID")

    private static var pressure_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "Pressure")

    private static var machineTyp_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "MachineTyp")

    private static var order_: Property = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "Order")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.machineConfiguration)
    }

    open class func array(from: EntityValueList) -> [MachineConfiguration] {
        return ArrayConverter.convert(from.toArray(), [MachineConfiguration]())
    }

    open class var color: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.color_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.color_ = value
            }
        }
    }

    open var color: String? {
        get {
            return StringValue.optional(self.optionalValue(for: MachineConfiguration.color))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.color, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> MachineConfiguration {
        return CastRequired<MachineConfiguration>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(machineConfigurationID: Int64?) -> EntityKey {
        return EntityKey().with(name: "MachineConfigurationID", value: LongValue.of(optional: machineConfigurationID))
    }

    open class var machineConfigurationID: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.machineConfigurationID_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.machineConfigurationID_ = value
            }
        }
    }

    open var machineConfigurationID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: MachineConfiguration.machineConfigurationID))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.machineConfigurationID, to: LongValue.of(optional: value))
        }
    }

    open class var machineID: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.machineID_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.machineID_ = value
            }
        }
    }

    open var machineID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: MachineConfiguration.machineID))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.machineID, to: LongValue.of(optional: value))
        }
    }

    open class var machineTyp: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.machineTyp_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.machineTyp_ = value
            }
        }
    }

    open var machineTyp: Machine? {
        get {
            return CastOptional<Machine>.from(self.optionalValue(for: MachineConfiguration.machineTyp))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.machineTyp, to: value)
        }
    }

    open var old: MachineConfiguration {
        return CastRequired<MachineConfiguration>.from(self.oldEntity)
    }

    open class var order: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.order_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.order_ = value
            }
        }
    }

    open var order: Order? {
        get {
            return CastOptional<Order>.from(self.optionalValue(for: MachineConfiguration.order))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.order, to: value)
        }
    }

    open class var orderID: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.orderID_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.orderID_ = value
            }
        }
    }

    open var orderID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: MachineConfiguration.orderID))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.orderID, to: LongValue.of(optional: value))
        }
    }

    open class var pressure: Property {
        get {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                return MachineConfiguration.pressure_
            }
        }
        set(value) {
            objc_sync_enter(MachineConfiguration.self)
            defer { objc_sync_exit(MachineConfiguration.self) }
            do {
                MachineConfiguration.pressure_ = value
            }
        }
    }

    open var pressure: String? {
        get {
            return StringValue.optional(self.optionalValue(for: MachineConfiguration.pressure))
        }
        set(value) {
            self.setOptionalValue(for: MachineConfiguration.pressure, to: StringValue.of(optional: value))
        }
    }
}
