// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

open class Customer: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var addressID_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "AddressID")

    private static var companyName_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "CompanyName")

    private static var customerID_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "CustomerID")

    private static var email_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "Email")

    private static var name_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "Name")

    private static var phone_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "Phone")

    private static var address_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "Address")

    private static var order_: Property = OdataServiceMetadata.EntityTypes.customer.property(withName: "Order")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: OdataServiceMetadata.EntityTypes.customer)
    }

    open class var address: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.address_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.address_ = value
            }
        }
    }

    open var address: Address? {
        get {
            return CastOptional<Address>.from(self.optionalValue(for: Customer.address))
        }
        set(value) {
            self.setOptionalValue(for: Customer.address, to: value)
        }
    }

    open class var addressID: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.addressID_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.addressID_ = value
            }
        }
    }

    open var addressID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Customer.addressID))
        }
        set(value) {
            self.setOptionalValue(for: Customer.addressID, to: LongValue.of(optional: value))
        }
    }

    open class func array(from: EntityValueList) -> [Customer] {
        return ArrayConverter.convert(from.toArray(), [Customer]())
    }

    open class var companyName: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.companyName_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.companyName_ = value
            }
        }
    }

    open var companyName: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.companyName))
        }
        set(value) {
            self.setOptionalValue(for: Customer.companyName, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> Customer {
        return CastRequired<Customer>.from(self.copyEntity())
    }

    open class var customerID: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.customerID_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.customerID_ = value
            }
        }
    }

    open var customerID: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: Customer.customerID))
        }
        set(value) {
            self.setOptionalValue(for: Customer.customerID, to: LongValue.of(optional: value))
        }
    }

    open class var email: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.email_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.email_ = value
            }
        }
    }

    open var email: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.email))
        }
        set(value) {
            self.setOptionalValue(for: Customer.email, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(customerID: Int64?) -> EntityKey {
        return EntityKey().with(name: "CustomerID", value: LongValue.of(optional: customerID))
    }

    open class var name: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.name_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.name))
        }
        set(value) {
            self.setOptionalValue(for: Customer.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Customer {
        return CastRequired<Customer>.from(self.oldEntity)
    }

    open class var order: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.order_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.order_ = value
            }
        }
    }

    open var order: [Order] {
        get {
            return ArrayConverter.convert(Customer.order.entityList(from: self).toArray(), [Order]())
        }
        set(value) {
            Customer.order.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class var phone: Property {
        get {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                return Customer.phone_
            }
        }
        set(value) {
            objc_sync_enter(Customer.self)
            defer { objc_sync_exit(Customer.self) }
            do {
                Customer.phone_ = value
            }
        }
    }

    open var phone: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.phone))
        }
        set(value) {
            self.setOptionalValue(for: Customer.phone, to: StringValue.of(optional: value))
        }
    }
}
