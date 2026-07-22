package pe.com.sytco.fastsales.beans;

import java.io.Serializable;

public class BeanInventarioPallet implements Serializable {
    private String fecha;
    private String almacen;
    private String fila;
    private String anaquel;
    private String columna;
    private Double nroCajas;
    private String nroPallet;
    private String codUsr;
    private Integer nroPallets;
    private String lectura;
    private String deviceID;

    public String getDeviceID() {
        return deviceID;
    }

    public void setDeviceID(String deviceID) {
        this.deviceID = deviceID;
    }

    public String getFila() {
        return fila;
    }

    public void setFila(String fila) {
        this.fila = fila;
    }

    public String getNroPallet() {
        return nroPallet;
    }

    public void setNroPallet(String nroPallet) {
        this.nroPallet = nroPallet;
    }

    public String getCodUsr() {
        return codUsr;
    }

    public void setCodUsr(String codUsr) {
        this.codUsr = codUsr;
    }

    public String getFecha() {

        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
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

    public String getColumna() {
        return columna;
    }

    public void setColumna(String columna) {
        this.columna = columna;
    }

    public Double getNroCajas() {
        return nroCajas;
    }

    public void setNroCajas(Double nroCajas) {
        this.nroCajas = nroCajas;
    }

    public Integer getNroPallets() {
        return nroPallets;
    }

    public void setNroPallets(Integer nroPallets) {
        this.nroPallets = nroPallets;
    }

    public String getLectura() {
        return lectura;
    }

    public void setLectura(String strLectura) {
        this.lectura = strLectura;
    }
}
