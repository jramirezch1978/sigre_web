package pe.com.sytco.fastsales.beans.Compras;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanDirecciones extends BeanAncestor implements Serializable {
    private static final long serialVersionUID = 7151114243553494058L;
    private String codigo, fullDireccion;
    private Integer itemDireccion;

    private String descripcion, dirDireccion, dirDireccion2, dirPais,
            dirDepartamento, dirProvincia, dirDistrito, dirCiudad,
            dirUrbanizacion, dirMnz, dirLote, dirNumero, dirCodPostal,
            flagUso, flagDirComercial, CEP, dirReferencia, dirInterior,
            dirSiglasPais, codPaisSunat, Ubigeo, codTienda, descUbigeo,
            zonaVenta, zonaDespacho, descZonaVenta, descZonaDespacho,
            descPaisSunat;
    private Double Latitud, Longitud;


    public String getCodigo() {
        return codigo;
    }
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    public String getFullDireccion() {
        return fullDireccion;
    }
    public void setFullDireccion(String value) {
        this.fullDireccion = value;
    }
    public Integer getItemDireccion() {
        return itemDireccion;
    }
    public void setItemDireccion(Integer value) {
        this.itemDireccion = value;
    }
    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    public String getDirDireccion() {
        return dirDireccion;
    }
    public void setDirDireccion(String dirDireccion) {
        this.dirDireccion = dirDireccion;
    }
    public String getDirDireccion2() {
        return dirDireccion2;
    }
    public void setDirDireccion2(String dirDireccion2) {
        this.dirDireccion2 = dirDireccion2;
    }
    public String getDirPais() {
        return dirPais;
    }
    public void setDirPais(String dirPais) {
        this.dirPais = dirPais;
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
    public String getDirDistrito() {
        return dirDistrito;
    }
    public void setDirDistrito(String dirDistrito) {
        this.dirDistrito = dirDistrito;
    }
    public String getDirCiudad() {
        return dirCiudad;
    }
    public void setDirCiudad(String dirCiudad) {
        this.dirCiudad = dirCiudad;
    }
    public String getDirUrbanizacion() {
        return dirUrbanizacion;
    }
    public void setDirUrbanizacion(String dirUrbanizacion) {
        this.dirUrbanizacion = dirUrbanizacion;
    }
    public String getDirMnz() {
        return dirMnz;
    }
    public void setDirMnz(String dirMnz) {
        this.dirMnz = dirMnz;
    }
    public String getDirLote() {
        return dirLote;
    }
    public void setDirLote(String dirLote) {
        this.dirLote = dirLote;
    }
    public String getDirNumero() {
        return dirNumero;
    }
    public void setDirNumero(String dirNumero) {
        this.dirNumero = dirNumero;
    }
    public String getDirCodPostal() {
        return dirCodPostal;
    }
    public void setDirCodPostal(String dirCodPostal) {
        this.dirCodPostal = dirCodPostal;
    }
    public String getFlagUso() {
        return flagUso;
    }
    public void setFlagUso(String flagUso) {
        this.flagUso = flagUso;
    }
    public String getFlagDirComercial() {
        return flagDirComercial;
    }
    public void setFlagDirComercial(String flagDirComercial) {
        this.flagDirComercial = flagDirComercial;
    }
    public String getCEP() {
        return CEP;
    }
    public void setCEP(String CEP) {
        this.CEP = CEP;
    }
    public String getDirReferencia() {
        return dirReferencia;
    }
    public void setDirReferencia(String dirReferencia) {
        this.dirReferencia = dirReferencia;
    }
    public String getDirInterior() {
        return dirInterior;
    }
    public void setDirInterior(String dirInterior) {
        this.dirInterior = dirInterior;
    }
    public String getDirSiglasPais() {
        return dirSiglasPais;
    }
    public void setDirSiglasPais(String dirSiglasPais) {
        this.dirSiglasPais = dirSiglasPais;
    }
    public String getCodPaisSunat() {
        return codPaisSunat;
    }
    public void setCodPaisSunat(String codPaisSunat) {
        this.codPaisSunat = codPaisSunat;
    }
    public String getUbigeo() {
        return Ubigeo;
    }
    public void setUbigeo(String ubigeo) {
        Ubigeo = ubigeo;
    }
    public String getZonaVenta() {
        return zonaVenta;
    }
    public void setZonaVenta(String zonaVenta) {
        this.zonaVenta = zonaVenta;
    }
    public String getZonaDespacho() {
        return zonaDespacho;
    }
    public void setZonaDespacho(String zonaDespacho) {
        this.zonaDespacho = zonaDespacho;
    }
    public Double getLatitud() {
        return Latitud;
    }
    public void setLatitud(Double latitud) {
        Latitud = latitud;
    }
    public Double getLongitud() {
        return Longitud;
    }
    public void setLongitud(Double longitud) {
        Longitud = longitud;
    }
    public String getDescZonaVenta() {
        return descZonaVenta;
    }
    public void setDescZonaVenta(String descZonaVenta) {
        this.descZonaVenta = descZonaVenta;
    }
    public String getDescZonaDespacho() {
        return descZonaDespacho;
    }
    public void setDescZonaDespacho(String descZonaDespacho) {
        this.descZonaDespacho = descZonaDespacho;
    }
    public String getCodTienda() {
        return codTienda;
    }
    public void setCodTienda(String codTienda) {
        this.codTienda = codTienda;
    }
    public String getDescUbigeo() {
        return descUbigeo;
    }
    public void setDescUbigeo(String descUbigeo) {
        this.descUbigeo = descUbigeo;
    }
    public String getDescPaisSunat() {
        return descPaisSunat;
    }
    public void setDescPaisSunat(String descPaisSunat) {
        this.descPaisSunat = descPaisSunat;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("codigo") != null)
            this.codigo = soapObject.getProperty("codigo").toString();
        else
            this.codigo = "";

        if(soapObject.getProperty("fullDireccion") != null)
            this.fullDireccion = soapObject.getProperty("fullDireccion").toString();
        else
            this.fullDireccion = "";

        if(soapObject.getProperty("itemDireccion") != null)
            this.itemDireccion = Integer.parseInt(soapObject.getProperty("itemDireccion").toString());
        else
            this.itemDireccion = 0;

        if(soapObject.getProperty("descripcion") != null)
            this.descripcion = soapObject.getProperty("descripcion").toString();
        else
            this.descripcion = "";

        if(soapObject.getProperty("dirDireccion") != null)
            this.dirDireccion = soapObject.getProperty("dirDireccion").toString();
        else
            this.dirDireccion = "";

        if(soapObject.getProperty("dirDireccion2") != null)
            this.dirDireccion2 = soapObject.getProperty("dirDireccion2").toString();
        else
            this.dirDireccion2 = "";

        if(soapObject.getProperty("dirPais") != null)
            this.dirPais = soapObject.getProperty("dirPais").toString();
        else
            this.dirPais = "";

        if(soapObject.getProperty("dirDepartamento") != null)
            this.dirDepartamento = soapObject.getProperty("dirDepartamento").toString();
        else
            this.dirDepartamento = "";

        if(soapObject.getProperty("dirProvincia") != null)
            this.dirProvincia = soapObject.getProperty("dirProvincia").toString();
        else
            this.dirProvincia = "";

        if(soapObject.getProperty("dirDistrito") != null)
            this.dirDistrito = soapObject.getProperty("dirDistrito").toString();
        else
            this.dirDistrito = "";

        if(soapObject.getProperty("dirCiudad") != null)
            this.dirCiudad = soapObject.getProperty("dirCiudad").toString();
        else
            this.dirCiudad = "";

        if(soapObject.getProperty("dirUrbanizacion") != null)
            this.dirUrbanizacion = soapObject.getProperty("dirUrbanizacion").toString();
        else
            this.dirUrbanizacion = "";

        if(soapObject.getProperty("dirMnz") != null)
            this.dirMnz = soapObject.getProperty("dirMnz").toString();
        else
            this.dirMnz = "";

        if(soapObject.getProperty("dirLote") != null)
            this.dirLote = soapObject.getProperty("dirLote").toString();
        else
            this.dirLote = "";

        if(soapObject.getProperty("dirNumero") != null)
            this.dirNumero = soapObject.getProperty("dirNumero").toString();
        else
            this.dirNumero = "";

        if(soapObject.getProperty("dirCodPostal") != null)
            this.dirCodPostal = soapObject.getProperty("dirCodPostal").toString();
        else
            this.dirCodPostal = "";

        if(soapObject.getProperty("flagUso") != null)
            this.flagUso = soapObject.getProperty("flagUso").toString();
        else
            this.flagUso = "";

        if(soapObject.getProperty("flagDirComercial") != null)
            this.flagDirComercial = soapObject.getProperty("flagDirComercial").toString();
        else
            this.flagDirComercial = "";

        if(soapObject.getProperty("dirReferencia") != null)
            this.dirReferencia = soapObject.getProperty("dirReferencia").toString();
        else
            this.dirReferencia = "";

        if(soapObject.getProperty("dirSiglasPais") != null)
            this.dirSiglasPais = soapObject.getProperty("dirSiglasPais").toString();
        else
            this.dirSiglasPais = "";

        if(soapObject.getProperty("zonaVenta") != null)
            this.zonaVenta = soapObject.getProperty("zonaVenta").toString();
        else
            this.zonaVenta = "";

        if(soapObject.getProperty("dirInterior") != null)
            this.dirInterior = soapObject.getProperty("dirInterior").toString();
        else
            this.dirInterior = "";

        if(soapObject.getProperty("codPaisSunat") != null)
            this.codPaisSunat = soapObject.getProperty("codPaisSunat").toString();
        else
            this.codPaisSunat = "";

        if(soapObject.getProperty("descPaisSunat") != null)
            this.descPaisSunat = soapObject.getProperty("descPaisSunat").toString();
        else
            this.descPaisSunat = "";

        if(soapObject.getProperty("zonaDespacho") != null)
            this.zonaDespacho = soapObject.getProperty("zonaDespacho").toString();
        else
            this.zonaDespacho = "";

        if(soapObject.getProperty("descZonaVenta") != null)
            this.descZonaVenta = soapObject.getProperty("descZonaVenta").toString();
        else
            this.descZonaVenta = "";

        if(soapObject.getProperty("descZonaDespacho") != null)
            this.descZonaDespacho = soapObject.getProperty("descZonaDespacho").toString();
        else
            this.descZonaDespacho = "";

        if(soapObject.getProperty("Ubigeo") != null)
            this.Ubigeo = soapObject.getProperty("Ubigeo").toString();
        else
            this.Ubigeo = "";

        if(soapObject.getProperty("CEP") != null)
            this.CEP = soapObject.getProperty("CEP").toString();
        else
            this.CEP = "";

        if(soapObject.getProperty("Latitud") != null)
            this.Latitud = Double.parseDouble(soapObject.getProperty("Latitud").toString());
        else
            this.Latitud = 0.00;

        if(soapObject.getProperty("Longitud") != null)
            this.Longitud = Double.parseDouble(soapObject.getProperty("Longitud").toString());
        else
            this.Longitud = 0.00;

        if(soapObject.getProperty("codTienda") != null)
            this.codTienda = soapObject.getProperty("codTienda").toString();
        else
            this.codTienda = "";

        if(soapObject.getProperty("descUbigeo") != null)
            this.descUbigeo = soapObject.getProperty("descUbigeo").toString();
        else
            this.descUbigeo = "";

    }
}
