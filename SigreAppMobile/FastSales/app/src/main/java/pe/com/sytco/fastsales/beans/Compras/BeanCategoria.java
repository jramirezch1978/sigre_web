package pe.com.sytco.fastsales.beans.Compras;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanCategoria extends BeanAncestor implements Serializable{

    private static final long serialVersionUID = -3346316943913450781L;

    private String catArt;
    private String descCategoria;
    private String flagServicio;
    private String flagArtMant;
    private String codClase;
    private String grupo;
    private String flagReplicacion;
    private String flagEstado;
    private String abreviatura;

    public String getCatArt() {
        return catArt;
    }
    public void setCatArt(String catArt) {
        this.catArt = catArt;
    }
    public String getDescCategoria() {
        return descCategoria;
    }
    public void setDescCategoria(String descCategoria) {
        this.descCategoria = descCategoria;
    }
    public String getFlagServicio() {
        return flagServicio;
    }
    public void setFlagServicio(String flagServicio) {
        this.flagServicio = flagServicio;
    }
    public String getFlagArtMant() {
        return flagArtMant;
    }
    public void setFlagArtMant(String flagArtMant) {
        this.flagArtMant = flagArtMant;
    }
    public String getCodClase() {
        return codClase;
    }
    public void setCodClase(String codClase) {
        this.codClase = codClase;
    }
    public String getGrupo() {
        return grupo;
    }
    public void setGrupo(String grupo) {
        this.grupo = grupo;
    }
    public String getFlagReplicacion() {
        return flagReplicacion;
    }
    public void setFlagReplicacion(String flagReplicacion) {
        this.flagReplicacion = flagReplicacion;
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

    @Override
    public String toString() {
        if (this.catArt == null && this.descCategoria == null) return null;

        return this.catArt.trim() + " - " + this.descCategoria.trim();
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("catArt") != null)
            this.catArt = soapObject.getProperty("catArt").toString();
        else
            this.catArt = "";

        if(soapObject.getProperty("descCategoria") != null)
            this.descCategoria = soapObject.getProperty("descCategoria").toString();
        else
            this.descCategoria = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("flagServicio") != null)
            this.flagServicio = soapObject.getProperty("flagServicio").toString();
        else
            this.flagServicio = "";

        if(soapObject.getProperty("flagArtMant") != null)
            this.flagArtMant = soapObject.getProperty("flagArtMant").toString();
        else
            this.flagArtMant = "";

        if(soapObject.getProperty("codClase") != null)
            this.codClase = soapObject.getProperty("codClase").toString();
        else
            this.codClase = "";

        if(soapObject.getProperty("grupo") != null)
            this.grupo = soapObject.getProperty("grupo").toString();
        else
            this.grupo = "";

        if(soapObject.getProperty("flagReplicacion") != null)
            this.flagReplicacion = soapObject.getProperty("flagReplicacion").toString();
        else
            this.flagReplicacion = "";

        if(soapObject.getProperty("abreviatura") != null)
            this.abreviatura = soapObject.getProperty("abreviatura").toString();
        else
            this.abreviatura = "";

    }


}

