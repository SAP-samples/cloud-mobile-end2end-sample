package com.sap.mobile.mahlwerk.extension

import com.sap.cloud.android.odata.odataservice.Job
import com.sap.mobile.mahlwerk.model.JobStatus

/** Convenience property for representing the status of a Job */
val Job.jobStatus: JobStatus
    get() {
        return JobStatus.values()[jobStatusID.toInt()]
    }