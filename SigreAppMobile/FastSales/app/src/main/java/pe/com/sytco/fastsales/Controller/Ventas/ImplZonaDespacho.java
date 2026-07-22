package pe.com.sytco.fastsales.Controller.Ventas;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaDespacho;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaVenta;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplZonaDespacho extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplZonaDespacho?wsdl";

    private ImplZonaDespacho()
    {

    }

    public ImplZonaDespacho(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanZonaDespacho> getZonasDespachobyUbigeo(String pUbigeo,
                                                           String pFiltro) throws Exception {
        List<BeanZonaDespacho> lista = null;

        try {
            String METHOD_NAME = "getZonasDespachobyUbigeo";
            lista = new ArrayList<BeanZonaDespacho>();

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
                    BeanZonaDespacho beanZonaDespacho = new BeanZonaDespacho();
                    beanZonaDespacho.populate(soapObject);

                    if (!beanZonaDespacho.getIsOk())
                        throw new Exception(beanZonaDespacho.getMensaje());

                    lista.add(beanZonaDespacho);
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
