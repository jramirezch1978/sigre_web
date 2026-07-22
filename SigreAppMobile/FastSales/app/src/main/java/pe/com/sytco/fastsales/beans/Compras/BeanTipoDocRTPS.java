package pe.com.sytco.fastsales.beans.Compras;

import android.util.Base64;

import androidx.annotation.NonNull;

import org.ksoap2.serialization.SoapObject;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanTipoDocRTPS  extends BeanAncestor implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = -7783284535720982534L;

    private String tipoDocRTPS, descTipoDocRTPS, flagEstado;

    public String getTipoDocRTPS() {
        return tipoDocRTPS;
    }

    public void setTipoDocRTPS(String tipoDocRTPS) {
        this.tipoDocRTPS = tipoDocRTPS;
    }

    public String getDescTipoDocRTPS() {
        return descTipoDocRTPS;
    }

    public void setDescTipoDocRTPS(String descTipoDocRTPS) {
        this.descTipoDocRTPS = descTipoDocRTPS;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if (soapObject.getProperty("tipoDocRTPS") != null)
            this.tipoDocRTPS = soapObject.getProperty("tipoDocRTPS").toString();
        else
            this.tipoDocRTPS = "";

        if (soapObject.getProperty("descTipoDocRTPS") != null)
            this.descTipoDocRTPS = soapObject.getProperty("descTipoDocRTPS").toString();
        else
            this.descTipoDocRTPS = "";

        if (soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado ="";

    }

    @NonNull
    @Override
    public String toString() {
        return this.tipoDocRTPS + '-' + this.descTipoDocRTPS;
    }
}
