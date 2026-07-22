package pe.com.sytco.fastsales.beans.Compras;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanSubCategoria extends BeanAncestor implements Serializable {
    private static final long serialVersionUID = -2142883928478052933L;

    private String codSubCategoria, descSubCategoria, flagServicio, flagEstado, cntblCntaHaber, cntblCntaDebe, cntaPrspEgreso, cntaPrspIngreso;

    public String getCodSubCategoria() {
        return codSubCategoria;
    }
    public void setCodSubCategoria(String codSubCategoria) {
        this.codSubCategoria = codSubCategoria;
    }
    public String getDescSubCategoria() {
        return descSubCategoria;
    }
    public void setDescSubCategoria(String descSubCategoria) {
        this.descSubCategoria = descSubCategoria;
    }
    public String getFlagServicio() {
        return flagServicio;
    }

    public void setFlagServicio(String flagServicio) {
        this.flagServicio = flagServicio;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String value) {
        this.flagEstado = value;
    }

    public String getCntblCntaHaber() {
        return cntblCntaHaber;
    }

    public void setCntblCntaHaber(String cntblCntaHaber) {
        this.cntblCntaHaber = cntblCntaHaber;
    }

    public String getCntblCntaDebe() {
        return cntblCntaDebe;
    }

    public void setCntblCntaDebe(String cntblCntaDebe) {
        this.cntblCntaDebe = cntblCntaDebe;
    }

    public String getCntaPrspEgreso() {
        return cntaPrspEgreso;
    }

    public void setCntaPrspEgreso(String cntaPrspEgreso) {
        this.cntaPrspEgreso = cntaPrspEgreso;
    }

    public String getCntaPrspIngreso() {
        return cntaPrspIngreso;
    }

    public void setCntaPrspIngreso(String cntaPrspIngreso) {
        this.cntaPrspIngreso = cntaPrspIngreso;
    }

    @Override
    public String toString() {
        if (this.codSubCategoria == null && this.descSubCategoria == null) return null;

        return this.codSubCategoria.trim() + " - " + this.descSubCategoria.trim();
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        //private String , , , , , , , ;

        if(soapObject.getProperty("codSubCategoria") != null)
            this.codSubCategoria = soapObject.getProperty("codSubCategoria").toString();
        else
            this.codSubCategoria = "";

        if(soapObject.getProperty("descSubCategoria") != null)
            this.descSubCategoria = soapObject.getProperty("descSubCategoria").toString();
        else
            this.descSubCategoria = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("flagServicio") != null)
            this.flagServicio = soapObject.getProperty("flagServicio").toString();
        else
            this.flagServicio = "";

        if(soapObject.getProperty("cntblCntaHaber") != null)
            this.cntblCntaHaber = soapObject.getProperty("cntblCntaHaber").toString();
        else
            this.cntblCntaHaber = "";

        if(soapObject.getProperty("cntblCntaDebe") != null)
            this.cntblCntaDebe = soapObject.getProperty("cntblCntaDebe").toString();
        else
            this.cntblCntaDebe = "";

        if(soapObject.getProperty("cntaPrspEgreso") != null)
            this.cntaPrspEgreso = soapObject.getProperty("cntaPrspEgreso").toString();
        else
            this.cntaPrspEgreso = "";

        if(soapObject.getProperty("cntaPrspIngreso") != null)
            this.cntaPrspIngreso = soapObject.getProperty("cntaPrspIngreso").toString();
        else
            this.cntaPrspIngreso = "";


    }
}
