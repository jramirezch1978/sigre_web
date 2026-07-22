package pe.com.sytco.fastsales.beans.Finanzas;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanFormaPago  extends BeanAncestor implements Serializable {
    private String formaPago, descFormaPago, flagEstado, flagNoCobrable;
    private int diasVencimiento, nroLibro;

    public String getFormaPago() {
        return formaPago;
    }
    public void setFormaPago(String formaPago) {
        this.formaPago = formaPago;
    }
    public String getDescFormaPago() {
        return descFormaPago;
    }
    public void setDescFormaPago(String descFormaPago) {
        this.descFormaPago = descFormaPago;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }
    public String getFlagNoCobrable() {
        return flagNoCobrable;
    }
    public void setFlagNoCobrable(String flagNoCobrable) {
        this.flagNoCobrable = flagNoCobrable;
    }
    public int getDiasVencimiento() {
        return diasVencimiento;
    }
    public void setDiasVencimiento(int diasVencimiento) {
        this.diasVencimiento = diasVencimiento;
    }
    public int getNroLibro() {
        return nroLibro;
    }
    public void setNroLibro(int nroLibro) {
        this.nroLibro = nroLibro;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("formaPago") != null)
            this.formaPago = soapObject.getProperty("formaPago").toString();
        else
            this.formaPago = "";

        if(soapObject.getProperty("descFormaPago") != null)
            this.descFormaPago = soapObject.getProperty("descFormaPago").toString();
        else
            this.descFormaPago = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("flagNoCobrable") != null)
            this.flagNoCobrable = soapObject.getProperty("flagNoCobrable").toString();
        else
            this.flagNoCobrable = "";

        if (soapObject.getProperty("nroLibro") == null)
            this.nroLibro = 0;
        else
            this.nroLibro = Integer.parseInt(soapObject.getProperty("nroLibro").toString());

        if (soapObject.getProperty("diasVencimiento") == null)
            this.diasVencimiento = 0;
        else
            this.diasVencimiento = Integer.parseInt(soapObject.getProperty("diasVencimiento").toString());

    }
}
