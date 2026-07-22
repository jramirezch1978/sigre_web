package pe.com.sytco.fastsales.Controller.Almacen;

import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.ParteRecepcion.BeanParteRecepcion;
import pe.com.sytco.fastsales.beans.ParteRecepcion.BeanParteRecepcionUnd;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplParteRecepcion extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplParteRecepcion?wsdl";
    private String _nroParte;

    private ImplParteRecepcion()
    {

    }

    public ImplParteRecepcion(String empresa){
        this.empresaDefault = empresa;
    }

    public static Double getTotalCajas(List<BeanParteIngreso> listado) {
        Double ldblResult = 0.00D;

        for(BeanParteIngreso bean : listado){
            ldblResult += bean.getCantidad();
        }

        return ldblResult;
    }

    public static Double getTotalCompra(List<BeanParteIngreso> listado) {
        Double ldblResult = 0.00D;

        for(BeanParteIngreso bean : listado){
            ldblResult += bean.getValorCompra();
        }

        return ldblResult;
    }

    public static Double getTotalVenta(List<BeanParteIngreso> listado) {
        Double ldblResult = 0.00D;

        for(BeanParteIngreso bean : listado){
            ldblResult += bean.getValorVenta();
        }

        return ldblResult;
    }

    public List<String> getAnaquelByAlmacen(String pAlmacen) throws Exception {

        List<String> anaqueles = null;

        try {
            String METHOD_NAME = "getAnaquelByAlmacen";
            anaqueles = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    anaqueles.add(lsObjects.get(i).toString());
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return anaqueles;
    }

    public List<String> getFilaByAlmacen(String pAlmacen, String pAnaquel) throws Exception {

        List<String> filas = null;

        try {
            String METHOD_NAME = "getFilaByAlmacen";
            filas = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pAnaquel", pAnaquel));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    filas.add(lsObjects.get(i).toString());
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return filas;
    }

    public List<String> getColumnaByAlmacen(String pAlmacen, String pAnaquel,String pFila) throws Exception {

        List<String> columnas = null;

        try {
            String METHOD_NAME = "getColumnaByAlmacen";
            columnas = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pAnaquel", pAnaquel));
            param.add(new parametro("pFila", pFila));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    columnas.add(lsObjects.get(i).toString());
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return columnas;
    }

    public boolean Insertar(BeanParteRecepcion pCabecera,
                            List<BeanParteRecepcionUnd> pDetalle) throws Exception {

        StrRespuesta strRespuesta = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "Insertar";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCabecera", pCabecera));
            param.add(new parametro("pDetalle", pDetalle));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this._nroParte = null;
                throw new Exception(strRespuesta.getMensaje());
            }


            this._nroParte = strRespuesta.getCadena();
            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }
    }

    public String getNroParte() {
        return _nroParte;
    }

    public void setNroParte(String value) {
        this._nroParte = value;
    }

    public Double getCantidad(List<BeanCaja> detalle) {
        Double _cantidad = 0.0;
        for(BeanCaja obj : detalle){
            _cantidad += obj.getPesoPromedio();
        }

        return _cantidad;
    }

    public String getCodArticulo(List<BeanCaja> detalle) {
        String codArt = null;
        for(BeanCaja obj : detalle){
            codArt = obj.getCodArticulo();
            break;
        }
        return codArt;
    }

    public boolean InsertarCabecera(
            String pCodOrigen, String pAlmacenDst,
            String pAlmacenOrg, String pFecRecepcion, String pAnaquel, String pFila, String pColumna,
            String pCodArticulo, String pCodUsuario, String pCantRecibida) throws Exception {

        StrRespuesta strRespuesta = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "InsertarCabecera";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodOrigen", pCodOrigen));
            param.add(new parametro("pAlmacenDst", pAlmacenDst));
            param.add(new parametro("pAlmacenOrg", pAlmacenOrg));
            param.add(new parametro("pFecRecepcion", pFecRecepcion));
            param.add(new parametro("pAnaquel", pAnaquel));
            param.add(new parametro("pFila", pFila));
            param.add(new parametro("pColumna", pColumna));
            param.add(new parametro("pCodArticulo", pCodArticulo));
            param.add(new parametro("pCodUsuario", pCodUsuario));
            param.add(new parametro("pCantRecibida", pCantRecibida));


            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this._nroParte = null;
                throw new Exception(strRespuesta.getMensaje());
            }


            this._nroParte = strRespuesta.getCadena();
            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }
    }

    public boolean InsertarDetalle(
            String pNroParte,
            String pCodigoCU,
            String pNroPallet,
            String pCodUsuario) throws Exception {

        StrRespuesta strRespuesta = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "InsertarDetalle";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroParte", pNroParte));
            param.add(new parametro("pCodigoCU", pCodigoCU));
            param.add(new parametro("pNroPallet", pNroPallet));
            param.add(new parametro("pCodUsuario", pCodUsuario));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this._nroParte = null;
                throw new Exception(strRespuesta.getMensaje());
            }

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
        }
    }

    public Boolean InsertarParteCompleto(BeanParteRecepcion pCabecera,
                                         String pDetalle) throws Exception {

        StrRespuesta strRespuesta = null;
        PropertyInfo pi = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "InsertarParteCompleto";

            List<PropertyInfo> param = new ArrayList<PropertyInfo>();
            pi = new PropertyInfo();
            pi.setName("empresaDefault");
            pi.setType(PropertyInfo.STRING_CLASS);
            pi.setValue(empresaDefault);
            param.add(pi);

            pi = new PropertyInfo();
            pi.setName("pCabecera");
            pi.setType(PropertyInfo.OBJECT_CLASS);
            pi.setValue(pCabecera);
            param.add(pi);

            pi = new PropertyInfo();
            pi.setName("pDetalle");
            pi.setType(String.class);
            pi.setValue(pDetalle);
            param.add(pi);


            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().ConnectWithPropInfo(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this._nroParte = null;
                throw new Exception(strRespuesta.getMensaje());
            }

            //Me devuelve un nro de parte que lo coloco en la cabecera
            pCabecera.setNroParte(strRespuesta.getCadena());

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
        }
    }

    public Boolean InsertarDetalleBean(BeanParteRecepcionUnd pDetalle) throws Exception {

        StrRespuesta strRespuesta = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "InsertarDetalleBean";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pDetalle", pDetalle));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this._nroParte = null;
                throw new Exception(strRespuesta.getMensaje());
            }

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
        }
    }

    public List<String> getAnaquelLibreByAlmacen(String pAlmacen) {
        List<String> anaqueles = null;

        try {
            String METHOD_NAME = "getAnaquelLibreByAlmacen";
            anaqueles = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    anaqueles.add(lsObjects.get(i).toString());
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return anaqueles;
    }

    public List<String> getFilaLibreByAlmacen(String pAlmacen, String pAnaquel) throws Exception {

        List<String> filas = null;

        try {
            String METHOD_NAME = "getFilaLibreByAlmacen";
            filas = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pAnaquel", pAnaquel));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    filas.add(lsObjects.get(i).toString());
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return filas;
    }

    public List<String> getColumnaLibreByAlmacen(String pAlmacen, String pAnaquel,String pFila) throws Exception {

        List<String> columnas = null;

        try {
            String METHOD_NAME = "getColumnaLibreByAlmacen";
            columnas = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pAnaquel", pAnaquel));
            param.add(new parametro("pFila", pFila));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    columnas.add(lsObjects.get(i).toString());
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return columnas;
    }

}
