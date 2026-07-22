package pe.com.sytco.fastsales.beans.ZC;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanZCSuela extends BeanAncestor {
    private static final long serialVersionUID = 1389610349114742085L;

    private String codSuela, descSuela, flagEstado, abreviatura;

    public String getCodSuela() {
        return codSuela;
    }
    public void setCodSuela(String codSuela) {
        this.codSuela = codSuela;
    }
    public String getDescSuela() {
        return descSuela;
    }
    public void setDescSuela(String descSuela) {
        this.descSuela = descSuela;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }
    public String getAbreviatura() {
        return abreviatura;
    }
    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codSuela") == null)
            this.codSuela = null;
        else
            this.codSuela = obj.getProperty("codSuela").toString();

        if (obj.getProperty("descSuela") == null)
            this.descSuela = null;
        else
            this.descSuela = obj.getProperty("descSuela").toString();

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
