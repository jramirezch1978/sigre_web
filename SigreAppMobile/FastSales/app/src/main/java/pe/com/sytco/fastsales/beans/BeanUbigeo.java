package pe.com.sytco.fastsales.beans;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanUbigeo extends BeanAncestor implements Serializable {
    /*
        select t.ubigeo,
           t.distrito,
           t.provincia,
           t.departamento,
           t.flag_estado
        from sunat_ubigeo t
     */

    private String ubigeo, distrito, provincia, departamento, flagEstado, descUbigeo;

    public String getUbigeo() {
        return ubigeo;
    }
    public void setUbigeo(String ubigeo) {
        this.ubigeo = ubigeo;
    }
    public String getDistrito() {
        return distrito;
    }
    public void setDistrito(String distrito) {
        this.distrito = distrito;
    }
    public String getProvincia() {
        return provincia;
    }
    public void setProvincia(String provincia) {
        this.provincia = provincia;
    }
    public String getDepartamento() {
        return departamento;
    }
    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }
    public String getDescUbigeo() {
        return descUbigeo;
    }
    public void setDescUbigeo(String descUbigeo) {
        this.descUbigeo = descUbigeo;
    }

    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        //private String , , , , , ;
        if (soapObject.getProperty("ubigeo") == null)
            this.ubigeo = "";
        else
            this.ubigeo = soapObject.getProperty("ubigeo").toString();

        if (soapObject.getProperty("distrito") == null)
            this.distrito = "";
        else
            this.distrito = soapObject.getProperty("distrito").toString();

        if (soapObject.getProperty("provincia") == null)
            this.provincia = "";
        else
            this.provincia = soapObject.getProperty("provincia").toString();

        if (soapObject.getProperty("departamento") == null)
            this.departamento = "";
        else
            this.departamento = soapObject.getProperty("departamento").toString();

        if (soapObject.getProperty("flagEstado") == null)
            this.flagEstado = "";
        else
            this.flagEstado = soapObject.getProperty("flagEstado").toString();

        if (soapObject.getProperty("descUbigeo") == null)
            this.descUbigeo = "";
        else
            this.descUbigeo = soapObject.getProperty("descUbigeo").toString();

    }
}
