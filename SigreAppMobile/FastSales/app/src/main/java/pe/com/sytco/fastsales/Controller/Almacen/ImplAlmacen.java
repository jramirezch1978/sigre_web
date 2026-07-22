package pe.com.sytco.fastsales.Controller.Almacen;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.parametro;

/**
 * Created by jramirez on 08/05/2016.
 */
public class ImplAlmacen extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplAlmacen?wsdl";

    private ImplAlmacen()
    {

    }

    public ImplAlmacen(String empresa){
        this.empresaDefault = empresa;
    }

    public BeanAlmacen getOne(String pAlmacen) throws Exception {
        BeanAlmacen beanAlmacen = null;

        try {
            String METHOD_NAME = "getOne";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanAlmacen = new BeanAlmacen();
            beanAlmacen.populate(soapObject);

            return beanAlmacen;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanAlmacen = null;
        }
    }

    public List<BeanAlmacen> getAlmacenByArticulo(String pCodArt, String pUsuario) {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenByArticulo";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodArt", pCodArt));
            param.add(new parametro("pUsuario", pUsuario));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null){
                int length = lsObjects.size();

                for(int i=0; i<length; i ++){
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanAlmacen almacen = new BeanAlmacen();
                    almacen.populate(soapObject);

                    if (!almacen.getIsOk()){
                        throw new Exception(almacen.getMensaje());
                    }

                    lista.add(almacen);
                }
            }


        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;

    }

    public List<BeanAlmacen> getAlmacenesActivos() {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenesActivos";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanAlmacen almacen = new BeanAlmacen();
                    almacen.populate(soapObject);
                    lista.add(almacen);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;
    }

    public Boolean existeSKU(String strSKU) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "existeSKU";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("strSKU", strSKU.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();
    }

    public List<BeanAlmacen> getAlmacenPPTT(String pAlmacenPPTT) {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenPPTT";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacenPPTT", pAlmacenPPTT));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanAlmacen almacen = new BeanAlmacen();
                    almacen.populate(soapObject);
                    lista.add(almacen);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;
    }

    public List<BeanAlmacen> getAlmacenPPTTByUser(String pAlmacenPPTT, String pUsuario) {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenPPTTByUser";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacenPPTT", pAlmacenPPTT));
            param.add(new parametro("pUsuario", pUsuario));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanAlmacen almacen = new BeanAlmacen();
                    almacen.populate(soapObject);
                    lista.add(almacen);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;
    }


    public Boolean existeCU(String codigoCU) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "existeCU";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("codigoCU", codigoCU.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();
    }

    public List<BeanAlmacen> getAlmacenByUsuario(String pUsuario, String pFiltro) {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenByUsuario";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pUsuario", pUsuario));
            param.add(new parametro("pFiltro", pFiltro));


            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanAlmacen almacen = new BeanAlmacen();
                    almacen.populate(soapObject);

                    if (!almacen.getIsOk())
                        throw new Exception(almacen.getMensaje());

                    lista.add(almacen);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;
    }
}
