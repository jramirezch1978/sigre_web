package pe.com.sytco.fastsales.beans.Almacen;

import java.io.Serializable;

public class BeanArticuloMov implements Serializable {
    private static final long serialVersionUID = 4269947029131294579L;

    private String codOrigen;
    private Long nroMov;
    private String codArticulo;
    private String nroPallet;
    private String codigoCU;
    private String anaquel;
    private String fila;
    private String columna;
    private Double cantidad;
    private Double cantUnd2;
    private String und2;
    private String flagUnd2;
    private String orgAMP;
    private Long nroAMP;

    public String getCodOrigen() {
        return codOrigen;
    }

    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }

    public Long getNroMov() {
        return nroMov;
    }

    public void setNroMov(Long nroMov) {
        this.nroMov = nroMov;
    }

    public String getCodArticulo() {
        return codArticulo;
    }

    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }

    public String getNroPallet() {
        return nroPallet;
    }

    public void setNroPallet(String nroPallet) {
        this.nroPallet = nroPallet;
    }

    public String getCodigoCU() {
        return codigoCU;
    }

    public void setCodigoCU(String codigoCU) {
        this.codigoCU = codigoCU;
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

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public Double getCantUnd2() {
        return cantUnd2;
    }

    public void setCantUnd2(Double cantUnd2) {
        this.cantUnd2 = cantUnd2;
    }

    public String getUnd2() {
        return und2;
    }

    public void setUnd2(String und2) {
        this.und2 = und2;
    }

    public String getFlagUnd2() {
        return flagUnd2;
    }

    public void setFlagUnd2(String flagUnd2) {
        this.flagUnd2 = flagUnd2;
    }

    public String getOrgAMP() {
        return orgAMP;
    }

    public void setOrgAMP(String orgAMP) {
        this.orgAMP = orgAMP;
    }

    public Long getNroAMP() {
        return nroAMP;
    }

    public void setNroAMP(Long nroAMP) {
        this.nroAMP = nroAMP;
    }
}
