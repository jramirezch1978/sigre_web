package pe.com.sytco.fastsales.beans.Finanzas;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanDocTipo extends BeanAncestor implements Serializable {

    private static final long serialVersionUID = 2021781952971876243L;

    private String tipoDoc, descTipoDoc, tipoCredFiscal, flagRuc, flagSigno, flagEstado;
    private int nroLibro;

    public String getTipoDoc() {
        return tipoDoc;
    }
    public void setTipoDoc(String tipoDoc) {
        this.tipoDoc = tipoDoc;
    }
    public String getDescTipoDoc() {
        return descTipoDoc;
    }
    public void setDescTipoDoc(String descTipoDoc) {
        this.descTipoDoc = descTipoDoc;
    }
    public String getTipoCredFiscal() {
        return tipoCredFiscal;
    }
    public void setTipoCredFiscal(String tipoCredFiscal) {
        this.tipoCredFiscal = tipoCredFiscal;
    }
    public String getFlagRuc() {
        return flagRuc;
    }
    public void setFlagRuc(String flagRuc) {
        this.flagRuc = flagRuc;
    }
    public String getFlagSigno() {
        return flagSigno;
    }
    public void setFlagSigno(String flagSigno) {
        this.flagSigno = flagSigno;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
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

        if(soapObject.getProperty("tipoDoc") != null)
            this.tipoDoc = soapObject.getProperty("tipoDoc").toString();
        else
            this.tipoDoc = "";

        if(soapObject.getProperty("descTipoDoc") != null)
            this.descTipoDoc = soapObject.getProperty("descTipoDoc").toString();
        else
            this.descTipoDoc = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("tipoCredFiscal") != null)
            this.tipoCredFiscal = soapObject.getProperty("tipoCredFiscal").toString();
        else
            this.tipoCredFiscal = "";

        if(soapObject.getProperty("flagSigno") != null)
            this.flagSigno = soapObject.getProperty("flagSigno").toString();
        else
            this.flagSigno = "";

        if(soapObject.getProperty("flagRuc") != null)
            this.flagRuc = soapObject.getProperty("flagRuc").toString();
        else
            this.flagRuc = "";

        if (soapObject.getProperty("nroLibro") == null)
            this.nroLibro = 0;
        else
            this.nroLibro = Integer.parseInt(soapObject.getProperty("nroLibro").toString());


    }
}
