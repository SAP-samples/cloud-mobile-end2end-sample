// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Material: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var materialID_: Property = OdataServiceMetadata.EntityTypes.material.property(withName: "MaterialID")

    private static var name_: Property = OdataServiceMetadata.EntityTypes.material.property(withName: "Name")

    private static var materialPosition_: Property = OdataServiceMetadata.EntityTypes.material.property(withName: "MaterialPosition")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.material)
    }

    open class func array(from: EntityValueList) -> [Material] {
        return ArrayConverter.convert(from.toArray(), [Material]())
    }

    open func copy() -> Material {
        return CastRequired<Material>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(materialID: Int64?) -> EntityKey {
        return EntityKey().with(name: "MaterialID", value: LongValue.of(optional: materialID))
    }

    open class var materialID: Property {
        get {
            objc_sync_enter(Material.self)
            defer { objc_sync_exit(Material.self) }
            do {
                return Material.materialID_
            }
        }
        set(value) {
            objc_sync_enter(Material.self)
            defer { objc_sync_exit(Material.self) }
            do {
                Material.materialID_ = value
            }
        }
    }

    open var materialID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Material.materialID))
        }
        set(value) {
            self.setOptionalValue(for: Material.materialID, to: LongValue.of(optional: value))
        }
    }

    open class var materialPosition: Property {
        get {
            objc_sync_enter(Material.self)
            defer { objc_sync_exit(Material.self) }
            do {
                return Material.materialPosition_
            }
        }
        set(value) {
            objc_sync_enter(Material.self)
            defer { objc_sync_exit(Material.self) }
            do {
                Material.materialPosition_ = value
            }
        }
    }

    open var materialPosition: [MaterialPosition] {
        get {
            return ArrayConverter.convert(Material.materialPosition.entityList(from: self).toArray(), [MaterialPosition]())
        }
        set(value) {
            Material.materialPosition.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class var name: Property {
        get {
            objc_sync_enter(Material.self)
            defer { objc_sync_exit(Material.self) }
            do {
                return Material.name_
            }
        }
        set(value) {
            objc_sync_enter(Material.self)
            defer { objc_sync_exit(Material.self) }
            do {
                Material.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Material.name))
        }
        set(value) {
            self.setOptionalValue(for: Material.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Material {
        return CastRequired<Material>.from(self.oldEntity)
    }
}
