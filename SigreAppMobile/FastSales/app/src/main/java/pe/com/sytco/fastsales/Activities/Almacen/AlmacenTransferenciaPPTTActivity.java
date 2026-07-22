package pe.com.sytco.fastsales.Activities.Almacen;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TabHost;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplLecturasCruiser;
import pe.com.sytco.fastsales.Controller.ImplListadoCajas;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteTransferencia;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewCajasAdapter;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.BeanLecturasCruiser;
import pe.com.sytco.fastsales.beans.ParteTransferencia.BeanParteTransferencia;
import pe.com.sytco.fastsales.beans.ParteTransferencia.BeanParteTransferenciaUnd;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class AlmacenTransferenciaPPTTActivity extends AppCompatActivity {

    //Interfaz
    private Button btnSalir, btnTransferir, btnListarCajas, btnLeerPalletOrg, btnLeerPalletDst;
    private EditText etFechaRecepcion, etNroPalletOrg, etNroPalletDst;
    private Spinner spAnaquelOrg, spFilaOrg, spColumnaOrg, spAnaquelDst, spFilaDst, spColumnaDst, spAlmacenOrg, spAlmacenDst;
    private TextView tvMensaje, tvNroRegistros, tvVersionName;
    private String _strNroPalletOrg, _strNroPalletDst;
    private ImageButton ibObtenerFecha;
    private BeanAlmacen almacenOrg,almacenDst;
    private ListView lvListadoCajas;
    private TabHost TbH;

    //DAtos
    List<BeanAlmacen> almacenesOrg, almacenesDst;

    //Listado de Cajas
    ArrayAdapter adaptador;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_almacen_transferencia_pptt);

            InitControllers();

            AsignarEventos();

            LoadDataDefault();

        } catch (PackageManager.NameNotFoundException e) {

            MessageBox.AlertDialog(this, "Error al crear el Activity", "Ha ocurrido una excepcion: " + e.getMessage(), false);
            e.printStackTrace();

        }
    }

    private void AsignarEventos() {
        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                finish();
            }
        });

        btnListarCajas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ListarCajasPallet();
            }
        });

        btnTransferir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
               TransferirPallet();
            }
        });

        //Boton para el boton de obtener fecha
        ibObtenerFecha.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenTransferenciaPPTTActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaRecepcion.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


                    }
                    //Estos valores deben ir en ese orden, de lo contrario no mostrara la fecha actual
                    /**
                     *También puede cargar los valores que usted desee
                     */
                },year, mes, dia);

                //Muestro el widget
                recogerFecha.show();
            }
        });
        //Capturo el enter en el lector de codigo de barra
        etNroPalletOrg.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    // Perform action on key press
                    if (etNroPalletOrg.getText() != null) {
                        etNroPalletOrg.setText(etNroPalletOrg.getText().toString().toUpperCase());

                        ListarAlmacenOrigen();
                        return true;
                    }

                }
                return false;
            }
        });
        btnLeerPalletOrg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ListarAlmacenOrigen();
            }
        });

        btnLeerPalletDst.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ListarAlmacenDestino();
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etNroPalletDst.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    // Perform action on key press
                    if (etNroPalletOrg.getText() != null) {
                        etNroPalletOrg.setText(etNroPalletOrg.getText().toString().toUpperCase());

                        ListarAlmacenDestino();
                        return true;
                    }

                }
                return false;
            }
        });

        spAlmacenOrg.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                almacenOrg = (BeanAlmacen) adapterView.getItemAtPosition(position);
                new AlmacenTransferenciaPPTTActivity.LoadAnaquelesOrgTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenOrg = null;
            }
        });

        spAnaquelOrg.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                String anaquel = (String) adapterView.getItemAtPosition(position);
                new AlmacenTransferenciaPPTTActivity.LoadFilasOrgTask(anaquel).execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenOrg = null;
            }
        });

        spFilaOrg.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                String anaquel = spAnaquelOrg.getSelectedItem().toString();
                String fila = (String) adapterView.getItemAtPosition(position);

                new AlmacenTransferenciaPPTTActivity.LoadColumnasOrgTask(anaquel, fila).execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenOrg = null;
            }
        });

        spAlmacenDst.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                almacenDst = (BeanAlmacen) adapterView.getItemAtPosition(position);
                new AlmacenTransferenciaPPTTActivity.LoadAnaquelesDstTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenOrg = null;
            }
        });

        spAnaquelDst.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                String anaquel = (String) adapterView.getItemAtPosition(position);
                new AlmacenTransferenciaPPTTActivity.LoadFilasDstTask(anaquel).execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenOrg = null;
            }
        });

        spFilaDst.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                String anaquel = spAnaquelDst.getSelectedItem().toString();
                String fila = (String) adapterView.getItemAtPosition(position);

                new AlmacenTransferenciaPPTTActivity.LoadColumnasDstTask(anaquel, fila).execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenOrg = null;
            }
        });
    }

    private void ListarCajasPallet() {
        new AlmacenTransferenciaPPTTActivity.ListarCajasPalletTask().execute();
    }


    private void TransferirPallet() {
        //UTIL.SonidoError(AlmacenTransferenciaPPTTActivity.this);
        //MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error en Transferencia",
        //            "Error Transferencia de Pallet " + _strNroPalletOrg + ". Ha ocurrido un error", false);
        new AlmacenTransferenciaPPTTActivity.GuardarTransferenciaTask().execute();

    }

    private void ListarAlmacenDestino() {
        new AlmacenTransferenciaPPTTActivity.LoadAlmacenDstTask(etNroPalletDst.getText().toString()).execute();
    }

    private void ListarAlmacenOrigen() {
        new AlmacenTransferenciaPPTTActivity.LoadAlmacenesOrgTask(etNroPalletOrg.getText().toString()).execute();
    }

    private void LoadDataDefault() throws PackageManager.NameNotFoundException {
        //Creamos el tab
        TbH.setup();                                                         //lo activamos

        TabHost.TabSpec tab1 = TbH.newTabSpec("tab1");  //aspectos de cada Tab (pestaña)
        TabHost.TabSpec tab2 = TbH.newTabSpec("tab2");
        TabHost.TabSpec tab3 = TbH.newTabSpec("tab3");

        tab1.setIndicator("ORIGEN");    //qué queremos que aparezca en las pestañas
        tab1.setContent(R.id.tab1); //definimos el id de cada Tab (pestaña)

        tab2.setIndicator("CAJAS");
        tab2.setContent(R.id.tab2);

        tab3.setIndicator("DESTINO");
        tab3.setContent(R.id.tab3);

        TbH.addTab(tab1); //añadimos los tabs ya programados
        TbH.addTab(tab2);
        TbH.addTab(tab3);

        etNroPalletDst.setText("");
        etNroPalletOrg.setText("");
        tvMensaje.setText("");

        //Imprimir la version de la aplicacion
        tvVersionName.setText("Version: " + this.getPackageManager().getPackageInfo(getPackageName(), 0).versionName);

        new LoadDataTask().execute();
    }

    private void InitControllers() {
        spAnaquelOrg = (Spinner) findViewById(R.id.spAnaquelOrg);
        spFilaOrg = (Spinner) findViewById(R.id.spFilaOrg);
        spColumnaOrg = (Spinner) findViewById(R.id.spColumnaOrg);
        spAnaquelDst = (Spinner) findViewById(R.id.spAnaquelDst);
        spFilaDst = (Spinner) findViewById(R.id.spFilaDst);
        spColumnaDst = (Spinner) findViewById(R.id.spColumnaDst);

        //Almacenes
        spAlmacenOrg = (Spinner) findViewById(R.id.spAlmacenOrg);
        spAlmacenDst = (Spinner) findViewById(R.id.spAlmacenDst);

        etFechaRecepcion = (EditText) findViewById(R.id.etFechaRecepcion);
        etNroPalletOrg = (EditText) findViewById(R.id.etNroPalletOrg);
        etNroPalletDst = (EditText) findViewById(R.id.etNroPalletDst);

        tvMensaje = (TextView) findViewById(R.id.tvMensaje);
        tvNroRegistros = (TextView) findViewById(R.id.tvNroRegistros);
        tvVersionName = (TextView) findViewById(R.id.tvVersionName);

        btnSalir = (Button) findViewById(R.id.btnSalir);
        btnTransferir = (Button) findViewById(R.id.btnTransferir);
        btnListarCajas = (Button) findViewById(R.id.btnListarCajas);
        btnLeerPalletOrg = (Button) findViewById(R.id.btnLeerPalletOrg);
        btnLeerPalletDst = (Button) findViewById(R.id.btnLeerPalletDst);

        ibObtenerFecha = (ImageButton)findViewById(R.id.ibObtenerFecha);
        lvListadoCajas = (ListView) findViewById(R.id.lvListadoCajas);

        TbH = (TabHost) findViewById(R.id.tabHost); //llamamos al Tabhost
    }

    public void RefrescarCajas() {
        //Indico el adaptador para el listado de Servidores
        adaptador = new ListViewCajasAdapter(AlmacenTransferenciaPPTTActivity.this, ImplListadoCajas.getListadoCajas(), this);
        lvListadoCajas.setAdapter(adaptador);

        tvNroRegistros.setText(UTIL.ConvetToString(ImplListadoCajas.getListadoCajas().size(), "###,##0"));

        //Le pongo el foco a la lista de Servidores
        lvListadoCajas.requestFocus();
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, isFechaRecepcion;

        ImplAlmacen implAlmacen = null;
        ImplUtil implUtil = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Cargando datos por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Obtengo la fecha de recepcion
                implUtil = new ImplUtil(ImplEmpresa.empresaDefault.getCodigo());
                isFechaRecepcion = UTIL.parseSqlDatetoString(implUtil.TimeServidor(), "dd/MM/yyyy");


                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implAlmacen = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    etFechaRecepcion.setText(isFechaRecepcion);
                }else{
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al selecionar almacen destino", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadAlmacenesOrgTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, strLectura;

        ImplLecturasCruiser implLecturasCruiser = null;
        ImplParteTransferencia implParteTransferencia = null;
        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        public LoadAlmacenesOrgTask(String value){
            strLectura = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo almacenes de Origen por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
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
                BeanLecturasCruiser obj = new BeanLecturasCruiser();
                if (userLogin.getOrigenAlt() == null)
                    obj.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
                else
                    obj.setCodOrigen(userLogin.getOrigenAlt());

                obj.setLectura(strLectura);
                obj.setEquipo(UTIL.getDeviceName(AlmacenTransferenciaPPTTActivity.this));
                obj.setUsuario(userLogin.getUsuario());
                obj.setDeviceID(ImplSegLoginDevice.currentDevice.getDeviceID());

                implLecturasCruiser = new ImplLecturasCruiser(ImplEmpresa.empresaDefault.getCodigo());
                implLecturasCruiser.Insertar(obj);

                //Valido el numero de Pallet
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                if (!implParteTransferencia.validarPallet(strLectura)){
                    return false;
                }

                //Obtengo el nro de Pallet correto
                _strNroPalletOrg =implParteTransferencia.getNroPallet();


                almacenesOrg = implParteTransferencia.getAlmacenesOrgByPallet(_strNroPalletOrg);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implLecturasCruiser = null;
                implParteTransferencia = null;
                userLogin = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    etNroPalletOrg.setText(_strNroPalletOrg);

                    //Coloco el mismo pallet en el destino
                    etNroPalletDst.setText(_strNroPalletOrg);

                    //Obtengo el almacen Origen
                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, almacenesOrg);

                    spAlmacenOrg.setAdapter(adapter);
                }else{
                    etNroPalletOrg.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al ubicar en almacen Origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadAnaquelesOrgTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        private List<String> anaqueles;
        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo ANAQUELES de Origen por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Valido el numero de Pallet
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo el nro de Pallet correto
                anaqueles =implParteTransferencia.getAnaquelesOrgByPallet(_strNroPalletOrg, almacenOrg.getAlmacen());

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, anaqueles);

                    spAnaquelOrg.setAdapter(adapter);
                }else{
                    etNroPalletOrg.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadFilasOrgTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        String _anaquel;
        private List<String> filas;
        private ProgressDialog pDialog;

        public LoadFilasOrgTask(String value) {
            this._anaquel = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo FILAS de Origen por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Valido el numero de Pallet
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo el nro de Pallet correto
                filas =implParteTransferencia.getFilasOrgByPallet(_strNroPalletOrg, almacenOrg.getAlmacen(), _anaquel);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, filas);

                    spFilaOrg.setAdapter(adapter);
                }else{
                    etNroPalletOrg.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadColumnasOrgTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        String _anaquel, _fila;
        private List<String> columnas;
        private ProgressDialog pDialog;

        public LoadColumnasOrgTask(String v1, String v2) {
            this._anaquel = v1;
            this._fila = v2;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo COLUMNAS de Origen por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Valido el numero de Pallet
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo el nro de Pallet correto
                columnas =implParteTransferencia.getColumnasOrgByPallet(_strNroPalletOrg, almacenOrg.getAlmacen(), _anaquel, _fila);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, columnas);

                    spColumnaOrg.setAdapter(adapter);
                }else{
                    etNroPalletOrg.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class ListarCajasPalletTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, almacen, anaquel, fila, columna;

        ImplParteTransferencia implParteTransferencia = null;

        private ProgressDialog pDialog;


        protected void onPreExecute() {
            super.onPreExecute();

            //Obtengo los datos necesarios
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo Listado de Cajas del PALLET " + _strNroPalletOrg + " por favor espere...");
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


                almacen = ((BeanAlmacen)spAlmacenOrg.getSelectedItem()).getAlmacen();
                anaquel = (String) spAnaquelOrg.getSelectedItem();
                fila = (String) spFilaOrg.getSelectedItem();
                columna = (String) spColumnaOrg.getSelectedItem();

                //Valido el numero de Pallet
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                List<BeanCaja> cajas = implParteTransferencia.getListadoCajasByPallet(_strNroPalletOrg, almacen, anaquel, fila, columna);
                ImplListadoCajas.setListadoCajas(cajas);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al obtener el Listado de Cajas del Pallet: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    RefrescarCajas();
                }else{
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error en ListarCajasPalletTask, listar Cajas por Pallet", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadAlmacenDstTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, _strLectura;

        ImplAlmacen implAlmacen = null;
        ImplParteTransferencia implParteTransferencia = null;
        ImplLecturasCruiser implLecturasCruiser = null;
        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        public LoadAlmacenDstTask(String value) {
            _strLectura = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Cargando almacenes de DESTINO por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            String strLectura;
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                if(almacenOrg == null)
                {
                    mensaje = "No se ha especificado un almacen Origen, por favor corrija";
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
                BeanLecturasCruiser obj = new BeanLecturasCruiser();
                if (userLogin.getOrigenAlt() == null)
                    obj.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
                else
                    obj.setCodOrigen(userLogin.getOrigenAlt());

                obj.setLectura(_strLectura);
                obj.setEquipo(UTIL.getDeviceName(AlmacenTransferenciaPPTTActivity.this));
                obj.setUsuario(userLogin.getUsuario());
                obj.setDeviceID(ImplSegLoginDevice.currentDevice.getDeviceID());

                implLecturasCruiser = new ImplLecturasCruiser(ImplEmpresa.empresaDefault.getCodigo());
                implLecturasCruiser.Insertar(obj);

                //Valido el numero de Pallet
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                if (!implParteTransferencia.validarPalletDst(_strLectura)){
                    return false;
                }

                _strNroPalletDst = implParteTransferencia.getNroPallet();

                //LLenado de Lista para los articulos
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                almacenesDst = implParteTransferencia.getAlmacenPPTTByUser(userLogin.getUsuario());


                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implAlmacen = null;
                implLecturasCruiser = null;
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    etNroPalletDst.setText(_strNroPalletDst);

                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, almacenesDst);

                    spAlmacenDst.setAdapter(adapter);
                }else{
                    spAlmacenOrg.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al selecionar almacen destino", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                }

                implParteTransferencia= null;
                implAlmacen = null;

            }



        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadAnaquelesDstTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        private List<String> anaqueles;
        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo ANAQUELES de Destino por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //LLenado de Lista para los articulos
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                anaqueles = implParteTransferencia.getAnaquelesDstByPallet(almacenDst.getAlmacen());

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, anaqueles);

                    spAnaquelDst.setAdapter(adapter);
                }else{
                    etNroPalletDst.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadFilasDstTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        String _anaquel;
        private List<String> filas;
        private ProgressDialog pDialog;

        public LoadFilasDstTask(String value) {
            this._anaquel = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo FILAS de Destino por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                ///LLenado de Lista para los articulos
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                filas = implParteTransferencia.getFilasDstByPallet(almacenDst.getAlmacen(), _anaquel);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, filas);

                    spFilaDst.setAdapter(adapter);
                }else{
                    etNroPalletDst.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadColumnasDstTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        String _anaquel, _fila;
        private List<String> columnas;
        private ProgressDialog pDialog;

        public LoadColumnasDstTask(String v1, String v2) {
            this._anaquel = v1;
            this._fila = v2;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Obteniendo COLUMNAS de Destino por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //LLenado de Lista para los articulos
                implParteTransferencia = new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                columnas = implParteTransferencia.getColumnasDstByPallet(almacenDst.getAlmacen(), _anaquel, _fila);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTransferenciaPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, columnas);

                    spColumnaDst.setAdapter(adapter);
                }else{
                    etNroPalletDst.requestFocus();
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class GuardarTransferenciaTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        BeanUsuario userLogin = null;
        BeanParteTransferencia cabecera = null;
        List<BeanParteTransferenciaUnd> detalle = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTransferenciaPPTTActivity.this);
            pDialog.setMessage("Guardando la transferencia por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @SuppressLint("WrongThread")
        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Datos del usuario
                final GlobalClass globalVariable = (GlobalClass) AlmacenTransferenciaPPTTActivity.this.getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                implParteTransferencia= new ImplParteTransferencia(ImplEmpresa.empresaDefault.getCodigo());
                cabecera = new BeanParteTransferencia();
                detalle = new ArrayList<BeanParteTransferenciaUnd>();

                /*
                    private String nroParte;
                    private String codOrigen;
                    private String almacenOrg;
                    private String almacenDst;
                    private String anaquelOrg;
                    private String anaquelDst;
                    private String filaOrg;
                    private String filaDst;
                    private String columnaOrg;
                    private String coulmnaDst;
                    private String codUsuario;
                    private String nroPalletOrg;
                    private String nroPalletDst;
                    private Double cantidad;
                 */

                if(_strNroPalletOrg == null || _strNroPalletOrg.trim().equals(""))
                {
                    mensaje = "No se ha espeficado el Nro dePallet ORIGEN";
                    return false;
                }

                if(_strNroPalletDst == null || _strNroPalletDst.trim().equals(""))
                {
                    mensaje = "No se ha espeficado el Nro dePallet DESTINO";
                    return false;
                }

                //Datos de la cabecera
                cabecera.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
                cabecera.setAlmacenOrg(almacenOrg.getAlmacen());
                cabecera.setAlmacenDst(almacenDst.getAlmacen());
                cabecera.setAnaquelOrg((String) spAnaquelOrg.getSelectedItem());
                cabecera.setAnaquelDst((String) spAnaquelDst.getSelectedItem());
                cabecera.setFilaOrg((String) spFilaOrg.getSelectedItem());
                cabecera.setFilaDst((String) spFilaDst.getSelectedItem());
                cabecera.setColumnaOrg((String) spColumnaOrg.getSelectedItem());
                cabecera.setColumnaDst((String) spColumnaDst.getSelectedItem());
                cabecera.setCodUsuario(userLogin.getUsuario());
                cabecera.setNroPalletOrg(_strNroPalletOrg);
                cabecera.setNroPalletDst(_strNroPalletDst);
                cabecera.setCantidad(ImplListadoCajas.getCantidad());
                cabecera.setFecTransferencia(UTIL.parseStringToSqlDate(etFechaRecepcion.getText().toString()));
                cabecera.setNroCajas( ImplListadoCajas.getCantidadUnd2().intValue() );

                for(BeanCaja caja : ImplListadoCajas.getListadoCajas()){
                    BeanParteTransferenciaUnd obj = new BeanParteTransferenciaUnd();
                    obj.setCodigoCU(caja.getCodigoCU());
                    obj.setCodUsuario(userLogin.getUsuario());
                    obj.setCodArt(caja.getCodArticulo());
                    detalle.add(obj);
                }

                Gson gson = new GsonBuilder().create();
                String strDetalle = gson.toJson(detalle);
                System.out.println("Detalle del parte de transferencia: " + strDetalle);

                implParteTransferencia.InsertarParteCompleto(cabecera, strDetalle);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al grabar Parte de Transferencia: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteTransferencia = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    UTIL.SonidoCorrecto(AlmacenTransferenciaPPTTActivity.this);
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Grabado satisfactoriamente",
                            "Se ha generado el nro de PARTE: " + cabecera.getNroParte() + " correctamente", true);
                    etNroPalletDst.setText("");
                    etNroPalletOrg.setText("");
                    ImplListadoCajas.getListadoCajas().clear();

                    RefrescarCajas();

                    etNroPalletOrg.requestFocus();
                }else{
                    MessageBox.AlertDialog(AlmacenTransferenciaPPTTActivity.this, "Error al guardar la transferencia", mensaje, false);
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

}
