package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanArticuloClase;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.beans.Compras.BeanUnidad;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplArticuloClase extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplArticuloClase?wsdl";

    private ImplArticuloClase()
    {

    }

    public ImplArticuloClase(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanArticuloClase> getActivosByFiltro(String pFiltro) throws Exception {
        List<BeanArticuloClase> lista = null;

        try {
            String METHOD_NAME = "getActivosByFiltro";
            lista = new ArrayList<BeanArticuloClase>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticuloClase bean = new BeanArticuloClase();
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

    public BeanArticuloClase getOne(String pCodClase) throws Exception {
        BeanArticuloClase bean = null;

        try {
            String METHOD_NAME = "getOne";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodClase", pCodClase));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            bean = new BeanArticuloClase();
            bean.populate(soapObject);

            if (!bean.getIsOk())
                throw new  Exception(bean.getMensaje());

            return bean;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            bean = null;
        }
    }

    public String getDescClase(String pCodClase) throws Exception {
        BeanArticuloClase bean = this.getOne(pCodClase);

        if (bean != null)
            return bean.getDescClase();
        else
            return "";
    }
}
