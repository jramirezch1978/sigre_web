package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanTipoDocRTPS;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplTipoDocRTPS extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplTipoDocRTPS?wsdl";

    private ImplTipoDocRTPS()
    {

    }

    public ImplTipoDocRTPS(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanTipoDocRTPS> getAllActivos() {
        List<BeanTipoDocRTPS> lista = null;

        try {
            String METHOD_NAME = "getAllActivos";
            lista = new ArrayList<BeanTipoDocRTPS>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));


            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
            int length = lsObjects.size();

            for(int i=0; i<length; i ++){
                ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                BeanTipoDocRTPS posicion = new BeanTipoDocRTPS();
                posicion.populate(soapObject);
                lista.add(posicion);
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;

    }
}
