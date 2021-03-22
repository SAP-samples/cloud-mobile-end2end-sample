package com.sap.odata.listener;

import com.sap.cloud.server.odata.*;

public class PartsToChangeListener extends com.sap.cloud.server.odata.DefaultEntityListener {
    private com.sap.odata.MainServlet servlet;
    private com.sap.odata.proxy.OdataService service;

    public PartsToChangeListener(com.sap.odata.MainServlet servlet, com.sap.odata.proxy.OdataService service) {
        super();
        this.servlet = servlet;
        this.service = service;
        allowUnused(this.servlet);
        allowUnused(this.service);
    }

    @Override public void beforeQuery(DataQuery query) {
        allowUnused(query);
    }

    public void beforeSave(EntityValue entityValue) {
        // Shared code for beforeCreate / beforeUpdate.
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
    }

    @Override public void beforeCreate(EntityValue entityValue) {
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
        beforeSave(entity);
    }

    @Override public void beforeUpdate(EntityValue entityValue) {
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
        beforeSave(entity);
    }

    @Override public void beforeDelete(EntityValue entityValue) {
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
    }

    public void afterSave(EntityValue entityValue) {
        // Shared code for afterCreate / afterUpdate.
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
    }

    @Override public void afterCreate(EntityValue entityValue) {
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
        afterSave(entity);
    }

    @Override public void afterUpdate(EntityValue entityValue) {
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
        afterSave(entity);
    }

    @Override public void afterDelete(EntityValue entityValue) {
        com.sap.odata.proxy.PartsToChange entity = (com.sap.odata.proxy.PartsToChange)entityValue;
        allowUnused(entity);
    }
}
