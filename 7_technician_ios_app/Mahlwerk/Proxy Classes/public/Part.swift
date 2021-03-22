// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Part: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var name_: Property = OdataServiceMetadata.EntityTypes.part.property(withName: "Name")

    private static var partID_: Property = OdataServiceMetadata.EntityTypes.part.property(withName: "PartID")

    private static var partsToChange_: Property = OdataServiceMetadata.EntityTypes.part.property(withName: "PartsToChange")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.part)
    }

    open class func array(from: EntityValueList) -> [Part] {
        return ArrayConverter.convert(from.toArray(), [Part]())
    }

    open func copy() -> Part {
        return CastRequired<Part>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(partID: Int64?) -> EntityKey {
        return EntityKey().with(name: "PartID", value: LongValue.of(optional: partID))
    }

    open class var name: Property {
        get {
            objc_sync_enter(Part.self)
            defer { objc_sync_exit(Part.self) }
            do {
                return Part.name_
            }
        }
        set(value) {
            objc_sync_enter(Part.self)
            defer { objc_sync_exit(Part.self) }
            do {
                Part.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Part.name))
        }
        set(value) {
            self.setOptionalValue(for: Part.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Part {
        return CastRequired<Part>.from(self.oldEntity)
    }

    open class var partID: Property {
        get {
            objc_sync_enter(Part.self)
            defer { objc_sync_exit(Part.self) }
            do {
                return Part.partID_
            }
        }
        set(value) {
            objc_sync_enter(Part.self)
            defer { objc_sync_exit(Part.self) }
            do {
                Part.partID_ = value
            }
        }
    }

    open var partID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Part.partID))
        }
        set(value) {
            self.setOptionalValue(for: Part.partID, to: LongValue.of(optional: value))
        }
    }

    open class var partsToChange: Property {
        get {
            objc_sync_enter(Part.self)
            defer { objc_sync_exit(Part.self) }
            do {
                return Part.partsToChange_
            }
        }
        set(value) {
            objc_sync_enter(Part.self)
            defer { objc_sync_exit(Part.self) }
            do {
                Part.partsToChange_ = value
            }
        }
    }

    open var partsToChange: [PartsToChange] {
        get {
            return ArrayConverter.convert(Part.partsToChange.entityList(from: self).toArray(), [PartsToChange]())
        }
        set(value) {
            Part.partsToChange.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }
}
