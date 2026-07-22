package pe.com.sytco.fastsales.beans;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Hashtable;

/**
 * Created by jramirez on 05/04/2016.
 */
public class BeanUsuario implements Serializable, KvmSerializable {

    private String usuario;
    private String nombre;
    private String clave;
    private String perfil;
    private String email;
    private String flagEstado;
    private String OrigenAlt;
    private String flagOrigen;
    private Integer timeout;
    private Integer nivelLogObjeto;
    private String flagReplicacion;
    private String telemobil;
    private String flagTelemobil;
    private Date fechaUCC;
    private Date fecLogin;

    //GET Y SET
    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getPerfil() {
        return perfil;
    }

    public void setPerfil(String perfil) {
        this.perfil = perfil;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public String getOrigenAlt() {
        return OrigenAlt;
    }

    public void setOrigenAlt(String origenAlt) {
        OrigenAlt = origenAlt;
    }

    public String getFlagOrigen() {
        return flagOrigen;
    }

    public void setFlagOrigen(String flagOrigen) {
        this.flagOrigen = flagOrigen;
    }

    public Integer getTimeout() {
        return timeout;
    }

    public void setTimeout(Integer timeout) {
        this.timeout = timeout;
    }

    public Integer getNivelLogObjeto() {
        return nivelLogObjeto;
    }

    public void setNivelLogObjeto(Integer nivelLogObjeto) {
        this.nivelLogObjeto = nivelLogObjeto;
    }

    public String getFlagReplicacion() {
        return flagReplicacion;
    }

    public void setFlagReplicacion(String flagReplicacion) {
        this.flagReplicacion = flagReplicacion;
    }

    public String getTelemobil() {
        return telemobil;
    }

    public void setTelemobil(String telemobil) {
        this.telemobil = telemobil;
    }

    public String getFlagTelemobil() {
        return flagTelemobil;
    }

    public void setFlagTelemobil(String flagTelemobil) {
        this.flagTelemobil = flagTelemobil;
    }

    public Date getFechaUCC() {
        return fechaUCC;
    }

    public void setFechaUCC(Date fechaUCC) {
        this.fechaUCC = fechaUCC;
    }

    //Constructores
    public BeanUsuario() {
        this.setFlagEstado("1");
    }

    //Funciones para la Logica de negocio
    public void populate(ExtendedSoapObject soapObject) {
        this.usuario = soapObject.getProperty("usuario").toString();
        this.nombre = soapObject.getProperty("nombre").toString();

        if (soapObject.getProperty("email") == null )
            this.email = null;
        else
            this.email = soapObject.getProperty("email").toString();

        this.flagEstado = soapObject.getProperty("flagEstado").toString();

        if (soapObject.getProperty("origenAlt") == null )
            this.OrigenAlt = null;
        else
            this.OrigenAlt = soapObject.getProperty("origenAlt").toString();

        if (soapObject.getProperty("flagOrigen") == null )
            this.flagOrigen = null;
        else
            this.flagOrigen = soapObject.getProperty("flagOrigen").toString();

        if (soapObject.getProperty("timeout") == null )
            this.timeout = null;
        else
            this.timeout = Integer.parseInt(soapObject.getProperty("timeout").toString());

        if (soapObject.getProperty("nivelLogObjeto") == null )
            this.nivelLogObjeto = null;
        else
            this.nivelLogObjeto = Integer.parseInt(soapObject.getProperty("nivelLogObjeto").toString());

        if (soapObject.getProperty("perfil") == null )
            this.perfil = null;
        else
            this.perfil = soapObject.getProperty("perfil").toString();


    }

    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return usuario;
            case 1: return nombre;
            case 2: return clave;
            case 3: return perfil;
            case 4: return email;
            case 5: return flagEstado;
            case 6: return OrigenAlt;
            case 7: return flagOrigen;
            case 8: return timeout;
            case 9: return nivelLogObjeto;
            case 10: return flagReplicacion;
            case 11: return telemobil;
            case 12: return flagTelemobil;
            case 13: return fechaUCC;

        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 14;
    }

    @Override
    public void setProperty(int i, Object value) {
        switch(i) {
            case 0:
                usuario = value.toString();
                break;
            case 1:
                nombre = value.toString();
                break;
            case 2:
                clave = value.toString();
                break;
            case 3:
                perfil = value.toString();
                break;
            case 4:
                email = value.toString();
                break;
            case 5:
                flagEstado = value.toString();
                break;
            case 6:
                OrigenAlt = value.toString();
                break;
            case 7:
                flagOrigen = value.toString();
                break;
            case 8:
                if (value == null){
                    timeout = null;
                }else{
                    timeout = Integer.parseInt(value.toString());
                }
                break;

            case 9:
                if (value == null){
                    nivelLogObjeto = null;
                }else{
                    nivelLogObjeto = Integer.parseInt(value.toString());
                }
                break;

            case 10:
                flagReplicacion = value.toString();
                break;

            case 11:
                telemobil = value.toString();
                break;

            case 12:
                flagTelemobil = value.toString();
                break;

            case 13:
                fechaUCC = (Date)value;
                break;

        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {

        switch(__index) {
            case 0:
                __info.name = "usuario";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "nombre";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "clave";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "perfil";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "email";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "flagEstado";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "OrigenAlt";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "flagOrigen";
                __info.type = String.class;
                break;
            case 8:
                __info.name = "timeout";
                __info.type = Integer.class;
                break;
            case 9:
                __info.name = "nivelLogObjeto";
                __info.type = Integer.class;
                break;
            case 10:
                __info.name = "flagReplicacion";
                __info.type = String.class;
                break;
            case 11:
                __info.name = "telemobil";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "flagTelemobil";
                __info.type = String.class;
                break;
            case 13:
                __info.name = "fechaUCC";
                __info.type = Date.class;
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

    public String getUsuario() {
        return usuario;
    }

    public String getFullName() {
        return this.getNombre();
    }

    public String getFlagCambioClave() {
        return "0";
    }

    public Date getFecLogin() {
        return fecLogin;
    }

    public void setFecLogin(Date value) {
        this.fecLogin = value;
    }
}
