package pe.com.sytco.fastsales.beans.Compras;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

/**
 * Created by jramirez on 30/04/2016.
 */
public class BeanMarca extends BeanAncestor {
    private String codMarca;
    private String nomMarca;
    private String flagEstado;

    public BeanMarca() {

    }

    public String getCodMarca() {
        return codMarca;
    }

    public void setCodMarca(String codMarca) {
        this.codMarca = codMarca;
    }

    public String getNomMarca() {
        return nomMarca;
    }

    public void setNomMarca(String nomMarca) {
        this.nomMarca = nomMarca;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codMarca") == null)
            this.codMarca = null;
        else
            this.codMarca = obj.getProperty("codMarca").toString();

        if (obj.getProperty("nomMarca") == null)
            this.nomMarca = null;
        else
            this.nomMarca = obj.getProperty("nomMarca").toString();

        if (obj.getProperty("flagEstado") == null)
            this.flagEstado = null;
        else
            this.flagEstado = obj.getProperty("flagEstado").toString();

    }
}
