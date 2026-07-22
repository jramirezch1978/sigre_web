package pe.com.sytco.fastsales.Controller;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanLecturasCruiser;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplLecturasCruiser extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplLecturasCruiser?wsdl";

    private ImplLecturasCruiser()
    {

    }

    public ImplLecturasCruiser(String empresa){
        this.empresaDefault = empresa;
    }

    public static String getNroLote(String pLectura) throws Exception {
        String [] datos;
        String  ls_nroPallet;

        if (pLectura.contains("|")) {
            datos = pLectura.split("\\|");

            if (datos.length < 3) {
                throw new Exception("La lectura no contiene el valor del pallet en la tercera posicion, por favor verifique!");
            }

            //El nro de pallet debe ir en la tercera posicion
            ls_nroPallet = datos[2];

        }else {
            ls_nroPallet = pLectura;
        }

        return ls_nroPallet;
    }

    public boolean Insertar(BeanLecturasCruiser obj) throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "Insertar";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("obj", obj));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return true;
    }
}
