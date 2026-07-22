package pe.com.sytco.fastsales.beans;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanAndroidDevice extends BeanAncestor implements Serializable, KvmSerializable {

    private String deviceID, IMEI, Software, deviceName, manufacturer, model, codUsuario, codOrigen, nroParte, fecRegistro;

    public String getCodOrigen() {
        return codOrigen;
    }
    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }
    public String getCodUsuario() {
        return codUsuario;
    }
    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }
    public String getManufacturer() {
        return manufacturer;
    }
    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }
    public String getModel() {
        return model;
    }
    public void setModel(String model) {
        this.model = model;
    }
    public String getDeviceID() {
        return deviceID;
    }
    public void setDeviceID(String value) {
        this.deviceID = value;
    }
    public String getIMEI() {
        return IMEI;
    }
    public void setIMEI(String IMEI) {
        this.IMEI = IMEI;
    }
    public String getSoftware() {
        return Software;
    }
    public void setSoftware(String software) {
        Software = software;
    }
    public String getDeviceName() {
        return deviceName;
    }
    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }
    public String getFecRegistro() {
        return fecRegistro;
    }
    public void setFecRegistro(String fecRegistro) {
        this.fecRegistro = fecRegistro;
    }
    public String getNroParte() {
        return nroParte;
    }
    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }

    //private String ID, IMEI, Software, deviceName, manufacturer, model, codUsuario;
    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return deviceID;
            case 1: return IMEI;
            case 2: return Software;
            case 3: return deviceName;
            case 4: return manufacturer;
            case 5: return model;
            case 6: return codUsuario;
            case 7: return nroParte;
            case 8: return codOrigen;
            case 9: return fecRegistro;
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 10;
    }

    @Override
    public void setProperty(int i, Object value) {
        switch(i) {
            case 0:
                deviceID = value.toString();
                break;
            case 1:
                IMEI = value.toString();
                break;
            case 2:
                Software = value.toString();
                break;
            case 3:
                deviceName = value.toString();
                break;
            case 4:
                manufacturer = value.toString();
                break;
            case 5:
                model = value.toString();
                break;
            case 6:
                codUsuario = value.toString();
                break;
            case 7:
                nroParte = value.toString();
                break;
            case 8:
                codOrigen = value.toString();
                break;
            case 9:
                fecRegistro = value.toString();
                break;

        }
    }

    //private String ID, IMEI, Software, deviceName, manufacturer, model, codUsuario;
    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        switch(__index) {
            case 0:
                __info.name = "deviceID";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "IMEI";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "Software";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "deviceName";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "manufacturer";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "model";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "codUsuario";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "nroParte";
                __info.type = String.class;
                break;
            case 8:
                __info.name = "codOrigen";
                __info.type = String.class;
                break;
            case 9:
                __info.name = "fecRegistro";
                __info.type = String.class;
                break;
        }
    }

    @Override
    public String getInnerText() {
        return null;
    }

    @Override
    public void setInnerText(String s) {

    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if(soapObject.getProperty("deviceID") != null)
            this.deviceID = soapObject.getProperty("deviceID").toString();
        else
            this.deviceID = "";

        if(soapObject.getProperty("IMEI") != null)
            this.IMEI = soapObject.getProperty("IMEI").toString();
        else
            this.IMEI = "";

        if(soapObject.getProperty("Software") != null)
            this.Software = soapObject.getProperty("Software").toString();
        else
            this.Software = "";

        if(soapObject.getProperty("deviceName") != null)
            this.deviceName = soapObject.getProperty("deviceName").toString();
        else
            this.deviceName = "";

        if(soapObject.getProperty("manufacturer") != null)
            this.manufacturer = soapObject.getProperty("manufacturer").toString();
        else
            this.manufacturer = "";

        if(soapObject.getProperty("model") != null)
            this.model = soapObject.getProperty("model").toString();
        else
            this.model = "";

        if(soapObject.getProperty("codUsuario") != null)
            this.codUsuario = soapObject.getProperty("codUsuario").toString();
        else
            this.codUsuario = "";

        if(soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = "";

        if(soapObject.getProperty("nroParte") != null)
            this.nroParte = soapObject.getProperty("nroParte").toString();
        else
            this.nroParte = "";

        if(soapObject.getProperty("modelo") != null)
            this.model = soapObject.getProperty("modelo").toString();
        else
            this.model = "";

        if(soapObject.getProperty("fecRegistro") != null)
            this.fecRegistro = soapObject.getProperty("fecRegistro").toString();
        else
            this.fecRegistro = "";

    }

}
