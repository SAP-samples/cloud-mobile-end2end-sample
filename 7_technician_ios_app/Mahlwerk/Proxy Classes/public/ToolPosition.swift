// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class ToolPosition: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var jobID_: Property = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "JobID")

    private static var quantity_: Property = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "Quantity")

    private static var toolID_: Property = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "ToolID")

    private static var toolPositionID_: Property = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "ToolPositionID")

    private static var job_: Property = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "Job")

    private static var tool_: Property = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "Tool")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.toolPosition)
    }

    open class func array(from: EntityValueList) -> [ToolPosition] {
        return ArrayConverter.convert(from.toArray(), [ToolPosition]())
    }

    open func copy() -> ToolPosition {
        return CastRequired<ToolPosition>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class var job: Property {
        get {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                return ToolPosition.job_
            }
        }
        set(value) {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                ToolPosition.job_ = value
            }
        }
    }

    open var job: Job? {
        get {
            return CastOptional<Job>.from(self.optionalValue(for: ToolPosition.job))
        }
        set(value) {
            self.setOptionalValue(for: ToolPosition.job, to: value)
        }
    }

    open class var jobID: Property {
        get {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                return ToolPosition.jobID_
            }
        }
        set(value) {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                ToolPosition.jobID_ = value
            }
        }
    }

    open var jobID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: ToolPosition.jobID))
        }
        set(value) {
            self.setOptionalValue(for: ToolPosition.jobID, to: LongValue.of(optional: value))
        }
    }

    open class func key(toolPositionID: Int64?) -> EntityKey {
        return EntityKey().with(name: "ToolPositionID", value: LongValue.of(optional: toolPositionID))
    }

    open var old: ToolPosition {
        return CastRequired<ToolPosition>.from(self.oldEntity)
    }

    open class var quantity: Property {
        get {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                return ToolPosition.quantity_
            }
        }
        set(value) {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                ToolPosition.quantity_ = value
            }
        }
    }

    open var quantity: Int? {
        get {
            return ShortValue.optional(self.optionalValue(for: ToolPosition.quantity))
        }
        set(value) {
            self.setOptionalValue(for: ToolPosition.quantity, to: ShortValue.of(optional: value))
        }
    }

    open class var tool: Property {
        get {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                return ToolPosition.tool_
            }
        }
        set(value) {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                ToolPosition.tool_ = value
            }
        }
    }

    open var tool: Tool? {
        get {
            return CastOptional<Tool>.from(self.optionalValue(for: ToolPosition.tool))
        }
        set(value) {
            self.setOptionalValue(for: ToolPosition.tool, to: value)
        }
    }

    open class var toolID: Property {
        get {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                return ToolPosition.toolID_
            }
        }
        set(value) {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                ToolPosition.toolID_ = value
            }
        }
    }

    open var toolID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: ToolPosition.toolID))
        }
        set(value) {
            self.setOptionalValue(for: ToolPosition.toolID, to: LongValue.of(optional: value))
        }
    }

    open class var toolPositionID: Property {
        get {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                return ToolPosition.toolPositionID_
            }
        }
        set(value) {
            objc_sync_enter(ToolPosition.self)
            defer { objc_sync_exit(ToolPosition.self) }
            do {
                ToolPosition.toolPositionID_ = value
            }
        }
    }

    open var toolPositionID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: ToolPosition.toolPositionID))
        }
        set(value) {
            self.setOptionalValue(for: ToolPosition.toolPositionID, to: LongValue.of(optional: value))
        }
    }
}
