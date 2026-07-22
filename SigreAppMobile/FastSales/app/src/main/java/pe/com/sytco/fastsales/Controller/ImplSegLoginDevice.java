package pe.com.sytco.fastsales.Controller;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import androidx.core.app.ActivityCompat;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanAndroidDevice;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.util.LogHelper;

public class ImplSegLoginDevice extends ImplAncestor {
    public static BeanAndroidDevice currentDevice = null;

    private String WSDL = "SigreWebService/ImplSegLoginDevice?wsdl";

    private ImplSegLoginDevice() {

    }

    public ImplSegLoginDevice(String empresa) {
        this.empresaDefault = empresa;
    }


    public StrRespuesta registraDevice(Context context) throws Exception {
        return registraDevice(context, null);
    }

    public StrRespuesta registraDevice(Context context, ProgressCallback progressCallback) throws Exception {
        long startTime = LogHelper.getTimestampMillis();
        LogHelper.i("ImplSegLoginDevice", "====================================");
        LogHelper.logMethodStart("ImplSegLoginDevice", "registraDevice - INICIO");
        
        StrRespuesta strRespuesta = new StrRespuesta();
        BeanAndroidDevice device = new BeanAndroidDevice();
        BeanUsuario userLogin = null;

        try {

            //Obtengo el ID
            if (progressCallback != null) progressCallback.onProgressUpdate("Obteniendo ID del dispositivo...");
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Obteniendo Android ID", startTime);
            device.setDeviceID(Settings.Secure.getString(context.getApplicationContext().getContentResolver(), Settings.Secure.ANDROID_ID));
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Android ID obtenido: " + device.getDeviceID(), startTime);

            //Obtengo el Device Name
            if (progressCallback != null) progressCallback.onProgressUpdate("Leyendo información del fabricante...");
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Obteniendo información de fabricante y modelo", startTime);
            device.setManufacturer(android.os.Build.MANUFACTURER);
            device.setModel(android.os.Build.MODEL);
            device.setDeviceName(android.os.Build.MANUFACTURER + " " + android.os.Build.MODEL);
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Fabricante: " + device.getManufacturer() + ", Modelo: " + device.getModel(), startTime);

            //Obtengo el IMEI
            if (progressCallback != null) progressCallback.onProgressUpdate("Verificando permisos del teléfono...");
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Obteniendo TelephonyManager", startTime);
            TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            LogHelper.logCheckpoint("ImplSegLoginDevice", "TelephonyManager obtenido", startTime);
            
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Verificando permisos READ_PHONE_STATE", startTime);
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                LogHelper.e("ImplSegLoginDevice", "No hay permisos para leer datos del dispositivo");
                throw new Exception("El software no tiene acceso para poder leer datos del Dispositivo, por favor verifique!");
                //return false;
            }
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Permisos verificados correctamente", startTime);
            
            //Software
            if (progressCallback != null) progressCallback.onProgressUpdate("Obteniendo versión de software...");
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Obteniendo versión de software", startTime);
            device.setSoftware(telephonyManager.getDeviceSoftwareVersion());
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Versión de software: " + device.getSoftware(), startTime);

            device.setIMEI("12345"); //telephonyManager.getDeviceId());

            if(device.getIMEI() == null)
                device.setIMEI("SIN IMEI. Version Software: " + device.getSoftware());

            if (device.getIMEI() == null)
                device.setIMEI("DESCONOCIDO");
            
            LogHelper.logCheckpoint("ImplSegLoginDevice", "IMEI configurado: " + device.getIMEI(), startTime);

            //Indico el origen
            //Obtengo el usuario
            if (progressCallback != null) progressCallback.onProgressUpdate("Obteniendo información de usuario...");
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Obteniendo GlobalClass y usuario", startTime);
            final GlobalClass globalVariable = (GlobalClass) context.getApplicationContext();
            userLogin = globalVariable.getUserLogin();
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Usuario obtenido: " + (userLogin != null ? userLogin.getUsuario() : "null"), startTime);

            if (userLogin == null || userLogin.getOrigenAlt() == null)
                device.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
            else
                device.setCodOrigen(userLogin.getOrigenAlt());
            
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Código de origen: " + device.getCodOrigen(), startTime);

            //Invoco al WebServices
            if (progressCallback != null) progressCallback.onProgressUpdate("Conectando con el servidor...");
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Preparando llamada al WebService", startTime);
            String METHOD_NAME = "registraDevice";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pDevice", device));
            
            LogHelper.logCheckpoint("ImplSegLoginDevice", "Llamando al WebService registraDevice", startTime);
            long wsStartTime = LogHelper.getTimestampMillis();

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            LogHelper.logCheckpoint("ImplSegLoginDevice", "WebService retornó respuesta", startTime);
            LogHelper.i("ImplSegLoginDevice", "Tiempo de WebService: " + (LogHelper.getTimestampMillis() - wsStartTime) + "ms");

            if (progressCallback != null) progressCallback.onProgressUpdate("Procesando respuesta del servidor...");
            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                LogHelper.e("ImplSegLoginDevice", "Error en respuesta: " + strRespuesta.getMensaje());
                throw new Exception(strRespuesta.getMensaje());
            }

