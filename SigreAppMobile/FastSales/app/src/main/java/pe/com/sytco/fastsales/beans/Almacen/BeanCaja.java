package pe.com.sytco.fastsales.beans.Almacen;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Hashtable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanCaja extends BeanAncestor implements Serializable, KvmSerializable {
    private String codigoCU;
    private String nroTrazabilidad;
    private String nroOT;
    private Double pesoPromedio;
    private String und;
    private String codArticulo;
    private java.sql.Date fecProduccion;

    private String nroPallet, codUsuario;

    //Otros valores
    private Double saldoUnd;
    private Double saldoUnd2;
    private String anaquel;
    private String fila;
    private String columna;
    private String nroLote;
    private String und2;
    private boolean isValido = false;





    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return getCodigoCU();
            case 1: return getNroTrazabilidad();
            case 2: return this.getNroOT();
            case 3: return this.getPesoPromedio();
            case 4: return this.getUnd();
            case 5: return this.getFecProduccion();
            case 6: return this.getCodArticulo();
            case 7: return this.getSaldoUnd();
            case 8: return this.getSaldoUnd2();
            case 9: return this.getAnaquel();
            case 10: return this.getFila();
            case 11: return this.getColumna();
            case 12: return this.getUnd2();
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 13;
    }

    @Override
    public void setProperty(int i, Object value) {
        switch(i) {
            case 0:
                setCodigoCU(value.toString());
                break;
            case 1:
                setNroTrazabilidad(value.toString());
                break;
            case 2:
                this.setNroOT(value.toString());
                break;
            case 3:
                this.setPesoPromedio(Double.valueOf(value.toString()));
                break;
            case 4:
                this.setUnd(value.toString());
                break;
            case 5:
                this.fecProduccion = UTIL.parseStringToSqlDate(value.toString());
                break;
            case 6:
                this.setCodArticulo(value.toString());
                break;
            case 7:
                this.setSaldoUnd(Double.parseDouble(value.toString()));
                break;
            case 8:
                this.setSaldoUnd2(Double.parseDouble(value.toString()));
                break;
            case 9:
                this.setAnaquel(value.toString());
                break;
            case 10:
                this.setFila(value.toString());
                break;
            case 11:
                this.setColumna(value.toString());
                break;
            case 12:
                this.setUnd2(value.toString());
                break;
        }
    }

        /*
            private Double saldoUnd;
            private Double saldoUnd2;
            private String anaquel;
            private String fila;
            private String columna;
            private String und2;
         */

    /*
    private String codigoCU;
    private String nroTrazabilidad;
    private String nroOT;
    private Float pesoPromedio;
    private String und;
     */
    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        switch(__index) {
            case 0:
                __info.name = "codigoCU";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "nroTrazabilidad";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "nroOT";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "pesoPromedio";
                __info.type = Float.class;
                break;
            case 4:
                __info.name = "und";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "fecProduccion";
                __info.type = java.sql.Date.class;
                break;
            case 6:
                __info.name = "codArticulo";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "saldoUnd";
                __info.type = Double.class;
                break;
            case 8:
                __info.name = "saldoUnd2";
                __info.type = Double.class;
                break;
            case 9:
                __info.name = "anaquel";
                __info.type = String.class;
                break;
            case 10:
                __info.name = "fila";
                __info.type = String.class;
                break;
            case 11:
                __info.name = "columna";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "und2";
                __info.type = String.class;
                break;
        }
    }


    @Override
    public String getInnerText() {
        return null;
    }

    @Override
    public void setInnerText(String s) {

    }

    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if (soapObject.getProperty("codigoCU") != null)
            this.codigoCU = soapObject.getProperty("codigoCU").toString();
        else
            this.codigoCU = null;

        if (soapObject.getProperty("nroTrazabilidad") != null)
            this.nroTrazabilidad = soapObject.getProperty("nroTrazabilidad").toString();
        else
            this.nroTrazabilidad = null;

        if (soapObject.getProperty("nroOT") != null)
            this.nroOT = soapObject.getProperty("nroOT").toString();
        else
            this.nroOT = null;

        if (soapObject.getProperty("und") != null)
            this.und = soapObject.getProperty("und").toString();
        else
            this.und = null;

        if (soapObject.getProperty("codArticulo") != null)
            this.codArticulo = soapObject.getProperty("codArticulo").toString();
        else
            this.codArticulo = null;

        if (soapObject.getProperty("fecProduccion") != null)
            this.fecProduccion = UTIL.parseStringToSqlDate(soapObject.getProperty("fecProduccion").toString());
        else
            this.fecProduccion = null;

        if (soapObject.getProperty("pesoPromedio") == null)
            this.pesoPromedio = 0.0;
        else
            this.pesoPromedio = Double.parseDouble(soapObject.getProperty("pesoPromedio").toString());

        /*
            private Double saldoUnd;
            private Double saldoUnd2;
            private String anaquel;
            private String fila;
            private String columna;
            private String und2;
         */

        if (soapObject.getProperty("saldoUnd") == null)
            this.saldoUnd = 0.0;
        else
            this.saldoUnd = Double.parseDouble(soapObject.getProperty("saldoUnd").toString());

        if (soapObject.getProperty("saldoUnd2") == null)
            this.saldoUnd2 = 0.0;
        else
            this.saldoUnd2 = Double.parseDouble(soapObject.getProperty("saldoUnd2").toString());

        if (soapObject.getProperty("anaquel") == null)
            this.anaquel = "";
        else
            this.anaquel = soapObject.getProperty("anaquel").toString();

        if (soapObject.getProperty("fila") == null)
            this.fila = "";
        else
            this.fila = soapObject.getProperty("fila").toString();

        if (soapObject.getProperty("columna") == null)
            this.columna = "";
        else
            this.columna = soapObject.getProperty("columna").toString();

        if (soapObject.getProperty("und2") == null)
            this.und2 = "";
        else
            this.und2 = soapObject.getProperty("und2").toString();
    }

    public String getCodigoCU() {
        return codigoCU;
    }

    public void setCodigoCU(String codigoCU) {
        this.codigoCU = codigoCU;
    }

    public String getNroTrazabilidad() {
        return nroTrazabilidad;
    }

    public void setNroTrazabilidad(String nroTrazabilidad) {
        this.nroTrazabilidad = nroTrazabilidad;
    }

    public String getNroOT() {
        return nroOT;
    }

    public void setNroOT(String nroOT) {
        this.nroOT = nroOT;
    }

    public Double getPesoPromedio() {
        return pesoPromedio;
    }

    public void setPesoPromedio(Double value) {
        this.pesoPromedio = value;
    }

    public String getUnd() {
        return und;
    }

    public void setUnd(String und) {
        this.und = und;
    }

    public Date getFecProduccion() {
        return fecProduccion;
    }

    public void setFecProduccion(Date fecProduccion) {
        this.fecProduccion = fecProduccion;
    }

    public String getCodArticulo() {
        return codArticulo;
    }

    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }

    public void setNroPallet(String value) {
        this.nroPallet = value;
    }

    public String getNroPallet() {
        return nroPallet;
    }

    public void setCodUsuario(String value) {
        this.codUsuario = value;
    }

    public String getCodUsuario() {
        return this.codUsuario;
    }

    public Double getSaldoUnd() {
        return saldoUnd;
    }

    public void setSaldoUnd(Double saldoUnd) {
        this.saldoUnd = saldoUnd;
    }

    public Double getSaldoUnd2() {
        return saldoUnd2;
    }

    public void setSaldoUnd2(Double saldoUnd2) {
        this.saldoUnd2 = saldoUnd2;
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

    public String getUnd2() {
        return und2;
    }

    public void setUnd2(String und2) {
        this.und2 = und2;
    }

    public String getNroLote() {
        return nroLote;
    }

    public void setNroLote(String nroLote) {
        this.nroLote = nroLote;
    }

    public boolean isValido() {
        return isValido;
    }

    public void setIsValido(boolean value){
        this.isValido = value;
    }
}
