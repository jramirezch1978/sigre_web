package pe.com.sytco.fastsales.Controller;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplInventarioConteo extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplInventarioConteo?wsdl";

    private ImplInventarioConteo()
    {

    }

    public ImplInventarioConteo(String empresa){
        this.empresaDefault = empresa;
    }

    public Integer getTotalLeido(String fechaConteo, String pAlmacen, Integer pNroConteo) throws Exception {

        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getTotalLeido";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("fechaConteo", fechaConteo));
        param.add(new parametro("pAlmacen", pAlmacen));
        param.add(new parametro("pNroConteo", pNroConteo));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getCount();
    }

    public Integer getTotalLeidoUsuario(String fechaConteo, String pAlmacen, Integer pNroConteo, String pUsuario) throws Exception {

        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getTotalLeidoUsuario";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("fechaConteo", fechaConteo));
        param.add(new parametro("pAlmacen", pAlmacen));
        param.add(new parametro("pNroConteo", pNroConteo));
        param.add(new parametro("pUsuario", pUsuario));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getCount();
    }

    public Integer getTotalbyUbicacion(String fechaConteo, String pAlmacen, Integer pNroConteo, String pUbicacion) throws Exception {

        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getTotalbyUbicacion";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("fechaConteo", fechaConteo));
        param.add(new parametro("pAlmacen", pAlmacen));
        param.add(new parametro("pNroConteo", pNroConteo));
        param.add(new parametro("pUbicacion", pUbicacion));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getCount();
    }

    public boolean InsertarWithCU(String pCodArt,
                            String fechaConteo,
                            String pAlmacen,
                            Integer pNroConteo,
                            String pUbicacion,
                            String pCodigoCU,
                            String pUsuario) throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "InsertarWithCU";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pCodArt", pCodArt));
        param.add(new parametro("fechaConteo", fechaConteo));
        param.add(new parametro("pAlmacen", pAlmacen));
        param.add(new parametro("pNroConteo", pNroConteo));
        param.add(new parametro("pUbicacion", pUbicacion));
        param.add(new parametro("pCodigoCU", pCodigoCU));
        param.add(new parametro("pUsuario", pUsuario));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return true;
    }

    public boolean Insertar(String pCodArt, String fechaConteo, String pAlmacen,
                            Integer pNroConteo,
                            String pUbicacion,
                            String pUsuario) throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "Insertar";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pCodArt", pCodArt));
        param.add(new parametro("fechaConteo", fechaConteo));
        param.add(new parametro("pAlmacen", pAlmacen));
        param.add(new parametro("pNroConteo", pNroConteo));
        param.add(new parametro("pUbicacion", pUbicacion));
        param.add(new parametro("pUsuario", pUsuario));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return true;
    }

    public String getUbicacionMinima(String pAlmacen) throws Exception {

        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getUbicacionMinima";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pAlmacen", pAlmacen));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getCadena();
    }

    public List<String> getListadoPosicion(String pAlmacen) throws Exception {

        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getListadoPosicion";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pAlmacen", pAlmacen));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getListadoString();
    }

    public boolean existeInventarioCU(String pAlmacen, String pFechaConteo, String pNroConteo, String pCodigoCU) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "existeInventarioCU";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pAlmacen", pAlmacen.trim()));
        param.add(new parametro("pFechaConteo", pFechaConteo.trim()));
        param.add(new parametro("pNroConteo", pNroConteo.trim()));
        param.add(new parametro("pCodigoCU", pCodigoCU.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        //Valido si hay registros al respecto
        if (strRespuesta.getCount()== 0)
            return false;
        else
            return true;
    }

    public String getUbicacion(String pAlmacen, String pFechaConteo, String pNroConteo, String pCodigoCU) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getUbicacion";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pAlmacen", pAlmacen.trim()));
        param.add(new parametro("pFechaConteo", pFechaConteo.trim()));
        param.add(new parametro("pNroConteo", pNroConteo.trim()));
        param.add(new parametro("pCodigoCU", pCodigoCU.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        //Valido si hay registros al respecto
        return strRespuesta.getCadena();
    }
}
