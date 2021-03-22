// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

internal class OdataServiceMetadataChanges {
    static func merge(metadata: CSDLDocument) {
        metadata.hasGeneratedProxies = true
        OdataServiceMetadata.document = metadata
        OdataServiceMetadataChanges.merge1(metadata: metadata)
        try! OdataServiceFactory.registerAll()
    }

    private static func merge1(metadata: CSDLDocument) {
        Ignore.valueOf_any(metadata)
        if !OdataServiceMetadata.EntityTypes.address.isRemoved {
            OdataServiceMetadata.EntityTypes.address = metadata.entityType(withName: "com.sap.odata.Address")
        }
        if !OdataServiceMetadata.EntityTypes.customer.isRemoved {
            OdataServiceMetadata.EntityTypes.customer = metadata.entityType(withName: "com.sap.odata.Customer")
        }
        if !OdataServiceMetadata.EntityTypes.job.isRemoved {
            OdataServiceMetadata.EntityTypes.job = metadata.entityType(withName: "com.sap.odata.Job")
        }
        if !OdataServiceMetadata.EntityTypes.machine.isRemoved {
            OdataServiceMetadata.EntityTypes.machine = metadata.entityType(withName: "com.sap.odata.Machine")
        }
        if !OdataServiceMetadata.EntityTypes.machineConfiguration.isRemoved {
            OdataServiceMetadata.EntityTypes.machineConfiguration = metadata.entityType(withName: "com.sap.odata.MachineConfiguration")
        }
        if !OdataServiceMetadata.EntityTypes.material.isRemoved {
            OdataServiceMetadata.EntityTypes.material = metadata.entityType(withName: "com.sap.odata.Material")
        }
        if !OdataServiceMetadata.EntityTypes.materialPosition.isRemoved {
            OdataServiceMetadata.EntityTypes.materialPosition = metadata.entityType(withName: "com.sap.odata.MaterialPosition")
        }
        if !OdataServiceMetadata.EntityTypes.order.isRemoved {
            OdataServiceMetadata.EntityTypes.order = metadata.entityType(withName: "com.sap.odata.Order")
        }
        if !OdataServiceMetadata.EntityTypes.orderEvents.isRemoved {
            OdataServiceMetadata.EntityTypes.orderEvents = metadata.entityType(withName: "com.sap.odata.OrderEvents")
        }
        if !OdataServiceMetadata.EntityTypes.part.isRemoved {
            OdataServiceMetadata.EntityTypes.part = metadata.entityType(withName: "com.sap.odata.Part")
        }
        if !OdataServiceMetadata.EntityTypes.partsToChange.isRemoved {
            OdataServiceMetadata.EntityTypes.partsToChange = metadata.entityType(withName: "com.sap.odata.PartsToChange")
        }
        if !OdataServiceMetadata.EntityTypes.step.isRemoved {
            OdataServiceMetadata.EntityTypes.step = metadata.entityType(withName: "com.sap.odata.Step")
        }
        if !OdataServiceMetadata.EntityTypes.task.isRemoved {
            OdataServiceMetadata.EntityTypes.task = metadata.entityType(withName: "com.sap.odata.Task")
        }
        if !OdataServiceMetadata.EntityTypes.tool.isRemoved {
            OdataServiceMetadata.EntityTypes.tool = metadata.entityType(withName: "com.sap.odata.Tool")
        }
        if !OdataServiceMetadata.EntityTypes.toolPosition.isRemoved {
            OdataServiceMetadata.EntityTypes.toolPosition = metadata.entityType(withName: "com.sap.odata.ToolPosition")
        }
        if !OdataServiceMetadata.EntityTypes.user.isRemoved {
            OdataServiceMetadata.EntityTypes.user = metadata.entityType(withName: "com.sap.odata.User")
        }
        if !OdataServiceMetadata.EntitySets.addressSet.isRemoved {
            OdataServiceMetadata.EntitySets.addressSet = metadata.entitySet(withName: "AddressSet")
        }
        if !OdataServiceMetadata.EntitySets.customerSet.isRemoved {
            OdataServiceMetadata.EntitySets.customerSet = metadata.entitySet(withName: "CustomerSet")
        }
        if !OdataServiceMetadata.EntitySets.jobSet.isRemoved {
            OdataServiceMetadata.EntitySets.jobSet = metadata.entitySet(withName: "JobSet")
        }
        if !OdataServiceMetadata.EntitySets.machineConfigurationSet.isRemoved {
            OdataServiceMetadata.EntitySets.machineConfigurationSet = metadata.entitySet(withName: "MachineConfigurationSet")
        }
        if !OdataServiceMetadata.EntitySets.machineSet.isRemoved {
            OdataServiceMetadata.EntitySets.machineSet = metadata.entitySet(withName: "MachineSet")
        }
        if !OdataServiceMetadata.EntitySets.materialPositionSet.isRemoved {
            OdataServiceMetadata.EntitySets.materialPositionSet = metadata.entitySet(withName: "MaterialPositionSet")
        }
        if !OdataServiceMetadata.EntitySets.materialSet.isRemoved {
            OdataServiceMetadata.EntitySets.materialSet = metadata.entitySet(withName: "MaterialSet")
        }
        if !OdataServiceMetadata.EntitySets.orderEventsSet.isRemoved {
            OdataServiceMetadata.EntitySets.orderEventsSet = metadata.entitySet(withName: "OrderEventsSet")
        }
        if !OdataServiceMetadata.EntitySets.orderSet.isRemoved {
            OdataServiceMetadata.EntitySets.orderSet = metadata.entitySet(withName: "OrderSet")
        }
        if !OdataServiceMetadata.EntitySets.partSet.isRemoved {
            OdataServiceMetadata.EntitySets.partSet = metadata.entitySet(withName: "PartSet")
        }
        if !OdataServiceMetadata.EntitySets.partsToChangeSet.isRemoved {
            OdataServiceMetadata.EntitySets.partsToChangeSet = metadata.entitySet(withName: "PartsToChangeSet")
        }
        if !OdataServiceMetadata.EntitySets.stepSet.isRemoved {
            OdataServiceMetadata.EntitySets.stepSet = metadata.entitySet(withName: "StepSet")
        }
        if !OdataServiceMetadata.EntitySets.taskSet.isRemoved {
            OdataServiceMetadata.EntitySets.taskSet = metadata.entitySet(withName: "TaskSet")
        }
        if !OdataServiceMetadata.EntitySets.toolPositionSet.isRemoved {
            OdataServiceMetadata.EntitySets.toolPositionSet = metadata.entitySet(withName: "ToolPositionSet")
        }
        if !OdataServiceMetadata.EntitySets.toolSet.isRemoved {
            OdataServiceMetadata.EntitySets.toolSet = metadata.entitySet(withName: "ToolSet")
        }
        if !OdataServiceMetadata.EntitySets.userSet.isRemoved {
            OdataServiceMetadata.EntitySets.userSet = metadata.entitySet(withName: "UserSet")
        }
        if !OdataServiceMetadata.FunctionImports.createJobByPredictiveMaintenance.isRemoved {
            OdataServiceMetadata.FunctionImports.createJobByPredictiveMaintenance = metadata.dataMethod(withName: "createJobByPredictiveMaintenance")
        }
        if !Address.addressID.isRemoved {
            Address.addressID = OdataServiceMetadata.EntityTypes.address.property(withName: "AddressID")
        }
        if !Address.country.isRemoved {
            Address.country = OdataServiceMetadata.EntityTypes.address.property(withName: "Country")
        }
        if !Address.houseNumber.isRemoved {
            Address.houseNumber = OdataServiceMetadata.EntityTypes.address.property(withName: "HouseNumber")
        }
        if !Address.postalCode.isRemoved {
            Address.postalCode = OdataServiceMetadata.EntityTypes.address.property(withName: "PostalCode")
        }
        if !Address.street.isRemoved {
            Address.street = OdataServiceMetadata.EntityTypes.address.property(withName: "Street")
        }
        if !Address.town.isRemoved {
            Address.town = OdataServiceMetadata.EntityTypes.address.property(withName: "Town")
        }
        if !Address.customer.isRemoved {
            Address.customer = OdataServiceMetadata.EntityTypes.address.property(withName: "Customer")
        }
        if !Address.task.isRemoved {
            Address.task = OdataServiceMetadata.EntityTypes.address.property(withName: "Task")
        }
        if !Customer.addressID.isRemoved {
            Customer.addressID = OdataServiceMetadata.EntityTypes.customer.property(withName: "AddressID")
        }
        if !Customer.companyName.isRemoved {
            Customer.companyName = OdataServiceMetadata.EntityTypes.customer.property(withName: "CompanyName")
        }
        if !Customer.customerID.isRemoved {
            Customer.customerID = OdataServiceMetadata.EntityTypes.customer.property(withName: "CustomerID")
        }
        if !Customer.email.isRemoved {
            Customer.email = OdataServiceMetadata.EntityTypes.customer.property(withName: "Email")
        }
        if !Customer.name.isRemoved {
            Customer.name = OdataServiceMetadata.EntityTypes.customer.property(withName: "Name")
        }
        if !Customer.phone.isRemoved {
            Customer.phone = OdataServiceMetadata.EntityTypes.customer.property(withName: "Phone")
        }
        if !Customer.address.isRemoved {
            Customer.address = OdataServiceMetadata.EntityTypes.customer.property(withName: "Address")
        }
        if !Customer.order.isRemoved {
            Customer.order = OdataServiceMetadata.EntityTypes.customer.property(withName: "Order")
        }
        if !Job.actualWorkHours.isRemoved {
            Job.actualWorkHours = OdataServiceMetadata.EntityTypes.job.property(withName: "ActualWorkHours")
        }
        if !Job.doneDate.isRemoved {
            Job.doneDate = OdataServiceMetadata.EntityTypes.job.property(withName: "DoneDate")
        }
        if !Job.jobID.isRemoved {
            Job.jobID = OdataServiceMetadata.EntityTypes.job.property(withName: "JobID")
        }
        if !Job.jobStatusID.isRemoved {
            Job.jobStatusID = OdataServiceMetadata.EntityTypes.job.property(withName: "JobStatusID")
        }
        if !Job.predictedWorkHours.isRemoved {
            Job.predictedWorkHours = OdataServiceMetadata.EntityTypes.job.property(withName: "PredictedWorkHours")
        }
        if !Job.suggested.isRemoved {
            Job.suggested = OdataServiceMetadata.EntityTypes.job.property(withName: "Suggested")
        }
        if !Job.taskID.isRemoved {
            Job.taskID = OdataServiceMetadata.EntityTypes.job.property(withName: "TaskID")
        }
        if !Job.title.isRemoved {
            Job.title = OdataServiceMetadata.EntityTypes.job.property(withName: "Title")
        }
        if !Job.materialPosition.isRemoved {
            Job.materialPosition = OdataServiceMetadata.EntityTypes.job.property(withName: "MaterialPosition")
        }
        if !Job.partsToChange.isRemoved {
            Job.partsToChange = OdataServiceMetadata.EntityTypes.job.property(withName: "PartsToChange")
        }
        if !Job.step.isRemoved {
            Job.step = OdataServiceMetadata.EntityTypes.job.property(withName: "Step")
        }
        if !Job.task.isRemoved {
            Job.task = OdataServiceMetadata.EntityTypes.job.property(withName: "Task")
        }
        if !Job.toolPosition.isRemoved {
            Job.toolPosition = OdataServiceMetadata.EntityTypes.job.property(withName: "ToolPosition")
        }
        if !Machine.description.isRemoved {
            Machine.description = OdataServiceMetadata.EntityTypes.machine.property(withName: "Description")
        }
        if !Machine.machineID.isRemoved {
            Machine.machineID = OdataServiceMetadata.EntityTypes.machine.property(withName: "MachineID")
        }
        if !Machine.name.isRemoved {
            Machine.name = OdataServiceMetadata.EntityTypes.machine.property(withName: "Name")
        }
        if !Machine.machineConfiguration.isRemoved {
            Machine.machineConfiguration = OdataServiceMetadata.EntityTypes.machine.property(withName: "MachineConfiguration")
        }
        if !Machine.task.isRemoved {
            Machine.task = OdataServiceMetadata.EntityTypes.machine.property(withName: "Task")
        }
        if !MachineConfiguration.color.isRemoved {
            MachineConfiguration.color = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "Color")
        }
        if !MachineConfiguration.machineConfigurationID.isRemoved {
            MachineConfiguration.machineConfigurationID = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "MachineConfigurationID")
        }
        if !MachineConfiguration.machineID.isRemoved {
            MachineConfiguration.machineID = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "MachineID")
        }
        if !MachineConfiguration.orderID.isRemoved {
            MachineConfiguration.orderID = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "OrderID")
        }
        if !MachineConfiguration.pressure.isRemoved {
            MachineConfiguration.pressure = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "Pressure")
        }
        if !MachineConfiguration.machineTyp.isRemoved {
            MachineConfiguration.machineTyp = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "MachineTyp")
        }
        if !MachineConfiguration.order.isRemoved {
            MachineConfiguration.order = OdataServiceMetadata.EntityTypes.machineConfiguration.property(withName: "Order")
        }
        if !Material.materialID.isRemoved {
            Material.materialID = OdataServiceMetadata.EntityTypes.material.property(withName: "MaterialID")
        }
        if !Material.name.isRemoved {
            Material.name = OdataServiceMetadata.EntityTypes.material.property(withName: "Name")
        }
        if !Material.materialPosition.isRemoved {
            Material.materialPosition = OdataServiceMetadata.EntityTypes.material.property(withName: "MaterialPosition")
        }
        if !MaterialPosition.jobID.isRemoved {
            MaterialPosition.jobID = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "JobID")
        }
        if !MaterialPosition.materialID.isRemoved {
            MaterialPosition.materialID = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "MaterialID")
        }
        if !MaterialPosition.materialPositionID.isRemoved {
            MaterialPosition.materialPositionID = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "MaterialPositionID")
        }
        if !MaterialPosition.quantity.isRemoved {
            MaterialPosition.quantity = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "Quantity")
        }
        if !MaterialPosition.job.isRemoved {
            MaterialPosition.job = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "Job")
        }
        if !MaterialPosition.material.isRemoved {
            MaterialPosition.material = OdataServiceMetadata.EntityTypes.materialPosition.property(withName: "Material")
        }
        if !Order.customerID.isRemoved {
            Order.customerID = OdataServiceMetadata.EntityTypes.order.property(withName: "CustomerID")
        }
        if !Order.description.isRemoved {
            Order.description = OdataServiceMetadata.EntityTypes.order.property(withName: "Description")
        }
        if !Order.dueDate.isRemoved {
            Order.dueDate = OdataServiceMetadata.EntityTypes.order.property(withName: "DueDate")
        }
        if !Order.orderID.isRemoved {
            Order.orderID = OdataServiceMetadata.EntityTypes.order.property(withName: "OrderID")
        }
        if !Order.orderStatusID.isRemoved {
            Order.orderStatusID = OdataServiceMetadata.EntityTypes.order.property(withName: "OrderStatusID")
        }
        if !Order.title.isRemoved {
            Order.title = OdataServiceMetadata.EntityTypes.order.property(withName: "Title")
        }
        if !Order.customer.isRemoved {
            Order.customer = OdataServiceMetadata.EntityTypes.order.property(withName: "Customer")
        }
        if !Order.machineConfiguration.isRemoved {
            Order.machineConfiguration = OdataServiceMetadata.EntityTypes.order.property(withName: "MachineConfiguration")
        }
        if !Order.orderEvents.isRemoved {
            Order.orderEvents = OdataServiceMetadata.EntityTypes.order.property(withName: "OrderEvents")
        }
        if !Order.task.isRemoved {
            Order.task = OdataServiceMetadata.EntityTypes.order.property(withName: "Task")
        }
        if !OrderEvents.date.isRemoved {
            OrderEvents.date = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "Date")
        }
        if !OrderEvents.orderEventTypeID.isRemoved {
            OrderEvents.orderEventTypeID = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "OrderEventTypeID")
        }
        if !OrderEvents.orderEventsID.isRemoved {
            OrderEvents.orderEventsID = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "OrderEventsID")
        }
        if !OrderEvents.orderID.isRemoved {
            OrderEvents.orderID = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "OrderID")
        }
        if !OrderEvents.text.isRemoved {
            OrderEvents.text = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "Text")
        }
        if !OrderEvents.order.isRemoved {
            OrderEvents.order = OdataServiceMetadata.EntityTypes.orderEvents.property(withName: "Order")
        }
        if !Part.name.isRemoved {
            Part.name = OdataServiceMetadata.EntityTypes.part.property(withName: "Name")
        }
        if !Part.partID.isRemoved {
            Part.partID = OdataServiceMetadata.EntityTypes.part.property(withName: "PartID")
        }
        if !Part.partsToChange.isRemoved {
            Part.partsToChange = OdataServiceMetadata.EntityTypes.part.property(withName: "PartsToChange")
        }
        if !PartsToChange.jobID.isRemoved {
            PartsToChange.jobID = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "JobID")
        }
        if !PartsToChange.partID.isRemoved {
            PartsToChange.partID = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "PartID")
        }
        if !PartsToChange.partsToChangeID.isRemoved {
            PartsToChange.partsToChangeID = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "PartsToChangeID")
        }
        if !PartsToChange.job.isRemoved {
            PartsToChange.job = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "Job")
        }
        if !PartsToChange.part.isRemoved {
            PartsToChange.part = OdataServiceMetadata.EntityTypes.partsToChange.property(withName: "Part")
        }
        if !Step.jobID.isRemoved {
            Step.jobID = OdataServiceMetadata.EntityTypes.step.property(withName: "JobID")
        }
        if !Step.name.isRemoved {
            Step.name = OdataServiceMetadata.EntityTypes.step.property(withName: "Name")
        }
        if !Step.stepID.isRemoved {
            Step.stepID = OdataServiceMetadata.EntityTypes.step.property(withName: "StepID")
        }
        if !Step.job.isRemoved {
            Step.job = OdataServiceMetadata.EntityTypes.step.property(withName: "Job")
        }
        if !Task.addressID.isRemoved {
            Task.addressID = OdataServiceMetadata.EntityTypes.task.property(withName: "AddressID")
        }
        if !Task.finalReportStatusID.isRemoved {
            Task.finalReportStatusID = OdataServiceMetadata.EntityTypes.task.property(withName: "FinalReportStatusID")
        }
        if !Task.machineID.isRemoved {
            Task.machineID = OdataServiceMetadata.EntityTypes.task.property(withName: "MachineID")
        }
        if !Task.notes.isRemoved {
            Task.notes = OdataServiceMetadata.EntityTypes.task.property(withName: "Notes")
        }
        if !Task.orderID.isRemoved {
            Task.orderID = OdataServiceMetadata.EntityTypes.task.property(withName: "OrderID")
        }
        if !Task.scheduledDate.isRemoved {
            Task.scheduledDate = OdataServiceMetadata.EntityTypes.task.property(withName: "ScheduledDate")
        }
        if !Task.taskID.isRemoved {
            Task.taskID = OdataServiceMetadata.EntityTypes.task.property(withName: "TaskID")
        }
        if !Task.taskStatusID.isRemoved {
            Task.taskStatusID = OdataServiceMetadata.EntityTypes.task.property(withName: "TaskStatusID")
        }
        if !Task.title.isRemoved {
            Task.title = OdataServiceMetadata.EntityTypes.task.property(withName: "Title")
        }
        if !Task.userID.isRemoved {
            Task.userID = OdataServiceMetadata.EntityTypes.task.property(withName: "UserID")
        }
        if !Task.address.isRemoved {
            Task.address = OdataServiceMetadata.EntityTypes.task.property(withName: "Address")
        }
        if !Task.job.isRemoved {
            Task.job = OdataServiceMetadata.EntityTypes.task.property(withName: "Job")
        }
        if !Task.machine.isRemoved {
            Task.machine = OdataServiceMetadata.EntityTypes.task.property(withName: "Machine")
        }
        if !Task.order.isRemoved {
            Task.order = OdataServiceMetadata.EntityTypes.task.property(withName: "Order")
        }
        if !Task.user.isRemoved {
            Task.user = OdataServiceMetadata.EntityTypes.task.property(withName: "User")
        }
        if !Tool.name.isRemoved {
            Tool.name = OdataServiceMetadata.EntityTypes.tool.property(withName: "Name")
        }
        if !Tool.toolID.isRemoved {
            Tool.toolID = OdataServiceMetadata.EntityTypes.tool.property(withName: "ToolID")
        }
        if !Tool.toolPosition.isRemoved {
            Tool.toolPosition = OdataServiceMetadata.EntityTypes.tool.property(withName: "ToolPosition")
        }
        if !ToolPosition.jobID.isRemoved {
            ToolPosition.jobID = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "JobID")
        }
        if !ToolPosition.quantity.isRemoved {
            ToolPosition.quantity = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "Quantity")
        }
        if !ToolPosition.toolID.isRemoved {
            ToolPosition.toolID = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "ToolID")
        }
        if !ToolPosition.toolPositionID.isRemoved {
            ToolPosition.toolPositionID = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "ToolPositionID")
        }
        if !ToolPosition.job.isRemoved {
            ToolPosition.job = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "Job")
        }
        if !ToolPosition.tool.isRemoved {
            ToolPosition.tool = OdataServiceMetadata.EntityTypes.toolPosition.property(withName: "Tool")
        }
        if !User.email.isRemoved {
            User.email = OdataServiceMetadata.EntityTypes.user.property(withName: "Email")
        }
        if !User.firstNames.isRemoved {
            User.firstNames = OdataServiceMetadata.EntityTypes.user.property(withName: "FirstNames")
        }
        if !User.lastNames.isRemoved {
            User.lastNames = OdataServiceMetadata.EntityTypes.user.property(withName: "LastNames")
        }
        if !User.phone.isRemoved {
            User.phone = OdataServiceMetadata.EntityTypes.user.property(withName: "Phone")
        }
        if !User.userID.isRemoved {
            User.userID = OdataServiceMetadata.EntityTypes.user.property(withName: "UserID")
        }
        if !User.task.isRemoved {
            User.task = OdataServiceMetadata.EntityTypes.user.property(withName: "Task")
        }
    }
}
