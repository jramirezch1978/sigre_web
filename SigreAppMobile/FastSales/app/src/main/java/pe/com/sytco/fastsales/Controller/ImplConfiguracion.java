package pe.com.sytco.fastsales.Controller;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.beans.parametro;

/**
 * Created by jramirez on 12/06/2016.
 */
public class ImplConfiguracion extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplConfiguracion?wsdl";

    private ImplConfiguracion()
    {

    }

    public ImplConfiguracion(String empresa){
        this.empresaDefault = empresa;
    }

    public String getParametro(String parametro, String defaultValue) throws Exception {
        String lsReturn;

        try {
            String METHOD_NAME = "getParametro";

            //Añado los parametros
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("parametro", parametro));
            param.add(new parametro("defaultValue", defaultValue));

            //Invoco a la conexión SOAP
            lsReturn = new SOAPClient().Connect(WSDL, METHOD_NAME, param).toString();

            return lsReturn;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }
    }

}
