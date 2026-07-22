package pe.com.sytco.fastsales.beans.Compras;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanArticuloClase extends BeanAncestor {

    private static final long serialVersionUID = -7738742215176185355L;
    private String codClase, descClase, flagEstado, codSunat;

    public String getCodClase() {
        return codClase;
    }

    public void setCodClase(String codClase) {
        this.codClase = codClase;
    }

    public String getDescClase() {
        return descClase;
    }

    public void setDescClase(String descClase) {
        this.descClase = descClase;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public String getCodSunat() {
        return codSunat;
    }

    public void setCodSunat(String codSunat) {
        this.codSunat = codSunat;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codClase") == null)
            this.codClase = null;
        else
            this.codClase = obj.getProperty("codClase").toString();

        if (obj.getProperty("descClase") == null)
            this.descClase = null;
        else
            this.descClase = obj.getProperty("descClase").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

        if (obj.getProperty("codSunat") == null)
            this.codSunat = null;
        else
            this.codSunat = obj.getProperty("codSunat").toString();

    }
}
