package pe.com.sytco.fastsales.beans.ZC;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZCSubLineas extends BeanAncestor {

    private String codSubLinea, descSubLinea, abreviatura, flagEstado;

    public String getCodSubLinea() {
        return codSubLinea;
    }
    public void setCodSubLinea(String codSubLinea) {
        this.codSubLinea = codSubLinea;
    }
    public String getDescSubLinea() {
        return descSubLinea;
    }
    public void setDescSubLinea(String descSubLinea) {
        this.descSubLinea = descSubLinea;
    }
    public String getAbreviatura() {
        return abreviatura;
    }
    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codSubLinea") == null)
            this.codSubLinea = null;
        else
            this.codSubLinea = obj.getProperty("codSubLinea").toString();

        if (obj.getProperty("descSubLinea") == null)
            this.descSubLinea = null;
        else
            this.descSubLinea = obj.getProperty("descSubLinea").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

        if (obj.getProperty("abreviatura") == null)
            this.abreviatura = null;
        else
            this.abreviatura = obj.getProperty("abreviatura").toString();

    }
}
