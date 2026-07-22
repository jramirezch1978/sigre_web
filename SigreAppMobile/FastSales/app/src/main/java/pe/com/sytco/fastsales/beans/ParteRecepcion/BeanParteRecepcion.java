package pe.com.sytco.fastsales.beans.ParteRecepcion;

import android.util.Log;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Hashtable;

import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanParteRecepcion extends BeanAncestor implements Serializable, KvmSerializable {

    /**
     *
     */
    private String nroParte;
    private String codOrigen;
    private String almacenOrg;
    private String almacenDst;
    private String anaquel;
    private String fila;
    private String columna;
    private String codUsr;
    private Date fecRegistro;
    private Date fecRecepcion;
    private Double cantRecibida;

    public String getNroParte() {
        return nroParte;
    }
    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }
    public String getCodOrigen() {
        return codOrigen;
    }
    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }
    public String getAlmacenOrg() {
        return almacenOrg;
    }
    public void setAlmacenOrg(String almacenOrg) {
        this.almacenOrg = almacenOrg;
    }
    public String getAlmacenDst() {
        return almacenDst;
    }
    public void setAlmacenDst(String almacenDst) {
        this.almacenDst = almacenDst;
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
    public String getCodUsr() {
        return codUsr;
    }
    public void setCodUsr(String codUsr) {
        this.codUsr = codUsr;
    }
    public Date getFecRecepcion() {
        return fecRecepcion;
    }
    public void setFecRecepcion(Date fecRecepcion) {
        this.fecRecepcion = fecRecepcion;
    }
    public Double getCantRecibida() {
        return cantRecibida;
    }
    public void setCantRecibida(Double cantRecibida) {
        this.cantRecibida = cantRecibida;
    }
    public Date getFecRegistro() {
        return fecRegistro;
    }
    public void setFecRegistro(Date fecRegistro) {
        this.fecRegistro = fecRegistro;
    }


    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return nroParte;
            case 1: return codOrigen;
            case 2: return almacenOrg;
            case 3: return almacenDst;
            case 4: return anaquel;
            case 5: return fila;
            case 6: return columna;
            case 7: return codUsr;
            case 8: return fecRegistro;
            case 9: return fecRecepcion;
            case 10: return cantRecibida;

        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 11;
    }

    @Override
    public void setProperty(int i, Object value) {
            /*
                private String nroParte;
                private String codOrigen;
                private String almacenOrg;
                private String almacenDst;
                private String anaquel;
                private String fila;
                private String columna;
                private String codUsr;
                private Date fecRegistro;
                private Date fecRecepcion;
                private Double cantRecibida;
             */

        switch(i) {
            case 0:
                nroParte = value.toString();
                break;
            case 1:
                codOrigen = value.toString();
                break;
            case 2:
                almacenOrg = value.toString();
                break;
            case 3:
                almacenDst = value.toString();
                break;
            case 4:
                anaquel = value.toString();
                break;
            case 5:
                fila = value.toString();
                break;
            case 6:
                columna = value.toString();
                break;
            case 7:
                codUsr = value.toString();
                break;
            case 8:
                Log.d("BeanParteRecepcion: ", "9");
                fecRegistro = (java.sql.Date) value;
                break;
            case 9:
                Log.d("BeanParteRecepcion: ", "10");
                fecRegistro = (java.sql.Date) value;
                break;
            case 10:
                Log.d("BeanParteRecepcion: ", "11");
                cantRecibida = (Double) value;
                break;

        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        /*
            private String nroParte;
            private String codOrigen;
            private String almacenOrg;
            private String almacenDst;
            private String anaquel;
            private String fila;
            private String columna;
            private String codUsr;
            private Date fecRegistro;
            private Date fecRecepcion;
            private Double cantRecibida;
         */
        switch(__index) {
            case 0:
                __info.name = "nroParte";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "codOrigen";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "almacenOrg";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "almacenDst";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "anaquel";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "fila";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "columna";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "codUsr";
                __info.type = String.class;
                break;
            case 8:
                Log.d("BeanParteRecepcion: ", "fecRegistro 9");
                __info.name = "fecRegistro";
                __info.type = java.sql.Date.class;
                break;
            case 9:
                Log.d("BeanParteRecepcion: ", "FecRecepcion 10");
                __info.name = "fecRecepcion";
                __info.type = java.sql.Date.class;
                break;
            case 10:
                Log.d("BeanParteRecepcion: ", "cantRecibida 11");
                __info.name = "cantRecibida";
                __info.type = Double.class;
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


    @Override
    public String toString(){
        return "[" + this.getAlmacenDst() + '|' + this.getAlmacenOrg() + '|' + UTIL.parseSqlDatetoString(this.fecRecepcion) + "]";
    }
}

