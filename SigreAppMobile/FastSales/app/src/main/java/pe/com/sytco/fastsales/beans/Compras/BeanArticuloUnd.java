package pe.com.sytco.fastsales.beans.Compras;

import androidx.annotation.NonNull;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanArticuloUnd extends BeanAncestor implements Serializable {
    private static final long serialVersionUID = 1947968272552154876L;

	/*
	 * select au.cod_art,
		       au.factor_conv_und,
		       au.und,
		       au.cod_usr,
		       u.desc_unidad
		from articulo_und au,
		     unidad       u
		where au.und = u.und
	 */

    private String codArticulo, und, descUnidad, codUsuario;
    private Double factorConvUnd;

    public String getCodArticulo() {
        return codArticulo;
    }
    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }
    public String getUnd() {
        return und;
    }
    public void setUnd(String und) {
        this.und = und;
    }
    public String getDescUnidad() {
        return descUnidad;
    }
    public void setDescUnidad(String descUnidad) {
        this.descUnidad = descUnidad;
    }
    public String getCodUsuario() {
        return codUsuario;
    }
    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }
    public Double getFactorConvUnd() {
        return factorConvUnd;
    }
    public void setFactorConvUnd(Double factorConvUnd) {
        this.factorConvUnd = factorConvUnd;
    }

    @NonNull
    @Override
    public String toString() {
        return this.descUnidad;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codArticulo") == null)
            this.codArticulo = null;
        else
            this.codArticulo = obj.getProperty("codArticulo").toString();

        if (obj.getProperty("und") == null)
            this.und = null;
        else
            this.und = obj.getProperty("und").toString();

        if (obj.getProperty("descUnidad") == null)
            this.descUnidad = null;
        else
            this.descUnidad = obj.getProperty("descUnidad").toString();

        if (obj.getProperty("codUsuario") == null)
            this.codUsuario = null;
        else
            this.codUsuario = obj.getProperty("codUsuario").toString();

        if (obj.getProperty("factorConvUnd") == null)
            this.factorConvUnd = 0.00;
        else
            this.factorConvUnd = Double.parseDouble(obj.getProperty("factorConvUnd").toString());

    }

}
