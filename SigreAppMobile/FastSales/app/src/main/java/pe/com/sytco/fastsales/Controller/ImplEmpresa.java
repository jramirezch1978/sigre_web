package pe.com.sytco.fastsales.Controller;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.LoginActivity;
import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.Finanzas.ImplTasaCambio;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.adapter.ListViewEmpresasAdapter;
import pe.com.sytco.fastsales.beans.BeanEmpresa;
import pe.com.sytco.fastsales.beans.BeanEntorno;
import pe.com.sytco.fastsales.beans.BeanParametros;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.SettingPreferences;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 07/11/2017.
 */
public class ImplEmpresa extends ImplAncestor {


    private String WSDL = "SigreWebService/ImplEmpresa?wsdl";

    //Variables estaticas
    private static String KEY_EMPRESA_DEFAULT = "EMPRESA_DEFAULT";
    public static Integer ACTION_LISTAR_EMPRESA = 1;
    private static Integer ACTION_VALIDAR_EMPRESA = 2;
    public static Integer ACTION_CARGAR_LOGO = 3;
    public static BeanEmpresa empresaDefault = null;

    //Variables privadas
    private List<BeanEmpresa> _empresas;
    private SettingPreferences pref;

    //Controles
    private ListView lvListEmpresas;
    private TextView tvNroEmpresas;
    private ImplEntorno implEntorno;

    //Parametros Generales
    public static BeanParametros beanParametros = null;

    //Constructores
    private ImplEmpresa()
    {

    }

    public ImplEmpresa(Context value){
        this.context = value;
        pref = new SettingPreferences(value);
        implEntorno = new ImplEntorno(context);
    }

