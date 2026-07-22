package pe.com.sytco.fastsales.Controller.Almacen;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanPosiciones;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplPosiciones extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplPosiciones?wsdl";

    private ImplPosiciones()
    {

    }

    public ImplPosiciones(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanPosiciones> getAll(String pUsuario, String pOrigen) {
        List<BeanPosiciones> lista = null;

        try {
            String METHOD_NAME = "getAll";
            lista = new ArrayList<BeanPosiciones>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pUsuario", pUsuario));
            param.add(new parametro("pOrigen", pOrigen));


            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
            int length = lsObjects.size();

            for(int i=0; i<length; i ++){
                ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                BeanPosiciones posicion = new BeanPosiciones();
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
