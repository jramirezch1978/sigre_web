package pe.com.sytco.fastsales.beans.Asistencia;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanAsistenciaHT580 extends BeanAncestor implements Serializable, KvmSerializable {
    private String recKey;
    private String codOrigen;
    private String codigo;
    private String nomTrabajador;
    private String flagInOut;
    private String fecRegistro;
    private String fecMovimiento;
    private String fecMarcacion;
    private String codUsr;
    private String direccionIP;
    private String flagVerifyType;
    private String turno;
    private String lecturaPDA;

    public BeanAsistenciaHT580(){
        this.fecMovimiento = UTIL.parseSqlDatetoString(UTIL.getSqlDateNow(), "dd/MM/yyyy");
        this.fecRegistro = UTIL.parseSqlDatetoString(UTIL.getSqlDateNow(), "dd/MM/yyyy hh:mm:ss");
        this.direccionIP = "";
    }

    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return recKey;
            case 1: return codOrigen;
            case 2: return codigo;
            case 3: return nomTrabajador;
            case 4: return flagInOut;
            case 5: return fecRegistro;
            case 6: return fecMovimiento;
            case 7: return fecMarcacion;
            case 8: return codUsr;
            case 9: return direccionIP;
            case 10: return flagVerifyType;
            case 11: return turno;
            case 12: return lecturaPDA;

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
                recKey = value.toString();
                break;
            case 1:
                codOrigen = value.toString();
                break;
            case 2:
                codigo = value.toString();
                break;
            case 3:
                nomTrabajador = value.toString();
                break;
            case 4:
                flagInOut = value.toString();
                break;
            case 5:
                fecRegistro = value.toString();
                break;
            case 6:
                fecMovimiento = value.toString();
                break;
            case 7:
                fecMarcacion = value.toString();
                break;
            case 8:
                codUsr = value.toString();
                break;
            case 9:
                direccionIP = value.toString();
                break;
            case 10:
                flagVerifyType = value.toString();
                break;
            case 11:
                turno = value.toString();
                break;
            case 12:
                lecturaPDA = value.toString();
                break;
        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        /*
            case 0: return recKey;
            case 1: return codOrigen;
            case 2: return codigo;
            case 3: return nombreCompleto;
            case 4: return flagInOut;
            case 5: return fecRegistro;
            case 6: return fecMovimiento;
            case 7: return fecMarcacion;
            case 8: return codUsr;
            case 9: return direccionIP;
            case 10: return flagVerifyType;
            case 11: return turno;
            case 12: return lecturaPDA;
         */

        switch(__index) {
            case 0:
                __info.name = "recKey";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "codOrigen";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "codigo";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "nomTrabajador";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "flagInOut";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "fecRegistro";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "fecMovimiento";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "fecMarcacion";
                __info.type = String.class;
                break;
            case 8:
                __info.name = "codUsr";
                __info.type = String.class;
                break;
            case 9:
                __info.name = "direccionIP";
                __info.type = String.class;
                break;
            case 10:
                __info.name = "flagVerifyType";
                __info.type = String.class;
                break;
            case 11:
                __info.name = "turno";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "lecturaPDA";
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

        /*
            case 0: return recKey;
            case 1: return codOrigen;
            case 2: return codigo;
            case 3: return nombreCompleto;
            case 4: return flagInOut;
            case 5: return fecRegistro;
            case 6: return fecMovimiento;
            case 7: return fecMarcacion;
            case 8: return codUsr;
            case 9: return direccionIP;
            case 10: return flagVerifyType;
            case 11: return turno;
            case 12: return lecturaPDA;
         */

        if(soapObject.getProperty("recKey") != null)
            this.recKey = soapObject.getProperty("recKey").toString();
        else
            this.recKey = "";

        if(soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = "";

        if(soapObject.getProperty("codigo") != null)
            this.codigo = soapObject.getProperty("codigo").toString();
        else
            this.codigo = "";

        if(soapObject.getProperty("nomTrabajador") != null)
            this.nomTrabajador = soapObject.getProperty("nomTrabajador").toString();
        else
            this.nomTrabajador = "";

        if(soapObject.getProperty("flagInOut") != null)
            this.flagInOut = soapObject.getProperty("flagInOut").toString();
        else
            this.flagInOut = "";

        if(soapObject.getProperty("fecRegistro") != null)
            this.fecRegistro = soapObject.getProperty("fecRegistro").toString();
        else
            this.fecRegistro = "";

        if(soapObject.getProperty("fecMovimiento") != null)
            this.fecMovimiento = soapObject.getProperty("fecMovimiento").toString();
        else
            this.fecMovimiento = "";

        if(soapObject.getProperty("fecMarcacion") != null)
            this.fecMarcacion = soapObject.getProperty("fecMarcacion").toString();
        else
            this.fecMarcacion = "";

        if(soapObject.getProperty("codUsr") != null)
            this.codUsr = soapObject.getProperty("codUsr").toString();
        else
            this.codUsr = "";

        if(soapObject.getProperty("direccionIP") != null)
            this.direccionIP = soapObject.getProperty("direccionIP").toString();
        else
            this.direccionIP = "";

        if(soapObject.getProperty("flagVerifyType") != null)
            this.flagVerifyType = soapObject.getProperty("flagVerifyType").toString();
        else
            this.flagVerifyType = "";

        if(soapObject.getProperty("turno") != null)
            this.turno = soapObject.getProperty("turno").toString();
        else
            this.turno = "";

        if(soapObject.getProperty("lecturaPDA") != null)
            this.lecturaPDA = soapObject.getProperty("lecturaPDA").toString();
        else
            this.lecturaPDA = "";


    }

    public String getRecKey() {
        return recKey;
    }

    public void setRecKey(String recKey) {
        this.recKey = recKey;
    }

    public String getCodOrigen() {
        return codOrigen;
    }

    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNomTrabajador() {
        return nomTrabajador;
    }

    public void setNomTrabajador(String nomTrabajador) {
        this.nomTrabajador = nomTrabajador;
    }

    public String getFlagInOut() {
        return flagInOut;
    }

    public void setFlagInOut(String flagInOut) {
        this.flagInOut = flagInOut;
    }

    public String getFecRegistro() {
        return fecRegistro;
    }

    public void setFecRegistro(String fecRegistro) {
        this.fecRegistro = fecRegistro;
    }

    public String getFecMovimiento() {
        return fecMovimiento;
    }

    public void setFecMovimiento(String fecMovimiento) {
        this.fecMovimiento = fecMovimiento;
    }

    public String getFecMarcacion() {
        return fecMarcacion;
    }

    public void setFecMarcacion(String fecMarcacion) {
        this.fecMarcacion = fecMarcacion;
    }

    public String getCodUsr() {
        return codUsr;
    }

    public void setCodUsr(String codUsr) {
        this.codUsr = codUsr;
    }

    public String getDireccionIP() {
        return direccionIP;
    }

    public void setDireccionIP(String direccionIP) {
        this.direccionIP = direccionIP;
    }

    public String getFlagVerifyType() {
        return flagVerifyType;
    }

    public void setFlagVerifyType(String flagVerifyType) {
        this.flagVerifyType = flagVerifyType;
    }

    public String getTurno() {
        return turno;
    }

    public void setTurno(String turno) {
        this.turno = turno;
    }

    public String getLecturaPDA() {
        return lecturaPDA;
    }

    public void setLecturaPDA(String lecturaPDA) {
        this.lecturaPDA = lecturaPDA;
    }

    public String getHoraMovimiento() {
        // Usar fecMarcacion en lugar de fecMovimiento
        // fecMarcacion contiene la fecha/hora exacta de la marcación
        if (this.fecMarcacion != null && !this.fecMarcacion.isEmpty()) {
            // Backend envía en formato 24 horas: dd/mm/yyyy HH24:mi:ss
            java.sql.Date ltFechaSQL = UTIL.parseStringToSqlDate(this.fecMarcacion, "dd/MM/yyyy HH:mm:ss");
            // Mostrar en formato 12 horas con AM/PM
            return UTIL.parseSqlDatetoString(ltFechaSQL, "hh:mm a");
        } else if (this.fecMovimiento != null && !this.fecMovimiento.isEmpty()) {
            // Fallback a fecMovimiento si fecMarcacion no está disponible
            java.sql.Date ltFechaSQL = UTIL.parseStringToSqlDate(this.fecMovimiento, "dd/MM/yyyy HH:mm:ss");
            return UTIL.parseSqlDatetoString(ltFechaSQL, "hh:mm a");
        }
        return "";
    }
}
