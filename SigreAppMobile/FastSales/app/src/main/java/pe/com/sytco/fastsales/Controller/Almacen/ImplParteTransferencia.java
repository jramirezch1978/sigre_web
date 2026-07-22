package pe.com.sytco.fastsales.Controller.Almacen;

import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.ParteTransferencia.BeanParteTransferencia;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplParteTransferencia extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplParteTransferencia?wsdl";
    private String _nroPallet;
    private String _nroParte;

    private ImplParteTransferencia()
    {

    }

    public ImplParteTransferencia(String empresa){
        this.empresaDefault = empresa;
    }

    public boolean validarPallet(String pLectura) throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "validarPallet";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pLectura", pLectura));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk()){
            this._nroPallet = null;
            throw new Exception(strRespuesta.getMensaje());
        }


        this._nroPallet = strRespuesta.getCadena();
        return strRespuesta.getIsOk();
    }

    public String getNroPallet() {
        return this._nroPallet;

    }

    public String getNroParte() {
        return this._nroParte;

    }

    public List<String> getAnaquelesOrgByPallet(String pNroPallet, String pAlmacen) throws Exception {

        List<String> anaqueles = null;

        try {
            String METHOD_NAME = "getAnaquelesOrgByPallet";
            anaqueles = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));
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

    public List<String> getFilasOrgByPallet(String pNroPallet, String pAlmacen, String pAnaquel) throws Exception {

        List<String> filas = null;

        try {
            String METHOD_NAME = "getFilasOrgByPallet";
            filas = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));
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

    public List<String> getColumnasOrgByPallet(String pNroPallet, String pAlmacen, String pAnaquel, String pFila) throws Exception {

        List<String> columnas = null;

        try {
            String METHOD_NAME = "getColumnasOrgByPallet";
            columnas = new ArrayList<String>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));
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

    public List<BeanAlmacen> getAlmacenesOrgByPallet(String pNroPallet) {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenesOrgByPallet";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));

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

    public Boolean InsertarParteCompleto(BeanParteTransferencia pCabecera,
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

    public boolean validarPalletDst(String pLectura) throws Exception {
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "validarPalletDst";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pLectura", pLectura));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk()){
            this._nroPallet = null;
            throw new Exception(strRespuesta.getMensaje());
        }


        this._nroPallet = strRespuesta.getCadena();
        return strRespuesta.getIsOk();
    }

    public List<BeanCaja> getListadoCajasByPallet(String pNroPallet,
                                                  String pAlmacen,
                                                  String pAnaquel,
                                                  String pFila,
                                                  String pColumna) {
        List<BeanCaja> lista = null;

        try {
            String METHOD_NAME = "getListadoCajasByPallet";
            lista = new ArrayList<BeanCaja>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pAnaquel", pAnaquel));
            param.add(new parametro("pFila", pFila));
            param.add(new parametro("pColumna", pColumna));


            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanCaja caja = new BeanCaja();
                    caja.populate(soapObject);
                    lista.add(caja);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }finally{

        }

        return lista;
    }

    public List<BeanAlmacen> getAlmacenPPTTByUser(String pUsuario) {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenPPTTByUser";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
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

    public List<String> getAnaquelesDstByPallet(String pAlmacen) {
        List<String> anaqueles = null;

        try {
            String METHOD_NAME = "getAnaquelesDstByPallet";
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

    public List<String> getFilasDstByPallet(String pAlmacen, String pAnaquel) {
        List<String> filas = null;

        try {
            String METHOD_NAME = "getFilasDstByPallet";
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

    public List<String> getColumnasDstByPallet(String pAlmacen, String pAnaquel, String pFila) {
        List<String> columnas = null;

        try {
            String METHOD_NAME = "getColumnasDstByPallet";
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
