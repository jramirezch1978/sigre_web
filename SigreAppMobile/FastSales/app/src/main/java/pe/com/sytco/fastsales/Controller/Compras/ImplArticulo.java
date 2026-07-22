package pe.com.sytco.fastsales.Controller.Compras;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.Compras.BeanArticuloUnd;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngresoDet;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 01/05/2016.
 */
public class ImplArticulo extends ImplAncestor {
    public static final int ACTION_FILTRAR_ARTICULOS = 1;

    private String WSDL = "SigreWebService/ImplArticulo?wsdl";

    private ImplArticulo()
    {

    }

    public ImplArticulo(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanArticulo> getAll() {
        return null;
    }

    public List<BeanArticulo> getByFiltro(String pFilttro) throws Exception {

        List<BeanArticulo> lista = null;

        try {
            String METHOD_NAME = "getByFiltro";
            lista = new ArrayList<BeanArticulo>();
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", "%" + pFilttro.trim() + "%"));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if(lsObjects != null) {
                int length = lsObjects.size();
                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticulo articulo = new BeanArticulo();
                    articulo.populate(soapObject);

                    if (!articulo.getIsOk())
                        throw new Exception(articulo.getMensaje());

                    lista.add(articulo);
                }
            }
            return lista;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }



    }

    public List<BeanArticulo> getBySKU(String strSKU) throws Exception {
        List<BeanArticulo> lista = null;

        try {
            String METHOD_NAME = "getBySKU";
            lista = new ArrayList<BeanArticulo>();
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", strSKU.trim()));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if(lsObjects != null) {
                int length = lsObjects.size();
                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticulo articulo = new BeanArticulo();
                    articulo.populate(soapObject);
                    lista.add(articulo);
                }
            }
            return lista;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    public List<BeanArticulo> getByCodigoCU(String pCodigoCU) throws Exception {
        List<BeanArticulo> lista = null;

        try {
            String METHOD_NAME = "getByCodigoCU";
            lista = new ArrayList<BeanArticulo>();
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodigoCU", pCodigoCU.trim()));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if(lsObjects != null) {
                int length = lsObjects.size();
                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticulo articulo = new BeanArticulo();
                    articulo.populate(soapObject);
                    lista.add(articulo);
                }
            }
            return lista;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    public boolean saveImagen(String pCodArt, String pBase64) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "saveImagen";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pCodArt", pCodArt.trim()));
        param.add(new parametro("pBase64", pBase64));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();
    }

    public boolean isCodigoCU(String strSKU) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "isCodigoCU";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("strSKU", strSKU.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();
    }

    public BeanArticulo getImagenGrupal(BeanParteIngresoDet pRowSelect) throws Exception{

        BeanArticulo beanArticulo = null;

        try {
            String METHOD_NAME = "getImagenGrupal";

            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pDescMarca", pRowSelect.getNomMarca()));
            param.add(new parametro("pEstilo", pRowSelect.getEstilo()));
            param.add(new parametro("pDescSuela", pRowSelect.getDescSuela()));
            param.add(new parametro("pDescAcabado", pRowSelect.getDescAcabado()));
            param.add(new parametro("pDescColor1", pRowSelect.getDescColorPrimario()));
            param.add(new parametro("pDescColor2", pRowSelect.getDescColorSecundario()));
            param.add(new parametro("pCodTaco", pRowSelect.getTaco()));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanArticulo = new BeanArticulo();
            beanArticulo.populate(soapObject);

            if (!beanArticulo.getIsOk()){
                throw new Exception(beanArticulo.getMensaje());
            }

            return beanArticulo;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    public BeanArticulo getImagenGrupalById(Integer pIdFoto) throws Exception{

        BeanArticulo beanArticulo = null;

        try {
            String METHOD_NAME = "getImagenGrupalById";

            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pIdFoto", pIdFoto));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanArticulo = new BeanArticulo();
            beanArticulo.populate(soapObject);

            if (!beanArticulo.getIsOk()){
                throw new Exception(beanArticulo.getMensaje());
            }

            return beanArticulo;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    public BeanArticulo getImagenGrupalScaledMedium(Integer pIdFoto) throws Exception{

        BeanArticulo beanArticulo = null;

        try {
            String METHOD_NAME = "getImagenGrupalScaledMedium";

            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pIdFoto", pIdFoto));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanArticulo = new BeanArticulo();
            beanArticulo.populate(soapObject);

            if (!beanArticulo.getIsOk()){
                throw new Exception(beanArticulo.getMensaje());
            }

            return beanArticulo;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    public boolean saveImagenGrupal(BeanParteIngresoDet pRowSelect, String pBase64) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "saveImagenGrupal";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pDescMarca", pRowSelect.getNomMarca()));
        param.add(new parametro("pEstilo", pRowSelect.getEstilo()));
        param.add(new parametro("pDescSuela", pRowSelect.getDescSuela()));
        param.add(new parametro("pDescAcabado", pRowSelect.getDescAcabado()));
        param.add(new parametro("pDescColor1", pRowSelect.getDescColorPrimario()));
        param.add(new parametro("pDescColor2", pRowSelect.getDescColorSecundario()));
        param.add(new parametro("pCodTaco", pRowSelect.getTaco()));
        param.add(new parametro("pBase64", pBase64));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();

    }

    public List<BeanArticuloUnd> getUndByCodArticulo(String pCodArticulo) throws Exception{
        List<BeanArticuloUnd> lista = null;

        try {
            String METHOD_NAME = "getUndByCodArticulo";
            lista = new ArrayList<BeanArticuloUnd>();
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodArticulo", pCodArticulo.trim()));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if(lsObjects != null) {
                int length = lsObjects.size();
                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticuloUnd bean = new BeanArticuloUnd();
                    bean.populate(soapObject);

                    if (!bean.getIsOk())
                        throw new Exception(bean.getMensaje());

                    lista.add(bean);
                }
            }
            return lista;

        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    //Metodos staticos
    public static BeanArticulo getInstanceArticulo(String asCadena) throws Exception {
        String lsSeparador;
        String[] partes;

        BeanArticulo articulo = new BeanArticulo();
        if (asCadena.contains("|")){
            lsSeparador = "\\|";
        }else if(asCadena.contains("]")){
            lsSeparador = "\\]";
        }else {
            throw new Exception("La Cadena " + asCadena + " no tiene caracter SEPARADOR");
        }

        partes = asCadena.split(lsSeparador);
        //Ahora recreo los datos segun el codigo QR
        articulo.setCodigoCU(partes[0]);
        articulo.setEmpresa(partes[1]);
        articulo.setCodSKU(partes[2]);
        articulo.setDescArticulo(partes[3]);
        articulo.setNroParte(partes[4]);
        articulo.setFecIngreso(UTIL.parseStringToSqlDate(partes[5], "dd/MM/yyyy"));

        return articulo;
    }


}
