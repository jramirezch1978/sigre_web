package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanSubCategoria;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplSubCategoria extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplSubCategoria?wsdl";

    private ImplSubCategoria()
    {

    }

    public ImplSubCategoria(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanSubCategoria> getAllByCategoria(String pCategoria,
                                                    String pFiltro) throws Exception {
        List<BeanSubCategoria> lista = null;

        try {
            String METHOD_NAME = "getAllByCategoriaByFiltro";
            lista = new ArrayList<BeanSubCategoria>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCategoria", pCategoria));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanSubCategoria beanSubCategoria = new BeanSubCategoria();
                    beanSubCategoria.populate(soapObject);

                    if (!beanSubCategoria.getIsOk())
                        throw new Exception(beanSubCategoria.getMensaje());

                    lista.add(beanSubCategoria);
                }
            }

            return lista;

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }


    }
}
