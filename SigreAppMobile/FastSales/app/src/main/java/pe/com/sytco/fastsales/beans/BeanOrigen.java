package pe.com.sytco.fastsales.beans;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanOrigen extends BeanAncestor implements Serializable {
    String codOrigen, nombre, dirCalle, dirNumero, dirLote, dirMnz, dirUrbanizacion, dirDistrito, dirDepartamento, dirProvincia, telefono, flagEstado;

    public String getCodOrigen() {
        return codOrigen;
    }

    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDirCalle() {
        return dirCalle;
    }

    public void setDirCalle(String dirCalle) {
        this.dirCalle = dirCalle;
    }

    public String getDirNumero() {
        return dirNumero;
    }

    public void setDirNumero(String dirNumero) {
        this.dirNumero = dirNumero;
    }

    public String getDirLote() {
        return dirLote;
    }

    public void setDirLote(String dirLote) {
        this.dirLote = dirLote;
    }

    public String getDirMnz() {
        return dirMnz;
    }

    public void setDirMnz(String dirMnz) {
        this.dirMnz = dirMnz;
    }

    public String getDirUrbanizacion() {
        return dirUrbanizacion;
    }

    public void setDirUrbanizacion(String dirUrbanizacion) {
        this.dirUrbanizacion = dirUrbanizacion;
    }

    public String getDirDistrito() {
        return dirDistrito;
    }

    public void setDirDistrito(String dirDistrito) {
        this.dirDistrito = dirDistrito;
    }

    public String getDirDepartamento() {
        return dirDepartamento;
    }

    public void setDirDepartamento(String dirDepartamento) {
        this.dirDepartamento = dirDepartamento;
    }

    public String getDirProvincia() {
        return dirProvincia;
    }

    public void setDirProvincia(String dirProvincia) {
        this.dirProvincia = dirProvincia;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if (soapObject.getProperty("codOrigen") == null)
            this.codOrigen = "";
        else
            this.codOrigen = soapObject.getProperty("codOrigen").toString();

        if (soapObject.getProperty("nombre") == null)
            this.nombre = "";
        else
            this.nombre = soapObject.getProperty("nombre").toString();

        if (soapObject.getProperty("dirCalle") == null)
            this.dirCalle = "";
        else
            this.dirCalle = soapObject.getProperty("dirCalle").toString();

        if (soapObject.getProperty("dirNumero") == null)
            this.dirNumero = "";
        else
            this.dirNumero = soapObject.getProperty("dirNumero").toString();

        if (soapObject.getProperty("dirLote") == null)
            this.dirLote = "";
        else
            this.dirLote = soapObject.getProperty("dirLote").toString();

        if (soapObject.getProperty("dirMnz") == null)
            this.dirMnz = "";
        else
            this.dirMnz = soapObject.getProperty("dirMnz").toString();

        if (soapObject.getProperty("dirUrbanizacion") == null)
            this.dirUrbanizacion = "";
        else
            this.dirUrbanizacion = soapObject.getProperty("dirUrbanizacion").toString();

        if (soapObject.getProperty("dirDistrito") == null)
            this.dirDistrito = "";
        else
            this.dirDistrito = soapObject.getProperty("dirDistrito").toString();

        if (soapObject.getProperty("dirDepartamento") == null)
            this.dirDepartamento = "";
        else
            this.dirDepartamento = soapObject.getProperty("dirDepartamento").toString();

        if (soapObject.getProperty("dirProvincia") == null)
            this.dirProvincia = "";
        else
            this.dirProvincia = soapObject.getProperty("dirProvincia").toString();

        if (soapObject.getProperty("telefono") == null)
            this.telefono = "";
        else
            this.telefono = soapObject.getProperty("telefono").toString();

        if (soapObject.getProperty("flagEstado") == null)
            this.flagEstado = "";
        else
            this.flagEstado = soapObject.getProperty("flagEstado").toString();

    }

}
