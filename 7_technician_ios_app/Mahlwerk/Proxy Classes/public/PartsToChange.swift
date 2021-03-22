// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class PartsToChange: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var jobID_: Property = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "JobID")

    private static var partID_: Property = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "PartID")

    private static var partsToChangeID_: Property = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "PartsToChangeID")

    private static var job_: Property = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "Job")

    private static var part_: Property = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "Part")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.partsToChange)
    }

    open class func array(from: EntityValueList) -> [PartsToChange] {
        return ArrayConverter.convert(from.toArray(), [PartsToChange]())
    }

    open func copy() -> PartsToChange {
        return CastRequired<PartsToChange>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class var job: Property {
        get {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                return PartsToChange.job_
            }
        }
        set(value) {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                PartsToChange.job_ = value
            }
        }
    }

    open var job: Job? {
        get {
            return CastOptional<Job>.from(self.optionalValue(for: PartsToChange.job))
        }
        set(value) {
            self.setOptionalValue(for: PartsToChange.job, to: value)
        }
    }

    open class var jobID: Property {
        get {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                return PartsToChange.jobID_
            }
        }
        set(value) {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                PartsToChange.jobID_ = value
            }
        }
    }

    open var jobID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: PartsToChange.jobID))
        }
        set(value) {
            self.setOptionalValue(for: PartsToChange.jobID, to: LongValue.of(optional: value))
        }
    }

    open class func key(partsToChangeID: Int64?) -> EntityKey {
        return EntityKey().with(name: "PartsToChangeID", value: LongValue.of(optional: partsToChangeID))
    }

    open var old: PartsToChange {
        return CastRequired<PartsToChange>.from(self.oldEntity)
    }

    open class var part: Property {
        get {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                return PartsToChange.part_
            }
        }
        set(value) {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                PartsToChange.part_ = value
            }
        }
    }

    open var part: Part? {
        get {
            return CastOptional<Part>.from(self.optionalValue(for: PartsToChange.part))
        }
        set(value) {
            self.setOptionalValue(for: PartsToChange.part, to: value)
        }
    }

    open class var partID: Property {
        get {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                return PartsToChange.partID_
            }
        }
        set(value) {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                PartsToChange.partID_ = value
            }
        }
    }

    open var partID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: PartsToChange.partID))
        }
        set(value) {
            self.setOptionalValue(for: PartsToChange.partID, to: LongValue.of(optional: value))
        }
    }

    open class var partsToChangeID: Property {
        get {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                return PartsToChange.partsToChangeID_
            }
        }
        set(value) {
            objc_sync_enter(PartsToChange.self)
            defer { objc_sync_exit(PartsToChange.self) }
            do {
                PartsToChange.partsToChangeID_ = value
            }
        }
    }

    open var partsToChangeID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: PartsToChange.partsToChangeID))
        }
        set(value) {
            self.setOptionalValue(for: PartsToChange.partsToChangeID, to: LongValue.of(optional: value))
        }
    }
}
