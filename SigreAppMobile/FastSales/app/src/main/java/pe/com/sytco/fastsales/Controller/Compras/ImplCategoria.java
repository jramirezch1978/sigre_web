package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplCategoria  extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplCategoria?wsdl";

    private ImplCategoria()
    {

    }

    public ImplCategoria(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanCategoria> getAll() throws Exception {
        List<BeanCategoria> lista = null;

        try {
            String METHOD_NAME = "getAll";
            lista = new ArrayList<BeanCategoria>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanCategoria beanCategoria = new BeanCategoria();
                    beanCategoria.populate(soapObject);

                    if (!beanCategoria.getIsOk())
                        throw new Exception(beanCategoria.getMensaje());

                    lista.add(beanCategoria);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }

    public List<BeanCategoria> getActivosAndAbrev(String pFiltro) throws Exception {
        List<BeanCategoria> lista = null;

        try {
            String METHOD_NAME = "getActivosAndAbrev";
            lista = new ArrayList<BeanCategoria>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanCategoria beanCategoria = new BeanCategoria();
                    beanCategoria.populate(soapObject);

                    if (!beanCategoria.getIsOk())
                        throw new Exception(beanCategoria.getMensaje());

                    lista.add(beanCategoria);
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
