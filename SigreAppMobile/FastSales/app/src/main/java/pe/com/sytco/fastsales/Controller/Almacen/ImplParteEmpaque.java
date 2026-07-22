package pe.com.sytco.fastsales.Controller.Almacen;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplParteEmpaque extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplParteEmpaque?wsdl";
    private String _nroPallet;

    private ImplParteEmpaque()
    {

    }

    public ImplParteEmpaque(String empresa){
        this.empresaDefault = empresa;
    }

    public Boolean validarPallet(String pLectura) throws Exception {

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
        return _nroPallet;
    }

    public List<BeanCaja> getCajasByPallet(String pNroPallet) throws Exception {

        List<BeanCaja> lista = new ArrayList<BeanCaja>();

        String METHOD_NAME = "getCajasByPallet";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pNroPallet", pNroPallet));

        List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
        int length = lsObjects.size();

        for(int i=0; i<length; i ++){
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
            BeanCaja caja = new BeanCaja();
            caja.populate(soapObject);
            lista.add(caja);
        }

        return lista;
    }

    public List<BeanAlmacen> getAlmacenesOrigenPallet(String strNroPallet) {

        List<BeanAlmacen> lista = null;

        try {
            String METHOD_NAME = "getAlmacenesOrigenPallet";
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
