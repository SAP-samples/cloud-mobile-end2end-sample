// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Tool: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var name_: Property = OdataServiceMetadata.EntityTypes.tool.property(withName: "Name")

    private static var toolID_: Property = OdataServiceMetadata.EntityTypes.tool.property(withName: "ToolID")

    private static var toolPosition_: Property = OdataServiceMetadata.EntityTypes.tool.property(withName: "ToolPosition")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.tool)
    }

    open class func array(from: EntityValueList) -> [Tool] {
        return ArrayConverter.convert(from.toArray(), [Tool]())
    }

    open func copy() -> Tool {
        return CastRequired<Tool>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(toolID: Int64?) -> EntityKey {
        return EntityKey().with(name: "ToolID", value: LongValue.of(optional: toolID))
    }

    open class var name: Property {
        get {
            objc_sync_enter(Tool.self)
            defer { objc_sync_exit(Tool.self) }
            do {
                return Tool.name_
            }
        }
        set(value) {
            objc_sync_enter(Tool.self)
            defer { objc_sync_exit(Tool.self) }
            do {
                Tool.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Tool.name))
        }
        set(value) {
            self.setOptionalValue(for: Tool.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Tool {
        return CastRequired<Tool>.from(self.oldEntity)
    }

    open class var toolID: Property {
        get {
            objc_sync_enter(Tool.self)
            defer { objc_sync_exit(Tool.self) }
            do {
                return Tool.toolID_
            }
        }
        set(value) {
            objc_sync_enter(Tool.self)
            defer { objc_sync_exit(Tool.self) }
            do {
                Tool.toolID_ = value
            }
        }
    }

    open var toolID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Tool.toolID))
        }
        set(value) {
            self.setOptionalValue(for: Tool.toolID, to: LongValue.of(optional: value))
        }
    }

    open class var toolPosition: Property {
        get {
            objc_sync_enter(Tool.self)
            defer { objc_sync_exit(Tool.self) }
            do {
                return Tool.toolPosition_
            }
        }
        set(value) {
            objc_sync_enter(Tool.self)
            defer { objc_sync_exit(Tool.self) }
            do {
                Tool.toolPosition_ = value
            }
        }
    }

    open var toolPosition: [ToolPosition] {
        get {
            return ArrayConverter.convert(Tool.toolPosition.entityList(from: self).toArray(), [ToolPosition]())
        }
        set(value) {
            Tool.toolPosition.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }
}
