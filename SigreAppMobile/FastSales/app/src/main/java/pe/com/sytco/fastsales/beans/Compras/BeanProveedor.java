package pe.com.sytco.fastsales.beans.Compras;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanProveedor extends BeanAncestor implements Serializable {
    private static final long serialVersionUID = 4966657497855975755L;

    private String proveedor;
    private String nomProveedor;
    private String flagEstado;
    private String tipoDocIdentidad;
    private String nroDocIdentidad;
    private String rucDni;

    // Datos para el Cliente
    private String nombre1;
    private String nombre2;
    private String apelPaterno;
    private String apelMaterno;
    private String email;
    private String flagPersoneria;
    private String usuario;

    //Para la direccion nueva
    private int itemDireccion;
    private String direccion;
    private String ubigeo;

    public String getProveedor() {
        return proveedor;
    }

    public void setProveedor(String proveedor) {
        this.proveedor = proveedor;
    }

    public String getNomProveedor() {
        return nomProveedor;
    }

    public void setNomProveedor(String nomProveedor) {
        this.nomProveedor = nomProveedor;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public String getTipoDocIdentidad() {
        return tipoDocIdentidad;
    }

    public void setTipoDocIdentidad(String tipoDocIdentidad) {
        this.tipoDocIdentidad = tipoDocIdentidad;
    }

    public String getNroDocIdentidad() {
        return nroDocIdentidad;
    }

    public void setNroDocIdentidad(String nroDocIdentidad) {
        this.nroDocIdentidad = nroDocIdentidad;
    }

    public String getRucDni() {
        return rucDni;
    }

    public void setRucDni(String rucDni) {
        this.rucDni = rucDni;
    }

    public int getItemDireccion() {
        return itemDireccion;
    }

    public void setItemDireccion(int itemDireccion) {
        this.itemDireccion = itemDireccion;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getNombre1() {
        return nombre1;
    }

    public void setNombre1(String nombre1) {
        this.nombre1 = nombre1;
    }

    public String getNombre2() {
        return nombre2;
    }

    public void setNombre2(String nombre2) {
        this.nombre2 = nombre2;
    }

    public String getApelPaterno() {
        return apelPaterno;
    }

    public void setApelPaterno(String apelPaterno) {
        this.apelPaterno = apelPaterno;
    }

    public String getApelMaterno() {
        return apelMaterno;
    }

    public void setApelMaterno(String apelMaterno) {
        this.apelMaterno = apelMaterno;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFlagPersoneria() {
        return flagPersoneria;
    }

    public void setFlagPersoneria(String flagPersoneria) {
        this.flagPersoneria = flagPersoneria;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getUbigeo() {
        return ubigeo;
    }

    public void setUbigeo(String ubigeo) {
        this.ubigeo = ubigeo;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("proveedor") != null)
            this.proveedor = soapObject.getProperty("proveedor").toString();
        else
            this.proveedor = "";

        if(soapObject.getProperty("nomProveedor") != null)
            this.nomProveedor = soapObject.getProperty("nomProveedor").toString();
        else
            this.nomProveedor = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("tipoDocIdentidad") != null)
            this.tipoDocIdentidad = soapObject.getProperty("tipoDocIdentidad").toString();
        else
            this.tipoDocIdentidad = "";

        if(soapObject.getProperty("nroDocIdentidad") != null)
            this.nroDocIdentidad = soapObject.getProperty("nroDocIdentidad").toString();
        else
            this.nroDocIdentidad = "";

        if(soapObject.getProperty("rucDni") != null)
            this.rucDni = soapObject.getProperty("rucDni").toString();
        else
            this.rucDni = "";

        if(soapObject.getProperty("itemDireccion") != null)
            this.itemDireccion = Integer.parseInt(soapObject.getProperty("itemDireccion").toString());
        else
            this.itemDireccion = 0;

        if(soapObject.getProperty("direccion") != null)
            this.direccion = soapObject.getProperty("direccion").toString();
        else
            this.direccion = "";

        //DAtos para el cliente
        if(soapObject.getProperty("apelPaterno") != null)
            this.apelPaterno = soapObject.getProperty("apelPaterno").toString();
        else
            this.apelPaterno = "";

        if(soapObject.getProperty("apelMaterno") != null)
            this.apelMaterno = soapObject.getProperty("apelMaterno").toString();
        else
            this.apelMaterno = "";

        if(soapObject.getProperty("nombre1") != null)
            this.nombre1 = soapObject.getProperty("nombre1").toString();
        else
            this.nombre1 = "";

        if(soapObject.getProperty("nombre2") != null)
            this.nombre2 = soapObject.getProperty("nombre2").toString();
        else
            this.nombre2 = "";

        if(soapObject.getProperty("email") != null)
            this.email = soapObject.getProperty("email").toString();
        else
            this.email = "";

        if(soapObject.getProperty("flagPersoneria") != null)
            this.flagPersoneria = soapObject.getProperty("flagPersoneria").toString();
        else
            this.flagPersoneria = "";

        if(soapObject.getProperty("usuario") != null)
            this.usuario = soapObject.getProperty("usuario").toString();
        else
            this.usuario = "";

        if(soapObject.getProperty("ubigeo") != null)
            this.ubigeo = soapObject.getProperty("ubigeo").toString();
        else
            this.ubigeo = "";
    }
}
