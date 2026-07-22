package pe.com.sytco.fastsales.beans.Compras;

import android.util.Base64;

import org.ksoap2.serialization.SoapObject;

import java.io.Serializable;
import java.sql.Date;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 30/04/2016.
 */
public class BeanArticulo  extends BeanAncestor implements Serializable{

    private String codArt;
    private String descArticulo;
    private String descFullArticulo;
    private String flagEstado;
    private BeanMarca marca;
    private String flagResposicion;
    private Double costoPromSol;
    private Double costoPromDol;
    private Double costoUltCompra;
    private String codSKU;
    private String codigoCU;
    private String codClase;
    private	String flagAfectoIGV;
    private String flagUnd2;
    private Double factorConvUnd;

    private String monedaCompra;
    private Double saldoTotal;
    private String und;
    private String und2;
    private byte[] imagen;

    //Datos del Precio de Venta
    private Double porcVtaUnidad;
    private Double precioVtaUnidad;
    private Double porcVtaMayor;
    private Double precioVtaMayor;
    private Double porcVtaOferta;
    private Double precioVtaOferta;

    //Adicional para zapaterias
    private String estilo;
    private String descColor;
    private String codTaco;
    private String nroParte;
    private Date fecIngreso;
    private String tieneFoto;



    private Date fecRegistro;

    public BeanArticulo(){

        porcVtaUnidad = 0.00;
        precioVtaUnidad = 0.0;
        porcVtaMayor = 0.0;
        precioVtaMayor = 0.0;
        tieneFoto = "0";
    }

    public String getCodArt() {
        return codArt;
    }

    public void setCodArt(String codArt) {
        this.codArt = codArt;
    }

    public String getDescArticulo() {
        return descArticulo;
    }

    public void setDescArticulo(String descArticulo) {
        this.descArticulo = descArticulo;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public BeanMarca getMarca() {
        return marca;
    }

    public void setMarca(BeanMarca marca) {
        this.marca = marca;
    }

    public String getFlagResposicion() {
        return flagResposicion;
    }

    public void setFlagResposicion(String flagResposicion) {
        this.flagResposicion = flagResposicion;
    }

    public Double getCostoPromSol() {
        return costoPromSol;
    }

    public void setCostoPromSol(Double costoPromSol) {
        this.costoPromSol = costoPromSol;
    }

    public Double getCostoPromDol() {
        return costoPromDol;
    }

    public void setCostoPromDol(Double costoPromDol) {
        this.costoPromDol = costoPromDol;
    }

    public Double getCostoUltCompra() {
        return costoUltCompra;
    }

    public void setCostoUltCompra(Double costoUltCompra) {
        this.costoUltCompra = costoUltCompra;
    }

    public Double getSaldoTotal() {
        return saldoTotal;
    }

    public void setSaldoTotal(Double saldoTotal) {
        this.saldoTotal = saldoTotal;
    }

    public String getUnd() {
        return und;
    }

    public void setUnd(String und) {
        this.und = und;
    }

    public String getUnd2() {
        return und2;
    }

    public void setUnd2(String und2) {
        this.und2 = und2;
    }

    public byte[] getImagen() {
        return imagen;
    }

    public void setImagen(byte[] imagen) {
        this.imagen = imagen;
    }

    public Date getFecRegistro() {
        return fecRegistro;
    }

    public void setFecRegistro(Date fecRegistro) {
        this.fecRegistro = fecRegistro;
    }

    public String getMonedaVenta() {
        return "S/.";
    }

    public String getMonedaCompra() {
        return monedaCompra;
    }

    public void setMonedaCompra(String monedaCompra) {
        this.monedaCompra = monedaCompra;
    }

    public Double getPorcVtaOferta() {
        return porcVtaOferta;
    }

    public void setPorcVtaOferta(Double porcVtaOferta) {
        this.porcVtaOferta = porcVtaOferta;
    }

    public Double getPrecioVtaOferta() {
        return precioVtaOferta;
    }

    public void setPrecioVtaOferta(Double precioVtaOferta) {
        this.precioVtaOferta = precioVtaOferta;
    }

    public String getTieneFoto() {
        return tieneFoto;
    }

    public void setTieneFoto(String tieneFoto) {
        this.tieneFoto = tieneFoto;
    }

    public String getDescFullArticulo() {
        return descFullArticulo;
    }

    public void setDescFullArticulo(String descFullArticulo) {
        this.descFullArticulo = descFullArticulo;
    }

    public Double getPorcVtaUnidad() {
        if (porcVtaUnidad == null)
            porcVtaUnidad = 0.00;

        return porcVtaUnidad;
    }

    public void setPorcVtaUnidad(Double porcVtaUnidad) {
        this.porcVtaUnidad = porcVtaUnidad;
    }

    public Double getPrecioVtaUnidad() {
        if (precioVtaUnidad == null)
            precioVtaUnidad = 0.00;

        return precioVtaUnidad;
    }

    public void setPrecioVtaUnidad(Double precioVtaUnidad) {
        this.precioVtaUnidad = precioVtaUnidad;
    }

    public Double getPorcVtaMayor() {
        if (porcVtaMayor == null)
            porcVtaMayor = 0.00;

        return porcVtaMayor;
    }

    public void setPorcVtaMayor(Double porcVtaMayor) {
        this.porcVtaMayor = porcVtaMayor;
    }

    public Double getPrecioVtaMayor() {
        if (precioVtaMayor == null)
            precioVtaMayor = 0.00;

        return precioVtaMayor;
    }

    public void setPrecioVtaMayor(Double precioVtaMayor) {
        this.precioVtaMayor = precioVtaMayor;
    }

    public String getEstilo() {
        return estilo;
    }

    public void setEstilo(String estilo) {
        this.estilo = estilo;
    }

    public String getDescColor() {
        return descColor;
    }

    public void setDescColor(String descColor) {
        this.descColor = descColor;
    }

    public String getCodTaco() {
        return codTaco;
    }

    public void setCodTaco(String codTaco) {
        this.codTaco = codTaco;
    }

    public String getAbrevArticulo() {
        //trim(M1.NOM_MARCA) || '_' || a.ESTILO || '_' || Co.DESCRIPCION || '_' || a.COD_TACO)
        return this.marca.getNomMarca().trim() + "_" + this.getEstilo() + "_" + this.getDescColor() + "_" + this.getCodTaco();
    }

    public String getCodSKU() {
        return codSKU;
    }

    public void setCodSKU(String codSKU) {
        this.codSKU = codSKU;
    }

    public void setCodigoCU(String value) {
        this.codigoCU = value;
    }

    public String getCodigoCU(){
        return this.codigoCU;
    }

    public String getNroParte() {
        return nroParte;
    }

    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }

