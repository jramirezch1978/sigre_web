package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanColor;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplColor extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplColor?wsdl";

    private ImplColor()
    {

    }

    public ImplColor(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanColor> getActivosByFiltro(String pFiltro) throws Exception {
        List<BeanColor> lista = null;

        try {
            String METHOD_NAME = "getActivosByFiltro";
            lista = new ArrayList<BeanColor>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanColor bean = new BeanColor();
                    bean.populate(soapObject);

                    if (!bean.getIsOk())
                        throw new Exception(bean.getMensaje());

                    lista.add(bean);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }
}
