package pe.com.sytco.fastsales.beans.ZC;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZCAcabado extends BeanAncestor {
    private static final long serialVersionUID = 7399629905619329228L;

    private String codAcabado, descAcabado, flagEstado;

    public String getCodAcabado() {
        return codAcabado;
    }

    public void setCodAcabado(String codAcabado) {
        this.codAcabado = codAcabado;
    }

    public String getDescAcabado() {
        return descAcabado;
    }

    public void setDescAcabado(String descAcabado) {
        this.descAcabado = descAcabado;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codAcabado") == null)
            this.codAcabado = null;
        else
            this.codAcabado = obj.getProperty("codAcabado").toString();

        if (obj.getProperty("descAcabado") == null)
            this.descAcabado = null;
        else
            this.descAcabado = obj.getProperty("descAcabado").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();


    }
}
