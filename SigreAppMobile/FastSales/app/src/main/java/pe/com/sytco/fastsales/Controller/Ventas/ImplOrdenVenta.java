package pe.com.sytco.fastsales.Controller.Ventas;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanArticuloMovProy;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplOrdenVenta extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplOrdenVenta?wsdl";

    private ImplOrdenVenta()
    {

    }

    public ImplOrdenVenta(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanOrdenVenta> getOrdenesVentaByFiltro(String pAlmacen, String pFiltro) throws Exception {
        List<BeanOrdenVenta> lista = null;

        try {
            String METHOD_NAME = "getOrdenesVentaByFiltro";
            lista = new ArrayList<BeanOrdenVenta>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanOrdenVenta beanOrdenVenta = new BeanOrdenVenta();
                    beanOrdenVenta.populate(soapObject);

                    if (!beanOrdenVenta.getIsOk())
                        throw new Exception(beanOrdenVenta.getMensaje());

                    lista.add(beanOrdenVenta);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }

        return lista;
    }

    public List<BeanArticuloMovProy> getDetalleOV(String pNroOV,
                                                  String pAlmacen,
                                                  String pFiltro) throws Exception {
        List<BeanArticuloMovProy> lista = null;

        try {
            String METHOD_NAME = "getDetalleOV";
            lista = new ArrayList<BeanArticuloMovProy>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroOV", pNroOV));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticuloMovProy beanAMP = new BeanArticuloMovProy();
                    beanAMP.populate(soapObject);

                    if (!beanAMP.getIsOk())
                        throw new Exception(beanAMP.getMensaje());

                    lista.add(beanAMP);
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
