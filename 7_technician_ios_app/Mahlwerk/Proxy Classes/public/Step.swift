// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Step: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var jobID_: Property = OdataServiceMetadata.EntityTypes.step.property(withName: "JobID")

    private static var name_: Property = OdataServiceMetadata.EntityTypes.step.property(withName: "Name")

    private static var stepID_: Property = OdataServiceMetadata.EntityTypes.step.property(withName: "StepID")

    private static var job_: Property = OdataServiceMetadata.EntityTypes.step.property(withName: "Job")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.step)
    }

    open class func array(from: EntityValueList) -> [Step] {
        return ArrayConverter.convert(from.toArray(), [Step]())
    }

    open func copy() -> Step {
        return CastRequired<Step>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class var job: Property {
        get {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                return Step.job_
            }
        }
        set(value) {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                Step.job_ = value
            }
        }
    }

    open var job: Job? {
        get {
            return CastOptional<Job>.from(self.optionalValue(for: Step.job))
        }
        set(value) {
            self.setOptionalValue(for: Step.job, to: value)
        }
    }

    open class var jobID: Property {
        get {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                return Step.jobID_
            }
        }
        set(value) {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                Step.jobID_ = value
            }
        }
    }

    open var jobID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Step.jobID))
        }
        set(value) {
            self.setOptionalValue(for: Step.jobID, to: LongValue.of(optional: value))
        }
    }

    open class func key(stepID: Int64?) -> EntityKey {
        return EntityKey().with(name: "StepID", value: LongValue.of(optional: stepID))
    }

    open class var name: Property {
        get {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                return Step.name_
            }
        }
        set(value) {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                Step.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Step.name))
        }
        set(value) {
            self.setOptionalValue(for: Step.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Step {
        return CastRequired<Step>.from(self.oldEntity)
    }

    open class var stepID: Property {
        get {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                return Step.stepID_
            }
        }
        set(value) {
            objc_sync_enter(Step.self)
            defer { objc_sync_exit(Step.self) }
            do {
                Step.stepID_ = value
            }
        }
    }

    open var stepID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Step.stepID))
        }
        set(value) {
            self.setOptionalValue(for: Step.stepID, to: LongValue.of(optional: value))
        }
    }
}
