package pe.com.sytco.fastsales.Controller;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanOrigen;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplOrigen extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplOrigen?wsdl";

    private ImplOrigen()
    {

    }

    public ImplOrigen(String empresa){
        this.empresaDefault = empresa;
    }

    public BeanOrigen getOne(String pOrigen) throws Exception {
        BeanOrigen beanOrigen = null;

        try {
            String METHOD_NAME = "getOne";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pOrigen", pOrigen));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanOrigen = new BeanOrigen();
            beanOrigen.populate(soapObject);

            return beanOrigen;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanOrigen = null;
        }
    }
}
