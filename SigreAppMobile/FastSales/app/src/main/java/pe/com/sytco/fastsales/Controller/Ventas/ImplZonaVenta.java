package pe.com.sytco.fastsales.Controller.Ventas;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaVenta;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplZonaVenta extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplZonaVenta?wsdl";

    private ImplZonaVenta()
    {

    }

    public ImplZonaVenta(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanZonaVenta> getZonasVentabyUbigeo(String pUbigeo,
                                                     String pFiltro) throws Exception {
        List<BeanZonaVenta> lista = null;

        try {
            String METHOD_NAME = "getZonasVentabyUbigeo";
            lista = new ArrayList<BeanZonaVenta>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pUbigeo", pUbigeo));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanZonaVenta beanZonaVenta = new BeanZonaVenta();
                    beanZonaVenta.populate(soapObject);

                    if (!beanZonaVenta.getIsOk())
                        throw new Exception(beanZonaVenta.getMensaje());

                    lista.add(beanZonaVenta);
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
