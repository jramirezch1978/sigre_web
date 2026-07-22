package pe.com.sytco.fastsales.beans.Compras;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanColor extends BeanAncestor {

    private static final long serialVersionUID = 368434961679814242L;

    private String codColor, descColor, flagEstado;

    public String getCodColor() {
        return codColor;
    }

    public void setCodColor(String codColor) {
        this.codColor = codColor;
    }

    public String getDescColor() {
        return descColor;
    }

    public void setDescColor(String descColor) {
        this.descColor = descColor;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codColor") == null)
            this.codColor = null;
        else
            this.codColor = obj.getProperty("codColor").toString();

        if (obj.getProperty("descColor") == null)
            this.descColor = null;
        else
            this.descColor = obj.getProperty("descColor").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

    }
}
