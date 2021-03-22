// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

internal class OdataServiceFactory {
    static func registerAll() throws {
        OdataServiceMetadata.EntityTypes.address.registerFactory(ObjectFactory.with(create: { Address(withDefaults: false) }, createWithDecoder: { d in try Address(from: d) }))
        OdataServiceMetadata.EntityTypes.customer.registerFactory(ObjectFactory.with(create: { Customer(withDefaults: false) }, createWithDecoder: { d in try Customer(from: d) }))
        OdataServiceMetadata.EntityTypes.job.registerFactory(ObjectFactory.with(create: { Job(withDefaults: false) }, createWithDecoder: { d in try Job(from: d) }))
        OdataServiceMetadata.EntityTypes.machine.registerFactory(ObjectFactory.with(create: { Machine(withDefaults: false) }, createWithDecoder: { d in try Machine(from: d) }))
        OdataServiceMetadata.EntityTypes.machineConfiguration.registerFactory(ObjectFactory.with(create: { MachineConfiguration(withDefaults: false) }, createWithDecoder: { d in try MachineConfiguration(from: d) }))
        OdataServiceMetadata.EntityTypes.material.registerFactory(ObjectFactory.with(create: { Material(withDefaults: false) }, createWithDecoder: { d in try Material(from: d) }))
        OdataServiceMetadata.EntityTypes.materialPosition.registerFactory(ObjectFactory.with(create: { MaterialPosition(withDefaults: false) }, createWithDecoder: { d in try MaterialPosition(from: d) }))
        OdataServiceMetadata.EntityTypes.order.registerFactory(ObjectFactory.with(create: { Order(withDefaults: false) }, createWithDecoder: { d in try Order(from: d) }))
        OdataServiceMetadata.EntityTypes.orderEvents.registerFactory(ObjectFactory.with(create: { OrderEvents(withDefaults: false) }, createWithDecoder: { d in try OrderEvents(from: d) }))
        OdataServiceMetadata.EntityTypes.part.registerFactory(ObjectFactory.with(create: { Part(withDefaults: false) }, createWithDecoder: { d in try Part(from: d) }))
        OdataServiceMetadata.EntityTypes.partsToChange.registerFactory(ObjectFactory.with(create: { PartsToChange(withDefaults: false) }, createWithDecoder: { d in try PartsToChange(from: d) }))
        OdataServiceMetadata.EntityTypes.step.registerFactory(ObjectFactory.with(create: { Step(withDefaults: false) }, createWithDecoder: { d in try Step(from: d) }))
        OdataServiceMetadata.EntityTypes.task.registerFactory(ObjectFactory.with(create: { Task(withDefaults: false) }, createWithDecoder: { d in try Task(from: d) }))
        OdataServiceMetadata.EntityTypes.tool.registerFactory(ObjectFactory.with(create: { Tool(withDefaults: false) }, createWithDecoder: { d in try Tool(from: d) }))
        OdataServiceMetadata.EntityTypes.toolPosition.registerFactory(ObjectFactory.with(create: { ToolPosition(withDefaults: false) }, createWithDecoder: { d in try ToolPosition(from: d) }))
        OdataServiceMetadata.EntityTypes.user.registerFactory(ObjectFactory.with(create: { User(withDefaults: false) }, createWithDecoder: { d in try User(from: d) }))
        OdataServiceStaticResolver.resolve()
    }
}
