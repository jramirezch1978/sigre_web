package pe.com.sytco.fastsales.beans.Comercializacion;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Hashtable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 05/05/2016.
 */
public class BeanProforma extends BeanAncestor implements Serializable {

    private String nroProforma;
    private String codOrigen;

    private String codEmpresa;
    private String cliente;
    private String nomCliente;
    private String direccion;
    private String rucDNI;
    private String vendedor, nomVendedor;
    private String flagEstado;
    private String flagBoletaFactura;
    private Integer itemDireccion;
    private String codUsuario;
    private String moneda;
    private Double tasaCambio;
    private String fecRegistro;
    private String ubigeo, descUbigeo;

    private Integer nroRegistros;
    private Double sumaCantidad, totalVenta;

    //flag_tranf_gratuita,
    private String flagTranfGratuita;

    private Boolean Nuevo = false;

    public BeanProforma(){

        this.setNuevo(true);

        //java.util.Date utilDate = new java.util.Date();
        //this.fecExpiracion = new java.sql.Date(utilDate.getTime());
        //this.fecRegistro = new java.sql.Date(utilDate.getTime());
    }

    public void setUsuario(BeanUsuario usuario) {
        this.vendedor = usuario.getUsuario();
    }
    public Boolean getNuevo() {
        return Nuevo;
    }
    public void setNuevo(Boolean nuevo) {
        Nuevo = nuevo;
    }
    public String getNroProforma() {
        return nroProforma;
    }
    public void setNroProforma(String value) {
        this.nroProforma = value;
    }
    public String getCodOrigen() {
        return codOrigen;
    }
    public void setCodOrigen(String value) {
        this.codOrigen = value;
    }
    public String getCodEmpresa() {
        return codEmpresa;
    }
    public void setCodEmpresa(String value) {
        codEmpresa = value;
    }
    public String getCliente() {
        return cliente;
    }
    public void setCliente(String value) {
        cliente = value;
    }
    public String getDireccion() {
        return direccion;
    }
    public void setDireccion(String value) {
        direccion = value;
    }
    public String getVendedor() {
        return vendedor;
    }
    public void setVendedor(String value) {
        vendedor = value;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String value) {
        this.flagEstado = value;
    }
    public String getFlagBoletaFactura() {
        return flagBoletaFactura;
    }
    public void setFlagBoletaFactura(String value) {
        this.flagBoletaFactura = value;
    }
    public Integer getItemDireccion() {
        return itemDireccion;
    }
    public void setItemDireccion(Integer itemDireccion) {
        this.itemDireccion = itemDireccion;
    }
    public String getCodUsuario() {
        return codUsuario;
    }
    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }
    public String getMoneda() {
        return moneda;
    }
    public void setMoneda(String moneda) {
        this.moneda = moneda;
    }
    public Double getTasaCambio() {
        return tasaCambio;
    }
    public void setTasaCambio(Double tasaCambio) {
        this.tasaCambio = tasaCambio;
    }
    public String getNomCliente() {
        return nomCliente;
    }
    public void setNomCliente(String nomCliente) {
        this.nomCliente = nomCliente;
    }
    public String getRucDNI() {
        return rucDNI;
    }
    public void setRucDNI(String rucDNI) {
        this.rucDNI = rucDNI;
    }
    public String getNomVendedor() {
        return nomVendedor;
    }
    public void setNomVendedor(String nomVendedor) {
        this.nomVendedor = nomVendedor;
    }
    public String getFecRegistro() {
        return fecRegistro;
    }
    public void setFecRegistro(String fecRegistro) {
        this.fecRegistro = fecRegistro;
    }
    public Integer getNroRegistros() {
        return nroRegistros;
    }
    public void setNroRegistros(Integer nroRegistros) {
        this.nroRegistros = nroRegistros;
    }
    public Double getSumaCantidad() {
        return sumaCantidad;
    }
    public void setSumaCantidad(Double sumaCantidad) {
        this.sumaCantidad = sumaCantidad;
    }
    public Double getTotalVenta() {
        return totalVenta;
    }
    public void setTotalVenta(Double totalVenta) {
        this.totalVenta = totalVenta;
    }
    public String getFlagTranfGratuita() {
        return flagTranfGratuita;
    }
    public void setFlagTranfGratuita(String flagTranfGratuita) {
        this.flagTranfGratuita = flagTranfGratuita;
    }
    public String getUbigeo() {
        return ubigeo;
    }
    public void setUbigeo(String ubigeo) {
        this.ubigeo = ubigeo;
    }
    public String getDescUbigeo() {
        return descUbigeo;
    }
    public void setDescUbigeo(String descUbigeo) {
        this.descUbigeo = descUbigeo;
    }

    public void ResetCabecera() {
        nroProforma = null;
        vendedor = null;
        this.flagBoletaFactura = "F";
        this.flagTranfGratuita = "0";
    }


    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("nroProforma") != null)
            this.nroProforma = soapObject.getProperty("nroProforma").toString();
        else
            this.nroProforma = "";

        if(soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = "";

        if(soapObject.getProperty("codEmpresa") != null)
            this.codEmpresa = soapObject.getProperty("codEmpresa").toString();
        else
            this.codEmpresa = "";

        if(soapObject.getProperty("nomCliente") != null)
            this.nomCliente = soapObject.getProperty("nomCliente").toString();
        else
            this.nomCliente = "";

        if(soapObject.getProperty("cliente") != null)
            this.cliente = soapObject.getProperty("cliente").toString();
        else
            this.cliente = "";

        if(soapObject.getProperty("direccion") != null)
            this.direccion = soapObject.getProperty("direccion").toString();
        else
            this.direccion = "";

        if(soapObject.getProperty("rucDNI") != null)
            this.rucDNI = soapObject.getProperty("rucDNI").toString();
        else
            this.rucDNI = "";

        if(soapObject.getProperty("vendedor") != null)
            this.vendedor = soapObject.getProperty("vendedor").toString();
        else
            this.vendedor = "";

        if(soapObject.getProperty("nomVendedor") != null)
            this.nomVendedor = soapObject.getProperty("nomVendedor").toString();
        else
            this.nomVendedor = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("flagBoletaFactura") != null)
            this.flagBoletaFactura = soapObject.getProperty("flagBoletaFactura").toString();
        else
            this.flagBoletaFactura = "";

        if(soapObject.getProperty("codUsuario") != null)
            this.codUsuario = soapObject.getProperty("codUsuario").toString();
        else
            this.codUsuario = "";

        if(soapObject.getProperty("moneda") != null)
            this.moneda = soapObject.getProperty("moneda").toString();
        else
            this.moneda = "";

        if(soapObject.getProperty("fecRegistro") != null)
            this.fecRegistro = soapObject.getProperty("fecRegistro").toString();
        else
            this.fecRegistro = "";

        if(soapObject.getProperty("flagTranfGratuita") != null)
            this.flagTranfGratuita = soapObject.getProperty("flagTranfGratuita").toString();
        else
            this.flagTranfGratuita = "";

        if(soapObject.getProperty("itemDireccion") != null)
            this.itemDireccion = Integer.parseInt(soapObject.getProperty("itemDireccion").toString());
        else
            this.itemDireccion = 0;

        if(soapObject.getProperty("nroRegistros") != null)
            this.nroRegistros = Integer.parseInt(soapObject.getProperty("nroRegistros").toString());
        else
            this.nroRegistros = 0;

        if(soapObject.getProperty("tasaCambio") != null)
            this.tasaCambio = Double.parseDouble(soapObject.getProperty("tasaCambio").toString());
        else
            this.tasaCambio = 0.00;

        if(soapObject.getProperty("sumaCantidad") != null)
            this.sumaCantidad = Double.parseDouble(soapObject.getProperty("sumaCantidad").toString());
        else
            this.sumaCantidad = 0.00;

        if(soapObject.getProperty("totalVenta") != null)
            this.totalVenta = Double.parseDouble(soapObject.getProperty("totalVenta").toString());
        else
            this.totalVenta = 0.00;

        if(soapObject.getProperty("ubigeo") != null)
            this.ubigeo = soapObject.getProperty("ubigeo").toString();
        else
            this.ubigeo = "";

        if(soapObject.getProperty("descUbigeo") != null)
            this.descUbigeo = soapObject.getProperty("descUbigeo").toString();
        else
            this.descUbigeo = "";

    }
}
