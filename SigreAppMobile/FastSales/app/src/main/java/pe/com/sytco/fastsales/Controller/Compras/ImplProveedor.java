package pe.com.sytco.fastsales.Controller.Compras;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.ksoap2.serialization.SoapObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.Compras.ComprasProvClientesActivity;
import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.apiServices.RENIEC.ApiClient;
import pe.com.sytco.fastsales.apiServices.RENIEC.ApiReniecService;
import pe.com.sytco.fastsales.apiServices.RENIEC.PersonaResponse;
import pe.com.sytco.fastsales.beans.Compras.BeanProveedor;
import pe.com.sytco.fastsales.beans.RENIEC.BeanResponseRENIEC;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.data.RestAdapter;

public class ImplProveedor extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplProveedor?wsdl";


    private ImplProveedor()
    {

    }

    public ImplProveedor(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanProveedor> getProveedoresByFiltro(String pFiltro) throws Exception {
        List<BeanProveedor> lista = null;

        try {
            String METHOD_NAME = "getProveedoresByFiltro";
            lista = new ArrayList<BeanProveedor>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanProveedor beanProveedor = new BeanProveedor();
                    beanProveedor.populate(soapObject);

                    if (!beanProveedor.getIsOk())
                        throw new Exception(beanProveedor.getMensaje());

                    lista.add(beanProveedor);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }

    public boolean insertClient(BeanProveedor beanCliente) throws Exception {
        String METHOD_NAME = "insertClient";

        StrRespuesta strRespuesta = null;

        Gson gson = new GsonBuilder().create();
        String  jsonCliente = "";
        List<parametro> param = null;


        try {
            strRespuesta = new StrRespuesta();

            jsonCliente = gson.toJson(beanCliente);
            System.out.println("JSON de Cliente: " + jsonCliente);

            param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("jsonClient", jsonCliente));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }


            return strRespuesta.getIsOk();

        }catch (Exception e) {
            throw e;

        }finally{
            strRespuesta = null;
            param = null;
        }
    }

    public List<BeanProveedor> getClientesByFiltroAndUbigeo(String pFiltro, String pUbigeo, String pFlagBoletaFactura) throws Exception {
        List<BeanProveedor> lista = null;

        try {
            String METHOD_NAME = "getClientesByFiltroAndUbigeo";
            lista = new ArrayList<BeanProveedor>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pFiltro", pFiltro));
            param.add(new parametro("pUbigeo", pUbigeo));
            param.add(new parametro("pFlagBoletaFactura", pFlagBoletaFactura));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanProveedor beanProveedor = new BeanProveedor();
                    beanProveedor.populate(soapObject);

                    if (!beanProveedor.getIsOk())
                        throw new Exception(beanProveedor.getMensaje());

                    lista.add(beanProveedor);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;
    }

    public BeanProveedor buscarDNIReniec2(String pTipoDocIdent, String pNroDocIdent, String pUsuario) throws Exception {
        String jsonResult= null;
        String wsURL = "https://api.reniec.cloud/dni/" + pNroDocIdent;
        URL url = null;
        BeanProveedor beanProveedor = null;
        try {

            //url = new URL(wsURL);
            HttpURLConnection urlConnection = RestAdapter.connectSelfSignedHttps(context, wsURL);
                    //(HttpURLConnection) url.openConnection();

            //DEFINIR PARAMETROS DE CONEXION
            urlConnection.setReadTimeout(15000 /* milliseconds */);
            urlConnection.setConnectTimeout(15000 /* milliseconds */);
            urlConnection.setRequestMethod("GET");// se puede cambiar por delete ,put ,etc
            urlConnection.setDoInput(true);
            urlConnection.setDoOutput(true);



            int responseCode=urlConnection.getResponseCode();// conexion OK?
            if(responseCode== HttpURLConnection.HTTP_OK){
                BufferedReader in= new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));

                StringBuffer sb= new StringBuffer("");
                String linea="";
                while ((linea=in.readLine())!= null){
                    sb.append(linea.trim() + "\r\n");
                    //break;

                }
                in.close();
                jsonResult= sb.toString();

                //El resultado esta en formato JSON, lo debo convertir a objeto
                /*
                {
                    "dni": "73157439",
                        "cui": 7,
                        "apellido_paterno": "RAMIREZ",
                        "apellido_materno": "ARICA",
                        "nombres": "GIANFRANCO ALEXANDER"
                }
                 */
                Gson gson = new Gson();
                BeanResponseRENIEC beanResponseRENIEC = gson.fromJson(jsonResult, BeanResponseRENIEC.class);

                //Ahora lleno el beanProveedor
                beanProveedor = new BeanProveedor();
                beanProveedor.setIsOk(true);
                beanProveedor.setTipoDocIdentidad(pTipoDocIdent);
                beanProveedor.setNroDocIdentidad(pNroDocIdent);
                beanProveedor.setUsuario(pUsuario);
                beanProveedor.setApelPaterno(beanResponseRENIEC.getApellido_paterno());
                beanProveedor.setApelMaterno(beanResponseRENIEC.getApellido_materno());
                beanProveedor.setNombre1(beanResponseRENIEC.getNombre1());
                beanProveedor.setNombre2(beanResponseRENIEC.getNombre2());
                beanProveedor.setNomProveedor(beanResponseRENIEC.getFullNombre());

                return beanProveedor;

            }
            else{
                jsonResult= new String("Error: "+ responseCode);

                beanProveedor = new BeanProveedor();
                beanProveedor.setIsOk(false);
                beanProveedor.setMensaje(jsonResult);

                return beanProveedor;

            }


        } catch (MalformedURLException e) {
            e.printStackTrace();
            throw  e;
        } catch (IOException e) {
            e.printStackTrace();
            throw  e;
        } catch (Exception e) {
            e.printStackTrace();
            throw  e;
        }

    }

    public BeanProveedor buscarDNIReniec(String pTipoDocIdent, String pNroDocIdent, String pUsuario) throws Exception {
        String baseURL = "https://api.reniec.cloud/";
        BeanProveedor beanProveedor = null;
        PersonaResponse personaResponse = null;
        ApiClient apiClient = null;
        try {

            apiClient = new ApiClient(baseURL);
            personaResponse = apiClient.Busqueda(pNroDocIdent);

            //Ahora lleno el beanProveedor
            beanProveedor = new BeanProveedor();
            beanProveedor.setIsOk(true);
            beanProveedor.setTipoDocIdentidad(pTipoDocIdent);
            beanProveedor.setNroDocIdentidad(pNroDocIdent);
            beanProveedor.setUsuario(pUsuario);
            beanProveedor.setApelPaterno(personaResponse.getApellidoPaterno());
            beanProveedor.setApelMaterno(personaResponse.getApellidoMaterno());
            beanProveedor.setNombre1(personaResponse.getNombre1());
            beanProveedor.setNombre2(personaResponse.getNombre2());
            beanProveedor.setNomProveedor(personaResponse.getFullNombre());

            return beanProveedor;

        } catch (Exception e) {
            e.printStackTrace();
            throw  e;
        } finally {
            beanProveedor = null;
            personaResponse = null;
            apiClient = null;

            System.gc();
        }

    }

    public boolean isEnrolling(String pTipoDocIdent, String pNroDocIdent) throws Exception {
        BeanProveedor beanCliente = null;

        try {
            String METHOD_NAME = "isEnrolling";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pTipoDocIdent", pTipoDocIdent));
            param.add(new parametro("pNroDocIdent", pNroDocIdent));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanCliente = new BeanProveedor();
            beanCliente.populate(soapObject);

            if (!beanCliente.getIsOk())
                throw new Exception(beanCliente.getMensaje());

            if (beanCliente.getIntReturn() > 0){
                return true;
            }else{
                return false;
            }


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanCliente = null;
        }
    }

    public BeanProveedor getProveedorbyNroDoc(String pTipoDocIdent, String pNroDocIdent) throws Exception {
        BeanProveedor beanCliente = null;

        try {
            String METHOD_NAME = "getProveedorbyNroDoc";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pTipoDocIdent", pTipoDocIdent));
            param.add(new parametro("pNroDocIdent", pNroDocIdent));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanCliente = new BeanProveedor();
            beanCliente.populate(soapObject);

            return beanCliente;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanCliente = null;
        }
    }

    public BeanProveedor getOne(String pCodCliente) throws Exception {
        BeanProveedor beanCliente = null;

        try {
            System.out.println(ImplProveedor.class + ".getOne() START");

            String METHOD_NAME = "getOne";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCodCliente", pCodCliente));

            System.out.println(ImplProveedor.class + ".getOne() --> Llamada a SOAPCLient (START)" );
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            System.out.println(ImplProveedor.class + ".getOne() --> Llamada a SOAPCLient (END)" );

            beanCliente = new BeanProveedor();
            beanCliente.populate(soapObject);

            return beanCliente;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanCliente = null;
            System.out.println(ImplProveedor.class + ".getOne() END");
        }
    }

    public BeanProveedor buscarRucSUNAT(String pRUC, String pUsuario) throws Exception {
        BeanProveedor beanCliente = null;

        try {
            String METHOD_NAME = "buscarRucSUNAT";
            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pRUC", pRUC));
            param.add(new parametro("pUsuario", pUsuario));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanCliente = new BeanProveedor();
            beanCliente.populate(soapObject);

            if (!beanCliente.getIsOk())
                throw new Exception(beanCliente.getMensaje());

            return beanCliente;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{
            beanCliente = null;
        }
    }
}
