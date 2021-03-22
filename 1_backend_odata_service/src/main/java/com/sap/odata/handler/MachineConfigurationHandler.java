package com.sap.odata.handler;

import com.sap.cloud.server.odata.*;

public class MachineConfigurationHandler extends com.sap.cloud.server.odata.DefaultEntityHandler {
    private com.sap.odata.MainServlet servlet;
    private com.sap.odata.proxy.OdataService service;

    public MachineConfigurationHandler(com.sap.odata.MainServlet servlet, com.sap.odata.proxy.OdataService service) {
        super(servlet, service);
        this.servlet = servlet;
        this.service = service;
        allowUnused(this.servlet);
        allowUnused(this.service);
    }

    @Override public DataValue executeQuery(DataQuery query) {
        return service.executeQuery(query).getResult();
    }

    @Override public void createEntity(EntityValue entityValue) {
        com.sap.odata.proxy.MachineConfiguration entity = (com.sap.odata.proxy.MachineConfiguration)entityValue;
        service.createEntity(entity);
    }

    @Override public void updateEntity(EntityValue entityValue) {
        com.sap.odata.proxy.MachineConfiguration entity = (com.sap.odata.proxy.MachineConfiguration)entityValue;
        entity.setMustBeModified(true);
        service.updateEntity(entity);
    }

    @Override public void deleteEntity(EntityValue entityValue) {
        com.sap.odata.proxy.MachineConfiguration entity = (com.sap.odata.proxy.MachineConfiguration)entityValue;
        service.deleteEntity(entity);
    }
}
