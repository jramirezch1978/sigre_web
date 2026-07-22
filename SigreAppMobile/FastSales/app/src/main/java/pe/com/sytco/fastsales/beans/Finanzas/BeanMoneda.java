package pe.com.sytco.fastsales.beans.Finanzas;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanMoneda extends BeanAncestor implements Serializable {

    private static final long serialVersionUID = 4788856331592419516L;

    private String codMoneda, descMoneda, flagEstado;

    public String getCodMoneda() {
        return codMoneda;
    }
    public void setCodMoneda(String codMoneda) {
        this.codMoneda = codMoneda;
    }
    public String getDescMoneda() {
        return descMoneda;
    }
    public void setDescMoneda(String descMoneda) {
        this.descMoneda = descMoneda;
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

        if(soapObject.getProperty("codMoneda") != null)
            this.codMoneda = soapObject.getProperty("codMoneda").toString();
        else
            this.codMoneda = "";

        if(soapObject.getProperty("descMoneda") != null)
            this.descMoneda = soapObject.getProperty("descMoneda").toString();
        else
            this.descMoneda = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

    }
}
