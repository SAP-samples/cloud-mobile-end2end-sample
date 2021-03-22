package com.sap.odata.listener;

import com.sap.cloud.server.odata.*;

public class TaskListener extends com.sap.cloud.server.odata.DefaultEntityListener {
    private com.sap.odata.MainServlet servlet;
    private com.sap.odata.proxy.OdataService service;


    public TaskListener(com.sap.odata.MainServlet servlet, com.sap.odata.proxy.OdataService service) {
        super();
        this.servlet = servlet;
        this.service = service;
    }

    @Override
    public void beforeQuery(DataQuery query) {
    }

    public void beforeSave(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
        // Shared code for beforeCreate / beforeUpdate.
    }

    @Override
    public void beforeCreate(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
        beforeSave(entity);
    }

    @Override
    public void beforeUpdate(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
        beforeSave(entity);
    }

    @Override
    public void beforeDelete(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
    }

    public void afterSave(EntityValue entityValue) {
        // Shared code for afterCreate / afterUpdate.
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
    }

    @Override
    public void afterCreate(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
        afterSave(entity);
    }

    @Override
    public void afterUpdate(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
        afterSave(entity);
    }

    @Override
    public void afterDelete(EntityValue entityValue) {
        com.sap.odata.proxy.Task entity = (com.sap.odata.proxy.Task) entityValue;
    }
}
