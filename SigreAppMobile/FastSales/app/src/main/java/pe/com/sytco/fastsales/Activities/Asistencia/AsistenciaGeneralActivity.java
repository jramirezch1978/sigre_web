package pe.com.sytco.fastsales.Activities.Asistencia;

import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import java.io.Serializable;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenDespachoPPTTActivity;
import pe.com.sytco.fastsales.Activities.Almacen.AlmacenOpcionesActivity;
import pe.com.sytco.fastsales.Activities.Almacen.AlmacenParteRecepcionPopupActivity;
import pe.com.sytco.fastsales.Activities.Almacen.AlmacenTomaInventarioActivity;
import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteDespacho;
import pe.com.sytco.fastsales.Controller.Asistencia.ImplAsistencia;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplOrigen;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.Dialog.DialogConfirmarAsistencia;
import pe.com.sytco.fastsales.Dialog.DialogSeleccionarTipoMovimiento;
import pe.com.sytco.fastsales.UI.AsistenciaUI;
import pe.com.sytco.fastsales.UI.ParteIngresoUI;
import pe.com.sytco.fastsales.beans.Asistencia.BeanAsistenciaHT580;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.beans.BeanOrigen;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.Services.ServerClockService;

public class AsistenciaGeneralActivity extends AppCompatActivity implements Serializable {

    private EditText etFechaMovimiento, etHoraMovimiento, etLecturaPDA;
    private TextView tvOrigen, tvTipoMovimientoSeleccionado, tvNombreEmpresa;
    private TextView tvServerDate, tvServerTime;
    private TextView tvTituloTablaAsistencia;
    private ImageView ivConnectionStatus, ivLogoEmpresa;
    private ImageButton ibFechaMovimiento;
    private Button btnRegistrar, btnSalir, btnLeerCodigo, btnSeleccionarTipoMovimiento;
    private LinearLayout llTipoMovimientoSeleccionado;

    private AsistenciaUI asistenciaUI;
    private ServerClockService serverClockService;

    //Variables diversas
    //Listado con la consulta de asistencoa
    List<BeanAsistenciaHT580> listaAsistencia = null;
    
    // Variables para tipo de movimiento seleccionado
    private String tipoMovimientoSeleccionado = null;
    private String descripcionMovimientoSeleccionado = null;
    
    // Caché de trabajadores consultados recientemente (evita llamadas SOAP repetidas)
    // Key: codTrabajador, Value: BeanTrabajador
    private static final Map<String, BeanTrabajador> TRABAJADORES_CACHE = new ConcurrentHashMap<String, BeanTrabajador>();
    private static final int MAX_CACHE_SIZE = 50; // Máximo 50 trabajadores en caché
    
