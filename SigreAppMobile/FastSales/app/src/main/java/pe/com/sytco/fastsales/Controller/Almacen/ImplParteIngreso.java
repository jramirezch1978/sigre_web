package pe.com.sytco.fastsales.Controller.Almacen;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanIngresoResumido;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanSugerencias;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplParteIngreso extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplParteIngreso?wsdl";

    public ImplParteIngreso(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanParteIngreso> getListadoByFechas(String pFechaDesde,
                                                     String pFechaHasta) throws Exception {

        List<BeanParteIngreso> lista = new ArrayList<BeanParteIngreso>();

        String METHOD_NAME = "getListadoByFechas";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pFechaDesde", pFechaDesde));
        param.add(new parametro("pFechaHasta", pFechaHasta));

        List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
        int length = lsObjects.size();

        for(int i=0; i<length; i ++){
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
            BeanParteIngreso bean = new BeanParteIngreso();
            bean.populate(soapObject);

            if (!bean.getIsOk()){
                throw new Exception(bean.getMensaje());
            }
            lista.add(bean);
        }

        return lista;
    }

    public BeanParteIngreso getOneJSON(String pNroParte) throws Exception {
        BeanParteIngreso beanParteIngreso = null;

        StrRespuesta strRespuesta = null;
        Gson gson = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "getOneJSON";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroParte", pNroParte));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }

            gson = new Gson();

            beanParteIngreso = gson.fromJson(strRespuesta.getCadena(), BeanParteIngreso.class);

            return beanParteIngreso;

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }
    }

    public List<BeanSugerencias> getSugerencias(String pSubCategoria,
                                                String pCodMarca,
                                                String pEstilo) throws Exception {

        List<BeanSugerencias> lista = null;

        try {
            String METHOD_NAME = "getSugerencias";
            lista = new ArrayList<BeanSugerencias>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pSubCategoria", pSubCategoria));
            param.add(new parametro("pCodMarca", pCodMarca));
            param.add(new parametro("pEstilo", pEstilo));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanSugerencias bean = new BeanSugerencias();
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

    public List<BeanIngresoResumido> getSugerenciasArticulos(String pProveedor, String pCategoria, String pSubCategoria,
                                                             String pUnd, String pCodMarca, String pCodLinea, String pCodSubLinea, String pEstilo,
                                                             String pCodAcabado, String pCodSuela, String pColor1, String pColor2,
                                                             String pCodTaco, Integer pTallaMin, Integer pTallaMax,
                                                             Integer pIncremento, String pPrecio) throws Exception {

        List<BeanIngresoResumido> lista = null;

        try {
            String METHOD_NAME = "getSugerenciasArticulos";
            lista = new ArrayList<BeanIngresoResumido>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pProveedor", pProveedor));
            param.add(new parametro("pCategoria", pCategoria));
            param.add(new parametro("pSubCategoria", pSubCategoria));
            param.add(new parametro("pUnd", pUnd));
            param.add(new parametro("pCodMarca", pCodMarca));
            param.add(new parametro("pCodLinea", pCodLinea));
            param.add(new parametro("pCodSubLinea", pCodSubLinea));
            param.add(new parametro("pEstilo", pEstilo));
            param.add(new parametro("pCodAcabado", pCodAcabado));
            param.add(new parametro("pCodSuela", pCodSuela));
            param.add(new parametro("pColor1", pColor1));
            param.add(new parametro("pColor2", pColor2));
            param.add(new parametro("pCodTaco", pCodTaco));
            param.add(new parametro("pTallaMin", pTallaMin));
            param.add(new parametro("pTallaMax", pTallaMax));
            param.add(new parametro("pIncremento", pIncremento));
            param.add(new parametro("pPrecio", pPrecio));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanIngresoResumido bean = new BeanIngresoResumido();
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
}
