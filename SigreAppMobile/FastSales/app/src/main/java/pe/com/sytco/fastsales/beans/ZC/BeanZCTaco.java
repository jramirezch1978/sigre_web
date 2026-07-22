package pe.com.sytco.fastsales.beans.ZC;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZCTaco extends BeanAncestor {

    private static final long serialVersionUID = -39728205923353462L;

    public String codTaco, descTaco, flagEstado;

    public String getCodTaco() {
        return codTaco;
    }

    public void setCodTaco(String codTaco) {
        this.codTaco = codTaco;
    }

    public String getDescTaco() {
        return descTaco;
    }

    public void setDescTaco(String descTaco) {
        this.descTaco = descTaco;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codTaco") == null)
            this.codTaco = null;
        else
            this.codTaco = obj.getProperty("codTaco").toString();

        if (obj.getProperty("descTaco") == null)
            this.descTaco = null;
        else
            this.descTaco = obj.getProperty("descTaco").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

    }
}
