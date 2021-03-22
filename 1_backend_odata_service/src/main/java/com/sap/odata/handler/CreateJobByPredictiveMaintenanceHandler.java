package com.sap.odata.handler;

import com.sap.cloud.server.odata.*;

public class CreateJobByPredictiveMaintenanceHandler extends com.sap.cloud.server.odata.DefaultMethodHandler {
    private com.sap.odata.MainServlet servlet;
    private com.sap.odata.proxy.OdataService service;

    public CreateJobByPredictiveMaintenanceHandler(com.sap.odata.MainServlet servlet, com.sap.odata.proxy.OdataService service) {
        super(servlet, service);
        this.servlet = servlet;
        this.service = service;
        allowUnused(this.servlet);
        allowUnused(this.service);
    }

    @Override public DataValue executeMethod(DataMethod method, ParameterList parameters) {
        Long taskID = LongValue.toNullable(parameters.getRequired("taskID"));
        com.sap.odata.proxy.JobList input = createJobByPredictiveMaintenance(taskID);
        return EntityValueList.share(input);
    }

    public com.sap.odata.proxy.JobList createJobByPredictiveMaintenance(Long taskID) {
        // Method implementation code should be placed here...
        throw DataServiceException.notImplemented("createJobByPredictiveMaintenance");
    }
}
