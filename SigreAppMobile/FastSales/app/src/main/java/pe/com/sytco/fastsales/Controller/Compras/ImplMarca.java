package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplMarca extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplMarca?wsdl";

    private ImplMarca()
    {

    }

    public ImplMarca(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanMarca> getActivosByFiltro(String pFiltro) throws Exception {
        List<BeanMarca> lista = null;

        try {
            String METHOD_NAME = "getActivosByFiltro";
            lista = new ArrayList<BeanMarca>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanMarca bean = new BeanMarca();
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
