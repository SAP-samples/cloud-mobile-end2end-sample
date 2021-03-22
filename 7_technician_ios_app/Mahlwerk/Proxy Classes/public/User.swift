// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class User: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var email_: Property = OdataServiceMetadata.EntityTypes.user.property(withName: "Email")

    private static var firstNames_: Property = OdataServiceMetadata.EntityTypes.user.property(withName: "FirstNames")

    private static var lastNames_: Property = OdataServiceMetadata.EntityTypes.user.property(withName: "LastNames")

    private static var phone_: Property = OdataServiceMetadata.EntityTypes.user.property(withName: "Phone")

    private static var userID_: Property = OdataServiceMetadata.EntityTypes.user.property(withName: "UserID")

    private static var task_: Property = OdataServiceMetadata.EntityTypes.user.property(withName: "Task")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.user)
    }

    open class func array(from: EntityValueList) -> [User] {
        return ArrayConverter.convert(from.toArray(), [User]())
    }

    open func copy() -> User {
        return CastRequired<User>.from(self.copyEntity())
    }

    open class var email: Property {
        get {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                return User.email_
            }
        }
        set(value) {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                User.email_ = value
            }
        }
    }

    open var email: String? {
        get {
            return StringValue.optional(self.optionalValue(for: User.email))
        }
        set(value) {
            self.setOptionalValue(for: User.email, to: StringValue.of(optional: value))
        }
    }

    open class var firstNames: Property {
        get {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                return User.firstNames_
            }
        }
        set(value) {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                User.firstNames_ = value
            }
        }
    }

    open var firstNames: String? {
        get {
            return StringValue.optional(self.optionalValue(for: User.firstNames))
        }
        set(value) {
            self.setOptionalValue(for: User.firstNames, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(userID: Int64?) -> EntityKey {
        return EntityKey().with(name: "UserID", value: LongValue.of(optional: userID))
    }

    open class var lastNames: Property {
        get {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                return User.lastNames_
            }
        }
        set(value) {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                User.lastNames_ = value
            }
        }
    }

    open var lastNames: String? {
        get {
            return StringValue.optional(self.optionalValue(for: User.lastNames))
        }
        set(value) {
            self.setOptionalValue(for: User.lastNames, to: StringValue.of(optional: value))
        }
    }

    open var old: User {
        return CastRequired<User>.from(self.oldEntity)
    }

    open class var phone: Property {
        get {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                return User.phone_
            }
        }
        set(value) {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                User.phone_ = value
            }
        }
    }

    open var phone: String? {
        get {
            return StringValue.optional(self.optionalValue(for: User.phone))
        }
        set(value) {
            self.setOptionalValue(for: User.phone, to: StringValue.of(optional: value))
        }
    }

    open class var task: Property {
        get {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                return User.task_
            }
        }
        set(value) {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                User.task_ = value
            }
        }
    }

    open var task: Task? {
        get {
            return CastOptional<Task>.from(self.optionalValue(for: User.task))
        }
        set(value) {
            self.setOptionalValue(for: User.task, to: value)
        }
    }

    open class var userID: Property {
        get {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                return User.userID_
            }
        }
        set(value) {
            objc_sync_enter(User.self)
            defer { objc_sync_exit(User.self) }
            do {
                User.userID_ = value
            }
        }
    }

    open var userID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: User.userID))
        }
        set(value) {
            self.setOptionalValue(for: User.userID, to: LongValue.of(optional: value))
        }
    }
}
