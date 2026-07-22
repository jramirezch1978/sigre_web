package pe.com.sytco.fastsales.beans;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanArticuloMovProy extends BeanAncestor implements Serializable {

    private static final long serialVersionUID = 869162124785646297L;
    private Long nroMov;
    private String codArticulo, descArticulo, und, und2, codOrigen, almacen;
    private Double cantProyect, cantProcesada;

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
    public String getDescArticulo() {
        return descArticulo;
    }
    public void setDescArticulo(String descArticulo) {
        this.descArticulo = descArticulo;
    }
    public String getUnd() {
        return und;
    }
    public void setUnd(String und) {
        this.und = und;
    }
    public Double getCantProyect() {
        return cantProyect;
    }
    public void setCantProyect(Double cantProyect) {
        this.cantProyect = cantProyect;
    }
    public String getUnd2() {
        return und2;
    }
    public void setUnd2(String und2) {
        this.und2 = und2;
    }
    public Double getCantProcesada() {
        return cantProcesada;
    }
    public void setCantProcesada(Double cantProcesada) {
        this.cantProcesada = cantProcesada;
    }
    public String getAlmacen() {
        return almacen;
    }
    public void setAlmacen(String almacen) {
        this.almacen = almacen;
    }

    @Override
    public String toString() {
        return  codArticulo + " - " + descArticulo;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if (soapObject.getProperty("codOrigen") == null)
            this.codOrigen = "";
        else
            this.codOrigen = soapObject.getProperty("codOrigen").toString();

        if (soapObject.getProperty("nroMov") == null)
            this.nroMov = 0L;
        else
            this.nroMov = Long.parseLong(soapObject.getProperty("nroMov").toString());

        if (soapObject.getProperty("almacen") == null)
            this.almacen = "";
        else
            this.almacen = soapObject.getProperty("almacen").toString();

        if (soapObject.getProperty("codArticulo") == null)
            this.codArticulo = "";
        else
            this.codArticulo = soapObject.getProperty("codArticulo").toString();

        if (soapObject.getProperty("descArticulo") == null)
            this.descArticulo = "";
        else
            this.descArticulo = soapObject.getProperty("descArticulo").toString();

        if (soapObject.getProperty("und") == null)
            this.und = "";
        else
            this.und = soapObject.getProperty("und").toString();

        if (soapObject.getProperty("und2") == null)
            this.und2 = "";
        else
            this.und2 = soapObject.getProperty("und2").toString();

        if (soapObject.getProperty("cantProyect") == null)
            this.cantProyect = 0.00;
        else
            this.cantProyect = Double.parseDouble(soapObject.getProperty("cantProyect").toString());

        if (soapObject.getProperty("cantProcesada") == null)
            this.cantProcesada = 0.00;
        else
            this.cantProcesada = Double.parseDouble(soapObject.getProperty("cantProcesada").toString());
    }
}
