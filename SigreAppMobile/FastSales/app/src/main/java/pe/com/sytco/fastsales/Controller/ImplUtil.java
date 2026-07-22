package pe.com.sytco.fastsales.Controller;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.parametro;

/**
 * Created by jramirez on 31/10/2017.
 */
public class ImplUtil extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplUtil?wsdl";

    public ImplUtil() {

    }

    public ImplUtil(String empresa) {
        this.empresaDefault = empresa;
    }

    public Boolean isOK() throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();
        try {
            String METHOD_NAME = "isOK";
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME));

            strRespuesta.populate(soapObject);

            return strRespuesta.getIsOk();


        } catch (Exception e) {

            e.printStackTrace();
            throw e;

        } finally {
            strRespuesta = null;
        }
    }



    public java.sql.Date TimeServidor() throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();
        try {
            String METHOD_NAME = "TimeServidor";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            return strRespuesta.getTimeServidor();


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            strRespuesta = null;
        }
    }
}
