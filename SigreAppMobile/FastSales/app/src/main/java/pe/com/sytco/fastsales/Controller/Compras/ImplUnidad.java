package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.beans.Compras.BeanUnidad;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplUnidad extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplUnidad?wsdl";

    private ImplUnidad()
    {

    }

    public ImplUnidad(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanUnidad> getActivosByFiltro(String pFiltro) throws Exception {
        List<BeanUnidad> lista = null;

        try {
            String METHOD_NAME = "getActivosByFiltro";
            lista = new ArrayList<BeanUnidad>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanUnidad bean = new BeanUnidad();
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

    public BeanUnidad getOne(String pUnd) throws Exception {
        BeanUnidad beanUnidad = null;

        try {
            String METHOD_NAME = "getOne";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pUnd", pUnd));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanUnidad = new BeanUnidad();
            beanUnidad.populate(soapObject);

            if (!beanUnidad.getIsOk())
                throw new  Exception(beanUnidad.getMensaje());

            return beanUnidad;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanUnidad = null;
        }
    }

    public String getDescUnidad(String pUnd) throws Exception {
        BeanUnidad bean = this.getOne(pUnd);

        if (bean != null)
            return bean.getDescUnidad();
        else
            return "";
    }
}