            device.setNroParte(strRespuesta.getCadena());
            strRespuesta.setCadena2(device.getDeviceID());

            //Guardo el device en la ruta correcta
            //ImplSegLoginDevice.currentDevice = device;

            LogHelper.logMethodEnd("ImplSegLoginDevice", "registraDevice - OK, NroParte: " + device.getNroParte(), startTime);
            LogHelper.i("ImplSegLoginDevice", "====================================");

            return strRespuesta;


        }catch (Exception e) {

            LogHelper.e("ImplSegLoginDevice", "Error en registraDevice", e);
            LogHelper.logMethodEnd("ImplSegLoginDevice", "registraDevice - ERROR", startTime);
            LogHelper.i("ImplSegLoginDevice", "====================================");
            e.printStackTrace();
            throw e;

        }finally{
            strRespuesta = null;
        }
    }

    public boolean registerLogin(String pNroRegistro,
                                 String pCodUsuario) throws Exception {
        long startTime = LogHelper.getTimestampMillis();
        LogHelper.i("ImplSegLoginDevice", "====================================");
        LogHelper.logMethodStart("ImplSegLoginDevice", "registerLogin");
        LogHelper.i("ImplSegLoginDevice", "NroRegistro: " + pNroRegistro + ", Usuario: " + pCodUsuario);
        
        StrRespuesta strRespuesta = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "registerLogin";

            LogHelper.logCheckpoint("ImplSegLoginDevice", "Preparando parámetros para WS", startTime);
            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroRegistro", pNroRegistro));
            param.add(new parametro("pCodUsuario", pCodUsuario));

            LogHelper.logCheckpoint("ImplSegLoginDevice", "Llamando al WebService registerLogin", startTime);
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            LogHelper.logCheckpoint("ImplSegLoginDevice", "WebService retornó, procesando respuesta", startTime);
            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                LogHelper.e("ImplSegLoginDevice", "Error en registerLogin: " + strRespuesta.getMensaje());
                throw new Exception(strRespuesta.getMensaje());
            }

            LogHelper.logMethodEnd("ImplSegLoginDevice", "registerLogin - OK", startTime);
            LogHelper.i("ImplSegLoginDevice", "====================================");
            return strRespuesta.getIsOk();

        }catch (Exception e) {
            LogHelper.e("ImplSegLoginDevice", "Error en registerLogin", e);
            LogHelper.logMethodEnd("ImplSegLoginDevice", "registerLogin - ERROR", startTime);
            throw e;
        }finally{

        }
    }

    public boolean registerLogout(String pNroRegistro) throws Exception {
        StrRespuesta strRespuesta = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "registerLogout";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroRegistro", pNroRegistro));

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

        }
    }

    public BeanAndroidDevice getDevice(String pDeviceID) throws Exception {
        BeanAndroidDevice beanDevice = null;

        try {
            beanDevice = new BeanAndroidDevice();

            String METHOD_NAME = "getDevice";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pDeviceID", pDeviceID));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanDevice.populate(soapObject);

            if(!beanDevice.getIsOk()){
                throw new Exception(beanDevice.getMensaje());
            }

            return beanDevice;

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{

        }
    }
}
