package pe.com.sytco.fastsales.beans.Almacen;

import java.io.Serializable;
import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanLecturas extends BeanAncestor implements Serializable {

    private static final long serialVersionUID = -1573347526295240599L;

    private String codUsuario, deviceID, nroPallet, nroLote, CUS, codArticulo, orgVale, nroVale, reckey,
            almacen, anaquel, fila, columna, codOrigen, und1, und2, fecRegistro, fecDespacho, nroOV;
    private Double saldoUnd1, saldoUnd2;
    private Integer nroCUS;

    public String getCodUsuario() {
        return codUsuario;
    }
    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }
    public String getDeviceID() {
        return deviceID;
    }
    public void setDeviceID(String deviceID) {
        this.deviceID = deviceID;
    }
    public String getNroPallet() {
        return nroPallet;
    }
    public void setNroPallet(String nroPallet) {
        this.nroPallet = nroPallet;
    }
    public String getNroLote() {
        return nroLote;
    }
    public void setNroLote(String nroLote) {
        this.nroLote = nroLote;
    }
    public String getCUS() {
        return CUS;
    }
    public void setCUS(String CUS) {
        this.CUS = CUS;
    }
    public String getCodArticulo() {
        return codArticulo;
    }
    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }
    public String getOrgVale() {
        return orgVale;
    }
    public void setOrgVale(String orgVale) {
        this.orgVale = orgVale;
    }
    public String getNroVale() {
        return nroVale;
    }
    public void setNroVale(String nroVale) {
        this.nroVale = nroVale;
    }
    public String getReckey() {
        return reckey;
    }
    public void setReckey(String reckey) {
        this.reckey = reckey;
    }
    public String getAlmacen() {
        return almacen;
    }
    public void setAlmacen(String almacen) {
        this.almacen = almacen;
    }
    public String getAnaquel() {
        return anaquel;
    }
    public void setAnaquel(String anaquel) {
        this.anaquel = anaquel;
    }
    public String getFila() {
        return fila;
    }
    public void setFila(String fila) {
        this.fila = fila;
    }
    public String getColumna() {
        return columna;
    }
    public void setColumna(String columna) {
        this.columna = columna;
    }
    public String getCodOrigen() {
        return codOrigen;
    }
    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }
    public String getUnd1() {
        return und1;
    }
    public void setUnd1(String und1) {
        this.und1 = und1;
    }
    public String getUnd2() {
        return und2;
    }
    public void setUnd2(String und2) {
        this.und2 = und2;
    }
    public String getFecRegistro() {
        return fecRegistro;
    }
    public void setFecRegistro(String fecRegistro) {
        this.fecRegistro = fecRegistro;
    }
    public String getFecDespacho() {
        return fecDespacho;
    }
    public void setFecDespacho(String fecDespacho) {
        this.fecDespacho = fecDespacho;
    }
    public Double getSaldoUnd1() {
        return saldoUnd1;
    }
    public void setSaldoUnd1(Double saldoUnd1) {
        this.saldoUnd1 = saldoUnd1;
    }
    public Double getSaldoUnd2() {
        return saldoUnd2;
    }
    public void setSaldoUnd2(Double saldoUnd2) {
        this.saldoUnd2 = saldoUnd2;
    }
    public Integer getNroCUS() {
        return nroCUS;
    }
    public void setNroCUS(Integer nroCUS) {
        this.nroCUS = nroCUS;
    }
    public String getNroOV() {
        return nroOV;
    }
    public void setNroOV(String nroOV) {
        this.nroOV = nroOV;
    }

    public static Double getNroCUS(List<BeanLecturas> pListado) {
        Double ldbl_Return = 0.0;

        for(BeanLecturas bean : pListado){
            ldbl_Return += bean.getNroCUS();
        }

        return ldbl_Return;
    }

    public static Double getSaldoUnd1(List<BeanLecturas> pListado) {
        Double ldbl_Return = 0.0;

        for(BeanLecturas bean : pListado){
            ldbl_Return += bean.getSaldoUnd1();
        }

        return ldbl_Return;
    }

    public static Double getSaldoUnd2(List<BeanLecturas> pListado) {
        Double ldbl_Return = 0.0;

        for(BeanLecturas bean : pListado){
            ldbl_Return += bean.getSaldoUnd2();
        }

        return ldbl_Return;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if(soapObject.getProperty("almacen") != null)
            this.almacen = soapObject.getProperty("almacen").toString();
        else
            this.almacen = "";

        if(soapObject.getProperty("codUsuario") != null)
            this.codUsuario = soapObject.getProperty("codUsuario").toString();
        else
            this.codUsuario = "";

        if(soapObject.getProperty("deviceID") != null)
            this.deviceID = soapObject.getProperty("deviceID").toString();
        else
            this.deviceID = "";

        if(soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = "";

        if(soapObject.getProperty("nroPallet") != null)
            this.nroPallet = soapObject.getProperty("nroPallet").toString();
        else
            this.nroPallet = "";

        if(soapObject.getProperty("nroLote") != null)
            this.nroLote = soapObject.getProperty("nroLote").toString();
        else
            this.nroLote = "";

        if(soapObject.getProperty("CUS") != null)
            this.CUS = soapObject.getProperty("CUS").toString();
        else
            this.CUS = "";

        if(soapObject.getProperty("codArticulo") != null)
            this.codArticulo = soapObject.getProperty("codArticulo").toString();
        else
            this.codArticulo = "";

        if(soapObject.getProperty("orgVale") != null)
            this.orgVale = soapObject.getProperty("orgVale").toString();
        else
            this.orgVale = "";

        if(soapObject.getProperty("nroVale") != null)
            this.nroVale = soapObject.getProperty("nroVale").toString();
        else
            this.nroVale = "";

        if(soapObject.getProperty("nroOV") != null)
            this.nroOV = soapObject.getProperty("nroOV").toString();
        else
            this.nroOV = "";

        if(soapObject.getProperty("reckey") != null)
            this.reckey = soapObject.getProperty("reckey").toString();
        else
            this.reckey = "";

        if(soapObject.getProperty("anaquel") != null)
            this.anaquel = soapObject.getProperty("anaquel").toString();
        else
            this.anaquel = "";

        if(soapObject.getProperty("fila") != null)
            this.fila = soapObject.getProperty("fila").toString();
        else
            this.fila = "";

        if(soapObject.getProperty("columna") != null)
            this.columna = soapObject.getProperty("columna").toString();
        else
            this.columna = "";

        if(soapObject.getProperty("und1") != null)
            this.und1 = soapObject.getProperty("und1").toString();
        else
            this.und1 = "";

        if(soapObject.getProperty("und2") != null)
            this.und2 = soapObject.getProperty("und2").toString();
        else
            this.und2 = "";

        if(soapObject.getProperty("fecRegistro") != null)
            this.fecRegistro = soapObject.getProperty("fecRegistro").toString();
        else
            this.fecRegistro = "";

        if(soapObject.getProperty("fecDespacho") != null)
            this.fecDespacho = soapObject.getProperty("fecDespacho").toString();
        else
            this.fecDespacho = "";

        if (soapObject.getProperty("saldoUnd1") == null)
            this.saldoUnd1 = 0.0;
        else
            this.saldoUnd1 = Double.parseDouble(soapObject.getProperty("saldoUnd1").toString());

        if (soapObject.getProperty("saldoUnd2") == null)
            this.saldoUnd2 = 0.0;
        else
            this.saldoUnd2 = Double.parseDouble(soapObject.getProperty("saldoUnd2").toString());

        if (soapObject.getProperty("nroCUS") == null)
            this.nroCUS = 0;
        else
            this.nroCUS = Integer.parseInt(soapObject.getProperty("nroCUS").toString());

    }
}
