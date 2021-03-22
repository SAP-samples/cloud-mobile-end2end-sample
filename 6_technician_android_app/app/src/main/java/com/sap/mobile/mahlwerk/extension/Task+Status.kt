package com.sap.mobile.mahlwerk.extension

import com.sap.cloud.android.odata.odataservice.Task
import com.sap.mobile.mahlwerk.model.FinalReportStatus
import com.sap.mobile.mahlwerk.model.TaskStatus

/** Convenience property for representing the status of a Task */
val Task.taskStatus: TaskStatus
    get() {
        return TaskStatus.values()[taskStatusID.toInt()]
    }

/** Convenience property for representing the final report status of a Task */
val Task.finalReportStatus: FinalReportStatus
    get() {
        return FinalReportStatus.values()[finalReportStatusID.toInt()]
    }