    public List<BeanEmpresa> getEmpresas() throws Exception {

        List<BeanEmpresa> lista = null;

        try {
            String METHOD_NAME = "getEmpresas";
            lista = new ArrayList<BeanEmpresa>();

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME);

            if(lsObjects != null) {
                int length = lsObjects.size();
                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanEmpresa empresa = new BeanEmpresa();
                    empresa.populate(soapObject);
                    lista.add(empresa);
                }
            }


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }

        return lista;

    }

    public String getParametro(String parametro, String defaultValue)  throws Exception {

        StrRespuesta strRespuesta = null;

        try {
            String METHOD_NAME = "getParametroWSDL";
            strRespuesta = new StrRespuesta();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault.getCodigo()));
            param.add(new parametro("parametro", parametro));
            param.add(new parametro("defaultValue", defaultValue));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }


            return strRespuesta.getCadena();

        }catch (Exception e) {
            throw e;

        }finally{
            strRespuesta = null;
        }


    }

    public BeanParametros getFullParametros()  throws Exception {

        BeanParametros beanParametros = null;

        try {
            String METHOD_NAME = "getFullParametros";
            beanParametros = new BeanParametros();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault.getCodigo()));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanParametros.populate(soapObject);

            if(!beanParametros.getIsOk()){
                throw new Exception(beanParametros.getMensaje());
            }


            return beanParametros;

        }catch (Exception e) {
            throw e;

        }finally{
            beanParametros = null;
        }


    }

    private void createDialogSelectEmpresa() {
        View layoutLocal;
        Button btnCancelar;

        //Valido si hay empresas para mostrar
        if (_empresas.size() == 0){
            MessageBox.AlertDialog("No hay empresas para seleccionar en el servidor " + SOAPClient.serverDefault.getNombre(), "Error al cargar empresas", context);
            return;
        }

        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);
        LayoutInflater inflater = ((Activity) context).getLayoutInflater();

        layoutLocal = inflater.inflate(R.layout.dialog_select_empresa, null);

        builderLocal.setView(layoutLocal);

        //Obtengo referencia a los Botones
        lvListEmpresas = (ListView) layoutLocal.findViewById(R.id.lvListEmpresas);
        btnCancelar = (Button) layoutLocal.findViewById(R.id.btnCancelar);
        tvNroEmpresas = (TextView)layoutLocal.findViewById(R.id.tvNroEmpresas);

        //Listo las empresas
        showEmpresasInListView(lvListEmpresas);

        //Programo los Click de los botones
        builderLocal.setCancelable(false);

        final AlertDialog dialogLocal = builderLocal.create();

        //Evento Click del ListView
        lvListEmpresas.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                try {
                    BeanEmpresa empresa = _empresas.get(position);

                    ImplEmpresa.empresaDefault = empresa;
                    saveEmpresaToPreferences(empresa);
                    implEntorno.ApplyEntorno(new BeanEntorno(empresa.getCodigo()));

                    if (context instanceof  LoginActivity){
                        ((LoginActivity)context).getBtnEmpresaDefault().setText(empresa.getCodigo());
                        ((LoginActivity)context).getBtnEmpresaDefault().setEnabled(true);
                        ((LoginActivity)context).RegistrarDevice();
                    }

                    dialogLocal.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Error al seleccionar empresa. Exception: " + ex.getMessage(), "Error en lvListEmpresas.OnItemClickListener", context);
                }
            }
        });

        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        confirmarCierre(dialogLocal);

                    }
                }
        );

        dialogLocal.show();

    }

    private void confirmarCierre(final AlertDialog dialogLocal) {

        //Si no se ha confirmado la empresa por Defecto entonces le pregunto al usuario si desea cerrar
        //el cuadro de dialogo
        if (ImplEmpresa.empresaDefault == null) {

            AlertDialog.Builder builder = new AlertDialog.Builder(context);

            builder.setMessage("No se ha especificado ninguna empresa por defecto. ¿Desea salir de todas maneras?");
            builder.setTitle("Confirmacion");
            builder.setCancelable(false);

            builder.setPositiveButton("SI", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    dialogLocal.dismiss();
                    dialog.cancel();
                }
            });
            builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    dialog.cancel();
                }
            });

            builder.create();
            builder.show();

        }else{
            dialogLocal.dismiss();
        }
    }


    public void showEmpresasInListView(ListView lvListEmpresas) {
        ArrayAdapter adaptador;
        //Indico el adaptador para el listado de Servidores
        adaptador = new ListViewEmpresasAdapter(context, _empresas);
        lvListEmpresas.setAdapter(adaptador);

        tvNroEmpresas.setText(UTIL.ConvetToString(_empresas.size(), "###,##0"));

        //Le pongo el foco a la lista de Servidores
        lvListEmpresas.requestFocus();

    }

    public void listarEmpresa() {
        new ListarEmpresaTask(context).execute(ImplEmpresa.ACTION_LISTAR_EMPRESA);
    }

    public BeanEmpresa loadEmpresaFromPreferences() throws Exception {

        String json;
        BeanServerRemote server = SOAPClient.serverDefault;

        if (server == null)
            throw new Exception("No se ha especificado un servidor por defecto, por favor corrija.");

        json = pref.loadFromPreferences(server.getNombre().trim() + "_" + ImplEmpresa.KEY_EMPRESA_DEFAULT);

        if(json != null){
            //Convierte JSONArray a Lista de Objetos!
            BeanEmpresa empresa = new Gson().fromJson(json, BeanEmpresa.class);

            return empresa;
        }

        return null;
    }

    public void saveEmpresaToPreferences(BeanEmpresa empresa) throws Exception {

        String json;
        BeanServerRemote server = SOAPClient.serverDefault;

        if (server == null)
            throw new Exception("No se ha especificado un servidor por defecto, por favor corrija.");

        json = new Gson().toJson(empresa);

        pref.saveToPreferences(server.getNombre().trim() + "_" + ImplEmpresa.KEY_EMPRESA_DEFAULT, json);
    }

    private void LoadParametros() {
        new LoadParametrosTask().execute();
    }

    public void ValidarEmpresa(BeanEmpresa bean) {
        new ListarEmpresaTask(bean, context).execute(ImplEmpresa.ACTION_VALIDAR_EMPRESA);
    }

    private void postTaskValidarEmpresa(BeanEmpresa empresa) throws Exception {
        boolean lbExiste = false;

        if (context instanceof LoginActivity){
            ((LoginActivity)context).getBtnEmpresaDefault().setEnabled(true);
        }

        if (_empresas == null || _empresas.size() == 0) {
            if (context instanceof LoginActivity){
                ((LoginActivity)context).getBtnEmpresaDefault().setText("");
            }

            throw new Exception("El servidor remoto " + SOAPClient.serverDefault.getNombre() + " no tiene definido ninguna empresa,"
                    + " por favor cooordine con el administrador");
        }

        for (BeanEmpresa obj: _empresas) {
            if(obj.getCodigo().toUpperCase().equals(empresa.getCodigo().toUpperCase())){
                ImplEmpresa.empresaDefault = obj;
                empresa = obj;
                lbExiste = true;
                break;
            }
        }

        if (lbExiste){
            ImplEmpresa.empresaDefault = empresa;

            implEntorno.ApplyEntorno(new BeanEntorno(empresa.getCodigo()));

            LoadParametros();

            if (context instanceof LoginActivity){
                ((LoginActivity)context).getBtnEmpresaDefault().setText(empresa.getCodigo());
                ((LoginActivity)context).RegistrarDevice();
            }

        }else{
            ImplEmpresa.empresaDefault = null;
            if (context instanceof LoginActivity){
                ((LoginActivity)context).getBtnEmpresaDefault().setText("");
            }

            listarEmpresa();
        }
    }

    //Clase Asincrona para cargar los datos iniciales, como el IGV y el ICBPER
    private class LoadParametrosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        private ProgressDialog pDialog;
        private ImplEmpresa implEmpresa;
        private ImplTasaCambio implTasaCambio;
        private LoadParametrosTask()
        {

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Un momento, cargando parametros iniciales, por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {

            try {

                //Creo los objetos
                implEmpresa = new ImplEmpresa(context);
                implTasaCambio = new ImplTasaCambio(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo los parametros
                ImplEmpresa.beanParametros = implEmpresa.getFullParametros();

                if (!ImplEmpresa.beanParametros.getIsOk()){
                    mensaje = ImplEmpresa.beanParametros.getMensaje();
                    return false;
                }

                return true;

            } catch (Exception ex) {
                ex.printStackTrace();
                mensaje = "Ha ocurrido una exception al recuperar datos necesarios. Error: " + ex.getMessage();
                return false;

            } finally {
                implEmpresa = null;
                implTasaCambio = null;
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                // dismiss the dialog after getting all products
                if (pDialog != null && pDialog.isShowing()) {
                    //get the Context object that was used to great the dialog
                    Context context = ((ContextWrapper)pDialog.getContext()).getBaseContext();

                    //if the Context used here was an activity AND it hasn't been finished or destroyed
                    //then dismiss it
                    if(context instanceof Activity) {
                        // Api >=17
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                            if (!((Activity) context).isFinishing() && !((Activity) context).isDestroyed()) {
                                pDialog.dismiss();
                            }
                        } else {

                            // Api < 17. Unfortunately cannot check for isDestroyed()
                            if (!((Activity) context).isFinishing()) {
                                pDialog.dismiss();
                            }
                        }
                    } else //if the Context used wasnt an Activity, then dismiss it too
                        pDialog.dismiss();

                }

                if (!result) {
                    MessageBox.AlertDialog(context, "Error en LoadTask()", mensaje, false);
                }


            } catch (Exception ex) {
                ex.printStackTrace();

            } finally {
                pDialog = null;
            }

        }

    }

    //Esta Clase permite seleccionar la empresa por defecto
    private class ListarEmpresaTask extends AsyncTask<Integer, Void, Boolean> {

        private Context context;
        private String mensaje;
        private ProgressDialog pDialog;
        private BeanEmpresa _empresa;
        private Integer liAction;

        public ListarEmpresaTask(Context value){
            context = value;
        }

        public ListarEmpresaTask(BeanEmpresa empresa, Context value){
            this._empresa = empresa;
            this.context = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Obteniendo la lista de empresas. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //Guardo la action enviada como parametro
                liAction = params[0];

                //Obtengo el linea
                _empresas = getEmpresas();

                return true;

            }catch (Exception ex){
                String exceptionType = ex.getClass().getName(); // Obtiene el nombre de la clase de la excepción
                mensaje = "Error del tipo " + exceptionType + ", al recuperar listado de Empresas en "
                        + SOAPClient.serverDefault.getNombre() + ". Mensaje: " + ex.getMessage();

                ex.printStackTrace();
                return false;
            }finally{

            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (!result) {

                    //Deshabilito el boton de empresa pore defecto
                    if (context instanceof LoginActivity){
                        ((LoginActivity)context).getBtnEmpresaDefault().setText("");
                        ((LoginActivity)context).getBtnEmpresaDefault().setEnabled(false);
                    }

                    MessageBox.AlertDialog(mensaje, "Error", context);

                }else {

                    if (liAction == ImplEmpresa.ACTION_LISTAR_EMPRESA) {
                        createDialogSelectEmpresa();
                    }else if(liAction == ImplEmpresa.ACTION_VALIDAR_EMPRESA){
                        postTaskValidarEmpresa(_empresa);
                    }

                }

            }catch(Exception ex){
                ex.printStackTrace();
            }finally {
                // Quito el dialogo despues de verificar la conexión con el servidor
                if ((pDialog != null) && pDialog.isShowing()) {
                    try {
                        pDialog.dismiss();
                    }catch(Exception ex){}
                }

            }
        }


    }

    /**
     * Carga el logo de una empresa específica DESPUÉS del login exitoso
     * @param codigoEmpresa Código de la empresa
     * @return BeanEmpresa con el logo en Base64, o null si hay error
     * @throws Exception con el mensaje de error si algo falla
     */
    public BeanEmpresa cargarLogoEmpresa(String codigoEmpresa) throws Exception {
        BeanEmpresa empresa = null;
        long tiempoInicio = System.currentTimeMillis();

        try {
            android.util.Log.i("ImplEmpresa", "[MOBILE] >>> INICIO cargarLogoEmpresa para: " + codigoEmpresa + " | Tiempo inicio: " + tiempoInicio);
            
            String METHOD_NAME = "cargarLogoEmpresa";
            List<parametro> listaParam = new ArrayList<parametro>();
            listaParam.add(new parametro("codigoEmpresa", codigoEmpresa));

            long tiempoAntesSOAP = System.currentTimeMillis();
            Object result = new SOAPClient().Connect(WSDL, METHOD_NAME, listaParam);
            long tiempoDespuesSOAP = System.currentTimeMillis();
            long tiempoSOAP = tiempoDespuesSOAP - tiempoAntesSOAP;
            
            android.util.Log.i("ImplEmpresa", "[MOBILE] >>> Llamada SOAP completada | Tiempo SOAP: " + tiempoSOAP + " ms");

            if (result != null && result instanceof SoapObject) {
                long tiempoAntesPopulate = System.currentTimeMillis();
                empresa = new BeanEmpresa();
                empresa.populate(new ExtendedSoapObject((SoapObject) result));
                long tiempoDespuesPopulate = System.currentTimeMillis();
                long tiempoPopulate = tiempoDespuesPopulate - tiempoAntesPopulate;
                
                long tiempoFin = System.currentTimeMillis();
                long tiempoTotal = tiempoFin - tiempoInicio;
                
                android.util.Log.i("ImplEmpresa", "[MOBILE] >>> FIN cargarLogoEmpresa | Tiempo populate: " + tiempoPopulate + " ms | Tiempo total: " + tiempoTotal + " ms");
                
                // Verificar si el logo se cargó correctamente (el backend pone mensaje en el SoapObject si hay error)
                return empresa;
            } else {
                long tiempoFin = System.currentTimeMillis();
                long tiempoTotal = tiempoFin - tiempoInicio;
                android.util.Log.e("ImplEmpresa", "[MOBILE] >>> ERROR: No se pudo conectar al servicio | Tiempo total: " + tiempoTotal + " ms");
                throw new Exception("No se pudo conectar al servicio para cargar el logo");
            }

        } catch (Exception ex) {
            long tiempoFin = System.currentTimeMillis();
            long tiempoTotal = tiempoFin - tiempoInicio;
            android.util.Log.e("ImplEmpresa", "[MOBILE] >>> EXCEPCIÓN en cargarLogoEmpresa | Tiempo total: " + tiempoTotal + " ms | Error: " + ex.getMessage(), ex);
            ex.printStackTrace();
            throw new Exception("Error al cargar el logo: " + ex.getMessage());
        }
    }

}
