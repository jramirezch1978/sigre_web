package pe.com.sytco.fastsales.beans.ParteRecepcion;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Hashtable;

import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;

public class BeanParteRecepcionUnd implements Serializable, KvmSerializable {
    private String nroParte;
    private Long nroItem;
    private String codigoCU;
    private String nroPallet;
    private String codUsuario;
    private Date fecRegistro;
    private String codArticulo;

    public BeanParteRecepcionUnd() {

    }

    public BeanParteRecepcionUnd(BeanCaja caja) {
        this.codigoCU = caja.getCodigoCU();
        this.nroPallet = caja.getNroPallet();
        this.codUsuario = caja.getCodUsuario();
    }

    @Override
    public Object getProperty(int i) {
        switch(i)  {

            case 0: return nroParte;
            case 1: return nroItem;
            case 2: return codigoCU;
            case 3: return nroPallet;
            case 4: return codUsuario;
            case 5: return fecRegistro;
            case 6: return codArticulo;
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 7;
    }

    @Override
    public void setProperty(int i, Object value) {
        switch(i) {
            case 0:
                nroParte = value.toString();
                break;
            case 1:
                nroItem = Long.valueOf(value.toString());
                break;
            case 2:
                codigoCU = value.toString();
                break;
            case 3:
                nroPallet = value.toString();
                break;
            case 4:
                codUsuario = value.toString();
                break;
            case 5:
                fecRegistro = (Date) value;
                break;
            case 6:
                codArticulo = value.toString();
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
                __info.name = "nroItem";
                __info.type = Long.class;
                break;
            case 2:
                __info.name = "codigoCU";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "nroPallet";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "codUsuario";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "fecRegistro";
                __info.type = Date.class;
                break;
            case 6:
                __info.name = "codArticulo";
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

    public String getNroParte() {
        return nroParte;
    }

    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }

    public Long getNroItem() {
        return nroItem;
    }

    public void setNroItem(Long nroItem) {
        this.nroItem = nroItem;
    }

    public String getCodigoCU() {
        return codigoCU;
    }

    public void setCodigoCU(String codigoCU) {
        this.codigoCU = codigoCU;
    }

    public String getNroPallet() {
        return nroPallet;
    }

    public void setNroPallet(String nroPallet) {
        this.nroPallet = nroPallet;
    }

    public String getCodUsuario() {
        return codUsuario;
    }

    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }

    @Override
    public String toString(){
        return "[" + this.getNroParte() +'|' + String.valueOf(this.getNroItem()) + '|' + this.getCodigoCU()
                + '|' + this.getNroPallet() + '|' + this.getCodUsuario() + ']';
    }

    public void setFecRegistro(Date fecRegistro) {
        this.fecRegistro = fecRegistro;
    }

    public String getCodArticulo() {
        return codArticulo;
    }

    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }
}
