package com.sap.odata.listener;

import com.sap.cloud.server.odata.*;

public class MaterialListener extends com.sap.cloud.server.odata.DefaultEntityListener {
    private com.sap.odata.MainServlet servlet;
    private com.sap.odata.proxy.OdataService service;

    public MaterialListener(com.sap.odata.MainServlet servlet, com.sap.odata.proxy.OdataService service) {
        super();
        this.servlet = servlet;
        this.service = service;
    }

    @Override public void beforeQuery(DataQuery query) {
    }

    public void beforeSave(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
        // Shared code for beforeCreate / beforeUpdate.
    }

    @Override public void beforeCreate(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
        beforeSave(entity);
    }

    @Override public void beforeUpdate(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
        beforeSave(entity);
    }

    @Override public void beforeDelete(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
    }

    public void afterSave(EntityValue entityValue) {
        // Shared code for afterCreate / afterUpdate.
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
    }

    @Override public void afterCreate(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
        afterSave(entity);
    }

    @Override public void afterUpdate(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
        afterSave(entity);
    }

    @Override public void afterDelete(EntityValue entityValue) {
        com.sap.odata.proxy.Material entity = (com.sap.odata.proxy.Material)entityValue;
    }
}
