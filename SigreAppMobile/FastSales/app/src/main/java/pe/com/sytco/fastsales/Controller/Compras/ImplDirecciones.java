package pe.com.sytco.fastsales.Controller.Compras;

import com.google.gson.Gson;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanOpcion;
import pe.com.sytco.fastsales.beans.Compras.BeanDirecciones;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplDirecciones extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplDirecciones?wsdl";

    private ImplDirecciones()
    {

    }

    public ImplDirecciones(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanDirecciones> getDireccionesByFiltro(String pProveedor, String pFiltro) throws Exception {
        List<BeanDirecciones> lista = null;

        try {
            String METHOD_NAME = "getDireccionesByFiltro";
            lista = new ArrayList<BeanDirecciones>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pProveedor", pProveedor));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanDirecciones beanDirecciones = new BeanDirecciones();
                    beanDirecciones.populate(soapObject);

                    if (!beanDirecciones.getIsOk())
                        throw new Exception(beanDirecciones.getMensaje());

                    lista.add(beanDirecciones);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }

    public List<BeanDirecciones> getDirecciones(String pProveedor) throws Exception {
        List<BeanDirecciones> lista = null;

        try {
            String METHOD_NAME = "getDirecciones";
            lista = new ArrayList<BeanDirecciones>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pProveedor", pProveedor));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanDirecciones beanDirecciones = new BeanDirecciones();
                    beanDirecciones.populate(soapObject);

                    if (!beanDirecciones.getIsOk())
                        throw new Exception(beanDirecciones.getMensaje());

                    lista.add(beanDirecciones);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }

    public boolean anularDireccion(Integer pItemDireccion) throws Exception {
        StrRespuesta strRespuesta = null;
        List<parametro> param = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "anularDireccion";

            param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pItemDireccion", pItemDireccion));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
            param = null;
        }

    }

    public boolean updateDireccion(BeanDirecciones beanDireccion) throws Exception {
        StrRespuesta strRespuesta = null;
        List<parametro> param = null;
        String pDireccionJSON = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "updateDireccion";

            //Genero el JSON
            pDireccionJSON = new Gson().toJson(beanDireccion);

            param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pDireccionJSON", pDireccionJSON));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
            param = null;
        }
    }

    public List<BeanOpcion> getDescDirecciones() throws Exception {
        List<BeanOpcion> lista = null;

        try {
            String METHOD_NAME = "getDescDirecciones";
            lista = new ArrayList<BeanOpcion>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanOpcion beanOpcion = new BeanOpcion();
                    beanOpcion.populate(soapObject);

                    if (!beanOpcion.getIsOk())
                        throw new Exception(beanOpcion.getMensaje());

                    lista.add(beanOpcion);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }

    public List<BeanOpcion> getFlagUsos() throws Exception {
        List<BeanOpcion> lista = null;

        try {
            String METHOD_NAME = "getFlagUsos";
            lista = new ArrayList<BeanOpcion>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanOpcion beanOpcion = new BeanOpcion();
                    beanOpcion.populate(soapObject);

                    if (!beanOpcion.getIsOk())
                        throw new Exception(beanOpcion.getMensaje());

                    lista.add(beanOpcion);
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