    public Date getFecIngreso() {
        return fecIngreso;
    }

    public void setFecIngreso(Date fecIngreso) {
        this.fecIngreso = fecIngreso;
    }

    public String getFlagAfectoIGV() {
        return flagAfectoIGV;
    }

    public void setFlagAfectoIGV(String flagAfectoIGV) {
        this.flagAfectoIGV = flagAfectoIGV;
    }

    public String getCodClase() {
        return codClase;
    }

    public void setCodClase(String codClase) {
        this.codClase = codClase;
    }

    public Double getFactorConvUnd() {
        return factorConvUnd;
    }

    public void setFactorConvUnd(Double factorConvUnd) {
        this.factorConvUnd = factorConvUnd;
    }

    public String getFlagUnd2() {
        return flagUnd2;
    }

    public void setFlagUnd2(String flagUnd2) {
        this.flagUnd2 = flagUnd2;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if (soapObject.getProperty("codArt") != null)
            this.codArt = soapObject.getProperty("codArt").toString();
        else
            this.codArt = "";

        if (soapObject.getProperty("descArticulo") != null)
            this.descArticulo = soapObject.getProperty("descArticulo").toString();
        else
            this.descArticulo = "";

        if (soapObject.getProperty("descFullArticulo") != null)
            this.descFullArticulo = soapObject.getProperty("descFullArticulo").toString();
        else
            this.descFullArticulo = "";

        if (soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado ="";

        if (soapObject.getProperty("flagResposicion") != null)
            this.flagResposicion = soapObject.getProperty("flagResposicion").toString();
        else
            this.flagResposicion = "";

        if (soapObject.getProperty("und") == null)
            this.und = null;
        else
            this.und = soapObject.getProperty("und").toString();


        if (soapObject.getProperty("und2") == null)
            this.und2 = null;
        else
            this.und2 = soapObject.getProperty("und2").toString();

        if (soapObject.getProperty("codSKU") == null)
            this.codSKU = null;
        else
            this.codSKU = soapObject.getProperty("codSKU").toString();

        if (soapObject.getProperty("codigoCU") == null)
            this.codigoCU = null;
        else
            this.codigoCU = soapObject.getProperty("codigoCU").toString();

        if (soapObject.getProperty("flagAfectoIGV") == null)
            this.flagAfectoIGV = null;
        else
            this.flagAfectoIGV = soapObject.getProperty("flagAfectoIGV").toString();

        //Datos Numericos
        if (soapObject.getProperty("costoPromSol") == null)
            this.costoPromSol = 0.00;
        else
            this.costoPromSol = Double.parseDouble(soapObject.getProperty("costoPromSol").toString());

        if (soapObject.getProperty("costoPromDol") == null)
            this.costoPromDol = 0.00;
        else
            this.costoPromDol = Double.parseDouble(soapObject.getProperty("costoPromDol").toString());

        if (soapObject.getProperty("costoUltCompra") == null)
            this.costoUltCompra = 0.00;
        else
            this.costoUltCompra = Double.parseDouble(soapObject.getProperty("costoUltCompra").toString());

        if (soapObject.getProperty("saldoTotal") == null)
            this.saldoTotal = 0.00;
        else
            this.saldoTotal = Double.parseDouble(soapObject.getProperty("saldoTotal").toString());

        if (soapObject.getProperty("porcVtaMayor") == null)
            this.porcVtaMayor = 0.00;
        else
            this.porcVtaMayor = Double.parseDouble(soapObject.getProperty("porcVtaMayor").toString());

        if (soapObject.getProperty("porcVtaUnidad") == null)
            this.porcVtaUnidad = 0.00;
        else
            this.porcVtaUnidad = Double.parseDouble(soapObject.getProperty("porcVtaUnidad").toString());

        if (soapObject.getProperty("porcVtaOferta") == null)
            this.porcVtaOferta = 0.00;
        else
            this.porcVtaOferta = Double.parseDouble(soapObject.getProperty("porcVtaOferta").toString());

        if (soapObject.getProperty("precioVtaMayor") == null)
            this.precioVtaMayor = 0.00;
        else
            this.precioVtaMayor = Double.parseDouble(soapObject.getProperty("precioVtaMayor").toString());

        if (soapObject.getProperty("precioVtaUnidad") == null)
            this.precioVtaUnidad = 0.00;
        else
            this.precioVtaUnidad = Double.parseDouble(soapObject.getProperty("precioVtaUnidad").toString());

        if (soapObject.getProperty("precioVtaOferta") == null)
            this.precioVtaOferta = 0.00;
        else
            this.precioVtaOferta = Double.parseDouble(soapObject.getProperty("precioVtaOferta").toString());


        //this.fecRegistro = java.sql.Date.parse(soapObject.getProperty("fecRegistro").toString());

        if (soapObject.getProperty("imagen") != null) {
            byte[] bloc = Base64.decode(soapObject.getProperty("imagen").toString(), Base64.DEFAULT);
            this.imagen = bloc;
        }else {
            this.imagen = null;
        }

        if (soapObject.getProperty("fecRegistro") == null)
            this.fecRegistro = null;
        else
            this.fecRegistro = UTIL.parseDate(soapObject.getProperty("fecRegistro").toString());

        //Ahora asigno la marca
        if (soapObject.getProperty("marca") == null)
            this.marca = null;
        else {
            BeanMarca bean = new BeanMarca();
            bean.populate(new ExtendedSoapObject((SoapObject) soapObject.getProperty("marca")));
            this.marca = bean;
        }
        //Obtengo datos para la zapateria
        if (soapObject.getProperty("estilo") == null)
            this.estilo = null;
        else
            this.estilo = soapObject.getProperty("estilo").toString();

        if (soapObject.getProperty("descColor") == null)
            this.descColor = null;
        else
            this.descColor = soapObject.getProperty("descColor").toString();

        if (soapObject.getProperty("codTaco") == null)
            this.codTaco = null;
        else
            this.codTaco = soapObject.getProperty("codTaco").toString();

        if (soapObject.getProperty("tieneFoto") == null)
            this.tieneFoto = "0";
        else
            this.tieneFoto = soapObject.getProperty("tieneFoto").toString();

        if (soapObject.getProperty("codClase") == null)
            this.codClase = "";
        else
            this.codClase = soapObject.getProperty("codClase").toString();

        if (soapObject.getProperty("flagUnd2") == null)
            this.flagUnd2 = "";
        else
            this.flagUnd2 = soapObject.getProperty("flagUnd2").toString();

        if (soapObject.getProperty("factorConvUnd") == null)
            this.factorConvUnd = 0.00;
        else
            this.factorConvUnd = Double.parseDouble(soapObject.getProperty("factorConvUnd").toString());

    }

}
