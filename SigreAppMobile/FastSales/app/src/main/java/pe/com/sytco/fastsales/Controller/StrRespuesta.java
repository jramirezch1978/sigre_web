package pe.com.sytco.fastsales.Controller;

import java.io.Serializable;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 24/04/2016.
 */
public class StrRespuesta implements Serializable {
    private static final long serialVersionUID = 1L;
    private Boolean isOk;
    private String mensaje;
    private String _cadena, _cadena2;
    private Integer Count;
    private Double _double1;
    private List<BeanCategoria> categorias;
    private List<String> listadoString;
    private String JSON1, JSON2;

    private Date _timeServidor;

    public StrRespuesta(boolean pIsOk, String pMensaje) {
        // TODO Auto-generated constructor stub
        this.isOk = pIsOk;
        this.mensaje = pMensaje;
    }
    public StrRespuesta() {
        // TODO Auto-generated constructor stub
        this.isOk = true;
    }
    public Boolean getIsOk() {
        return isOk;
    }
    public void setIsOk(Boolean isOk) {
        this.isOk = isOk;
    }
    public String getMensaje() {
        return mensaje;
    }
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    public Integer getCount() {
        return Count;
    }
    public void setCount(Integer count) {
        Count = count;
    }
    public String getCadena() {
        return _cadena;
    }
    public void setCadena(String value) {
        this._cadena = value;
    }
    public List<String> getListadoString() {
        return listadoString;
    }
    public void setListadoString(List<String> listadoString) {
        this.listadoString = listadoString;
    }
    public java.sql.Date getTimeServidor() {
        return _timeServidor;
    }
    public void setTimeServidor(java.sql.Date value) {
        this._timeServidor = value;
    }
    public Double getDouble1() {
        return _double1;
    }
    public void setDouble1(Double double1) {
        this._double1 = double1;
    }
    public void setCadena2(String value) {
        this._cadena2 = value;
    }
    public String getCadena2() {
        return _cadena2;
    }
    public String getJSON1() {
        return JSON1;
    }
    public void setJSON1(String JSON1) {
        this.JSON1 = JSON1;
    }
    public String getJSON2() {
        return JSON2;
    }
    public void setJSON2(String JSON2) {
        this.JSON2 = JSON2;
    }

    public void populate(ExtendedSoapObject soapObject) {
        this.isOk = Boolean.parseBoolean(soapObject.getProperty("isOk").toString());

        if (soapObject.getProperty("mensaje") == null)
            this.mensaje = null;
        else
            this.mensaje = soapObject.getProperty("mensaje").toString();

        if (soapObject.getProperty("JSON1") == null)
            this.JSON1 = null;
        else
            this.JSON1 = soapObject.getProperty("JSON1").toString();

        if (soapObject.getProperty("JSON2") == null)
            this.JSON2 = null;
        else
            this.JSON2 = soapObject.getProperty("JSON2").toString();

        if (soapObject.getProperty("count") == null)
            this.Count = 0;
        else
            this.Count = Integer.parseInt(soapObject.getProperty("count").toString());

        if (soapObject.getProperty("cadena") == null)
            this._cadena = null;
        else
            this._cadena = soapObject.getProperty("cadena").toString();

        if (soapObject.getProperty("cadena2") == null)
            this._cadena2 = null;
        else
            this._cadena2 = soapObject.getProperty("cadena2").toString();

        if (soapObject.getProperty("double1") == null)
            this._double1 = null;
        else
            this._double1 = Double.parseDouble(soapObject.getProperty("double1").toString());

        //Listado de Cadenas de String
        if (soapObject.getProperty("listadoString") == null)
            this.listadoString = new ArrayList<String>();
        else {
            this.listadoString = new ArrayList<String>();
            for(Object o : (Object [])soapObject.getProperty("listadoString")) {
                 this.listadoString.add(o.toString());
            }
        }

        if (soapObject.getProperty("timeServidor") == null)
            this._timeServidor = null;
        else
            this._timeServidor = UTIL.parseStringToSqlDate(soapObject.getProperty("timeServidor").toString());

    }


}
