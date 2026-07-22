package pe.com.sytco.fastsales.Controller.Finanzas;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Finanzas.BeanFormaPago;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplFormaPago  extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplFormaPago?wsdl";

    private ImplFormaPago()
    {

    }

    public ImplFormaPago(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanFormaPago> getFormasPagoActivos(String pFiltro) throws Exception {
        List<BeanFormaPago> lista = null;

        try {
            String METHOD_NAME = "getFormasPagoActivos";
            lista = new ArrayList<BeanFormaPago>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanFormaPago formaPago = new BeanFormaPago();
                    formaPago.populate(soapObject);

                    if (!formaPago.getIsOk())
                        throw new Exception(formaPago.getMensaje());

                    lista.add(formaPago);
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
