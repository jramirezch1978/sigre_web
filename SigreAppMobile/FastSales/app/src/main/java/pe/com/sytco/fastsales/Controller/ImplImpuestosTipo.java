package pe.com.sytco.fastsales.Controller;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplImpuestosTipo extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplImpuestosTipo?wsdl";

    public ImplImpuestosTipo(String empresa){
        this.empresaDefault = empresa;
    }

    public Double getICBPER() throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getICBPER";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getDouble1();
    }

    public Double getPorcIGV() throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getPorcIGV";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getDouble1();
    }
}