    // Caché de búsquedas de asistencia recientes
    // Key: "fecha|flagInOut|codUsuario", Value: List<BeanAsistenciaHT580>
    private static final Map<String, List<BeanAsistenciaHT580>> ASISTENCIA_CACHE = new ConcurrentHashMap<String, List<BeanAsistenciaHT580>>();
    private static final int MAX_ASISTENCIA_CACHE_SIZE = 10; // Máximo 10 búsquedas en caché


    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    final int mes1 = c.get(Calendar.MONTH);
    final int dia1 = 1;
    final int year1 = c.get(Calendar.YEAR);


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        try {
            super.onCreate(savedInstanceState);

            if (ImplEmpresa.empresaDefault == null) {
                throw new Exception("No se ha especificado la empresa");
            }

            setContentView(R.layout.activity_asistencia_general);


            InitControllers();

            AsignarEventos();

            LoadDataDefault();

        } catch (Exception e) {

            MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Ha ocurrido un error",
                    "Mensaje de Error: " + e.getMessage(), false);
            e.printStackTrace();

        }
    }

    private void LoadDataDefault() {
        java.sql.Date idtNow = UTIL.getSqlDateNow();
        if(ImplSegLoginDevice.currentDevice == null)
        {
            MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error en Origen",
                    "No se ha especificado Dispositivo Actual, por favor verifique!", false);
        }

        if(ImplSegLoginDevice.currentDevice.getCodOrigen() == null || ImplSegLoginDevice.currentDevice.getCodOrigen().equals("") )
        {
            MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error en Origen",
                    "No se ha especificado el Origen del dispositivo ACTUAL, por favor verifique con Sistemas!", false);
        }

        tvOrigen.setText("Org [" + ImplEmpresa.empresaDefault.getCodOrigen() + ","
                + ImplSegLoginDevice.currentDevice.getCodOrigen() + "]");

        etFechaMovimiento.setText(UTIL.parseSqlDatetoString(idtNow, "dd/MM/yyyy"));
        etHoraMovimiento.setText(UTIL.parseSqlDatetoString(idtNow, "hh:mm:ss"));

        // Por defecto, no hay tipo de movimiento seleccionado
        tipoMovimientoSeleccionado = null;
        descripcionMovimientoSeleccionado = null;
        llTipoMovimientoSeleccionado.setVisibility(View.GONE);

        btnLeerCodigo.setEnabled(false);
        etLecturaPDA.setEnabled(false);

    }

    private void AsignarEventos() {

        ibFechaMovimiento.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AsistenciaGeneralActivity.this,
                    new DatePickerDialog.OnDateSetListener() {
                        @Override
                        public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                            //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                            final int mesActual = month + 1;

                            //Muestro la fecha con el formato deseado
                            etFechaMovimiento.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


                        }
                    },year1, mes1, dia1);

                //Muestro el widget
                recogerFecha.show();
            }
        });

        // Botón para seleccionar tipo de movimiento
        btnSeleccionarTipoMovimiento.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mostrarDialogoSeleccionTipoMovimiento();
            }
        });

        //Comienza el registro activando algunos componentes y desactivando otros
        btnRegistrar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Validar que se haya seleccionado un tipo de movimiento
                if (tipoMovimientoSeleccionado == null) {
                    MessageBox.AlertDialog(AsistenciaGeneralActivity.this, 
                        "Tipo de Movimiento Requerido", 
                        "Por favor, seleccione un tipo de movimiento antes de comenzar el registro.", 
                        false);
                    return;
                }
                BuscarRegistros();
            }
        });

        etLecturaPDA.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {

                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    try{
                        LeerAndSaveCodigo();
                        return true; // CONSUMIR el evento para que NO se propague
                    }catch(Exception ex){
                        UTIL.SonidoError(AsistenciaGeneralActivity.this);
                        MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error en lectura", ex.getMessage(), false);
                        return true; // CONSUMIR el evento incluso si hay error
                    }

                }
                return false; // NO consumir otros eventos (teclas normales)
            }
        });

        btnLeerCodigo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LeerAndSaveCodigo();
            }
        });

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AsistenciaOpcionesActivity.class));
                finish();
            }
        });
    }

    private void LeerAndSaveCodigo() {
        String lsLecturaPDA = etLecturaPDA.getText().toString();
        etLecturaPDA.setText("");

        String datos[] = lsLecturaPDA.split("\\|");

        if(datos.length >= 1 && datos[0] != null && !datos[0].trim().isEmpty()) {
            String codTrabajador = datos[0];
            
            // Consultar los datos del trabajador
            new ObtenerTrabajadorTask(codTrabajador, lsLecturaPDA).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
            
        } else {
            UTIL.SonidoError(AsistenciaGeneralActivity.this);
            MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error en lectura", 
                    "El código leído está vacío o no es válido. Por favor, intente nuevamente.", false);
            etLecturaPDA.requestFocus();
        }
    }

    private void guardarAsistenciaTrabajador(BeanTrabajador trabajador, String lecturaPDA) {
        BeanAsistenciaHT580 beanAsistenciaHT580 = new BeanAsistenciaHT580();

        beanAsistenciaHT580.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
        beanAsistenciaHT580.setCodigo(trabajador.getCodTrabajador());

        // Usar el tipo de movimiento seleccionado del diálogo
        if (tipoMovimientoSeleccionado != null) {
            beanAsistenciaHT580.setFlagInOut(tipoMovimientoSeleccionado);
        } else {
            // Fallback: si no hay selección, mostrar error
            MessageBox.AlertDialog(AsistenciaGeneralActivity.this, 
                "Error", 
                "No se ha seleccionado un tipo de movimiento.", 
                false);
            return;
        }

        beanAsistenciaHT580.setFecMovimiento(UTIL.parseSqlDatetoString(UTIL.getSqlDateNow(), "dd/MM/yyyy hh:mm:ss"));

        //Grabo el cod usuario
        final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
        BeanUsuario userLogin = globalVariable.getUserLogin();

        beanAsistenciaHT580.setCodUsr(userLogin.getUsuario());
        beanAsistenciaHT580.setLecturaPDA(lecturaPDA);
        beanAsistenciaHT580.setFlagVerifyType("0");
        
        // Obtener la IP real del dispositivo (IPv4)
        String deviceIP = UTIL.getDeviceIPAddress();
        beanAsistenciaHT580.setDireccionIP(deviceIP);

        new GuardarAsistenciaTask(beanAsistenciaHT580).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
    }

    public void BuscarRegistros() {
        String pFechaMovimiento, pFlagInOut = null;

        // Usar el tipo de movimiento seleccionado
        if (tipoMovimientoSeleccionado != null) {
            pFlagInOut = tipoMovimientoSeleccionado;
        } else {
            MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error",
                    "Debe seleccionar un tipo de movimiento antes de continuar", false);
            return;
        }

        pFechaMovimiento = etFechaMovimiento.getText().toString();

        new BuscarAsistenciaTask(pFechaMovimiento, pFlagInOut).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
    }

    private void InitControllers() {

        //Creo el objeto para el UI de esta ventana
        asistenciaUI = new AsistenciaUI(this);

        tvOrigen = (TextView) findViewById(R.id.tvOrigen);
        tvNombreEmpresa = (TextView) findViewById(R.id.tvNombreEmpresa);
        ivLogoEmpresa = (ImageView) findViewById(R.id.ivLogoEmpresa);

        // Reloj digital del servidor
        tvServerDate = (TextView) findViewById(R.id.tvServerDate);
        tvServerTime = (TextView) findViewById(R.id.tvServerTime);
        ivConnectionStatus = (ImageView) findViewById(R.id.ivConnectionStatus);
        
        // Título de la tabla de asistencias con contador
        tvTituloTablaAsistencia = (TextView) findViewById(R.id.tvTituloTablaAsistencia);

        etFechaMovimiento = (EditText) findViewById(R.id.etFechaMovimiento);
        ibFechaMovimiento = (ImageButton)findViewById(R.id.ibFechaMovimiento);
        etHoraMovimiento = (EditText) findViewById(R.id.etHoraMovimiento);
        etLecturaPDA = (EditText) findViewById(R.id.etLecturaPDA);

        // Nuevos controles para tipo de movimiento
        btnSeleccionarTipoMovimiento = (Button) findViewById(R.id.btnSeleccionarTipoMovimiento);
        llTipoMovimientoSeleccionado = (LinearLayout) findViewById(R.id.llTipoMovimientoSeleccionado);
        tvTipoMovimientoSeleccionado = (TextView) findViewById(R.id.tvTipoMovimientoSeleccionado);

        btnRegistrar = (Button) findViewById(R.id.btnRegistrar);
        btnLeerCodigo = (Button) findViewById(R.id.btnLeerCodigo);
        btnSalir = (Button) findViewById(R.id.btnSalir);
        
        // Inicializar servicio de reloj del servidor
        initServerClock();
        
        // Cargar información de la empresa
        cargarInformacionEmpresa();

    }

    /**
     * Carga la información de la empresa (logo y nombre) en la barra de título
     */
    private void cargarInformacionEmpresa() {
        try {
            if (ImplEmpresa.empresaDefault != null) {
                // Mostrar nombre de empresa
                tvNombreEmpresa.setText(ImplEmpresa.empresaDefault.getRazonSocial());
                
                // Cargar logo desde Base64 si existe
                if (ImplEmpresa.empresaDefault.getLogoBase64() != null && 
                    !ImplEmpresa.empresaDefault.getLogoBase64().isEmpty()) {
                    try {
                        byte[] decodedString = Base64.decode(ImplEmpresa.empresaDefault.getLogoBase64(), Base64.DEFAULT);
                        Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
                        ivLogoEmpresa.setImageBitmap(decodedByte);
                    } catch (Exception e) {
                        android.util.Log.e("AsistenciaGeneral", "Error al cargar logo: " + e.getMessage());
                        // Si falla, usar logo por defecto
                        ivLogoEmpresa.setImageResource(R.drawable.icono_empresa);
                    }
                } else {
                    // Si no tiene logo, usar icono por defecto
                    ivLogoEmpresa.setImageResource(R.drawable.icono_empresa);
                }
            }
        } catch (Exception e) {
            android.util.Log.e("AsistenciaGeneral", "Error en cargarInformacionEmpresa: " + e.getMessage());
        }
    }

    /**
     * Inicializa el servicio de reloj del servidor
     * Nota: El servicio global de sincronización ya está corriendo en segundo plano
     */
    private void initServerClock() {
        serverClockService = new ServerClockService(this, new ServerClockService.ClockUpdateListener() {
            @Override
            public void onTimeUpdate(String dateTime, boolean isServerConnected) {
                updateClockDisplay(dateTime);
            }

            @Override
            public void onConnectionStatusChanged(boolean isConnected) {
                updateConnectionStatus(isConnected);
            }
        });
        
        // Iniciar el servicio de visualización del reloj
        // (El servicio global ya maneja la sincronización de hora del dispositivo)
        serverClockService.start();
    }
    
    /**
     * Actualiza la visualización del reloj
     * @param dateTime String con formato "dd/MM/yyyy hh:mm:ss a"
     */
    private void updateClockDisplay(String dateTime) {
        try {
            // Parsear la fecha/hora
            String[] parts = dateTime.split(" ");
            
            if (parts.length >= 3) {
                String date = parts[0]; // dd/MM/yyyy
                String time = parts[1] + " " + parts[2]; // hh:mm:ss AM/PM
                
                // Actualizar los TextViews
                tvServerDate.setText(date);
                tvServerTime.setText(time);
                
                // Actualizar campos ocultos para compatibilidad
                etFechaMovimiento.setText(date);
                etHoraMovimiento.setText(parts[1]); // Solo hh:mm:ss
            }
        } catch (Exception e) {
            android.util.Log.e("AsistenciaGeneral", "Error al actualizar reloj: " + e.getMessage());
        }
    }
    
    /**
     * Actualiza el indicador de estado de conexión
     * @param isConnected true si está conectado al servidor, false si usa hora local
     */
    private void updateConnectionStatus(boolean isConnected) {
        if (isConnected) {
            // Verde: conectado al servidor
            ivConnectionStatus.setColorFilter(0xFF4CAF50); // Verde
            ivConnectionStatus.setImageResource(android.R.drawable.presence_online);
        } else {
            // Rojo: sin conexión, usando hora local
            ivConnectionStatus.setColorFilter(0xFFF44336); // Rojo
            ivConnectionStatus.setImageResource(android.R.drawable.presence_busy);
        }
    }
    
    private void actionExit() {
        // Detener el servicio de reloj antes de salir
        if (serverClockService != null) {
            serverClockService.stop();
        }
        
        startActivity(new Intent(getApplicationContext(), HomeActivity.class));
        finish();
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Detener el servicio de reloj al destruir la actividad
        if (serverClockService != null) {
            serverClockService.stop();
        }
    }
    
    @Override
    protected void onPause() {
        super.onPause();
        // Detener el servicio cuando la actividad no está visible
        if (serverClockService != null) {
            serverClockService.stop();
        }
    }
    
    @Override
    protected void onResume() {
        super.onResume();
        // Reiniciar el servicio cuando la actividad vuelve a estar visible
        if (serverClockService != null && !serverClockService.isRunning()) {
            serverClockService.start();
        }
    }

    private void drawPedido(List<BeanAsistenciaHT580> listaAsistencia) {

        asistenciaUI.drawListadoAsistencia(listaAsistencia);

        // Actualizar el contador en el título de la tabla
        int cantidadRegistros = 0;
        if (listaAsistencia != null) {
            // Si el primer elemento tiene IsOk = false, significa que no hay registros
            if (listaAsistencia.size() > 0 && listaAsistencia.get(0).getIsOk()) {
                cantidadRegistros = listaAsistencia.size();
            }
        }
        tvTituloTablaAsistencia.setText(String.format("📋 CONSULTA DE ASISTENCIA (%d)", cantidadRegistros));

    }

    //Subclase para definir algunas tareas de busqueda de segundo plano
    private class BuscarAsistenciaTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, _fecMovimiento, _codUsuario, _flagInOut;
        private ProgressDialog pDialog;
        private ImplAsistencia implAsistencia = null;
        private BeanUsuario userLogin = null;
        private long taskCreationTime;

        public BuscarAsistenciaTask(String pFecMovimiento, String pFlagInOut){
            _fecMovimiento = pFecMovimiento;
            _flagInOut = pFlagInOut;
            this.taskCreationTime = System.currentTimeMillis();
            android.util.Log.i("AsistenciaGeneral", "[MOBILE] BuscarAsistenciaTask CREADO | Fecha: " + pFecMovimiento + " | Flag: " + pFlagInOut + " | Tiempo creación: " + taskCreationTime);
        }

        protected void onPreExecute() {
            long preExecuteTime = System.currentTimeMillis();
            long delayFromCreation = preExecuteTime - taskCreationTime;
            android.util.Log.i("AsistenciaGeneral", "[MOBILE] BuscarAsistenciaTask onPreExecute() ejecutado | Delay desde creación: " + delayFromCreation + " ms");
            
            super.onPreExecute();
            pDialog = new ProgressDialog(AsistenciaGeneralActivity.this);
            pDialog.setMessage("Buscando el registro de Asitencia, por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            long startTime = System.currentTimeMillis();
            try {
                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                _codUsuario = userLogin.getUsuario();

                // OPTIMIZACIÓN 1: Verificar caché primero
                String cacheKey = _fecMovimiento + "|" + _flagInOut + "|" + _codUsuario;
                List<BeanAsistenciaHT580> asistenciaCacheada = ASISTENCIA_CACHE.get(cacheKey);
                if (asistenciaCacheada != null) {
                    android.util.Log.i("AsistenciaGeneral", "[MOBILE] BuscarAsistenciaTask: Resultados encontrados en CACHÉ | Key: " + cacheKey + " | Tiempo: " + (System.currentTimeMillis() - startTime) + " ms");
                    listaAsistencia = asistenciaCacheada;
                    return true;
                }

                // Si no está en caché, hacer llamada SOAP
                android.util.Log.i("AsistenciaGeneral", "[MOBILE] BuscarAsistenciaTask: Consultando servidor | Fecha: " + _fecMovimiento + " | Flag: " + _flagInOut);
                implAsistencia = new ImplAsistencia(ImplEmpresa.empresaDefault.getCodigo());

                //LLenado de Lista para los cursos - ordenado por fecha de marcación DESC
                listaAsistencia = implAsistencia.getAsistenciaByFechaAndUserOrderByMarcacion(_fecMovimiento, _flagInOut, _codUsuario);

                // OPTIMIZACIÓN 2: Guardar en caché (con límite de tamaño)
                if (ASISTENCIA_CACHE.size() >= MAX_ASISTENCIA_CACHE_SIZE) {
                    // Eliminar el más antiguo (simple: eliminar el primero)
                    String firstKey = ASISTENCIA_CACHE.keySet().iterator().next();
                    ASISTENCIA_CACHE.remove(firstKey);
                    android.util.Log.d("AsistenciaGeneral", "[MOBILE] Caché de asistencia lleno, eliminando: " + firstKey);
                }
                ASISTENCIA_CACHE.put(cacheKey, listaAsistencia);
                android.util.Log.i("AsistenciaGeneral", "[MOBILE] BuscarAsistenciaTask: Resultados guardados en CACHÉ | Key: " + cacheKey + " | Tiempo total: " + (System.currentTimeMillis() - startTime) + " ms");

                return true;

            } catch (Exception ex) {
                android.util.Log.e("AsistenciaGeneral", "[MOBILE] BuscarAsistenciaTask: Error | Tiempo total: " + (System.currentTimeMillis() - startTime) + " ms | Error: " + ex.getMessage());
                mensaje =  ex.getMessage();
                ex.printStackTrace();
                return false;
            }finally {
                implAsistencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    drawPedido(listaAsistencia);

                    // Deshabilitar controles después de comenzar el registro
                    btnSeleccionarTipoMovimiento.setEnabled(false);
                    btnRegistrar.setEnabled(false);
                    etFechaMovimiento.setEnabled(false);
                    ibFechaMovimiento.setEnabled(false);

                    btnLeerCodigo.setEnabled(true);
                    etLecturaPDA.setEnabled(true);
                    etLecturaPDA.requestFocus();


                } else {
                    UTIL.SonidoError(AsistenciaGeneralActivity.this);
                    MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error al recuperar registros", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                }



            }

        }

    }

    //Subclase para garduar las asistencias en segundo plano
    private class GuardarAsistenciaTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        BeanAsistenciaHT580 _beanAsistenciaHT580 = null;
        private ProgressDialog pDialog;
        private ImplAsistencia implAsistencia = null;
        private BeanUsuario userLogin = null;
        private long taskCreationTime;

        public GuardarAsistenciaTask(BeanAsistenciaHT580 value){
            _beanAsistenciaHT580 = value;
            this.taskCreationTime = System.currentTimeMillis();
            android.util.Log.i("AsistenciaGeneral", "[MOBILE] GuardarAsistenciaTask CREADO | Trabajador: " + 
                (value != null ? value.getCodigo() : "null") + " | Tiempo creación: " + taskCreationTime);
        }

        protected void onPreExecute() {
            long preExecuteTime = System.currentTimeMillis();
            long delayFromCreation = preExecuteTime - taskCreationTime;
            android.util.Log.i("AsistenciaGeneral", "[MOBILE] GuardarAsistenciaTask onPreExecute() ejecutado | Delay desde creación: " + delayFromCreation + " ms");
            
            super.onPreExecute();
            
            // IMPORTANTE: Pausar el reloj durante la transacción de asistencia
            if (serverClockService != null && serverClockService.isRunning()) {
                serverClockService.pause();
            }
            
            pDialog = new ProgressDialog(AsistenciaGeneralActivity.this);
            pDialog.setMessage("Grabando el registro de Asitencia, por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                _beanAsistenciaHT580.setCodUsr(userLogin.getUsuario());

                implAsistencia = new ImplAsistencia(ImplEmpresa.empresaDefault.getCodigo());

                //LLenado de Lista para los cursos
                implAsistencia.saveAsistencia(_beanAsistenciaHT580);

                // OPTIMIZACIÓN: Invalidar caché de asistencia después de guardar
                // Esto asegura que la próxima búsqueda obtenga datos actualizados
                invalidarCacheAsistencia();

                return true;

            } catch (Exception ex) {
                mensaje =  ex.getMessage();
                ex.printStackTrace();
                return false;
            }finally {
                implAsistencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    BuscarRegistros();

                    btnLeerCodigo.setEnabled(true);
                    etLecturaPDA.setEnabled(true);
                    etLecturaPDA.requestFocus();


                } else {
                    UTIL.SonidoError(AsistenciaGeneralActivity.this);
                    MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error al guardar asistencia", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                
                // IMPORTANTE: Reanudar el reloj después de la transacción
                if (serverClockService != null && serverClockService.isRunning()) {
                    serverClockService.resume();
                }

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                }



            }

        }

    }

    //AsyncTask para obtener los datos del trabajador
    private class ObtenerTrabajadorTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        String _codTrabajador;
        String _lecturaPDA;
        BeanTrabajador _trabajador = null;
        private ProgressDialog pDialog;
        private ImplAsistencia implAsistencia = null;
        private long taskCreationTime;

        public ObtenerTrabajadorTask(String codTrabajador, String lecturaPDA){
            _codTrabajador = codTrabajador;
            _lecturaPDA = lecturaPDA;
            this.taskCreationTime = System.currentTimeMillis();
            android.util.Log.i("AsistenciaGeneral", "[MOBILE] ObtenerTrabajadorTask CREADO | Código: " + codTrabajador + " | Tiempo creación: " + taskCreationTime);
        }

        protected void onPreExecute() {
            long preExecuteTime = System.currentTimeMillis();
            long delayFromCreation = preExecuteTime - taskCreationTime;
            android.util.Log.i("AsistenciaGeneral", "[MOBILE] ObtenerTrabajadorTask onPreExecute() ejecutado | Delay desde creación: " + delayFromCreation + " ms");
            
            super.onPreExecute();
            pDialog = new ProgressDialog(AsistenciaGeneralActivity.this);
            pDialog.setMessage("Consultando datos del trabajador, por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            long startTime = System.currentTimeMillis();
            try {
                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                // OPTIMIZACIÓN 1: Validar formato del código antes de hacer llamada SOAP
                if (_codTrabajador == null || _codTrabajador.trim().isEmpty()) {
                    mensaje = "El código del trabajador está vacío";
                    return false;
                }
                
                String codTrabajadorNormalizado = _codTrabajador.trim().toUpperCase();
                
                // OPTIMIZACIÓN 2: Verificar caché primero
                BeanTrabajador trabajadorCacheado = TRABAJADORES_CACHE.get(codTrabajadorNormalizado);
                if (trabajadorCacheado != null) {
                    android.util.Log.i("AsistenciaGeneral", "[MOBILE] ObtenerTrabajadorTask: Trabajador encontrado en CACHÉ | Código: " + codTrabajadorNormalizado + " | Tiempo: " + (System.currentTimeMillis() - startTime) + " ms");
                    _trabajador = trabajadorCacheado;
                    return true;
                }

                // Si no está en caché, hacer llamada SOAP
                android.util.Log.i("AsistenciaGeneral", "[MOBILE] ObtenerTrabajadorTask: Consultando servidor | Código: " + codTrabajadorNormalizado);
                implAsistencia = new ImplAsistencia(ImplEmpresa.empresaDefault.getCodigo());

                // Obtener los datos del trabajador
                _trabajador = implAsistencia.getTrabajadorByCodigo(codTrabajadorNormalizado);

                if (_trabajador == null) {
                    mensaje = "No se encontraron datos del trabajador con código: " + codTrabajadorNormalizado;
                    return false;
                }

                // OPTIMIZACIÓN 3: Guardar en caché (con límite de tamaño)
                if (TRABAJADORES_CACHE.size() >= MAX_CACHE_SIZE) {
                    // Eliminar el más antiguo (simple: eliminar el primero)
                    String firstKey = TRABAJADORES_CACHE.keySet().iterator().next();
                    TRABAJADORES_CACHE.remove(firstKey);
                    android.util.Log.d("AsistenciaGeneral", "[MOBILE] Caché de trabajadores lleno, eliminando: " + firstKey);
                }
                TRABAJADORES_CACHE.put(codTrabajadorNormalizado, _trabajador);
                android.util.Log.i("AsistenciaGeneral", "[MOBILE] ObtenerTrabajadorTask: Trabajador guardado en CACHÉ | Código: " + codTrabajadorNormalizado + " | Tiempo total: " + (System.currentTimeMillis() - startTime) + " ms");

                // YA NO VALIDAMOS si está activo o cesado aquí
                // El diálogo DialogConfirmarAsistencia se encargará de mostrarlo adecuadamente
                return true;

            } catch (Exception ex) {
                android.util.Log.e("AsistenciaGeneral", "[MOBILE] ObtenerTrabajadorTask: Error | Tiempo total: " + (System.currentTimeMillis() - startTime) + " ms | Error: " + ex.getMessage());
                mensaje = "Error al consultar datos del trabajador: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implAsistencia = null;
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result && _trabajador != null) {
                    // Verificar si ES EL CUMPLEAÑOS del trabajador
                    // SOLO si está activo, no cesado Y es INGRESO A PLANTA (tipo "1")
                    if (esCumpleaniosTrabajador(_trabajador) && 
                        !_trabajador.estaInactivo() && 
                        !_trabajador.estaCesado() &&
                        "1".equals(tipoMovimientoSeleccionado)) {
                        // ¡ES SU CUMPLEAÑOS Y ES INGRESO A PLANTA! Mostrar animación primero
                        mostrarAnimacionCumpleanios(_trabajador, _lecturaPDA);
                    } else {
                        // No es su cumpleaños, está inactivo/cesado, o no es ingreso a planta
                        // Proceder normalmente
                        mostrarDialogOGuardar(_trabajador, _lecturaPDA);
                    }
                } else {
                    UTIL.SonidoError(AsistenciaGeneralActivity.this);
                    MessageBox.AlertDialog(AsistenciaGeneralActivity.this, "Error", mensaje, false);
                    etLecturaPDA.requestFocus();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                try {
                    pDialog.dismiss();
                } catch (Exception ex) {
                }
            }
        }
    }

    private void mostrarDialogConfirmacion(final BeanTrabajador trabajador, final String lecturaPDA) {
        DialogConfirmarAsistencia dialog = new DialogConfirmarAsistencia(
            AsistenciaGeneralActivity.this,
            trabajador,
            new DialogConfirmarAsistencia.OnConfirmListener() {
                @Override
                public void onConfirm(BeanTrabajador trabajador) {
                    // El usuario confirmó, proceder a guardar la asistencia
                    guardarAsistenciaTrabajador(trabajador, lecturaPDA);
                }

                @Override
                public void onCancel() {
                    // El usuario canceló, limpiar input y dar foco
                    etLecturaPDA.setText("");
                    etLecturaPDA.requestFocus();
                }
            }
        );
        dialog.show();
    }
    
    /**
     * Verifica si HOY es el cumpleaños del trabajador (día y mes coinciden)
     */
    private boolean esCumpleaniosTrabajador(BeanTrabajador trabajador) {
        try {
            String fechaNacimiento = trabajador.getFechaNacimiento();
            if (fechaNacimiento == null || fechaNacimiento.isEmpty()) {
                return false;
            }
            
            // Formato esperado: dd/MM/yyyy
            String[] partes = fechaNacimiento.split("/");
            if (partes.length != 3) {
                return false;
            }
            
            int diaNacimiento = Integer.parseInt(partes[0]);
            int mesNacimiento = Integer.parseInt(partes[1]);
            
            // Obtener día y mes actuales
            java.util.Calendar cal = java.util.Calendar.getInstance();
            int diaActual = cal.get(java.util.Calendar.DAY_OF_MONTH);
            int mesActual = cal.get(java.util.Calendar.MONTH) + 1; // Calendar.MONTH es 0-based
            
            // Comparar solo día y mes
            return (diaNacimiento == diaActual && mesNacimiento == mesActual);
            
        } catch (Exception e) {
            android.util.Log.e("AsistenciaGeneral", "Error al verificar cumpleaños: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Muestra la animación de cumpleaños y luego el diálogo de confirmación
     */
    private void mostrarAnimacionCumpleanios(final BeanTrabajador trabajador, final String lecturaPDA) {
        pe.com.sytco.fastsales.Dialog.DialogBirthdayAnimation birthdayDialog = 
            new pe.com.sytco.fastsales.Dialog.DialogBirthdayAnimation(
                AsistenciaGeneralActivity.this,
                trabajador.getNombreCompleto(),
                new pe.com.sytco.fastsales.Dialog.DialogBirthdayAnimation.OnAnimationFinishedListener() {
                    @Override
                    public void onAnimationFinished() {
                        // Después de la animación, mostrar el diálogo normal de confirmación
                        mostrarDialogOGuardar(trabajador, lecturaPDA);
                    }
                }
            );
        birthdayDialog.show();
    }
    
    /**
     * Muestra el diálogo de confirmación SIEMPRE (tenga o no foto)
     */
    private void mostrarDialogOGuardar(BeanTrabajador trabajador, String lecturaPDA) {
        // SIEMPRE mostrar el diálogo de confirmación, tenga o no foto
        // Si no tiene foto, el diálogo mostrará una imagen genérica
        mostrarDialogConfirmacion(trabajador, lecturaPDA);
    }

    /**
     * Invalida el caché de asistencia (se llama después de guardar/eliminar)
     * Método estático para que pueda ser llamado desde otras clases (ej: AsistenciaUI)
     */
    public static void invalidarCacheAsistencia() {
        ASISTENCIA_CACHE.clear();
        android.util.Log.i("AsistenciaGeneral", "[MOBILE] Caché de asistencia invalidado (después de guardar/eliminar)");
    }
    
    /**
     * Limpia el caché de trabajadores (útil si hay cambios en el servidor)
     */
    public static void limpiarCacheTrabajadores() {
        TRABAJADORES_CACHE.clear();
        android.util.Log.i("AsistenciaGeneral", "[MOBILE] Caché de trabajadores limpiado");
    }
    
    /**
     * Muestra el diálogo profesional para seleccionar el tipo de movimiento
     */
    private void mostrarDialogoSeleccionTipoMovimiento() {
        DialogSeleccionarTipoMovimiento dialog = new DialogSeleccionarTipoMovimiento(
            AsistenciaGeneralActivity.this,
            new DialogSeleccionarTipoMovimiento.OnTipoMovimientoSelectedListener() {
                @Override
                public void onTipoMovimientoSelected(String tipoMovimiento, String descripcion) {
                    // Guardar la selección
                    tipoMovimientoSeleccionado = tipoMovimiento;
                    descripcionMovimientoSeleccionado = descripcion;
                    
                    // Mostrar la selección en la UI
                    tvTipoMovimientoSeleccionado.setText(tipoMovimiento + " - " + descripcion);
                    llTipoMovimientoSeleccionado.setVisibility(View.VISIBLE);
                    
                    // Log para debugging
                    android.util.Log.i("AsistenciaGeneral", 
                        "Tipo de movimiento seleccionado: " + tipoMovimiento + " - " + descripcion);
                }

                @Override
                public void onCancel() {
                    // El usuario canceló la selección
                    android.util.Log.i("AsistenciaGeneral", "Selección de tipo de movimiento cancelada");
                }
            }
        );
        dialog.show();
    }

}