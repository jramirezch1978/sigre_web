package pe.com.sytco.fastsales.beans.ZC;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZCLinea extends BeanAncestor {

    private static final long serialVersionUID = -8168032868715624361L;
    private String codLinea, descLinea, flagEstado;
    private String abreviatura;
    private String flagPrintPrecio;

    public String getCodLinea() {
        return codLinea;
    }
    public void setCodLinea(String codLinea) {
        this.codLinea = codLinea;
    }
    public String getDescLinea() {
        return descLinea;
    }
    public void setDescLinea(String descLinea) {
        this.descLinea = descLinea;
    }
    public String getAbreviatura() {
        return abreviatura;
    }
    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }
    public String getFlagPrintPrecio() {
        return flagPrintPrecio;
    }
    public void setFlagPrintPrecio(String flagPrintPrecio) {
        this.flagPrintPrecio = flagPrintPrecio;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codLinea") == null)
            this.codLinea = null;
        else
            this.codLinea = obj.getProperty("codLinea").toString();

        if (obj.getProperty("descLinea") == null)
            this.descLinea = null;
        else
            this.descLinea = obj.getProperty("descLinea").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

        if (obj.getProperty("abreviatura") == null)
            this.abreviatura = null;
        else
            this.abreviatura = obj.getProperty("abreviatura").toString();

        if (obj.getProperty("flagPrintPrecio") == null)
            this.flagPrintPrecio = null;
        else
            this.flagPrintPrecio = obj.getProperty("flagPrintPrecio").toString();

    }
}
