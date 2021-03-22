// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class MaterialPosition: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var jobID_: Property = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "JobID")

    private static var materialID_: Property = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "MaterialID")

    private static var materialPositionID_: Property = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "MaterialPositionID")

    private static var quantity_: Property = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "Quantity")

    private static var job_: Property = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "Job")

    private static var material_: Property = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "Material")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.materialPosition)
    }

    open class func array(from: EntityValueList) -> [MaterialPosition] {
        return ArrayConverter.convert(from.toArray(), [MaterialPosition]())
    }

    open func copy() -> MaterialPosition {
        return CastRequired<MaterialPosition>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class var job: Property {
        get {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                return MaterialPosition.job_
            }
        }
        set(value) {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                MaterialPosition.job_ = value
            }
        }
    }

    open var job: Job? {
        get {
            return CastOptional<Job>.from(self.optionalValue(for: MaterialPosition.job))
        }
        set(value) {
            self.setOptionalValue(for: MaterialPosition.job, to: value)
        }
    }

    open class var jobID: Property {
        get {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                return MaterialPosition.jobID_
            }
        }
        set(value) {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                MaterialPosition.jobID_ = value
            }
        }
    }

    open var jobID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: MaterialPosition.jobID))
        }
        set(value) {
            self.setOptionalValue(for: MaterialPosition.jobID, to: LongValue.of(optional: value))
        }
    }

    open class func key(materialPositionID: Int64?) -> EntityKey {
        return EntityKey().with(name: "MaterialPositionID", value: LongValue.of(optional: materialPositionID))
    }

    open class var material: Property {
        get {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                return MaterialPosition.material_
            }
        }
        set(value) {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                MaterialPosition.material_ = value
            }
        }
    }

    open var material: Material? {
        get {
            return CastOptional<Material>.from(self.optionalValue(for: MaterialPosition.material))
        }
        set(value) {
            self.setOptionalValue(for: MaterialPosition.material, to: value)
        }
    }

    open class var materialID: Property {
        get {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                return MaterialPosition.materialID_
            }
        }
        set(value) {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                MaterialPosition.materialID_ = value
            }
        }
    }

    open var materialID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: MaterialPosition.materialID))
        }
        set(value) {
            self.setOptionalValue(for: MaterialPosition.materialID, to: LongValue.of(optional: value))
        }
    }

    open class var materialPositionID: Property {
        get {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                return MaterialPosition.materialPositionID_
            }
        }
        set(value) {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                MaterialPosition.materialPositionID_ = value
            }
        }
    }

    open var materialPositionID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: MaterialPosition.materialPositionID))
        }
        set(value) {
            self.setOptionalValue(for: MaterialPosition.materialPositionID, to: LongValue.of(optional: value))
        }
    }

    open var old: MaterialPosition {
        return CastRequired<MaterialPosition>.from(self.oldEntity)
    }

    open class var quantity: Property {
        get {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                return MaterialPosition.quantity_
            }
        }
        set(value) {
            objc_sync_enter(MaterialPosition.self)
            defer { objc_sync_exit(MaterialPosition.self) }
            do {
                MaterialPosition.quantity_ = value
            }
        }
    }

    open var quantity: Int? {
        get {
            return ShortValue.optional(self.optionalValue(for: MaterialPosition.quantity))
        }
        set(value) {
            self.setOptionalValue(for: MaterialPosition.quantity, to: ShortValue.of(optional: value))
        }
    }
}
