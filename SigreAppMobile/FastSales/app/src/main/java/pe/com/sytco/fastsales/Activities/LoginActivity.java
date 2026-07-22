package pe.com.sytco.fastsales.Activities;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.material.textfield.TextInputLayout;

import java.io.EOFException;
import java.net.SocketTimeoutException;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Finanzas.ImplTasaCambio;
import pe.com.sytco.fastsales.Controller.ImplConfiguracion;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Controller.ImplServerRemote;
import pe.com.sytco.fastsales.Controller.ImplUsuario;
import pe.com.sytco.fastsales.Controller.ProgressCallback;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.Services.ConnectionMonitorService;
import pe.com.sytco.fastsales.Services.GlobalTimeSyncService;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.beans.BeanAndroidDevice;
import pe.com.sytco.fastsales.beans.BeanEmpresa;
import pe.com.sytco.fastsales.beans.BeanPingHistory;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.data.PingHistoryDbHelper;
import pe.com.sytco.fastsales.util.LogHelper;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.PlayAppUpdateHelper;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ValidInputHelper;

public class LoginActivity extends AppCompatActivity {

    //Controles de la activity
    private EditText txtUser, txtClave;
    private Button btnLogin, btnServerDefault, btnEmpresaDefault;
    private ImageButton btnRefrescar;
    private TextView tvMensajeError, tvVersionName;
    private TextInputLayout tilUsuario, tilClave;
    
    // Badge de conexión flotante
    private LinearLayout llBadgeConexion;
    private ImageView ivEstadoConexion;
    private TextView tvEstadoConexion;
    
    // Servicio de monitoreo de conexión (solo activo en LoginActivity)
    private ConnectionMonitorService connectionMonitor;
    private PingHistoryDbHelper pingDbHelper;

    /** Actualización Google Play (antes del login). */
    private PlayAppUpdateHelper playAppUpdateHelper;

    //PAra guardar el usuario logueado
    private BeanUsuario userLogin;

    //Listado de Servidores remotos
    ImplServerRemote implServer;
    ImplEmpresa implEmpresa;

    private final static int REQUEST_CODE_ASK_PERMISSIONS = 1;

