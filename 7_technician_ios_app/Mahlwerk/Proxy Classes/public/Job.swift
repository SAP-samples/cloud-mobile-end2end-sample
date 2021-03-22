// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Job: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var actualWorkHours_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "ActualWorkHours")

    private static var doneDate_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "DoneDate")

    private static var jobID_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "JobID")

    private static var jobStatusID_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "JobStatusID")

    private static var predictedWorkHours_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "PredictedWorkHours")

    private static var suggested_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "Suggested")

    private static var taskID_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "TaskID")

    private static var title_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "Title")

    private static var materialPosition_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "MaterialPosition")

    private static var partsToChange_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "PartsToChange")

    private static var step_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "Step")

    private static var task_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "Task")

    private static var toolPosition_: Property = OdataServiceMetadata.EntityTypes.job.property(withName: "ToolPosition")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.job)
    }

    open class var actualWorkHours: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.actualWorkHours_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.actualWorkHours_ = value
            }
        }
    }

    open var actualWorkHours: Int? {
        get {
            return ShortValue.optional(self.optionalValue(for: Job.actualWorkHours))
        }
        set(value) {
            self.setOptionalValue(for: Job.actualWorkHours, to: ShortValue.of(optional: value))
        }
    }

    open class func array(from: EntityValueList) -> [Job] {
        return ArrayConverter.convert(from.toArray(), [Job]())
    }

    open func copy() -> Job {
        return CastRequired<Job>.from(self.copyEntity())
    }

    open class var doneDate: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.doneDate_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.doneDate_ = value
            }
        }
    }

    open var doneDate: GlobalDateTime? {
        get {
            return GlobalDateTime.castOptional(self.optionalValue(for: Job.doneDate))
        }
        set(value) {
            self.setOptionalValue(for: Job.doneDate, to: value)
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class var jobID: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.jobID_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.jobID_ = value
            }
        }
    }

    open var jobID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Job.jobID))
        }
        set(value) {
            self.setOptionalValue(for: Job.jobID, to: LongValue.of(optional: value))
        }
    }

    open class var jobStatusID: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.jobStatusID_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.jobStatusID_ = value
            }
        }
    }

    open var jobStatusID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Job.jobStatusID))
        }
        set(value) {
            self.setOptionalValue(for: Job.jobStatusID, to: LongValue.of(optional: value))
        }
    }

    open class func key(jobID: Int64?) -> EntityKey {
        return EntityKey().with(name: "JobID", value: LongValue.of(optional: jobID))
    }

    open class var materialPosition: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.materialPosition_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.materialPosition_ = value
            }
        }
    }

    open var materialPosition: [MaterialPosition] {
        get {
            return ArrayConverter.convert(Job.materialPosition.entityList(from: self).toArray(), [MaterialPosition]())
        }
        set(value) {
            Job.materialPosition.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open var old: Job {
        return CastRequired<Job>.from(self.oldEntity)
    }

    open class var partsToChange: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.partsToChange_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.partsToChange_ = value
            }
        }
    }

    open var partsToChange: PartsToChange? {
        get {
            return CastOptional<PartsToChange>.from(self.optionalValue(for: Job.partsToChange))
        }
        set(value) {
            self.setOptionalValue(for: Job.partsToChange, to: value)
        }
    }

    open class var predictedWorkHours: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.predictedWorkHours_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.predictedWorkHours_ = value
            }
        }
    }

    open var predictedWorkHours: Int? {
        get {
            return ShortValue.optional(self.optionalValue(for: Job.predictedWorkHours))
        }
        set(value) {
            self.setOptionalValue(for: Job.predictedWorkHours, to: ShortValue.of(optional: value))
        }
    }

    open class var step: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.step_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.step_ = value
            }
        }
    }

    open var step: [Step] {
        get {
            return ArrayConverter.convert(Job.step.entityList(from: self).toArray(), [Step]())
        }
        set(value) {
            Job.step.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class var suggested: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.suggested_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.suggested_ = value
            }
        }
    }

    open var suggested: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: Job.suggested))
        }
        set(value) {
            self.setOptionalValue(for: Job.suggested, to: BooleanValue.of(optional: value))
        }
    }

    open class var task: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.task_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.task_ = value
            }
        }
    }

    open var task: Task? {
        get {
            return CastOptional<Task>.from(self.optionalValue(for: Job.task))
        }
        set(value) {
            self.setOptionalValue(for: Job.task, to: value)
        }
    }

    open class var taskID: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.taskID_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.taskID_ = value
            }
        }
    }

    open var taskID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Job.taskID))
        }
        set(value) {
            self.setOptionalValue(for: Job.taskID, to: LongValue.of(optional: value))
        }
    }

    open class var title: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.title_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.title_ = value
            }
        }
    }

    open var title: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Job.title))
        }
        set(value) {
            self.setOptionalValue(for: Job.title, to: StringValue.of(optional: value))
        }
    }

    open class var toolPosition: Property {
        get {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                return Job.toolPosition_
            }
        }
        set(value) {
            objc_sync_enter(Job.self)
            defer { objc_sync_exit(Job.self) }
            do {
                Job.toolPosition_ = value
            }
        }
    }

    open var toolPosition: [ToolPosition] {
        get {
            return ArrayConverter.convert(Job.toolPosition.entityList(from: self).toArray(), [ToolPosition]())
        }
        set(value) {
            Job.toolPosition.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }
}
