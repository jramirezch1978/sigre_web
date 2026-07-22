package pe.com.sytco.fastsales.Services;

import android.provider.Settings;
import android.util.Log;

import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.adapter.MarshalDouble;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.beans.parametro;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.SoapFault;
import pe.com.sytco.fastsales.adapter.MarshalDate;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by jramirez on 01/10/2015.
 */
public class SOAPClient {
    public static BeanServerRemote serverDefault;
    public static String NAMESPACE = "http://SigreWebService/";
    private Integer TIMEOUT = 90000;  //Milisegundos
    //public static String Server_TEST ="http://sigre.serveftp.com:9090/"; //SERVER PEGAZUS "http://181.177.245.35:9090/"; //WSCIPLimaServer/ImplMenu?wsdl";
    //public static String Server_PROD ="http://190.117.115.148:8080/"; // CROMOPLASTIC "http://181.177.245.35:9090/"; //WSCIPLimaServer/ImplMenu?wsdl";
    //public static String ServerLocal_PROD ="http://192.168.0.170:8080/"; // CROMOPLASTIC "http://181.177.245.35:9090/"; //WSCIPLimaServer/ImplMenu?wsdl";
    //public static String IPServerPROD = "190.117.204.92";
    //public static String IPLocalPROD = "192.168.0.170";
    String URL = "";

    public Object Connect(String pPostFijoURL, String METHOD_NAME) throws Exception {

        //Elijo el server de acuerdo al tipo de ambiente
        this.CreateURLEnvironment(pPostFijoURL);

        //Coloco el nombre del metodo a llamar
        String SOAP_ACTION = NAMESPACE + METHOD_NAME; //"http://javaWSSaample/sayHello";

        SoapObject rpc;
        rpc = new SoapObject(NAMESPACE, METHOD_NAME);

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.bodyOut = rpc;

        envelope.dotNet = false;
        envelope.encodingStyle = SoapSerializationEnvelope.XSD;

        HttpTransportSE androidHttpTransport= null;
        try {
            androidHttpTransport = new HttpTransportSE(URL, TIMEOUT);
            androidHttpTransport.debug = true;

            androidHttpTransport.call(SOAP_ACTION, envelope);

            //Respuesta del Servicio web
            return envelope.getResponse();

        }catch (SocketTimeoutException e1){

                throw new Exception("Se ha sobrepasado el tiempo de Conexion, revise su conexión a la RED");

        }catch (Exception e){
            e.printStackTrace();
            throw e;
            //res=e.getMessage();
        }

    }

    private void CreateURLEnvironment(String pPostFijoURL) throws Exception {
        if (GlobalClass.CHOISE_ENVIROMENT == GlobalClass.ENVIROMENT_LOCAL){
            URL = this.getURLFromServer() + pPostFijoURL;
        }else if (GlobalClass.CHOISE_ENVIROMENT == GlobalClass.ENVIROMENT_PROD){
            URL = this.getURLFromServer() + pPostFijoURL;
        }else{
            URL = this.getURLFromServer() + pPostFijoURL;
        }

        System.out.println("URL: " + URL);
        System.out.println("=================================");

    }

    public String getURLFromServer() throws Exception {
        String lsURL;

        if (SOAPClient.serverDefault == null)
            throw new Exception("Error en SOAPClient.getURLFromServer. No se ha espeficicado un servidor por defecto.");

        lsURL = SOAPClient.serverDefault.getProtocolo() + "://" + SOAPClient.serverDefault.getHostIP() + ":" + SOAPClient.serverDefault.getPort() + "/";

        return lsURL;
    }

    public Object Connect(String pPostFijoURL, String METHOD_NAME, List<parametro> param) throws Exception {
        //Elijo el server de acuerdo al tipo de ambiente
        this.CreateURLEnvironment(pPostFijoURL);

        //Elijo el Metodo a llamar
        String SOAP_ACTION = NAMESPACE + METHOD_NAME; //"http://javaWSSaample/sayHello";

        SoapObject rpc;
        rpc = new SoapObject(NAMESPACE, METHOD_NAME);

        for(parametro p : param){
            PropertyInfo pi = new PropertyInfo();

            pi.name= p.getNombre(); // name of the parameter in your dotnet variable
            pi.type = p.getValue().getClass();
            pi.setValue(p.getValue());

            rpc.addProperty(pi);
        }

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.setOutputSoapObject(rpc);
        envelope.implicitTypes = true;
        envelope.setAddAdornments(false);

        envelope.bodyOut = rpc;

        envelope.dotNet = false;

        //Parser para las fechas
        MarshalDate md = new MarshalDate();
        md.register(envelope);

        //Parser para los Double
        MarshalDouble marshaldDouble = new MarshalDouble();
        marshaldDouble.register(envelope);



        envelope.encodingStyle = SoapSerializationEnvelope.XSD;

        HttpTransportSE androidHttpTransport= null;
        try {
            androidHttpTransport = new HttpTransportSE(URL, TIMEOUT);
            androidHttpTransport.debug = true;

            androidHttpTransport.call(SOAP_ACTION, envelope);

            Log.d("Aviso", "requestdump: " + androidHttpTransport.requestDump);

            //Respuesta del Servicio web
            //if (((SoapObject)envelope.bodyIn).getPropertyCount() == 1)
            //    return
            return envelope.getResponse();

        }catch (SocketTimeoutException e1){

            throw new Exception("Se ha sobrepasado el tiempo de Conexion, revise su conexión a la RED");

        }catch (Exception e){
            e.printStackTrace();
            throw e;
            //res=e.getMessage();
        }


    }

