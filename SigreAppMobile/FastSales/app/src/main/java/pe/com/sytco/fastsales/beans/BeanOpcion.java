package pe.com.sytco.fastsales.beans;

import androidx.annotation.NonNull;

import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanMaster;

public class BeanOpcion extends BeanMaster {

    @NonNull
    @Override
    public String toString() {
        return this.descripcion;
    }

    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if (soapObject.getProperty("codigo") == null)
            this.codigo = "";
        else
            this.codigo = soapObject.getProperty("codigo").toString();

        if (soapObject.getProperty("descripcion") == null)
            this.descripcion = "";
        else
            this.descripcion = soapObject.getProperty("descripcion").toString();

        if (soapObject.getProperty("flagEstado") == null)
            this.flagEstado = "";
        else
            this.flagEstado = soapObject.getProperty("flagEstado").toString();

    }

    public static int getPos(List<BeanOpcion> listado, String value) {
        Integer liPos = 0;

        for (BeanOpcion bean: listado) {
            if (bean.getDescripcion().trim().equals(value.trim()) || bean.getCodigo().trim().equals(value.trim())){
                return liPos;
            }
            liPos++;
        }

        return -1;


    }


}
