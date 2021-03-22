package com.sap.odata.handler;

import com.sap.cloud.server.odata.*;

public class MachineColorsHandler extends com.sap.cloud.server.odata.DefaultEntityHandler {
    private com.sap.odata.MainServlet servlet;
    private com.sap.odata.proxy.OdataService service;

    public MachineColorsHandler(com.sap.odata.MainServlet servlet, com.sap.odata.proxy.OdataService service) {
        super(servlet, service);
        this.servlet = servlet;
        this.service = service;
        allowUnused(this.servlet);
        allowUnused(this.service);
    }

    @Override public DataValue executeQuery(DataQuery query) {
        return service.executeQuery(query).getResult();
    }

    @Override public void updateEntity(EntityValue entityValue) {
        com.sap.odata.proxy.MachineColors entity = (com.sap.odata.proxy.MachineColors)entityValue;
        entity.setMustBeModified(true);
        service.updateEntity(entity);
    }

    @Override public void deleteEntity(EntityValue entityValue) {
        com.sap.odata.proxy.MachineColors entity = (com.sap.odata.proxy.MachineColors)entityValue;
        service.deleteEntity(entity);
    }

    public void createMedia(EntityValue entityValue, ByteStream stream) {
        com.sap.odata.proxy.MachineColors entity = (com.sap.odata.proxy.MachineColors)entityValue;
        service.createMedia(entity, stream);
    }

    public void uploadMedia(EntityValue entityValue, ByteStream stream) {
        com.sap.odata.proxy.MachineColors entity = (com.sap.odata.proxy.MachineColors)entityValue;
        service.uploadMedia(entity, stream);
    }

    public void downloadMedia(EntityValue entityValue, ByteStream stream) {
        com.sap.odata.proxy.MachineColors entity = (com.sap.odata.proxy.MachineColors)entityValue;
        service.downloadMedia(entity).copyTo(stream);
    }
}
