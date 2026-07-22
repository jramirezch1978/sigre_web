package pe.com.sytco.fastsales.beans.Comercializacion;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanOrdenVenta extends BeanAncestor implements Serializable {
    private String nroOrdenVenta;
    private String obs;
    private String nomCliente, rucDni, almacen, descAlmacen, cliente;

    public String getCliente() {
        return cliente;
    }
    public void setCliente(String cliente) {
        this.cliente = cliente;
    }
    public String getNomCliente() {
        return nomCliente;
    }
    public void setNomCliente(String nomCliente) {
        this.nomCliente = nomCliente;
    }
    public String getRucDni() {
        return rucDni;
    }
    public void setRucDni(String rucDni) {
        this.rucDni = rucDni;
    }
    public String getAlmacen() {
        return almacen;
    }
    public void setAlmacen(String value) {
        this.almacen = value;
    }
    public String getNroOrdenVenta() {
        return nroOrdenVenta;
    }
    public void setNroOrdenVenta(String nroOrdenVenta) {
        this.nroOrdenVenta = nroOrdenVenta;
    }
    public String getObs() {
        return obs;
    }
    public void setObs(String obs) {
        this.obs = obs;
    }
    public String getDescAlmacen() {
        return descAlmacen;
    }
    public void setDescAlmacen(String descAlmacen) {
        this.descAlmacen = descAlmacen;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if(soapObject.getProperty("nroOrdenVenta") != null)
            this.nroOrdenVenta = soapObject.getProperty("nroOrdenVenta").toString();
        else
            this.nroOrdenVenta = "";

        if(soapObject.getProperty("obs") != null)
            this.obs = soapObject.getProperty("obs").toString();
        else
            this.obs = "";

        if(soapObject.getProperty("cliente") != null)
            this.cliente = soapObject.getProperty("cliente").toString();
        else
            this.cliente = "";

        if(soapObject.getProperty("nomCliente") != null)
            this.nomCliente = soapObject.getProperty("nomCliente").toString();
        else
            this.nomCliente = "";

        if(soapObject.getProperty("rucDni") != null)
            this.rucDni = soapObject.getProperty("rucDni").toString();
        else
            this.rucDni = "";

        if(soapObject.getProperty("almacen") != null)
            this.almacen = soapObject.getProperty("almacen").toString();
        else
            this.almacen = "";

        if(soapObject.getProperty("descAlmacen") != null)
            this.descAlmacen = soapObject.getProperty("descAlmacen").toString();
        else
            this.descAlmacen = "";


    }

    public String toString(){
        return this.nroOrdenVenta + '-' + this.nomCliente;
    }



}
