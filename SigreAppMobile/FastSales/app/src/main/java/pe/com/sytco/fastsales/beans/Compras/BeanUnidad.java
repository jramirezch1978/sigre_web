package pe.com.sytco.fastsales.beans.Compras;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanUnidad extends BeanAncestor {

    private static final long serialVersionUID = 2326287809324261731L;

    private String und, descUnidad, tipoUnidad, flagEstado, flagDivisibilidad, codSunat;

    public String getUnd() {
        return und;
    }

    public void setUnd(String und) {
        this.und = und;
    }

    public String getDescUnidad() {
        return descUnidad;
    }

    public void setDescUnidad(String descUnidad) {
        this.descUnidad = descUnidad;
    }

    public String getTipoUnidad() {
        return tipoUnidad;
    }

    public void setTipoUnidad(String tipoUnidad) {
        this.tipoUnidad = tipoUnidad;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public String getFlagDivisibilidad() {
        return flagDivisibilidad;
    }

    public void setFlagDivisibilidad(String flagDivisibilidad) {
        this.flagDivisibilidad = flagDivisibilidad;
    }

    public String getCodSunat() {
        return codSunat;
    }

    public void setCodSunat(String codSunat) {
        this.codSunat = codSunat;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("und") == null)
            this.und = null;
        else
            this.und = obj.getProperty("und").toString();

        if (obj.getProperty("descUnidad") == null)
            this.descUnidad = null;
        else
            this.descUnidad = obj.getProperty("descUnidad").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

        if (obj.getProperty("tipoUnidad") == null)
            this.tipoUnidad = null;
        else
            this.tipoUnidad = obj.getProperty("tipoUnidad").toString();

        if (obj.getProperty("flagDivisibilidad") == null)
            this.flagDivisibilidad = null;
        else
            this.flagDivisibilidad = obj.getProperty("flagDivisibilidad").toString();

        if (obj.getProperty("codSunat") == null)
            this.codSunat = null;
        else
            this.codSunat = obj.getProperty("codSunat").toString();

    }
}
