package pe.com.sytco.fastsales.beans.Comercializacion;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZonaDespacho extends BeanAncestor implements Serializable {
    private static final long serialVersionUID = -2410184414414946505L;
    private String zonaDespacho, descZonaDespacho, ubigeo, flagEstado;

    public String getZonaDespacho() {
        return zonaDespacho;
    }
    public void setZonaDespacho(String zonaDespacho) {
        this.zonaDespacho = zonaDespacho;
    }
    public String getDescZonaDespacho() {
        return descZonaDespacho;
    }
    public void setDescZonaDespacho(String descZonaDespacho) {
        this.descZonaDespacho = descZonaDespacho;
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

        if(soapObject.getProperty("zonaDespacho") != null)
            this.zonaDespacho = soapObject.getProperty("zonaDespacho").toString();
        else
            this.zonaDespacho = "";

        if(soapObject.getProperty("descZonaDespacho") != null)
            this.descZonaDespacho = soapObject.getProperty("descZonaDespacho").toString();
        else
            this.descZonaDespacho = "";

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
