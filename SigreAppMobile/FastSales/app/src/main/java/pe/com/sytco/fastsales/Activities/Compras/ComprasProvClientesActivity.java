package pe.com.sytco.fastsales.Activities.Compras;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.List;

import dmax.dialog.SpotsDialog;
import pe.com.sytco.fastsales.Controller.Compras.ImplDirecciones;
import pe.com.sytco.fastsales.Controller.Compras.ImplProveedor;
import pe.com.sytco.fastsales.Controller.Compras.ImplTipoDocRTPS;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewDireccionAdapter;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanDirecciones;
import pe.com.sytco.fastsales.beans.Compras.BeanProveedor;
import pe.com.sytco.fastsales.beans.Compras.BeanTipoDocRTPS;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

import static pe.com.sytco.fastsales.R.id;
import static pe.com.sytco.fastsales.R.layout;

public class ComprasProvClientesActivity extends AppCompatActivity implements OnMapReadyCallback {

    //Interfaz de Usuario
    Spinner spTipoDoc;
    EditText etNroDocIdent, etRazonSocial, etApelPaterno, etApelMaterno, etNombre1, etNombre2,
             etEmail, etCodigo;
    Button btnSalir, btnGrabar, btnBuscar, btnNuevoCliente, btnAddTienda;
    TextView tvMensaje, tvNroTiendas;
    LinearLayout llSegment;
    ListView lvListadoTiendas;


    private GoogleMap mMap;
    private SupportMapFragment mMapFragment;
    private LocationRequest locationRequest;
    private FusedLocationProviderClient fusedLocation;
    private final static int LOCATION_REQUEST_CODE = 1;
    private String codCliente = null;

    private TabHost TbH;

    //DAtos para el cliente
    BeanProveedor beanCliente;
    List<BeanDirecciones> listaDirecciones = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(layout.activity_compras_prov_clientes);

        Bundle bundle = getIntent().getExtras();
        if (bundle != null)
            codCliente = (String) bundle.getSerializable("codCliente");
        else
            codCliente = null;

        InitControllers();

        AsignarEventos();