    public Button getBtnEmpresaDefault() {
        return btnEmpresaDefault;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        try{
            // Limpiar logs del dispositivo al iniciar la pantalla de login
            clearDeviceLogs();

            // Sin requestWindowFeature aquí: el theme ya tiene windowNoTitle,
            // y EdgeToEdge (pre-create) ya inicializó la ventana → requestFeature() fallaría.

            setContentView(R.layout.activity_login);

            implServer = new ImplServerRemote(getApplicationContext());
            implEmpresa = new ImplEmpresa(this);

            InitControllers();
            
            // Obtener la instancia singleton de la base de datos (ya inicializada en GlobalClass)
            pingDbHelper = PingHistoryDbHelper.getInstance(this);
            
            // INICIAR EL MONITOREO DE CONEXIÓN INMEDIATAMENTE
            // El monitoreo estará activo durante TODA LA VIDA del LoginActivity,
            // sin importar si está visible, oculto, minimizado o detrás de un dialog
            iniciarMonitoreoConexion();
            LogHelper.i("LoginActivity", "Monitoreo de conexión iniciado INMEDIATAMENTE después de InitControllers");

            HabilitarEventos();

            LoadDataDefault();

            // Antes del login: consultar Google Play por versión más nueva.
            setLoginUiEnabled(false);
            playAppUpdateHelper = new PlayAppUpdateHelper(this, new PlayAppUpdateHelper.Callback() {
                @Override
                public void onContinue() {
                    continueAfterUpdateCheck();
                }
            });
            playAppUpdateHelper.checkOnStartup();

        }catch (Exception ex){
            ex.printStackTrace();
            MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(), "Error al cargar aplicación", this);
        }
    }

    /**
     * Continúa el arranque normal del login tras la verificación de actualización Play.
     */
    private void continueAfterUpdateCheck() {
        try {
            //Valido la conexión a Internet
            if (!UTIL.isConnected(LoginActivity.this)) {
                setLoginUiEnabled(false);
                return;
            }

            setLoginUiEnabled(true);

            //Valido la versión del Android 7, y veo los permisos
            requestPermissions();

            //Verifico si hay servidores en la base de datos
            implServer.loadFromPrefererences();

            if (implServer.getServers().size() == 0) {
                implServer.messageAddServer(this);
            } else {
                LoadServerDefault();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(),
                    "Error al cargar aplicación", this);
        }
    }

    private void setLoginUiEnabled(boolean enabled) {
        if (txtUser != null) {
            txtUser.setEnabled(enabled);
        }
        if (txtClave != null) {
            txtClave.setEnabled(enabled);
        }
        if (btnLogin != null) {
            btnLogin.setEnabled(enabled);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (playAppUpdateHelper != null) {
            playAppUpdateHelper.resumeIfNeeded();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (playAppUpdateHelper != null) {
            playAppUpdateHelper.onActivityResult(requestCode, resultCode);
        }
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        
        LogHelper.i("LoginActivity", "LoginActivity destruyéndose - limpiando estadísticas y deteniendo monitoreo");
        
        // 1. LIMPIAR TODAS LAS ESTADÍSTICAS DE ESTA SESIÓN
        // Cada vez que se inicie LoginActivity nuevamente, las estadísticas comenzarán desde cero
        if (pingDbHelper != null) {
            try {
                int registrosEliminados = pingDbHelper.deleteAllPings();
                LogHelper.i("LoginActivity", "Estadísticas de ping eliminadas: " + registrosEliminados + " registros");
            } catch (Exception ex) {
                LogHelper.e("LoginActivity", "Error al limpiar estadísticas de ping", ex);
            }
        }
        
        // 2. DETENER EL MONITOREO DE CONEXIÓN
        // Esto ocurre cuando navegamos a BienvenidaActivity o cerramos la app
        detenerMonitoreoConexion();

        if (playAppUpdateHelper != null) {
            playAppUpdateHelper.unregister();
            playAppUpdateHelper = null;
        }
        
        // NO cerrar pingDbHelper aquí - es un singleton global
        // Se cerrará automáticamente cuando la app se destruya completamente
        
        LogHelper.i("LoginActivity", "LoginActivity destruido completamente - listo para nueva sesión");
    }

    private void LoadDataDefault() throws PackageManager.NameNotFoundException {
        //Imprimir la version de la aplicacion
        tvVersionName.setText("Version: " + this.getPackageManager().getPackageInfo(getPackageName(), 0).versionName);
    }

    private void InitControllers() {
        //Obtengo las referencias
        tvMensajeError = (TextView)findViewById(R.id.tvMensajeError);
        txtUser = (EditText) findViewById(R.id.etUsuario);
        txtClave = (EditText) findViewById(R.id.etClave);
        tilUsuario= (TextInputLayout) findViewById(R.id.tilUsuario);
        tilClave= (TextInputLayout) findViewById(R.id.tilClave);
        tvVersionName = (TextView)findViewById(R.id.tvVersionName);

        btnLogin= (Button) findViewById(R.id.btnLogin);
        btnRefrescar = (ImageButton)findViewById(R.id.btnRefrescar);
        btnServerDefault = (Button)findViewById(R.id.btnServerDefault);
        btnEmpresaDefault = (Button)findViewById(R.id.btnEmpresaDefault);

        // Badge de conexión
        llBadgeConexion = (LinearLayout) findViewById(R.id.llBadgeConexion);
        ivEstadoConexion = (ImageView) findViewById(R.id.ivEstadoConexion);
        tvEstadoConexion = (TextView) findViewById(R.id.tvEstadoConexion);

        tvMensajeError.setText("");
        tvMensajeError.setVisibility(View.GONE);
        llBadgeConexion.setVisibility(View.GONE);

        ValidInputHelper.bindTextInputLayout(tilUsuario, ValidInputHelper.notBlank());
        ValidInputHelper.bindEditText(txtClave, ValidInputHelper.minLength(1));
        
        // Hacer el badge clickeable para mostrar estadísticas
        llBadgeConexion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mostrarDialogEstadisticasPing();
            }
        });
    }

    private void HabilitarEventos() {
        //Habilito el evento Click boton btnRefrescar
        btnRefrescar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ValidarServerTask().execute();
            }
        });

        //Habilito el evento Click boton btnServerDefault
        btnServerDefault.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    if (implServer.getServers().size() == 0){

                        implServer.messageAddServer(LoginActivity.this);

                    }else{

                        //Si hay Servidores en el arreglo entonces muestro el cuadro de dialogo
                        implServer.dialogServerDefault(LoginActivity.this);

                    }


                } catch (Exception e) {
                    e.printStackTrace();
                    MessageBox.AlertDialog(LoginActivity.this, "Error", "Ha ocurrido un error. Mensaje: " + e.getMessage(), true);
                }
            }
        });

        //Habilito el evento Click boton btnServerDefault
        btnEmpresaDefault.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Bean Server Remote
                BeanServerRemote beanServerRemote;

                try {
                    //Coloco los datos necesarios
                    beanServerRemote = SOAPClient.serverDefault;

                    if (beanServerRemote == null)
                        throw new Exception("No se ha especificado un Server Remote por defecto, no se puede obtener el listado de Empresas");

                    implEmpresa.listarEmpresa();
                } catch (Exception e) {
                    e.printStackTrace();
                    MessageBox.AlertDialog(LoginActivity.this, "Error", "Ha ocurrido un error. Mensaje: " + e.getMessage(), true);
                }
            }
        });


    }

    public void LoadServerDefault() {
        //Obtengo el servidor por default
        BeanServerRemote bean = implServer.loadServerDefault();

        if (bean == null) return;

        btnServerDefault.setText(bean.getNombre());



        new ValidarServerTask().execute();

    }

    /**
     * Muestra el badge flotante de conexión con el estado correspondiente
     * @param conectado true si hay conexión, false si no hay
     */
    private void mostrarBadgeConexion(boolean conectado) {
        if (conectado) {
            // Configuración para CONECTADO (verde)
            llBadgeConexion.setBackgroundResource(R.drawable.badge_connected_bg);
            ivEstadoConexion.setImageResource(R.drawable.ic_wifi_connected);
            tvEstadoConexion.setText("Conectado");
            tvEstadoConexion.setTextColor(0xFF4CAF50); // Verde
        } else {
            // Configuración para DESCONECTADO (rojo)
            llBadgeConexion.setBackgroundResource(R.drawable.badge_disconnected_bg);
            ivEstadoConexion.setImageResource(R.drawable.ic_wifi_disconnected);
            tvEstadoConexion.setText("Desconectado");
            tvEstadoConexion.setTextColor(0xFFF44336); // Rojo
        }
        
        // Mostrar el badge PERMANENTEMENTE (no se auto-oculta)
        llBadgeConexion.setVisibility(View.VISIBLE);
    }

    public void LoadEmpresaDefault() throws Exception {


        //Obtengo la empresa por default
        BeanEmpresa bean = implEmpresa.loadEmpresaFromPreferences();
        System.out.println("LoadEmpresaDefault " + bean);

        if (bean == null) {
            implEmpresa.listarEmpresa();
        }else {

            implEmpresa.ValidarEmpresa(bean);
        }


    }

    //Esta función se llama desde el boton de Salir
    public void Salir(View view){
        new RegistrarLogoutTask().execute();
    }

    public void Ingresar(View view){
        String lsUsuario;
        BeanUsuario beanUsuario;

        //Ocultar teclado
        UTIL.OcultarTeclado(LoginActivity.this, btnLogin);

        lsUsuario = txtUser.getText().toString();

        if (lsUsuario.length() > 6){
            lsUsuario = lsUsuario.substring(0, 5);
        }

        beanUsuario = new BeanUsuario();

        beanUsuario.setUsuario(lsUsuario);
        beanUsuario.setClave(txtClave.getText().toString());

        if (!UTIL.validarTexto(beanUsuario.getUsuario())) {
            tilUsuario.setError("Debe ingresar un usuario");
            return;
        }else
            tilUsuario.setError(null);

        if (!UTIL.validarTexto(beanUsuario.getClave())) {
            tilClave.setError("Debe ingresar una contraseña");
            return;
        }else
            tilClave.setError(null);

        btnLogin.setEnabled(false);
        new LoginActivityTask(beanUsuario).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, ImplUsuario.ACTION_VALIDAR_CREDENCIALES);
    }

    public void RegistrarDevice() {
        new RegisterDeviceTask().executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
    }

    @SuppressLint("NewApi")
    private boolean requestPermissions(){
        int hasWriteContactsPermission;


        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            AlertDialog alertDialog = new AlertDialog.Builder(this).create();

            alertDialog.setTitle("Error");

            alertDialog.setMessage("La versión de Android debe ser 7 o SUPERIOR, puede continuar, " +
                    "pero debe brindar los accesos a este programa de manera manual, tener presente eso");

            alertDialog.setIcon(R.drawable.fail);

            alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int which) {
                    int permissionCheck;

                    permissionCheck = ContextCompat.checkSelfPermission(LoginActivity.this, Manifest.permission.CAMERA);

                    if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
                        // Explicar permiso
                        if (ActivityCompat.shouldShowRequestPermissionRationale(LoginActivity.this, Manifest.permission.CAMERA)) {
                            Toast.makeText(LoginActivity.this, "El permiso es necesario para utilizar la cámara.",
                                    Toast.LENGTH_SHORT).show();
                        }

                        // Solicitar el permiso
                        //if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        requestPermissions(new String[] {Manifest.permission.CAMERA, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, 3);
                        //}
                    }
                }
            });

            alertDialog.show();


        }
        else {

            hasWriteContactsPermission = checkSelfPermission(Manifest.permission.CAMERA);
            if (hasWriteContactsPermission != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[] {Manifest.permission.CAMERA, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, 3);
            }

        }

        return true;

    }

    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if(REQUEST_CODE_ASK_PERMISSIONS == requestCode) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "OK Permissions granted ! " + Build.VERSION.SDK_INT, Toast.LENGTH_LONG).show();

            } else {
                new androidx.appcompat.app.AlertDialog.Builder(this)
                    .setTitle("Proporciona los permisos para continuar")
                    .setMessage("Esta aplicacion requiere de los permisos de ubicacion para utilizarse")
                    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            finish();
                        }
                    })
                    .create()
                    .show();
            }
        }else{
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }


    private class LoginActivityTask extends AsyncTask<Integer, String, Boolean> {
        String mensaje;
        ImplUsuario implUsuario = null;
        BeanUsuario beanUsuario = null;
        ImplConfiguracion implConfiguracion = null;
        ImplSegLoginDevice implSegLoginDevice = null;

        Integer liAccion, liActionActivity;

        // Progress Dialog
        private ProgressDialog pDialog;
        private long taskCreationTime;

        public LoginActivityTask(BeanUsuario pBeanUsuario) {
            this.beanUsuario = pBeanUsuario;
            // Registrar el momento de creación del AsyncTask
            this.taskCreationTime = System.currentTimeMillis();
            LogHelper.i("LoginActivity", "[MOBILE] LoginActivityTask CREADO para usuario: " + 
                (pBeanUsuario != null ? pBeanUsuario.getUsuario() : "null") + 
                " | Tiempo creación: " + taskCreationTime);
        }

        protected void onPreExecute() {
            long preExecuteTime = System.currentTimeMillis();
            long delayFromCreation = preExecuteTime - taskCreationTime;
            LogHelper.i("LoginActivity", "[MOBILE] LoginActivityTask onPreExecute() ejecutado | Delay desde creación: " + delayFromCreation + " ms");
            
            super.onPreExecute();
            pDialog = new ProgressDialog(LoginActivity.this);
            pDialog.setMessage("Validando Credenciales. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }
        
        /**
         * Actualiza el mensaje del ProgressDialog usando publishProgress
         * Este método debe ser llamado desde doInBackground para actualizar la UI
         */
        private void updateProgressMessage(String message) {
            publishProgress(message);
        }
        
        /**
         * Se ejecuta en el hilo principal cuando se llama a publishProgress()
         */
        @Override
        protected void onProgressUpdate(String... values) {
            super.onProgressUpdate(values);
            if (values != null && values.length > 0 && pDialog != null && pDialog.isShowing()) {
                pDialog.setMessage(values[0]);
            }
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            long startTime = LogHelper.getTimestampMillis();
            liAccion = params[0];
            String lsClaveDB;

            //Accion de validar credenciales
            if (params[0] == ImplUsuario.ACTION_VALIDAR_CREDENCIALES){
                try{
                    LogHelper.i("LoginActivity", "====================================");
                    LogHelper.logMethodStart("LoginActivity", "doInBackground - Validar Credenciales");
                    LogHelper.i("LoginActivity", "Usuario: " + beanUsuario.getUsuario());
                    LogHelper.i("LoginActivity", "====================================");
                    
                    if (ImplEmpresa.empresaDefault == null)
                    {
                        mensaje = "No se ha definido la empresa por defecto";
                        LogHelper.e("LoginActivity", "Error: Empresa por defecto no definida");
                        return false;
                    }

                    LogHelper.logCheckpoint("LoginActivity", "Creando instancia ImplUsuario", startTime);
                    implUsuario = new ImplUsuario(ImplEmpresa.empresaDefault.getCodigo());
                    implConfiguracion = new ImplConfiguracion(ImplEmpresa.empresaDefault.getCodigo());

                    LogHelper.logCheckpoint("LoginActivity", "Obteniendo clave del usuario desde BD", startTime);
                    lsClaveDB = implUsuario.getClave(beanUsuario.getUsuario()).toLowerCase();

                    if(lsClaveDB.equals("x") && lsClaveDB.equals(beanUsuario.getClave().toLowerCase())){
                        LogHelper.i("LoginActivity", "Usuario requiere cambio de clave");
                        liActionActivity = 1; //Cambio de clave
                        LogHelper.logMethodEnd("LoginActivity", "doInBackground", startTime);
                        return true;
                    }

                    LogHelper.logCheckpoint("LoginActivity", "Llamando a validarCredenciales WS", startTime);
                    if (implUsuario.validarCredenciales(beanUsuario.getUsuario(), beanUsuario.getClave())) {
                        LogHelper.logCheckpoint("LoginActivity", "Credenciales válidas - Obteniendo datos del usuario", startTime);
                        
                        userLogin = implUsuario.getOne(beanUsuario.getUsuario());
                        userLogin.setFecLogin(UTIL.getSqlDateNow());

                    LogHelper.logCheckpoint("LoginActivity", "Guardando usuario en GlobalClass", startTime);
                    //Guardo el usuario que se ha logueado
                    final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                    globalVariable.setUserLogin(userLogin);

                    mensaje = "Credenciales correctas.\nBienvenido " + userLogin.getFullName();

                    LogHelper.logCheckpoint("LoginActivity", "Iniciando procesos paralelos: getParametro y registerLogin", startTime);
                    updateProgressMessage("Finalizando configuración...");
                    
                    // Datos necesarios para los procesos paralelos
                    final String codigoEmpresa = ImplEmpresa.empresaDefault.getCodigo();
                    final String nroParte = ImplSegLoginDevice.currentDevice.getNroParte();
                    final String codUsuario = userLogin.getUsuario();
                    
                    // PROCESO 1: Obtener parámetros en paralelo
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                LogHelper.i("LoginActivity", "[PARALELO] Iniciando getParametro");
                                ImplConfiguracion implConfigAsync = new ImplConfiguracion(codigoEmpresa);
                                String claveEditPrecio = implConfigAsync.getParametro("CLAVE_EDIT_PRECIO", "123456");
                                globalVariable.setEditPassword(claveEditPrecio);
                                LogHelper.i("LoginActivity", "[PARALELO] getParametro completado");
                            } catch (Exception e) {
                                LogHelper.e("LoginActivity", "Error en getParametro paralelo (no crítico): " + e.getMessage(), e);
                                // Usar valor por defecto si falla
                                globalVariable.setEditPassword("123456");
                            }
                        }
                    }).start();
                    
                    // PROCESO 2: Registrar login en paralelo
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                LogHelper.i("LoginActivity", "[PARALELO] Iniciando registerLogin");
                                ImplSegLoginDevice implSegLoginDeviceAsync = new ImplSegLoginDevice(codigoEmpresa);
                                implSegLoginDeviceAsync.registerLogin(nroParte, codUsuario);
                                LogHelper.i("LoginActivity", "[PARALELO] registerLogin completado");
                            } catch (Exception e) {
                                LogHelper.e("LoginActivity", "Error en registerLogin paralelo (no crítico): " + e.getMessage(), e);
                                // No lanzar excepción, es un proceso no crítico
                            }
                        }
                    }).start();

                    LogHelper.logCheckpoint("LoginActivity", "Procesos paralelos iniciados, continuando flujo", startTime);
                    //Indico la opcion
                    liActionActivity = 2;
                        
                        LogHelper.logMethodEnd("LoginActivity", "doInBackground - LOGIN EXITOSO", startTime);
                        LogHelper.i("LoginActivity", "====================================");
                        return true;

                    } else {
                        mensaje = "Credenciales incorrectas";
                        liActionActivity = 2;
                        LogHelper.e("LoginActivity", "Credenciales incorrectas");
                        LogHelper.logMethodEnd("LoginActivity", "doInBackground - CREDENCIALES INCORRECTAS", startTime);
                        return false;
                    }
                }catch (Exception ex){
                    mensaje = "Error al momento de Validar Credenciales: " + ex.getMessage();
                    LogHelper.e("LoginActivity", "Error en validación", ex);
                    LogHelper.logMethodEnd("LoginActivity", "doInBackground - ERROR", startTime);
                    return false;
                }finally {
                    implUsuario = null;
                    implConfiguracion = null;
                    implSegLoginDevice = null;
                }
            }

            mensaje = "Accion no definida en LoginActivityTask " + String.valueOf(liAccion) + ". Por favor verifique!";
            LogHelper.e("LoginActivity", "Acción no definida: " + liAccion);
            return false;
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (liAccion == ImplUsuario.ACTION_VALIDAR_CREDENCIALES) {
                    if (!result)
                        Toast.makeText(LoginActivity.this, mensaje, Toast.LENGTH_LONG).show();
                    else {
                        if (liActionActivity == 2)
                            Toast.makeText(LoginActivity.this, mensaje, Toast.LENGTH_SHORT).show();
                        else {
                            implUsuario = new ImplUsuario(ImplEmpresa.empresaDefault.getCodigo());
                            implUsuario.dialogCambiarClave(beanUsuario, LoginActivity.this);
                            return;
                        }
                    }

                    if (result) {
                        // Iniciar sincronización de hora con el servidor
                        iniciarSincronizacionHora();
                    } else {
                        btnLogin.setEnabled(true);
                    }

                } else {
                    //Error Action no implementada
                    Toast.makeText(LoginActivity.this, mensaje, Toast.LENGTH_LONG).show();
                }
            }catch(Exception ex){
                ex.printStackTrace();
            }finally {
                // dismiss the dialog after getting all products
                implUsuario = null;
                pDialog.dismiss();
            }
        }

    }

    private class ValidarServerTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje;
        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(LoginActivity.this);
            pDialog.setMessage("Verificando Conexión con el servidor. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            String lsURL = "";
            try {
                //Obtengo el URL para ver si hay un servidor por defecto
                lsURL = new SOAPClient().getURLFromServer();

                return true;

            }catch(EOFException e){
                mensaje = "Error, servidor " + SOAPClient.serverDefault.getNombre() + " no disponible."
                       + "\nURL: " + lsURL;
                e.printStackTrace();
                return false;
            }catch (Exception ex){
                mensaje = "Error: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            }finally{

            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);

            try {

                if (!result) {
                    // Mostrar badge de desconectado
                    mostrarBadgeConexion(false);

                    //Deshabilito el boton de empresa pore defecto
                    btnEmpresaDefault.setText("");
                    btnEmpresaDefault.setEnabled(false);

                    MessageBox.AlertDialog(mensaje, "Error de Conexión al servidor", LoginActivity.this);

                }else {

                    // Mostrar badge de conectado
                    mostrarBadgeConexion(true);

                    //Habilito el boton de Empresa por defecto
                    btnEmpresaDefault.setEnabled(true);

                    LoadEmpresaDefault();

                }

            }catch(Exception ex){
                MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(), "Error", LoginActivity.this );
                ex.printStackTrace();
            }finally {
                // Quito el dialogo despues de verificar la conexión con el servidor
                if (pDialog != null ) {
                    try {
                        pDialog.dismiss();
                    }catch(Exception ex){}
                }

            }
        }

    }

    private class RegisterDeviceTask extends AsyncTask<Integer, String, Boolean> {

        private String mensaje;
        private ProgressDialog pDialog;
        private ImplSegLoginDevice implSegLoginDevice = null;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(LoginActivity.this);
            pDialog.setMessage("Iniciando registro de dispositivo...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            long startTime = LogHelper.getTimestampMillis();
            LogHelper.i("LoginActivity", "====================================");
            LogHelper.logMethodStart("LoginActivity", "RegisterDeviceTask.doInBackground - INICIO");
            
            String lsURL = "";
            try {
                //Registro el dispositivo directamente en el servidor
                publishProgress("Validando empresa por defecto...");
                LogHelper.logCheckpoint("LoginActivity", "Validando empresa por defecto", startTime);
                
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    LogHelper.e("LoginActivity", "Empresa por defecto es null");
                    return false;
                }
                
                LogHelper.logCheckpoint("LoginActivity", "Empresa validada: " + ImplEmpresa.empresaDefault.getCodigo(), startTime);

                publishProgress("Creando instancia de ImplSegLoginDevice...");
                LogHelper.logCheckpoint("LoginActivity", "Creando ImplSegLoginDevice", startTime);
                implSegLoginDevice = new ImplSegLoginDevice(ImplEmpresa.empresaDefault.getCodigo());
                LogHelper.logCheckpoint("LoginActivity", "ImplSegLoginDevice creado", startTime);
                
                // Crear callback para actualizar el progreso
                ProgressCallback progressCallback = new ProgressCallback() {
                    @Override
                    public void onProgressUpdate(String message) {
                        publishProgress(message);
                    }
                };
                
                LogHelper.logCheckpoint("LoginActivity", "Llamando a registraDevice con callback", startTime);
                long registraDeviceStart = LogHelper.getTimestampMillis();
                
                StrRespuesta rpta = implSegLoginDevice.registraDevice(LoginActivity.this, progressCallback);
                
                LogHelper.logCheckpoint("LoginActivity", "registraDevice completado", startTime);
                LogHelper.i("LoginActivity", "Tiempo total de registraDevice: " + (LogHelper.getTimestampMillis() - registraDeviceStart) + "ms");

                if (!rpta.getIsOk()){
                    mensaje = rpta.getMensaje();
                    LogHelper.e("LoginActivity", "Error en registraDevice: " + mensaje);
                    return false;
                }

                publishProgress("Obteniendo información completa del dispositivo...");
                LogHelper.logCheckpoint("LoginActivity", "Llamando a getDevice con ID: " + rpta.getCadena2(), startTime);
                BeanAndroidDevice beanAndroidDevice = implSegLoginDevice.getDevice(rpta.getCadena2());
                LogHelper.logCheckpoint("LoginActivity", "getDevice completado", startTime);

                if (!beanAndroidDevice.getIsOk()) {
                    mensaje = beanAndroidDevice.getMensaje();
                    LogHelper.e("LoginActivity", "Error en getDevice: " + mensaje);
                    return false;
                }

                beanAndroidDevice.setNroParte(rpta.getCadena());

                ImplSegLoginDevice.currentDevice = beanAndroidDevice;
                
                publishProgress("Registro completado exitosamente");
                LogHelper.logMethodEnd("LoginActivity", "RegisterDeviceTask.doInBackground - OK, NroParte: " + beanAndroidDevice.getNroParte(), startTime);
                LogHelper.i("LoginActivity", "====================================");

                return true;

            }catch(SocketTimeoutException e){
                mensaje = "Se ha sobrepasado el tiempo de conexion con el Servidor, por favor revise su conexion";
                LogHelper.e("LoginActivity", "SocketTimeoutException", e);
                LogHelper.i("LoginActivity", "====================================");
                e.printStackTrace();
                return false;
            }
            catch(Exception e){
                mensaje = "Error al registrar Dispositivo en el servidor: " + e.getMessage();
                LogHelper.e("LoginActivity", "Exception en RegisterDeviceTask", e);
                LogHelper.i("LoginActivity", "====================================");
                e.printStackTrace();
                return false;
            }finally{
                implSegLoginDevice = null;
                System.gc();
            }
        }
        
        @Override
        protected void onProgressUpdate(String... values) {
            super.onProgressUpdate(values);
            if (pDialog != null && pDialog.isShowing() && values != null && values.length > 0) {
                pDialog.setMessage(values[0]);
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (!result) {
                    //MessageBox.AlertDialog(mensaje, , LoginActivity.this.getApplicationContext());
                    AlertDialog.Builder builder;
                    builder = new AlertDialog.Builder(LoginActivity.this);
                    builder.setTitle("Error al registrar Dispositivo");
                    builder.setMessage(mensaje);
                    builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.cancel();
                            finish();
                        }
                    });
                    builder.setCancelable(false);
                    builder.create();
                    builder.show();


                }else {
                    Toast.makeText(LoginActivity.this, "Registro de dispositivo realizado correctamente. Nro Registro: "
                            + ImplSegLoginDevice.currentDevice.getNroParte(), Toast.LENGTH_LONG).show();
                }

            }catch(Exception ex){
                MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(), "Error", LoginActivity.this );
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

    private class RegistrarLogoutTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje;
        private ProgressDialog pDialog;
        private ImplSegLoginDevice implSegLoginDevice = null;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(LoginActivity.this);
            pDialog.setMessage("Registrando Logout en el Servidor. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            String lsURL = "";
            try {
                //Registro el dispositivo directamente en el servidor
                implSegLoginDevice = new ImplSegLoginDevice(ImplEmpresa.empresaDefault.getCodigo());
                implSegLoginDevice.registerLogout(ImplSegLoginDevice.currentDevice.getNroParte());

                return true;

            }catch(Exception e){
                mensaje = "Error al registrar Logout del Dispositivo en el servidor: " + e.getMessage();
                e.printStackTrace();
                return false;
            }finally{
                implSegLoginDevice = null;
                System.gc();
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (!result) {
                    MessageBox.AlertDialog(mensaje, "Error al registrar Dispositivo", LoginActivity.this);

                }else {
                    Toast.makeText(LoginActivity.this, "Registro de Logout realizado correctamente. Nro Registro: "
                            + ImplSegLoginDevice.currentDevice.getNroParte(), Toast.LENGTH_LONG).show();
                }

                finish();

            }catch(Exception ex){
                MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(), "Error", LoginActivity.this );
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
     * Inicia la sincronización de hora con el servidor
     * Muestra un diálogo de progreso durante la sincronización inicial
     */
    private void iniciarSincronizacionHora() {
        final ProgressDialog syncDialog = new ProgressDialog(LoginActivity.this);
        syncDialog.setMessage("Un momento, se está actualizando la hora del PDA con el servidor...");
        syncDialog.setIndeterminate(true);
        syncDialog.setCancelable(false);
        syncDialog.show();
        
        final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
        
        globalVariable.startTimeSynchronization(new GlobalTimeSyncService.InitialSyncListener() {
            @Override
            public void onSyncStarted() {
                // El diálogo ya está mostrándose
            }
            
            @Override
            public void onSyncCompleted(boolean success, String message) {
                // Cerrar el diálogo de sincronización
                if (syncDialog != null && syncDialog.isShowing()) {
                    syncDialog.dismiss();
                }
                
                // Mostrar resultado brevemente (solo si hubo error)
                if (!success) {
                    Toast.makeText(LoginActivity.this, 
                        "Advertencia: " + message + "\nLa aplicación usará la hora del servidor para las operaciones", 
                        Toast.LENGTH_LONG).show();
                }
                
                // Continuar con el flujo normal de login
                // CARGAR EL LOGO DE LA EMPRESA DESPUÉS DEL LOGIN EXITOSO (en segundo plano)
                LogHelper.i("LoginActivity", "Iniciando carga de logo en segundo plano para " + ImplEmpresa.empresaDefault.getCodigo());
                
                // Capturar datos del usuario para usarlos en el AsyncTask
                final String nombreUsuario = userLogin.getNombre() != null ? userLogin.getNombre() : userLogin.getUsuario();
                final String codigoEmpresa = ImplEmpresa.empresaDefault.getCodigo();
                
                new AsyncTask<String, String, BeanEmpresa>() {
                    private ProgressDialog progressDialog;
                    private long taskCreationTime;
                    
                    {
                        // Constructor: registrar el momento de creación del AsyncTask
                        taskCreationTime = System.currentTimeMillis();
                        LogHelper.i("LoginActivity", "[MOBILE] AsyncTask de logo CREADO para: " + codigoEmpresa + " | Tiempo creación: " + taskCreationTime);
                    }
                    
                    @Override
                    protected void onPreExecute() {
                        long preExecuteTime = System.currentTimeMillis();
                        long delayFromCreation = preExecuteTime - taskCreationTime;
                        LogHelper.i("LoginActivity", "[MOBILE] AsyncTask de logo onPreExecute() ejecutado | Delay desde creación: " + delayFromCreation + " ms");
                        
                        // Mostrar ProgressDialog antes de iniciar la carga
                        progressDialog = new ProgressDialog(LoginActivity.this);
                        progressDialog.setMessage("Cargando logo de la empresa " + codigoEmpresa + "...\n\nRuta esperada: [Servidor]/sigre_exe/logos/" + codigoEmpresa + "_LOGO.png");
                        progressDialog.setCancelable(false);
                        progressDialog.show();
                    }
                    
                    @Override
                    protected BeanEmpresa doInBackground(String... params) {
                        long tiempoInicio = System.currentTimeMillis();
                        try {
                            String codigoEmpresa = params[0];
                            LogHelper.i("LoginActivity", "[MOBILE] Iniciando carga de logo para: " + codigoEmpresa + " | Tiempo inicio: " + tiempoInicio);
                            
                            ImplEmpresa implEmpresa = new ImplEmpresa(LoginActivity.this);
                            BeanEmpresa resultado = implEmpresa.cargarLogoEmpresa(codigoEmpresa);
                            
                            long tiempoFin = System.currentTimeMillis();
                            long tiempoTotal = tiempoFin - tiempoInicio;
                            
                            // Si el logo se cargó exitosamente, publicar la ruta completa
                            if (resultado != null && resultado.isOk() && resultado.getLogoFile() != null) {
                                LogHelper.i("LoginActivity", "[MOBILE] Logo cargado exitosamente | Tiempo total: " + tiempoTotal + " ms | Archivo: " + resultado.getLogoFile());
                                publishProgress("Logo encontrado:\n" + resultado.getLogoFile() + "\n\nTiempo: " + tiempoTotal + " ms");
                            } else if (resultado != null && resultado.getMensaje() != null) {
                                LogHelper.e("LoginActivity", "[MOBILE] Error al cargar logo | Tiempo total: " + tiempoTotal + " ms | Error: " + resultado.getMensaje());
                                publishProgress("Error:\n" + resultado.getMensaje() + "\n\nTiempo: " + tiempoTotal + " ms");
                            } else {
                                LogHelper.e("LoginActivity", "[MOBILE] Error desconocido al cargar logo | Tiempo total: " + tiempoTotal + " ms");
                                publishProgress("Error desconocido\n\nTiempo: " + tiempoTotal + " ms");
                            }
                            
                            return resultado;
                        } catch (Exception ex) {
                            long tiempoFin = System.currentTimeMillis();
                            long tiempoTotal = tiempoFin - tiempoInicio;
                            LogHelper.e("LoginActivity", "[MOBILE] Excepción al cargar logo | Tiempo total: " + tiempoTotal + " ms | Error: " + ex.getMessage(), ex);
                            publishProgress("Excepción:\n" + ex.getMessage() + "\n\nTiempo: " + tiempoTotal + " ms");
                            return null;
                        }
                    }
                    
                    @Override
                    protected void onProgressUpdate(String... values) {
                        // Actualizar el mensaje del ProgressDialog con la ruta completa
                        if (progressDialog != null && progressDialog.isShowing() && values.length > 0) {
                            progressDialog.setMessage("Cargando logo de la empresa " + codigoEmpresa + "...\n\n" + values[0]);
                        }
                    }
                    
                    @Override
                    protected void onPostExecute(BeanEmpresa empresaConLogo) {
                        // Cerrar el ProgressDialog
                        if (progressDialog != null && progressDialog.isShowing()) {
                            progressDialog.dismiss();
                        }
                        
                        if (empresaConLogo != null && empresaConLogo.isOk()) {
                            // Logo cargado exitosamente, actualizar la empresa por defecto
                            ImplEmpresa.empresaDefault.setLogoBase64(empresaConLogo.getLogoBase64());
                            ImplEmpresa.empresaDefault.setLogoFile(empresaConLogo.getLogoFile());
                            LogHelper.i("LoginActivity", "Logo cargado exitosamente desde: " + empresaConLogo.getLogoFile());
                        } else {
                            // Error al cargar logo, mostrar mensaje pero continuar
                            String mensajeError = (empresaConLogo != null && empresaConLogo.getMensaje() != null) 
                                ? empresaConLogo.getMensaje() 
                                : "Error desconocido al cargar el logo";
                            LogHelper.e("LoginActivity", "Error al cargar logo: " + mensajeError);
                            Toast.makeText(LoginActivity.this, 
                                "ADVERTENCIA:\n" + mensajeError, 
                                Toast.LENGTH_LONG).show();
                        }
                        
                        // Navegar a la pantalla de bienvenida (sin importar el resultado del logo)
                        //if (userLogin.getFlagCambioClave().equals("0")) {
                            //Si no hay cambio de clave o no ha caducado entonces lo remito a la pantalla de bienvenida
                            Intent intent = new Intent(LoginActivity.this, BienvenidaActivity.class);
                            // Pasar el nombre del usuario a la pantalla de bienvenida
                            intent.putExtra("NOMBRE_USUARIO", nombreUsuario);
                            startActivity(intent);
                        //}else {
                            //Sino de lo contrario lo mando a la pantalla de cambio de clave
                        //    Intent intent = new Intent(LoginActivity.this, MenuActivity.class);
                        //    startActivity(intent);
                        //}
                        
                        finish();
                    }
                }.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, codigoEmpresa);
            }
        });
    }

    /**
     * Método para limpiar/reiniciar los logs del dispositivo al iniciar la pantalla de login.
     * Esto ayuda a diagnosticar problemas mostrando solo los logs de la sesión actual.
     */
    private void clearDeviceLogs() {
        try {
            // Intento 1: Limpiar el buffer de logcat (requiere permisos READ_LOGS)
            // En versiones modernas de Android esto puede fallar, pero lo intentamos
            Runtime.getRuntime().exec(new String[]{"logcat", "-c"});
            
            // Intento 2: Marcar el inicio de una nueva sesión con separadores visuales
            android.util.Log.d("===================", "============================================================");
            android.util.Log.d("===================", "============================================================");
            android.util.Log.d("===================", "   NUEVA SESIÓN DE LOGIN - " + new java.util.Date().toString());
            android.util.Log.d("===================", "============================================================");
            android.util.Log.d("===================", "============================================================");
            
        } catch (Exception e) {
            // Si falla la limpieza, solo marcamos el inicio
            android.util.Log.d("LoginActivity", "No se pudo limpiar logcat, marcando inicio de sesión");
            android.util.Log.d("===================", "INICIO DE SESIÓN - " + new java.util.Date().toString());
        }
    }
    
    /**
     * Inicia el servicio de monitoreo de conexión (SOLO en LoginActivity)
     * Mide el ping cada segundo y actualiza el badge de conexión
     */
    private void iniciarMonitoreoConexion() {
        if (connectionMonitor != null) {
            // Ya está iniciado
            return;
        }
        
        // MOSTRAR EL BADGE INMEDIATAMENTE COMO "CONECTANDO..."
        mostrarBadgeConectando();
        
        try {
            // Crear el servicio de monitoreo con su listener
            connectionMonitor = new ConnectionMonitorService(
                new ConnectionMonitorService.ConnectionStatusListener() {
                    @Override
                    public void onConnectionStatusChanged(boolean isConnected, Long latencyMs) {
                        // Actualizar el badge de conexión en el UI thread
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mostrarBadgeConexion(isConnected);
                                
                                // Actualizar también el texto con la latencia si está conectado
                                if (isConnected && latencyMs != null) {
                                    tvEstadoConexion.setText(String.format("Conectado (%dms)", latencyMs));
                                }
                            }
                        });
                    }
                    
                    @Override
                    public void onPingUpdated(BeanPingHistory ping) {
                        // Este método se llamará cada segundo con el nuevo ping
                        // Útil para actualizar la gráfica en tiempo real si el dialog está abierto
                    }
                },
                pingDbHelper
            );
            
            // Iniciar el monitoreo
            connectionMonitor.start();
            
            LogHelper.i("LoginActivity", "Monitoreo de conexión iniciado");
            
        } catch (Exception ex) {
            LogHelper.e("LoginActivity", "Error al iniciar monitoreo de conexión", ex);
        }
    }
    
    /**
     * Muestra el badge en estado "Conectando..." al inicio del monitoreo
     */
    private void mostrarBadgeConectando() {
        // Configuración para CONECTANDO (amarillo/naranja)
        llBadgeConexion.setBackgroundResource(R.drawable.badge_disconnected_bg);
        ivEstadoConexion.setImageResource(R.drawable.ic_wifi_disconnected);
        tvEstadoConexion.setText("Conectando...");
        tvEstadoConexion.setTextColor(0xFFFF9800); // Naranja
        
        // Mostrar el badge
        llBadgeConexion.setVisibility(View.VISIBLE);
    }
    
    /**
     * Detiene el servicio de monitoreo de conexión
     */
    private void detenerMonitoreoConexion() {
        if (connectionMonitor != null) {
            try {
                connectionMonitor.stop();
                connectionMonitor = null;
                LogHelper.i("LoginActivity", "Monitoreo de conexión detenido");
            } catch (Exception ex) {
                LogHelper.e("LoginActivity", "Error al detener monitoreo de conexión", ex);
            }
        }
    }
    
    /**
     * Muestra el dialog de monitoreo con gráficas en tiempo real
     */
    private void mostrarDialogEstadisticasPing() {
        try {
            if (pingDbHelper == null) {
                Toast.makeText(this, "Base de datos de pings no disponible", Toast.LENGTH_SHORT).show();
                return;
            }
            
            // Crear y mostrar el dialog de monitoreo con actualización en tiempo real
            pe.com.sytco.fastsales.Dialog.PingMonitorDialog dialog = 
                new pe.com.sytco.fastsales.Dialog.PingMonitorDialog(this, pingDbHelper);
            
            dialog.show();
            
            LogHelper.i("LoginActivity", "Dialog de monitoreo de pings abierto - actualización en tiempo real cada 1 segundo");
            
        } catch (Exception ex) {
            LogHelper.e("LoginActivity", "Error al mostrar dialog de monitoreo", ex);
            Toast.makeText(this, "Error al abrir el monitor de conexión", Toast.LENGTH_SHORT).show();
        }
    }
}
