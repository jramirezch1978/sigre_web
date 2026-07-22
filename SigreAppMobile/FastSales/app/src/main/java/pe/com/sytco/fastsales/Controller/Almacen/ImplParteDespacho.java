package pe.com.sytco.fastsales.Controller.Almacen;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Almacen.BeanCodigoCU;
import pe.com.sytco.fastsales.beans.Almacen.BeanLecturas;
import pe.com.sytco.fastsales.beans.BeanArticuloMovProy;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.beans.BeanPallet;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplParteDespacho extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplParteDespacho?wsdl";

    private String _nroVale, _nroPallet, _codigoCU = "", _palletOrCU = "";

    //Listado de PackingList, para poderlo editar posteriormente
    private static List<BeanCaja> _packingList;

    private ImplParteDespacho()
    {

    }

    public ImplParteDespacho(String empresa){
        this.empresaDefault = empresa;
    }

    public static void setListadoCajas(List<BeanCaja> value) {
        ImplParteDespacho._packingList = value;
    }
    public static List<BeanCaja> getListadoCajas() {
        return ImplParteDespacho._packingList;
    }
    public String getNroVale() {
        return _nroVale;
    }
    public void setNroVale(String value) {
        this._nroVale = value;
    }
    public static String getUnd() {
        if (ImplParteDespacho._packingList.size() == 0) return "";

        return ImplParteDespacho._packingList.get(0).getUnd();
    }
    public static String getUnd2() {
        if (ImplParteDespacho._packingList.size() == 0) return "";

        return ImplParteDespacho._packingList.get(0).getUnd2();
    }
    public String getNroPallet() {
        return this._nroPallet;
    }
    public String getCodigoCU() {
        return this._codigoCU;
    }
    public String getPalletOrCU() {
        return this._palletOrCU;
    }
    public static Double getSaldoUnd() {
        Double ldbl_return = 0.0;

        if (ImplParteDespacho._packingList.size() == 0) return ldbl_return;

        for(BeanCaja caja : ImplParteDespacho._packingList){
            ldbl_return += caja.getSaldoUnd();
        }

        return ldbl_return;
    }
    public static Double getSaldoUnd2() {
        Double ldbl_return = 0.0;

        if (ImplParteDespacho._packingList.size() == 0) return ldbl_return;

        for(BeanCaja caja : ImplParteDespacho._packingList){
            ldbl_return += caja.getSaldoUnd2();
        }

        return ldbl_return;
    }

    public List<BeanOrdenVenta> getOVPendientes(String pNroPallet) throws Exception {
        List<BeanOrdenVenta> lista = null;

        try {
            String METHOD_NAME = "getOVPendientes";
            lista = new ArrayList<BeanOrdenVenta>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanOrdenVenta ov = new BeanOrdenVenta();
                    ov.populate(soapObject);

                    if (!ov.getIsOk())
                        throw new Exception(ov.getMensaje());

                    lista.add(ov);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }

        return lista;
    }

    public List<BeanAlmacen> getAlmacenesByOV(String pNroOV, String pNroPallet) throws Exception {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenesByOV";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroOV", pNroOV));
            param.add(new parametro("pNroPallet", pNroPallet));

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
            throw e;
        }finally{

        }

        return lista;
    }

    public List<BeanAlmacen> getAlmacenesPallet(String strNroPallet) throws Exception {
        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenesPallet";
            lista = new ArrayList<BeanAlmacen>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("strNroPallet", strNroPallet));

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
            throw  e;
        }finally{

        }

        return lista;
    }

    public List<BeanCaja> getCajasByPallet(String pNroPallet, String pNroOV, String pAlmacen, String pCodArt) throws Exception {
        List<BeanCaja> lista = null;

        try {
            String METHOD_NAME = "getCajasByPallet";
            lista = new ArrayList<BeanCaja>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));
            param.add(new parametro("pNroOV", pNroOV));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pCodArt", pCodArt));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanCaja caja = new BeanCaja();
                    caja.populate(soapObject);

                    if (!caja.getIsOk())
                        throw new Exception(caja.getMensaje());

                    lista.add(caja);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }

        return lista;
    }

    public List<BeanArticuloMovProy> getArticulosByOV(String pNroPallet, String pNroOV, String pAlmacen) throws Exception {
        List<BeanArticuloMovProy> lista = null;

        try {
            String METHOD_NAME = "getArticulosByOV";
            lista = new ArrayList<BeanArticuloMovProy>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroPallet", pNroPallet));
            param.add(new parametro("pNroOV", pNroOV));
            param.add(new parametro("pAlmacen", pAlmacen));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanArticuloMovProy row = new BeanArticuloMovProy();
                    row.populate(soapObject);

                    if (!row.getIsOk())
                        throw new Exception(row.getMensaje());

                    lista.add(row);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw  e;
        }finally{

        }

        return lista;
    }

    public boolean InsertarParteDespacho(String pOrigenDevice,
                                         String pDeviceID,
                                         String pFecDespacho,
                                         String pOrgAMP,
                                         Long pNroAMP,
                                         String pCodArt,
                                         String pAlmacen,
                                         String pNroOV,
                                         String pCodUsuario,
                                         String pListadoCU) throws Exception {

        StrRespuesta strRespuesta = null;
        List<parametro> param = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "InsertarParteDespacho";

            param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pOrigenDevice", pOrigenDevice));
            param.add(new parametro("pDeviceID", pDeviceID));
            param.add(new parametro("pFecDespacho", pFecDespacho));
            param.add(new parametro("pOrgAMP", pOrgAMP));
            param.add(new parametro("pNroAMP", pNroAMP));
            param.add(new parametro("pCodArt", pCodArt));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pNroOV", pNroOV));
            param.add(new parametro("pCodUsuario", pCodUsuario));
            param.add(new parametro("pListadoCU", pListadoCU));


            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this._nroVale = null;
                throw new Exception(strRespuesta.getMensaje());
            }

            //Me devuelve un nro de parte que lo coloco en la cabecera
            this.setNroVale(strRespuesta.getCadena());

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
            param = null;
        }
    }

    public boolean validarPallet(String pLectura) throws Exception {
        BeanPallet beanPallet = new BeanPallet();

        String METHOD_NAME = "validarPallet";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pLectura", pLectura));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        beanPallet.populate(soapObject);

        if(!beanPallet.getIsOk()){
            this._nroPallet = null;
            throw new Exception(beanPallet.getMensaje());
        }


        this._nroPallet = beanPallet.getNroPallet();
        return beanPallet.getIsOk();
    }

    public boolean validarLectura(String pLectura) throws Exception {
        BeanPallet beanPallet = new BeanPallet();

        String METHOD_NAME = "validarLectura";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pLectura", pLectura));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        beanPallet.populate(soapObject);

        if(!beanPallet.getIsOk()){
            this._nroPallet = "";
            this._codigoCU = "";
            this._palletOrCU = "";
            throw new Exception(beanPallet.getMensaje());
        }

        this._nroPallet = beanPallet.getNroPallet();
        this._codigoCU = beanPallet.getCodigoCU();
        this._palletOrCU = beanPallet.getPalletOrCU();

        return beanPallet.getIsOk();
    }

    public List<BeanCodigoCU> getCodigosCULectura(String pAlmacen,
                                                  String pNroVenta,
                                                  String pOrgAMP,
                                                  Long pNroAMP,
                                                  String pLectura) throws Exception {
        List<BeanCodigoCU> lista = null;

        try {
            String METHOD_NAME = "getCodigosCULectura";
            lista = new ArrayList<BeanCodigoCU>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pAlmacen", pAlmacen));
            param.add(new parametro("pNroVenta", pNroVenta));
            param.add(new parametro("pOrgAMP", pOrgAMP));
            param.add(new parametro("pNroAMP", pNroAMP));
            param.add(new parametro("pLectura", pLectura));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanCodigoCU row = new BeanCodigoCU();
                    row.populate(soapObject);

                    if (!row.getIsOk())
                        throw new Exception(row.getMensaje());

                    lista.add(row);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw  e;
        }finally{

        }

        return lista;
    }

    public List<BeanLecturas> getResumenLectura(String pCodUsuario,
                                                String pDeviceID,
                                                String pFecDespacho) throws Exception {
        List<BeanLecturas> lista = null;

        try {
            String METHOD_NAME = "getResumenLectura";
            lista = new ArrayList<BeanLecturas>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodUsuario", pCodUsuario));
            param.add(new parametro("pDeviceID", pDeviceID));
            param.add(new parametro("pFecDespacho", pFecDespacho));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanLecturas row = new BeanLecturas();
                    row.populate(soapObject);

                    if (!row.getIsOk())
                        throw new Exception(row.getMensaje());

                    lista.add(row);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw  e;
        }finally{

        }

        return lista;
    }
}