        LoadDataDefault();


    }

    private void InitControllers() {
        spTipoDoc = (Spinner) findViewById(id.spTipoDoc);

        tvMensaje = (TextView) findViewById(id.tvMensaje);
        tvNroTiendas = (TextView) findViewById(id.tvNroTiendas);

        etCodigo = (EditText) findViewById(id.etCodigo);
        etNroDocIdent = (EditText) findViewById(id.etNroDocIdent);
        etRazonSocial = (EditText) findViewById(id.etRazonSocial);
        etApelPaterno = (EditText) findViewById(id.etApelPaterno);
        etApelMaterno = (EditText) findViewById(id.etApelMaterno);
        etNombre1 = (EditText) findViewById(id.etNombre1);
        etNombre2 = (EditText) findViewById(id.etNombre2);
        etEmail = (EditText) findViewById(id.etEmail);

        btnNuevoCliente = (Button) findViewById(id.btnNuevoCliente);
        btnBuscar = (Button) findViewById(id.btnBuscar);
        btnAddTienda = (Button) findViewById(id.btnAddTienda);
        btnGrabar = (Button) findViewById(id.btnGrabar);
        btnSalir = (Button) findViewById(id.btnSalir);

        TbH = (TabHost) findViewById(id.tabHost); //llamamos al Tabhost
        llSegment = (LinearLayout) findViewById(id.llSegment); //llamamos al Tabhost
        lvListadoTiendas = (ListView) findViewById(id.lvListadoTiendas);

        fusedLocation = LocationServices.getFusedLocationProviderClient(this);

        mMapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(id.mapClient);
        mMapFragment.getMapAsync(this);
    }

    private void AsignarEventos() {
        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), ComprasOpcionesActivity.class));
                finish();
            }
        });

        btnBuscar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String ls_tipoDocIdent, ls_nroDocIdent;

                //Validacion minima antes de comenzar la busqueda

                if (spTipoDoc.getSelectedItem() == null){
                    UTIL.SonidoCampanilla(ComprasProvClientesActivity.this);
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en Validación de documento",
                            "Debe elegir un tipo de documento de IDENTIFICACION", false);
                    spTipoDoc.requestFocus();
                    return;
                }

                if(etNroDocIdent.getText() == null || etNroDocIdent.getText().toString() == null || etNroDocIdent.getText().toString().isEmpty()){
                    UTIL.SonidoCampanilla(ComprasProvClientesActivity.this);
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en Validación de documento",
                            "Debe ingresar un NUMERO DE DOCUMENTO", false);
                    etNroDocIdent.requestFocus();
                    return;
                }

                ls_tipoDocIdent = ((BeanTipoDocRTPS)spTipoDoc.getSelectedItem()).getTipoDocRTPS();
                ls_nroDocIdent = etNroDocIdent.getText().toString();

                if (ls_tipoDocIdent.equals("6") && ls_nroDocIdent.trim().length() != 11){
                    UTIL.SonidoCampanilla(ComprasProvClientesActivity.this);
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en Validación de documento", "El RUC debe ser de 11 digitos", false);
                    return;
                }

                if (ls_tipoDocIdent.equals("1") && ls_nroDocIdent.trim().length() != 8){
                    UTIL.SonidoCampanilla(ComprasProvClientesActivity.this);
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en Validación de documento", "El DNI debe ser de 8 digitos", false);
                    return;
                }

                new BuscarDatosTask().execute();
            }
        });

        btnNuevoCliente.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ResetDatos();

                spTipoDoc.setEnabled(true);
                etNroDocIdent.setEnabled(true);

                llSegment.setVisibility(View.INVISIBLE);
                btnGrabar.setVisibility(View.INVISIBLE);
                btnNuevoCliente.setEnabled(false);
                btnBuscar.setVisibility(View.VISIBLE);

                etNroDocIdent.requestFocus();

            }
        });
        btnAddTienda.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if(etCodigo.getText() == null || etCodigo.getText().toString() == null || etCodigo.getText().toString().isEmpty()){
                    UTIL.SonidoCampanilla(ComprasProvClientesActivity.this);
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en Validación de documento",
                            "El Cliente debe tener un Codigo para adicionar alguna Direccion, por favor grabe la cabecera", false);
                    etNroDocIdent.requestFocus();
                    return;
                }

                BeanDirecciones beanDireccion = new BeanDirecciones();
                beanDireccion.setCodigo(etCodigo.getText().toString());

                Intent intent = new Intent(getApplicationContext(), ComprasAddDireccionActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("direccionSelected", beanDireccion);
                intent.putExtras(bundle);


                startActivity(intent);
                //finish();
            }
        });

        btnGrabar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                GrabarCliente();
            }
        });
    }

    private void GrabarCliente() {
        String ls_tipoDocRTPS = ((BeanTipoDocRTPS) spTipoDoc.getSelectedItem()).getTipoDocRTPS();
        String ls_nroDocIdent = etNroDocIdent.getText().toString();
        String ls_RUCDNI = "", ls_FlagPersoneria = "", ls_razonSocial = "";

        if (ls_nroDocIdent.isEmpty()){
            MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "Debe indicar un nro de documento de Identidad", false);
            return;
        }

        if(ls_tipoDocRTPS.equals("6")){
            if (ls_nroDocIdent.length() != 11){
                MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC debe ser de 11 digitos", false);
                return;
            }

            if (ls_nroDocIdent.substring(1,2).equals("10")){

                if (etApelPaterno.getText().toString() == null || etApelPaterno.getText().toString().isEmpty()){
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC es de persona natural, " +
                                "por lo que debe ingresar el Apellido PATERNO", false);
                    return;
                }

                if (etApelMaterno.getText().toString() == null || etApelMaterno.getText().toString().isEmpty()){
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC es de persona natural, " +
                                "por lo que debe ingresar el Apellido MATERNO", false);
                    return;
                }

                if (etNombre1.getText().toString() == null || etNombre1.getText().toString().isEmpty()){
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC es de persona natural, " +
                            "por lo que debe ingresar el PRIMER NOMBRE", false);
                    return;
                }

                //Genero la razon social sobre el los componentes
                ls_razonSocial += etApelPaterno.getText().toString().trim() + " " + etApelMaterno.getText().toString().trim() + ", " + etNombre1.getText().toString().trim();

                if(etNombre2.getText().toString() != null &&  !etNombre2.getText().toString().isEmpty()){
                    ls_razonSocial += " " + etNombre2.getText().toString().trim();
                }

                etRazonSocial.setText(ls_razonSocial);
            }

            ls_RUCDNI = ls_nroDocIdent;
            ls_FlagPersoneria = "N";

        }else if(ls_tipoDocRTPS.equals("1")){
            if (ls_nroDocIdent.length() != 8){
                MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El DNI debe ser de 11 digitos", false);
                return;
            }

            if (etApelPaterno.getText().toString() == null || etApelPaterno.getText().toString().isEmpty()){
                MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC es de persona natural, " +
                        "por lo que debe ingresar el Apellido PATERNO", false);
                return;
            }

            if (etApelMaterno.getText().toString() == null || etApelMaterno.getText().toString().isEmpty()){
                MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC es de persona natural, " +
                        "por lo que debe ingresar el Apellido MATERNO", false);
                return;
            }

            if (etNombre1.getText().toString() == null || etNombre1.getText().toString().isEmpty()){
                MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error", "El RUC es de persona natural, " +
                        "por lo que debe ingresar el PRIMER NOMBRE", false);
                return;
            }

            //Genero la razon social sobre el los componentes
            ls_razonSocial += etApelPaterno.getText().toString().trim() + " " + etApelMaterno.getText().toString().trim() + ", " + etNombre1.getText().toString().trim();

            if(etNombre2.getText().toString() != null &&  !etNombre2.getText().toString().isEmpty()){
                ls_razonSocial += " " + etNombre2.getText().toString().trim();
            }

            etRazonSocial.setText(ls_razonSocial);

            if(ls_nroDocIdent.substring(1,2).equals("10")){
                ls_FlagPersoneria = "N";
            }else{
                ls_FlagPersoneria = "J";
            }

        }

        //Datos para el cliente
        beanCliente = new BeanProveedor();
        beanCliente.setProveedor(etCodigo.getText().toString());
        beanCliente.setNomProveedor(etRazonSocial.getText().toString());
        beanCliente.setTipoDocIdentidad(ls_tipoDocRTPS);
        beanCliente.setRucDni(ls_RUCDNI);
        beanCliente.setNroDocIdentidad(etNroDocIdent.getText().toString());
        beanCliente.setApelPaterno(etApelPaterno.getText().toString());
        beanCliente.setApelMaterno(etApelMaterno.getText().toString());
        beanCliente.setNombre1(etNombre1.getText().toString());
        beanCliente.setNombre2(etNombre2.getText().toString());
        beanCliente.setEmail(etEmail.getText().toString());
        beanCliente.setFlagPersoneria(ls_FlagPersoneria);

        new SaveClientTask().execute();
    }

    private void LoadDataDefault() {
        SetupTabHost();

        llSegment.setVisibility(View.GONE);
        btnGrabar.setVisibility(View.GONE);

        ResetDatos();

        startLocation();

        new LoadTipoDocRTPSTask().execute();
    }

    private void ResetDatos() {
        etNroDocIdent.setText("");
        etRazonSocial.setText("");
        etApelPaterno.setText("");
        etApelMaterno.setText("");
        etNombre1.setText("");
        etNombre2.setText("");
        etEmail.setText("");
        etCodigo.setText("");
        tvMensaje.setText("");
        tvNroTiendas.setText("0");
    }

    private void enableControles(boolean status) {
        etNroDocIdent.setEnabled(status);
        etRazonSocial.setEnabled(status);
        etApelPaterno.setEnabled(status);
        etApelMaterno.setEnabled(status);
        etNombre1.setEnabled(status);
        etNombre2.setEnabled(status);
        etEmail.setEnabled(status);
    }

    private void SetupTabHost() {
        //Creamos el tab
        TbH.setup();                                                         //lo activamos

        TabHost.TabSpec tab1 = TbH.newTabSpec("tab1");  //aspectos de cada Tab (pestaña)
        TabHost.TabSpec tab2 = TbH.newTabSpec("tab2");
        TabHost.TabSpec tab3 = TbH.newTabSpec("tab3");

        tab1.setIndicator("CABECERA");    //qué queremos que aparezca en las pestañas
        tab1.setContent(id.tab1); //definimos el id de cada Tab (pestaña)

        tab2.setIndicator("DIRECCIONES");
        tab2.setContent(id.tab2);

        tab3.setIndicator("MAPA");
        tab3.setContent(id.tab3);

        TbH.addTab(tab1); //añadimos los tabs ya programados
        TbH.addTab(tab2);
        TbH.addTab(tab3);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        mMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
        mMap.getUiSettings().setZoomControlsEnabled(true);

        locationRequest = new LocationRequest();
        //Valor entre 1000 y 3000
        locationRequest.setInterval(1000);
        locationRequest.setFastestInterval(1000);
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        locationRequest.setSmallestDisplacement(5);
    }

    private LocationCallback locationCallback = new LocationCallback(){
        @Override
        public void onLocationResult(LocationResult locationResult) {
            for(Location location : locationResult.getLocations()){
                if(getApplicationContext() != null){
                    //Generar la location del usuario en tiempo real
                    mMap.moveCamera(CameraUpdateFactory.newCameraPosition(
                            new CameraPosition.Builder()
                                    .target(new LatLng(location.getLatitude(), location.getLongitude()))
                                    .zoom(15f)
                                    .build()
                    ));
                }
            }
        }
    };

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if(requestCode == LOCATION_REQUEST_CODE){
            if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
                if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED){
                    fusedLocation.requestLocationUpdates(locationRequest, locationCallback, Looper.myLooper());
                }
            }
        }
    }

    private void startLocation(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED){
                fusedLocation.requestLocationUpdates(locationRequest, locationCallback, Looper.myLooper());
            }else{
                checkLocationPermissions();
            }
        }else{
            fusedLocation.requestLocationUpdates(locationRequest, locationCallback, Looper.myLooper());
        }
    }

    private void checkLocationPermissions(){
        if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_FINE_LOCATION)){
                new androidx.appcompat.app.AlertDialog.Builder(this)
                        .setTitle("Proporciona los permisos para continuar")
                        .setMessage("Esta aplicacion requiere de los permisos de ubicacion para utilizarse")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                ActivityCompat.requestPermissions(ComprasProvClientesActivity.this,
                                        new String[] {Manifest.permission.ACCESS_FINE_LOCATION},
                                        LOCATION_REQUEST_CODE);
                            }
                        })
                        .create()
                        .show();
            }else{
                ActivityCompat.requestPermissions(ComprasProvClientesActivity.this,
                        new String[] {Manifest.permission.ACCESS_FINE_LOCATION},
                        LOCATION_REQUEST_CODE);
            }
        }
    }

    private void parseObjectToFrame() {
        String ls_tipoDocIdent, ls_nroDocIdent;

        ls_tipoDocIdent = ((BeanTipoDocRTPS)spTipoDoc.getSelectedItem()).getTipoDocRTPS();
        ls_nroDocIdent = etNroDocIdent.getText().toString();

        UTIL.SonidoCorrecto(ComprasProvClientesActivity.this);

        //si el beanCliente guarda algo entonces lo muestro
        if (beanCliente.getIsOk()){
            etCodigo.setText(beanCliente.getProveedor());
            etRazonSocial.setText(beanCliente.getNomProveedor());
            etApelPaterno.setText(beanCliente.getApelPaterno());
            etApelMaterno.setText(beanCliente.getApelMaterno());
            etNombre1.setText(beanCliente.getNombre1());
            etNombre2.setText(beanCliente.getNombre2());
            etEmail.setText(beanCliente.getEmail());
            tvMensaje.setText("");

            enableControles(true);

        }else{
            //tvMensaje.setText(beanCliente.getMensaje());
            if (beanCliente.getIntReturn() == -1)
                Toast.makeText(ComprasProvClientesActivity.this, beanCliente.getMensaje(), Toast.LENGTH_LONG).show();

            etCodigo.setText("");
            etRazonSocial.setText("");
            etApelPaterno.setText("");
            etApelMaterno.setText("");
            etNombre1.setText("");
            etNombre2.setText("");
            etEmail.setText("");



            enableControles(true);
        }

        if (ls_tipoDocIdent.equals("1") || (ls_tipoDocIdent.equals("6") && ls_nroDocIdent.substring(1,2).equals("10"))) {
            etRazonSocial.setEnabled(false);

            etApelPaterno.setEnabled(true);
            etApelMaterno.setEnabled(true);
            etNombre1.setEnabled(true);
            etNombre2.setEnabled(true);

            etApelPaterno.requestFocus();

        }

        if(ls_tipoDocIdent.equals("6") && ls_nroDocIdent.substring(1,2).equals("20")){
            etRazonSocial.setEnabled(true);

            etApelPaterno.setEnabled(false);
            etApelMaterno.setEnabled(false);
            etNombre1.setEnabled(false);
            etNombre2.setEnabled(false);

            etRazonSocial.requestFocus();
        }

        //levanto las direcciones
        if (listaDirecciones == null){
            listaDirecciones = new ArrayList<BeanDirecciones>();
        }

        ArrayAdapter<BeanDirecciones> adapter = new ListViewDireccionAdapter(ComprasProvClientesActivity.this, listaDirecciones);

        lvListadoTiendas.setAdapter(adapter);

        tvNroTiendas.setText(UTIL.ConvetToString(listaDirecciones.size(), "###,##0"));

        llSegment.setVisibility(View.VISIBLE);
        btnGrabar.setVisibility(View.VISIBLE);
        btnBuscar.setVisibility(View.INVISIBLE);
        btnNuevoCliente.setEnabled(true);

        spTipoDoc.setEnabled(false);
        etNroDocIdent.setEnabled(false);
    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadTipoDocRTPSTask extends AsyncTask<Integer, Void, Boolean> {

        String mensaje;

        ImplTipoDocRTPS implTipoDocRTPS = null;
        private List<BeanTipoDocRTPS> listaTipoDocs;
        private AlertDialog mDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog.Builder(ComprasProvClientesActivity.this)
                            .setMessage("Se esta buscando los tipos de Documento")
                            .create();
            mDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //LLenado de Lista para los articulos
                System.out.println(LoadTipoDocRTPSTask.class + "doInBackground() START");

                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }


                implTipoDocRTPS = new ImplTipoDocRTPS(ImplEmpresa.empresaDefault.getCodigo());
                listaTipoDocs = implTipoDocRTPS.getAllActivos();

                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase LoadTipoDocRTPS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implTipoDocRTPS = null;
                System.out.println(LoadTipoDocRTPSTask.class + "doInBackground() END");
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //asigno el Arrat de documentos
                    ArrayAdapter<BeanTipoDocRTPS> langAdapter = new ArrayAdapter<BeanTipoDocRTPS>(ComprasProvClientesActivity.this,
                            layout.spinner_text, listaTipoDocs);
                    langAdapter.setDropDownViewResource(R.layout.simple_spinner_dropdown);

                    spTipoDoc.setAdapter(langAdapter);

                }else{
                    etNroDocIdent.requestFocus();
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error al cargar Tipos de Documentos", mensaje, false);
                }

                if (codCliente != null && !codCliente.isEmpty()){
                    new BuscarClienteTask().execute();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();

                } catch (Exception ex) {
                }

            }

        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class BuscarDatosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        private AlertDialog mDialog;
        private ImplProveedor implProveedor  = null;
        private ImplDirecciones implDirecciones = null;
        private BeanUsuario userLogin = null;
        private String ls_tipoDocIdent, ls_nroDocIdent, lsUsuario;
        boolean lbValidarSUNAT = false;

        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog.Builder(ComprasProvClientesActivity.this)
                        .setMessage("Un momento, validando la información")
                        .create();
            mDialog.show();

            ls_tipoDocIdent = ((BeanTipoDocRTPS)spTipoDoc.getSelectedItem()).getTipoDocRTPS();
            ls_nroDocIdent = etNroDocIdent.getText().toString();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }
                //Inserto la lectura en la base de datos de lectura
                lsUsuario = userLogin.getUsuario();

                //LLenado de Lista para los articulos
                implProveedor = new ImplProveedor(ImplEmpresa.empresaDefault.getCodigo());
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo los datos
                implProveedor.setContext(ComprasProvClientesActivity.this);

                if (implProveedor.isEnrolling(ls_tipoDocIdent, ls_nroDocIdent)){
                    beanCliente = implProveedor.getProveedorbyNroDoc(ls_tipoDocIdent, ls_nroDocIdent);
                    listaDirecciones = implDirecciones.getDirecciones(beanCliente.getProveedor());
                }else{
                    if (ls_tipoDocIdent.equals("6")){
                        //if (ImplEmpresa.beanParametros.getValidaSunat() != null && ImplEmpresa.beanParametros.getValidaSunat().equals("1")) {
                        //    beanCliente = implProveedor.buscarRucSUNAT(ls_nroDocIdent, lsUsuario);
                        //    listaDirecciones = implDirecciones.getDirecciones(beanCliente.getProveedor());
                        //}
                        lbValidarSUNAT = true;

                    }else{
                        //if (ImplEmpresa.beanParametros.getValidaReniec() != null && ImplEmpresa.beanParametros.getValidaReniec().equals("1")) {
                        //    beanCliente = implProveedor.buscarDNIReniec(ls_tipoDocIdent, ls_nroDocIdent, lsUsuario);
                        //    listaDirecciones = new ArrayList<BeanDirecciones>();
                        //}
                        beanCliente = new BeanProveedor();
                        listaDirecciones = new ArrayList<BeanDirecciones>();
                    }
                }



                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase BuscarDatosTask. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implProveedor = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    if(lbValidarSUNAT) {
                        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(ComprasProvClientesActivity.this);
                        dialogo1.setTitle("Verificar en SUNAT");
                        dialogo1.setMessage("¿ El RUC no esta registrado, desea buscarlo en los Servidores de SUNAT?");
                        dialogo1.setCancelable(false);
                        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialogo1, int id) {

                                try {
                                    new BuscarClienteSunatTask().execute();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }

                            }
                        });
                        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialogo1, int id) {
                                beanCliente = new BeanProveedor();
                                listaDirecciones = new ArrayList<BeanDirecciones>();
                                parseObjectToFrame();
                                dialogo1.dismiss();
                            }
                        });
                        dialogo1.show();
                    }else{
                        parseObjectToFrame();
                    }



                }else{
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en BuscarDatosTask", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();
                    beanCliente = null;

                } catch (Exception ex) {

                }

            }

        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class BuscarClienteTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        private AlertDialog mDialog;
        private ImplProveedor implProveedor  = null;
        private ImplDirecciones implDirecciones = null;

        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog.Builder(ComprasProvClientesActivity.this)
                        .setMessage("Cargando Datos del cliente")
                        .create();
            mDialog.show();

        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //LLenado de Lista para los articulos
                System.out.println(LoadTipoDocRTPSTask.class + ".doInBackground() START");

                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //LLenado de Lista para los articulos
                implProveedor = new ImplProveedor(ImplEmpresa.empresaDefault.getCodigo());
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo los datos
                implProveedor.setContext(ComprasProvClientesActivity.this);

                beanCliente = implProveedor.getOne(codCliente);
                listaDirecciones = implDirecciones.getDirecciones(beanCliente.getProveedor());

                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase BuscarClienteTask. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implProveedor = null;
                //LLenado de Lista para los articulos
                System.out.println(LoadTipoDocRTPSTask.class + ".doInBackground() END");
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {

                    parseObjectToFrame();

                }else{
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en BuscarDatosTask", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();
                    beanCliente = null;

                } catch (Exception ex) {

                }

            }

        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class BuscarClienteSunatTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        private AlertDialog mDialog;
        private ImplProveedor implProveedor  = null;
        private ImplDirecciones implDirecciones = null;
        private BeanUsuario userLogin = null;
        private String ls_tipoDocIdent, ls_nroDocIdent, lsUsuario;

        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog.Builder(ComprasProvClientesActivity.this)
                    .setMessage("Un momento, validando la información en Servidor de SUNAT")
                    .create();
            mDialog.show();

            ls_tipoDocIdent = ((BeanTipoDocRTPS)spTipoDoc.getSelectedItem()).getTipoDocRTPS();
            ls_nroDocIdent = etNroDocIdent.getText().toString();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }
                //Inserto la lectura en la base de datos de lectura
                lsUsuario = userLogin.getUsuario();

                //LLenado de Lista para los articulos
                implProveedor = new ImplProveedor(ImplEmpresa.empresaDefault.getCodigo());
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo los datos
                implProveedor.setContext(ComprasProvClientesActivity.this);

                if (implProveedor.isEnrolling(ls_tipoDocIdent, ls_nroDocIdent)){
                    beanCliente = implProveedor.getProveedorbyNroDoc(ls_tipoDocIdent, ls_nroDocIdent);
                    listaDirecciones = implDirecciones.getDirecciones(beanCliente.getProveedor());
                }else{
                    if (ls_tipoDocIdent.equals("6")){
                        if (ImplEmpresa.beanParametros.getValidaSunat() != null && ImplEmpresa.beanParametros.getValidaSunat().equals("1")) {
                            beanCliente = implProveedor.buscarRucSUNAT(ls_nroDocIdent, lsUsuario);
                            listaDirecciones = implDirecciones.getDirecciones(beanCliente.getProveedor());
                        }
                    }
                }

                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase BuscarDatosTask. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implProveedor = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    parseObjectToFrame();

                }else{
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error en BuscarClienteSUNAT", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();
                    beanCliente = null;

                } catch (Exception ex) {

                }

            }

        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class SaveClientTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        private AlertDialog mDialog;
        private ImplProveedor implProveedor;
        private BeanProveedor beanRpta;
        private BeanUsuario userLogin;



        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog.Builder(ComprasProvClientesActivity.this)
                        .setMessage("Espere un momento")
                        .create();
            mDialog.show();

        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                beanCliente.setUsuario(userLogin.getUsuario());

                //LLenado de Lista para los articulos
                implProveedor = new ImplProveedor(ImplEmpresa.empresaDefault.getCodigo());
                if (implProveedor.insertClient(beanCliente)){
                    beanRpta = implProveedor.getProveedorbyNroDoc(beanCliente.getTipoDocIdentidad(), beanCliente.getNroDocIdentidad());
                }

                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase LoadTipoDocRTPS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                beanCliente = null;
                implProveedor = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    etCodigo.setText(beanRpta.getProveedor());
                    UTIL.SonidoCorrecto(ComprasProvClientesActivity.this);
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Aviso", "Los datos se grabaron correctamente", true);
                }else{
                    etNroDocIdent.requestFocus();
                    MessageBox.AlertDialog(ComprasProvClientesActivity.this, "Error al cargar Tipos de Documentos", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();
                    beanCliente = null;

                } catch (Exception ex) {
                }

            }

        }

    }
}