    public Object ConnectWithPropInfo(String pPostFijoURL, String METHOD_NAME, List<PropertyInfo> param) throws Exception {
        //Elijo el server de acuerdo al tipo de ambiente
        this.CreateURLEnvironment(pPostFijoURL);

        String SOAP_ACTION = NAMESPACE + METHOD_NAME; //"http://javaWSSaample/sayHello";

        SoapObject rpc;
        rpc = new SoapObject(NAMESPACE, METHOD_NAME);

        for(PropertyInfo p : param){
            rpc.addProperty(p);
        }

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.bodyOut = rpc;

        envelope.dotNet = false;

        //Parser para las fechas
        MarshalDate md = new MarshalDate();
        md.register(envelope);
        //Parser para los Double
        MarshalDouble marshaldDouble = new MarshalDouble();
        marshaldDouble.register(envelope);

        envelope.setOutputSoapObject(rpc);

        envelope.encodingStyle = SoapSerializationEnvelope.XSD;

        HttpTransportSE androidHttpTransport= null;
        try {
            androidHttpTransport = new HttpTransportSE(URL, TIMEOUT);
            androidHttpTransport.debug = true;

            androidHttpTransport.call(SOAP_ACTION, envelope);

            Log.d("Aviso", "requestdump: " + androidHttpTransport.requestDump);

            //Respuesta del Servicio web
            //if (((SoapObject)envelope.bodyIn).getPropertyCount() == 1)
            //    return
            return envelope.getResponse();

        }catch (SocketTimeoutException e1){

            throw new Exception("Se ha sobrepasado el tiempo de Conexion, revise su conexión a la RED");

        }catch (Exception e){
            e.printStackTrace();
            throw e;
            //res=e.getMessage();
        }


    }

    public List<Object> ConnectReturnList(String pPostFijoURL, String METHOD_NAME, List<parametro> param) throws Exception {

        try {
            //Elijo el server de acuerdo al tipo de ambiente
            this.CreateURLEnvironment(pPostFijoURL);

            String SOAP_ACTION = NAMESPACE + METHOD_NAME; //"http://javaWSSaample/sayHello";

            SoapObject rpc;
            rpc = new SoapObject(NAMESPACE, METHOD_NAME);

            for(parametro p : param){
                rpc.addProperty(p.getNombre(), p.getValue());
            }

            SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
            envelope.bodyOut = rpc;

            envelope.dotNet = false;
            envelope.encodingStyle = SoapSerializationEnvelope.XSD;

            HttpTransportSE androidHttpTransport= null;

            androidHttpTransport = new HttpTransportSE(URL, TIMEOUT);
            androidHttpTransport.debug = true;

            androidHttpTransport.call(SOAP_ACTION, envelope);

            //En caso que haya una falla
            if (envelope.bodyIn instanceof SoapFault){
                System.out.println(envelope.bodyIn);
                SoapFault fault = (SoapFault)envelope.bodyIn;
                throw new Exception("Error en metodo SOAPClient.ConnectReturnList. " + fault.getMessage());

            }else if(envelope.bodyIn instanceof SoapObject) {

                //Respuesta del Servicio web
                if (((SoapObject) envelope.bodyIn).getPropertyCount() == 1) {
                    List<Object> lista = new ArrayList<Object>();
                    lista.add(((SoapObject) envelope.bodyIn).getProperty(0));
                    return lista;
                } else {
                    return (List<Object>) envelope.getResponse();
                }
            }

            return new ArrayList<Object>();

        }catch (SocketException e2){

            throw new Exception("La conexion al Servidor de Servicios Web se ha reinciado, por favor verifique!");

        }catch (SocketTimeoutException e1){

            throw new Exception("Se ha sobrepasado el tiempo de Conexion, revise su conexión a la RED");

        }catch (Exception e){
            e.printStackTrace();
            throw e;
            //res=e.getMessage();
        }


    }

    public List<Object> ConnectReturnList(String pPostFijoURL, String METHOD_NAME) throws Exception {
        try {

            //Elijo el server de acuerdo al tipo de ambiente
            this.CreateURLEnvironment(pPostFijoURL);

            String SOAP_ACTION = NAMESPACE + METHOD_NAME; //"http://javaWSSaample/sayHello";

            SoapObject rpc;
            rpc = new SoapObject(NAMESPACE, METHOD_NAME);

            SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
            envelope.bodyOut = rpc;

            envelope.dotNet = false;
            envelope.encodingStyle = SoapSerializationEnvelope.XSD;

            HttpTransportSE androidHttpTransport= null;

            androidHttpTransport = new HttpTransportSE(URL, TIMEOUT);
            androidHttpTransport.debug = true;

            androidHttpTransport.call(SOAP_ACTION, envelope);

            if (envelope.bodyIn instanceof SoapFault){
                System.out.println(envelope.bodyIn);
                SoapFault fault = (SoapFault)envelope.bodyIn;
                throw new Exception("Error en metodo SOAPClient.ConnectReturnList. " + fault.getMessage());

            }else if(envelope.bodyIn instanceof SoapObject) {
                //Respuesta del Servicio web
                if (((SoapObject) envelope.bodyIn).getPropertyCount() == 1) {
                    List<Object> lista = new ArrayList<Object>();
                    lista.add(((SoapObject) envelope.bodyIn).getProperty(0));
                    return lista;
                } else {
                    return (List<Object>) envelope.getResponse();
                }
            }

            return new ArrayList<Object>();

        }catch (SocketTimeoutException e1) {

            throw new Exception("Se ha sobrepasado el tiempo de Conexion, revise su conexión a la RED");
        } catch (Exception e){
            e.printStackTrace();
            throw e;
            //res=e.getMessage();
        }


    }

}
