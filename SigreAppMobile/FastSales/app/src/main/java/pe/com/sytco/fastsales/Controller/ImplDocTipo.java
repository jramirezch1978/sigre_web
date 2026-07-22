package pe.com.sytco.fastsales.Controller;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Finanzas.BeanDocTipo;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplDocTipo  extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplDocTipo?wsdl";

    private ImplDocTipo()
    {

    }

    public ImplDocTipo(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanDocTipo> getDocTiposByFiltro(String pFiltro) throws Exception {
        List<BeanDocTipo> lista = null;

        try {
            String METHOD_NAME = "getDocTiposByFiltro";
            lista = new ArrayList<BeanDocTipo>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanDocTipo beanDocTipo = new BeanDocTipo();
                    beanDocTipo.populate(soapObject);

                    if (!beanDocTipo.getIsOk())
                        throw new Exception(beanDocTipo.getMensaje());

                    lista.add(beanDocTipo);
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
