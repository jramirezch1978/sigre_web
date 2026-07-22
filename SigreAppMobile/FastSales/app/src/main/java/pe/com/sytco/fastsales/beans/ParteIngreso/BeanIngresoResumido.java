package pe.com.sytco.fastsales.beans.ParteIngreso;

import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanIngresoResumido extends BeanAncestor {
    private String codSKU, descArticulo, und, codArticulo, proveedor;
    private Double talla, cantidad, oldPrecioCompra, newPrecioCompra, subTotal, newPrecioVenta, oldPrecioVenta;
    private boolean nuevo;


    public String getCodArticulo() {
        return codArticulo;
    }
    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }
    public String getCodSKU() {
        return codSKU;
    }
    public void setCodSKU(String codSKU) {
        this.codSKU = codSKU;
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
    public Double getTalla() {
        return talla;
    }
    public void setTalla(Double talla) {
        this.talla = talla;
    }
    public Double getCantidad() {
        return cantidad;
    }
    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }
    public Double getOldPrecioCompra() {
        return oldPrecioCompra;
    }
    public void setOldPrecioCompra(Double oldPrecioCompra) {
        this.oldPrecioCompra = oldPrecioCompra;
    }
    public Double getNewPrecioCompra() {
        return newPrecioCompra;
    }
    public void setNewPrecioCompra(Double newPrecioCompra) {
        this.newPrecioCompra = newPrecioCompra;
    }
    public Double getSubTotal() {
        return subTotal;
    }
    public void setSubTotal(Double subTotal) {
        this.subTotal = subTotal;
    }
    public Double getNewPrecioVenta() {
        return newPrecioVenta;
    }
    public void setNewPrecioVenta(Double newPrecioVenta) {
        this.newPrecioVenta = newPrecioVenta;
    }
    public Double getOldPrecioVenta() {
        return oldPrecioVenta;
    }
    public void setOldPrecioVenta(Double oldPrecioVenta) {
        this.oldPrecioVenta = oldPrecioVenta;
    }
    public String getProveedor() {
        return proveedor;
    }
    public void setProveedor(String proveedor) {
        this.proveedor = proveedor;
    }
    public boolean setNuevo() {
        return nuevo;
    }
    @Override
    public void setNuevo(boolean value) {
        this.nuevo = value;
    }

    public static Double getTotalUnidades(List<BeanIngresoResumido> listado) {
        Double ldbl_return = 0.00;

        for(BeanIngresoResumido obj : listado){
            ldbl_return += obj.getCantidad();
        }

        return ldbl_return;
    }

    public static Double getNewTotalCompra(List<BeanIngresoResumido> listado) {
        Double ldbl_return = 0.00;

        for(BeanIngresoResumido obj : listado){
            ldbl_return += obj.getCantidad() * obj.getNewPrecioCompra();
        }

        return ldbl_return;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if(soapObject.getProperty("codSKU") != null)
            this.codSKU = soapObject.getProperty("codSKU").toString();
        else
            this.codSKU = "";

        if(soapObject.getProperty("descArticulo") != null)
            this.descArticulo = soapObject.getProperty("descArticulo").toString();
        else
            this.descArticulo = "";

        if(soapObject.getProperty("und") != null)
            this.und = soapObject.getProperty("und").toString();
        else
            this.und = "";

        if(soapObject.getProperty("codArticulo") != null)
            this.codArticulo = soapObject.getProperty("codArticulo").toString();
        else
            this.codArticulo = "";

        if(soapObject.getProperty("proveedor") != null)
            this.proveedor = soapObject.getProperty("proveedor").toString();
        else
            this.proveedor = "";

        if (soapObject.getProperty("talla") == null)
            this.talla = 0.00;
        else
            this.talla = Double.parseDouble(soapObject.getProperty("talla").toString());

        if (soapObject.getProperty("cantidad") == null)
            this.cantidad = 0.00;
        else
            this.cantidad = Double.parseDouble(soapObject.getProperty("cantidad").toString());

        if (soapObject.getProperty("oldPrecioCompra") == null)
            this.oldPrecioCompra = 0.00;
        else
            this.oldPrecioCompra = Double.parseDouble(soapObject.getProperty("oldPrecioCompra").toString());

        if (soapObject.getProperty("newPrecioCompra") == null)
            this.newPrecioCompra = 0.00;
        else
            this.newPrecioCompra = Double.parseDouble(soapObject.getProperty("newPrecioCompra").toString());

        if (soapObject.getProperty("subTotal") == null)
            this.subTotal = 0.00;
        else
            this.subTotal = Double.parseDouble(soapObject.getProperty("subTotal").toString());

        if (soapObject.getProperty("newPrecioVenta") == null)
            this.newPrecioVenta = 0.00;
        else
            this.newPrecioVenta = Double.parseDouble(soapObject.getProperty("newPrecioVenta").toString());

        if (soapObject.getProperty("oldPrecioVenta") == null)
            this.oldPrecioVenta = 0.00;
        else
            this.oldPrecioVenta = Double.parseDouble(soapObject.getProperty("oldPrecioVenta").toString());

        if (soapObject.getProperty("nuevo") == null)
            this.nuevo = false;
        else
            this.nuevo = Boolean.parseBoolean(soapObject.getProperty("nuevo").toString());

    }
}
