package pe.com.sytco.fastsales.beans.ParteTransferencia;

import android.util.Log;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Hashtable;

public class BeanParteTransferencia implements Serializable, KvmSerializable {
    private String nroParte;
    private String codOrigen;
    private String almacenOrg;
    private String almacenDst;
    private String anaquelOrg;
    private String anaquelDst;
    private String filaOrg;
    private String filaDst;
    private String columnaOrg;
    private String columnaDst;
    private String codUsuario;
    private String nroPalletOrg;
    private String nroPalletDst;
    private Double cantidad;
    private Date fecTransferencia;
    private Integer nroCajas;

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

    public void setAlmacenOrg(String value) {
        this.almacenOrg = value;
    }

    public String getAlmacenDst() {
        return almacenDst;
    }

    public void setAlmacenDst(String value) {
        this.almacenDst = value;
    }

    public String getAnaquelOrg() {
        return anaquelOrg;
    }

    public void setAnaquelOrg(String value) {
        this.anaquelOrg = value;
    }

    public String getAnaquelDst() {
        return anaquelDst;
    }

    public void setAnaquelDst(String value) {
        this.anaquelDst = value;
    }

    public String getFilaOrg() {
        return filaOrg;
    }

    public void setFilaOrg(String value) {
        this.filaOrg = value;
    }

    public String getFilaDst() {
        return filaDst;
    }

    public void setFilaDst(String value) {
        this.filaDst = value;
    }

    public String getColumnaOrg() {
        return columnaOrg;
    }

    public void setColumnaOrg(String value) {
        this.columnaOrg = value;
    }

    public String getColumnaDst() {
        return columnaDst;
    }

    public void setColumnaDst(String value) {
        this.columnaDst = value;
    }

    public String getCodUsuario() {
        return codUsuario;
    }

    public void setCodUsuario(String value) {
        this.codUsuario = value;
    }

    public String getNroPalletOrg() {
        return nroPalletOrg;
    }

    public void setNroPalletOrg(String value) {
        this.nroPalletOrg = value;
    }

    public String getNroPalletDst() {
        return nroPalletDst;
    }

    public void setNroPalletDst(String value) {
        this.nroPalletDst = value;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double value) {
        this.cantidad = value;
    }

    public Integer getNroCajas() {
        return nroCajas;
    }

    public void setNroCajas(Integer value) {
        this.nroCajas = value;
    }

    /*
        private String nroParte;
        private String codOrigen;
        private String almacenOrg;
        private String almacenDst;
        private String anaquelOrg;
        private String anaquelDst;
        private String filaOrg;
        private String filaDst;
        private String columnaOrg;
        private String coulmnaDst;
        private String codUsuario;
        private String nroPalletOrg;
        private String nroPalletDst;
        private Double cantidad;
        private Date fecTransferencia;
        private Integer nroCajas
     */
    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return nroParte;
            case 1: return codOrigen;
            case 2: return almacenOrg;
            case 3: return almacenDst;
            case 4: return anaquelOrg;
            case 5: return anaquelDst;
            case 6: return filaOrg;
            case 7: return filaDst;
            case 8: return columnaOrg;
            case 9: return columnaDst;
            case 10: return codUsuario;
            case 11: return nroPalletOrg;
            case 12: return nroPalletDst;
            case 13: return cantidad;
            case 14: return fecTransferencia;
            case 15: return nroCajas;

        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 16;
    }

    @Override
    public void setProperty(int i, Object value) {
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
                anaquelOrg = value.toString();
                break;
            case 5:
                anaquelDst = value.toString();
                break;
            case 6:
                filaOrg = value.toString();
                break;
            case 7:
                filaDst = value.toString();
                break;
            case 8:
                 columnaOrg = value.toString();
                break;
            case 9:
                columnaDst = value.toString();
                break;
            case 10:
                codUsuario = value.toString();
                break;
            case 11:
                nroPalletOrg = value.toString();
                break;
            case 12:
                nroPalletDst = value.toString();
                break;
            case 13:
                cantidad = (Double)value;
                break;
            case 14:
                fecTransferencia = (java.sql.Date)value;
                break;
            case 15:
                nroCajas = (Integer)value;
                break;
        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
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
                __info.name = "anaquelOrg";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "anaquelDst";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "filaOrg";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "filaDst";
                __info.type = String.class;
                break;
            case 8:
                __info.name = "columnaOrg";
                __info.type = String.class;
                break;
            case 9:
                __info.name = "columnaDst";
                __info.type = String.class;
                break;

            case 10:
                __info.name = "codUsuario";
                __info.type = String.class;
                break;
            case 11:
                __info.name = "nroPalletOrg";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "nroPalletDst";
                __info.type = String.class;
                break;
            case 13:
                __info.name = "cantidad";
                __info.type = Double.class;
                break;
            case 14:
                __info.name = "fecTransferencia";
                __info.type = java.sql.Date.class;
                break;
            case 15:
                __info.name = "nroCajas";
                __info.type = Integer.class;
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

    public Date getFecTransferencia() {
        return fecTransferencia;
    }

    public void setFecTransferencia(Date fecTransferencia) {
        this.fecTransferencia = fecTransferencia;
    }
}
