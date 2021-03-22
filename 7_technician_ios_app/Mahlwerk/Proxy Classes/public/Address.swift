// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Address: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var addressID_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "AddressID")

    private static var country_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "Country")

    private static var houseNumber_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "HouseNumber")

    private static var postalCode_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "PostalCode")

    private static var street_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "Street")

    private static var town_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "Town")

    private static var customer_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "Customer")

    private static var task_: Property = OdataServiceMetadata.EntityTypes.address.property(withName: "Task")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.address)
    }

    open class var addressID: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.addressID_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.addressID_ = value
            }
        }
    }

    open var addressID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Address.addressID))
        }
        set(value) {
            self.setOptionalValue(for: Address.addressID, to: LongValue.of(optional: value))
        }
    }

    open class func array(from: EntityValueList) -> [Address] {
        return ArrayConverter.convert(from.toArray(), [Address]())
    }

    open func copy() -> Address {
        return CastRequired<Address>.from(self.copyEntity())
    }

    open class var country: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.country_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.country_ = value
            }
        }
    }

    open var country: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.country))
        }
        set(value) {
            self.setOptionalValue(for: Address.country, to: StringValue.of(optional: value))
        }
    }

    open class var customer: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.customer_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.customer_ = value
            }
        }
    }

    open var customer: Customer? {
        get {
            return CastOptional<Customer>.from(self.optionalValue(for: Address.customer))
        }
        set(value) {
            self.setOptionalValue(for: Address.customer, to: value)
        }
    }

    open class var houseNumber: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.houseNumber_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.houseNumber_ = value
            }
        }
    }

    open var houseNumber: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.houseNumber))
        }
        set(value) {
            self.setOptionalValue(for: Address.houseNumber, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(addressID: Int64?) -> EntityKey {
        return EntityKey().with(name: "AddressID", value: LongValue.of(optional: addressID))
    }

    open var old: Address {
        return CastRequired<Address>.from(self.oldEntity)
    }

    open class var postalCode: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.postalCode_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.postalCode_ = value
            }
        }
    }

    open var postalCode: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.postalCode))
        }
        set(value) {
            self.setOptionalValue(for: Address.postalCode, to: StringValue.of(optional: value))
        }
    }

    open class var street: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.street_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.street_ = value
            }
        }
    }

    open var street: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.street))
        }
        set(value) {
            self.setOptionalValue(for: Address.street, to: StringValue.of(optional: value))
        }
    }

    open class var task: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.task_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.task_ = value
            }
        }
    }

    open var task: Task? {
        get {
            return CastOptional<Task>.from(self.optionalValue(for: Address.task))
        }
        set(value) {
            self.setOptionalValue(for: Address.task, to: value)
        }
    }

    open class var town: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.town_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.town_ = value
            }
        }
    }

    open var town: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.town))
        }
        set(value) {
            self.setOptionalValue(for: Address.town, to: StringValue.of(optional: value))
        }
    }
}
