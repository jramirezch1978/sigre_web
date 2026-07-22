package pe.com.sytco.fastsales.beans.Comercializacion;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZonaVenta extends BeanAncestor implements Serializable {

    private static final long serialVersionUID = -2410184414414946505L;
    private String zonaVenta, descZonaVenta, ubigeo, flagEstado;

    public String getZonaVenta() {
        return zonaVenta;
    }
    public void setZonaVenta(String zonaVenta) {
        this.zonaVenta = zonaVenta;
    }
    public String getDescZonaVenta() {
        return descZonaVenta;
    }
    public void setDescZonaVenta(String descZonaVenta) {
        this.descZonaVenta = descZonaVenta;
    }
    public String getUbigeo() {
        return ubigeo;
    }
    public void setUbigeo(String ubigeo) {
        this.ubigeo = ubigeo;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("zonaVenta") != null)
            this.zonaVenta = soapObject.getProperty("zonaVenta").toString();
        else
            this.zonaVenta = "";

        if(soapObject.getProperty("descZonaVenta") != null)
            this.descZonaVenta = soapObject.getProperty("descZonaVenta").toString();
        else
            this.descZonaVenta = "";

        if(soapObject.getProperty("ubigeo") != null)
            this.ubigeo = soapObject.getProperty("ubigeo").toString();
        else
            this.ubigeo = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";


    }
}
