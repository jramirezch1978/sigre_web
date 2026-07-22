package pe.com.sytco.fastsales.beans.Comercializacion;

import androidx.annotation.NonNull;

import java.io.Serializable;

import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanPreciosArticulo extends BeanAncestor implements Serializable {
    private String descPrecio;
    private Double precio;

    public BeanPreciosArticulo(String pDescPrecio, Double precioValue) {
        this.descPrecio = pDescPrecio;
        this.precio = precioValue;
    }

    public String getDescPrecio() {
        return descPrecio;
    }
    public void setDescPrecio(String descPrecio) {
        this.descPrecio = descPrecio;
    }
    public Double getPrecio() {
        return precio;
    }
    public void setPrecio(Double precio) {
        this.precio = precio;
    }

    @NonNull
    @Override
    public String toString() {
        return this.descPrecio + " " + UTIL.ConvetToString(this.precio, "###,##0.00");
    }
}
