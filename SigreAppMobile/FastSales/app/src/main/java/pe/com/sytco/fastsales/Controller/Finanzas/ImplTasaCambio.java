package pe.com.sytco.fastsales.Controller.Finanzas;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Finanzas.BeanFormaPago;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplTasaCambio extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplTasaCambio?wsdl";

    private ImplTasaCambio()
    {

    }

    public ImplTasaCambio(String empresa){
        this.empresaDefault = empresa;
    }

    public Double getTasaCambio() throws Exception {
        StrRespuesta strRespuesta = null;

        try {
            String METHOD_NAME = "getTasaCambio";
            strRespuesta = new StrRespuesta();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }


            return strRespuesta.getDouble1();

        }catch (Exception e) {
            throw e;

        }finally{
            strRespuesta = null;
        }
    }
}
