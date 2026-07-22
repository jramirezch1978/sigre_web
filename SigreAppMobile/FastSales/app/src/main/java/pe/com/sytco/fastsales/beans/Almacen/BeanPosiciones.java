package pe.com.sytco.fastsales.beans.Almacen;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;

public class BeanPosiciones implements Serializable {
    private String _anaquel;
    private String _columna;
    private String _fila;
    private String _almacen;
    private String _descAlmacen;

    public String getAnaquel() {
        return _anaquel;
    }
    public void setAnaquel(String value) {
        this._anaquel = value;
    }
    public String getColumna() {
        return _columna;
    }
    public void setColumna(String value) {
        this._columna = value;
    }
    public String getFila() {
        return _fila;
    }
    public void setFila(String value) {
        this._fila = value;
    }
    public String getAlmacen() {
        return _almacen;
    }
    public void setAlmacen(String value) {
        this._almacen = value;
    }

    public String getDescAlmacen() {
        return _descAlmacen;
    }
    public void setDescAlmacen(String _descAlmacen) {
        this._descAlmacen = _descAlmacen;
    }

    public void populate(ExtendedSoapObject soapObject) {
        this._almacen = soapObject.getProperty("almacen").toString();
        this._descAlmacen = soapObject.getProperty("descAlmacen").toString();
        this._anaquel = soapObject.getProperty("anaquel").toString();
        this._fila = soapObject.getProperty("fila").toString();
        this._columna = soapObject.getProperty("columna").toString();
    }
}
