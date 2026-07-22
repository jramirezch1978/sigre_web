package pe.com.sytco.fastsales.beans;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanParametros extends BeanAncestor implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = -3561998615258048606L;

    private Double ICBPER = 0.0, porcIGV = 0.0;
    private String showPrecioMin = "", showPrecioMay = "", solicitarCliente = "", codIGV = "", validarSotck = "", claseBonif="";
    private String soles, dolares;
    private String showVentasNVC, showICBPER, validaReniec, validaSunat;

    public Double getICBPER() {
        return ICBPER;
    }
    public void setICBPER(Double value) {
        this.ICBPER = value;
    }
    public Double getPorcIGV() {
        return porcIGV;
    }
    public void setPorcIGV(Double value) {
        this.porcIGV = value;
    }
    public String getShowPrecioMin() {
        return showPrecioMin;
    }
    public void setShowPrecioMin(String value) {
        this.showPrecioMin = value;
    }
    public String getShowPrecioMay() {
        return showPrecioMay;
    }
    public void setShowPrecioMay(String value) {
        this.showPrecioMay = value;
    }
    public String getSolicitarCliente() {
        return solicitarCliente;
    }
    public void setSolicitarCliente(String value) {
        this.solicitarCliente = value;
    }
    public String getCodIGV() {
        return codIGV;
    }
    public void setCodIGV(String codIGV) {
        this.codIGV = codIGV;
    }
    public String getValidarSotck() {
        return validarSotck;
    }
    public void setValidarSotck(String validarSotck) {
        this.validarSotck = validarSotck;
    }
    public String getClaseBonif() {
        return claseBonif;
    }
    public void setClaseBonif(String claseBonif) {
        this.claseBonif = claseBonif;
    }
    public String getSoles() {
        return soles;
    }
    public void setSoles(String soles) {
        this.soles = soles;
    }
    public String getDolares() {
        return dolares;
    }
    public void setDolares(String dolares) {
        this.dolares = dolares;
    }
    public String getShowVentasNVC() {
        return showVentasNVC;
    }
    public void setShowVentasNVC(String showVentasNVC) {
        this.showVentasNVC = showVentasNVC;
    }
    public String getShowICBPER() {
        return showICBPER;
    }
    public void setShowICBPER(String value) {
        this.showICBPER = value;
    }
    public String getValidaReniec() {
        return validaReniec;
    }
    public void setValidaReniec(String value) {
        this.validaReniec = value;
    }
    public String getValidaSunat() {
        return validaSunat;
    }
    public void setValidaSunat(String value) {
        this.validaSunat = value;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        /*
            private Double ICBPER = 0.0, porcIGV = 0.0;
            private String showPrecioMin = "", showPrecioMay = "", solicitarCliente = "", codIGV = "";
        */

        if (soapObject.getProperty("ICBPER") == null)
            this.ICBPER = 0.00;
        else
            this.ICBPER = Double.parseDouble(soapObject.getProperty("ICBPER").toString());

        if (soapObject.getProperty("porcIGV") == null)
            this.porcIGV = 0.00;
        else
            this.porcIGV = Double.parseDouble(soapObject.getProperty("porcIGV").toString());

        if (soapObject.getProperty("showPrecioMin") == null)
            this.showPrecioMin = "";
        else
            this.showPrecioMin = soapObject.getProperty("showPrecioMin").toString();

        if (soapObject.getProperty("showPrecioMay") == null)
            this.showPrecioMay = "";
        else
            this.showPrecioMay = soapObject.getProperty("showPrecioMay").toString();

        if (soapObject.getProperty("solicitarCliente") == null)
            this.solicitarCliente = "";
        else
            this.solicitarCliente = soapObject.getProperty("solicitarCliente").toString();

        if (soapObject.getProperty("codIGV") == null)
            this.codIGV = "";
        else
            this.codIGV = soapObject.getProperty("codIGV").toString();

        if (soapObject.getProperty("validarSotck") == null)
            this.validarSotck = "";
        else
            this.validarSotck = soapObject.getProperty("validarSotck").toString();

        if (soapObject.getProperty("claseBonif") == null)
            this.claseBonif = "";
        else
            this.claseBonif = soapObject.getProperty("claseBonif").toString();

        if (soapObject.getProperty("soles") == null)
            this.soles = "";
        else
            this.soles = soapObject.getProperty("soles").toString();

        if (soapObject.getProperty("dolares") == null)
            this.dolares = "";
        else
            this.dolares = soapObject.getProperty("dolares").toString();

        if (soapObject.getProperty("showVentasNVC") == null)
            this.showVentasNVC = "";
        else
            this.showVentasNVC = soapObject.getProperty("showVentasNVC").toString();

        if (soapObject.getProperty("showICBPER") == null)
            this.showICBPER = "";
        else
            this.showICBPER = soapObject.getProperty("showICBPER").toString();

        if (soapObject.getProperty("validaReniec") == null)
            this.validaReniec = "";
        else
            this.validaReniec = soapObject.getProperty("validaReniec").toString();

        if (soapObject.getProperty("validaSunat") == null)
            this.validaSunat = "";
        else
            this.validaSunat = soapObject.getProperty("validaSunat").toString();

    }



}

