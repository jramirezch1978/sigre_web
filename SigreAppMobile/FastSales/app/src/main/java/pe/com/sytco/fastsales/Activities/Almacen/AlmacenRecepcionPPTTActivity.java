package pe.com.sytco.fastsales.Activities.Almacen;

import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import java.net.SocketTimeoutException;
import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplLecturasCruiser;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteEmpaque;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Dialog.DialogConfirmCajaCU;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanLecturasCruiser;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class AlmacenRecepcionPPTTActivity extends AppCompatActivity {

    //Interfaz de la Activity
    private BottomNavigationView navigation;
    private Spinner spAlmacenOrg;
    TextView tvMensaje;
    EditText etNroPallet, etFechaRecepcion;
    private ImageButton ibObtenerFecha;
    private Button btnLeerCodigo, btnSalir, btnShowDestino;


    //Arreglos de datos
    List<BeanAlmacen> almacenesOrg;
    BeanAlmacen almacenSelect;
    String strNroPallet;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_recepcion_pptt);

        InitControllers();

        LoadDataDefault();

        AsignarEventos();


    }

    private void InitControllers() {
        navigation = (BottomNavigationView) findViewById(R.id.navigation);
        spAlmacenOrg = (Spinner)findViewById(R.id.spAlmacenOrg);
        etFechaRecepcion = (EditText) findViewById(R.id.etFechaRecepcion);

        etNroPallet = (EditText) findViewById(R.id.etNroPallet);
        tvMensaje= (TextView) findViewById(R.id.tvMensaje);

        ibObtenerFecha = (ImageButton)findViewById(R.id.ibObtenerFecha);

        btnShowDestino = (Button) findViewById(R.id.btnShowDestino);
        btnLeerCodigo = (Button) findViewById(R.id.btnLeerCodigo);
        btnSalir = (Button) findViewById(R.id.btnSalir);

    }

    private void AsignarEventos() {
        //Asigno los eventos
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);

        spAlmacenOrg.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                almacenSelect = (BeanAlmacen) adapterView.getItemAtPosition(position);

            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenSelect = null;
            }
        });

        //Boton para el boton de obtener fecha
        ibObtenerFecha.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenRecepcionPPTTActivity.this, new DatePickerDialog.OnDateSetListener() {
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

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                finish();
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etNroPallet.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    // Perform action on key press
                    if (etNroPallet.getText() != null) {
                        etNroPallet.setText(etNroPallet.getText().toString().toUpperCase());

                        validarLecturaPallet();
                        return true;
                    }

                }
                return false;
            }
        });

        btnLeerCodigo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                validarLecturaPallet();
            }
        });

        btnShowDestino.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openDialogArticuloConfirm();
            }
        });

    }

    private void validarLecturaPallet(){
        String strLectura = etNroPallet.getText().toString();

        if (strLectura.trim().equals("")){
            MessageBox.AlertDialog("No ha ingresado ningun NRO DE PALLET para validar", "Error en filtro", AlmacenRecepcionPPTTActivity.this);
            return;
        }

        new ValidarLecturaTask(strLectura).execute();

        etNroPallet.setText("");
    }

    private void openDialogArticuloConfirm() {
        if (strNroPallet.trim().equals("")){
            MessageBox.AlertDialog("No ha ingresado ningun NRO DE PALLET para validar", "Error en filtro", AlmacenRecepcionPPTTActivity.this);
            return;
        }

        BeanAlmacen almacenOrg = (BeanAlmacen)spAlmacenOrg.getSelectedItem();
        String fecRecepcion = etFechaRecepcion.getText().toString();

        new DialogConfirmCajaCU(AlmacenRecepcionPPTTActivity.this, almacenOrg.getAlmacen(), fecRecepcion).openDialog(strNroPallet);
    }

    private void LoadDataDefault() {

        etNroPallet.setText("");
        tvMensaje.setText("");

        new LoadDataTask().execute();
    }

    //Clase privada de los eventos del NavigationView
    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                    finish();
                    return true;
                case R.id.navigation_dashboard:
                    startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                    finish();
                    return true;
                case R.id.navigation_notifications:
                    return true;
            }
            return false;
        }
    };

    public void setMensaje(String s) {
        tvMensaje.setText(s);
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, isFechaRecepcion;

        ImplAlmacen implAlmacen = null;
        ImplUtil implUtil = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenRecepcionPPTTActivity.this);
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

                    etNroPallet.requestFocus();
                }else{
                    MessageBox.AlertDialog(AlmacenRecepcionPPTTActivity.this, "Error al selecionar almacen destino", mensaje, false);
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
    private class ValidarLecturaTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, strLectura;

        ImplLecturasCruiser implLecturasCruiser = null;
        ImplParteEmpaque implParteEmpaque = null;
        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        public ValidarLecturaTask(String value){
            strLectura = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenRecepcionPPTTActivity.this);
            pDialog.setMessage("Validando Nro Lote por favor espere...");
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
                obj.setEquipo(UTIL.getDeviceName(AlmacenRecepcionPPTTActivity.this));
                obj.setUsuario(userLogin.getUsuario());
                obj.setDeviceID(ImplSegLoginDevice.currentDevice.getDeviceID());

                implLecturasCruiser = new ImplLecturasCruiser(ImplEmpresa.empresaDefault.getCodigo());
                implLecturasCruiser.Insertar(obj);

                //Valido el numero de Pallet
                implParteEmpaque = new ImplParteEmpaque(ImplEmpresa.empresaDefault.getCodigo());
                if (!implParteEmpaque.validarPallet(strLectura)){
                    return false;
                }

                //Obtengo el nro de Pallet correto
                strNroPallet =implParteEmpaque.getNroPallet();

                //Cargar el almacen segun la recepcion
                almacenesOrg = implParteEmpaque.getAlmacenesOrigenPallet(strNroPallet);

                return true;

            } catch(SocketTimeoutException ex){

                mensaje = "Se ha excedido el tiempo de espera de lectura al validar la información con el Servidor: ";
                ex.printStackTrace();
                return false;

            } catch (Exception ex) {

                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;

            } finally {
                implLecturasCruiser = null;
                implParteEmpaque = null;
                userLogin = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    btnShowDestino.setEnabled(true);
                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(AlmacenRecepcionPPTTActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, almacenesOrg);

                    spAlmacenOrg.setAdapter(adapter);

                    tvMensaje.setText("Pallet Leido: " + strNroPallet);
                    //etNroPallet.setText(strNroPallet);
                }else{
                    btnShowDestino.setEnabled(false);
                    MessageBox.AlertDialog(AlmacenRecepcionPPTTActivity.this, "Error al validar Nro Pallet", mensaje, false);
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
