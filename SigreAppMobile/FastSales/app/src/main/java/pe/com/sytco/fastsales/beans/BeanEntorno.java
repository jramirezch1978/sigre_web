package pe.com.sytco.fastsales.beans;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;

/**
 * Created by jramirez on 14/11/2017.
 */
public class BeanEntorno implements Serializable, KvmSerializable {

    /**
     *
     */
    private static final long serialVersionUID = -6508751894797996842L;
    private String empresaDefault;


    public BeanEntorno() {

    }

    public BeanEntorno(String empresa) {
        this.empresaDefault = empresa;
    }



    /**
     * @return the empresaDefault
     */
    public String getEmpresaDefault() {
        return empresaDefault;
    }

    /**
     * @param value the _empresaDefault to set
     */
    public void setEmpresaDefault(String value) {
        this.empresaDefault = value;
    }

    public void populate(ExtendedSoapObject soapObject) {
        this.empresaDefault = soapObject.getProperty("empresaDefault").toString();
    }

    @Override
    public Object getProperty(int i) {
       /*
            private String empresaDefault;
         */
        switch(i)  {

            case 0: return empresaDefault;
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 1;
    }

    @Override
    public void setProperty(int i, Object value) {
        /*
            private String empresaDefault;
         */
        switch(i) {
            case 0:
                empresaDefault = value.toString();
                break;
        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        /*
            private String empresaDefault;
         */
        switch(__index) {
            case 0:
                __info.name = "empresaDefault";
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


}
