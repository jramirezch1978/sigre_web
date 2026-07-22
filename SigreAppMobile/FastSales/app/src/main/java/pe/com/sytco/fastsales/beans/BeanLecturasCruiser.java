package pe.com.sytco.fastsales.beans;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;

import pe.com.sytco.fastsales.util.UTIL;

public class BeanLecturasCruiser implements Serializable, KvmSerializable {
    /**
     *
     */

    private String _reckey;
    private String _usuario;
    private String _lectura;
    private String _equipo;

    private java.sql.Date _fec_registro;
    private String _codOrigen;
    private String _deviceID;

    public String getReckey() {
        return _reckey;
    }
    public void setReckey(String value) {
        this._reckey = value;
    }
    public String getUsuario() {
        return _usuario;
    }
    public void setUsuario(String value) {
        this._usuario = value;
    }
    public String getLectura() {
        return _lectura;
    }
    public void setLectura(String value) {
        this._lectura = value;
    }
    public String getEquipo() {
        return _equipo;
    }
    public void setEquipo(String value) {
        this._equipo = value;
    }
    public java.sql.Date getFecRegistro() {
        return _fec_registro;
    }
    public void setFecRegistro(java.sql.Date value) {
        this._fec_registro = value;
    }
    public String getCodOrigen() {
        return _codOrigen;
    }
    public void setCodOrigen(String value) {
        this._codOrigen = value;
    }
    public String getDeviceID() {
        return _deviceID;
    }

    public void setDeviceID(String value) {
        this._deviceID = value;
    }

    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return _reckey;
            case 1: return _usuario;
            case 2: return _lectura;
            case 3: return _equipo;
            case 4: return _fec_registro;
            case 5: return _codOrigen;
            case 6: return _deviceID;
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 7;
    }

    @Override
    public void setProperty(int i, Object value) {
        /*
            case 0: return _reckey;
            case 1: return _usuario;
            case 2: return _lectura;
            case 3: return _equipo;
            case 4: return _fec_registro;
            case 5: return _codOrigen;
         */
        switch(i) {
            case 0:
                _reckey = value.toString();
                break;
            case 1:
                _usuario = value.toString();
                break;
            case 2:
                _lectura = value.toString();
                break;
            case 3:
                _equipo = value.toString();
                break;
            case 4:
                _fec_registro = UTIL.parseStringToSqlDate(value.toString());
                break;
            case 5:
                _codOrigen = value.toString();
                break;
            case 6:
                _deviceID = value.toString();
                break;
        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        /*
            case 0: return _reckey;
            case 1: return _usuario;
            case 2: return _lectura;
            case 3: return _equipo;
            case 4: return _fec_registro;
            case 5: return _codOrigen;
         */
        switch(__index) {
            case 0:
                __info.name = "_reckey";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "_usuario";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "_lectura";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "_equipo";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "_fecRegistro";
                __info.type = java.sql.Date.class;
                break;
            case 5:
                __info.name = "_codOrigen";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "_deviceID";
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
}
