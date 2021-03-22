// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Machine: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var description_: Property = OdataServiceMetadata.EntityTypes.machine.property(withName: "Description")

    private static var machineID_: Property = OdataServiceMetadata.EntityTypes.machine.property(withName: "MachineID")

    private static var name_: Property = OdataServiceMetadata.EntityTypes.machine.property(withName: "Name")

    private static var machineConfiguration_: Property = OdataServiceMetadata.EntityTypes.machine.property(withName: "MachineConfiguration")

    private static var task_: Property = OdataServiceMetadata.EntityTypes.machine.property(withName: "Task")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.machine)
    }

    open class func array(from: EntityValueList) -> [Machine] {
        return ArrayConverter.convert(from.toArray(), [Machine]())
    }

    open func copy() -> Machine {
        return CastRequired<Machine>.from(self.copyEntity())
    }

    open class var description: Property {
        get {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                return Machine.description_
            }
        }
        set(value) {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                Machine.description_ = value
            }
        }
    }

    open var description: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Machine.description))
        }
        set(value) {
            self.setOptionalValue(for: Machine.description, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(machineID: Int64?) -> EntityKey {
        return EntityKey().with(name: "MachineID", value: LongValue.of(optional: machineID))
    }

    open class var machineConfiguration: Property {
        get {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                return Machine.machineConfiguration_
            }
        }
        set(value) {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                Machine.machineConfiguration_ = value
            }
        }
    }

    open var machineConfiguration: [MachineConfiguration] {
        get {
            return ArrayConverter.convert(Machine.machineConfiguration.entityList(from: self).toArray(), [MachineConfiguration]())
        }
        set(value) {
            Machine.machineConfiguration.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class var machineID: Property {
        get {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                return Machine.machineID_
            }
        }
        set(value) {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                Machine.machineID_ = value
            }
        }
    }

    open var machineID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Machine.machineID))
        }
        set(value) {
            self.setOptionalValue(for: Machine.machineID, to: LongValue.of(optional: value))
        }
    }

    open class var name: Property {
        get {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                return Machine.name_
            }
        }
        set(value) {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                Machine.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Machine.name))
        }
        set(value) {
            self.setOptionalValue(for: Machine.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Machine {
        return CastRequired<Machine>.from(self.oldEntity)
    }

    open class var task: Property {
        get {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                return Machine.task_
            }
        }
        set(value) {
            objc_sync_enter(Machine.self)
            defer { objc_sync_exit(Machine.self) }
            do {
                Machine.task_ = value
            }
        }
    }

    open var task: Task? {
        get {
            return CastOptional<Task>.from(self.optionalValue(for: Machine.task))
        }
        set(value) {
            self.setOptionalValue(for: Machine.task, to: value)
        }
    }
}
