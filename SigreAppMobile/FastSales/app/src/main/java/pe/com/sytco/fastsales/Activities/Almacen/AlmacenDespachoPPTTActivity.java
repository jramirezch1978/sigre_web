package pe.com.sytco.fastsales.Activities.Almacen;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TabHost;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplLecturasCruiser;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteDespacho;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Dialog.DialogEditCodigoCU;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchAlmacenPPTT;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchArticuloOV;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchOrdenVenta;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.ParteDespachoUI;
import pe.com.sytco.fastsales.beans.Almacen.BeanCodigoCU;
import pe.com.sytco.fastsales.beans.BeanArticuloMovProy;
import pe.com.sytco.fastsales.beans.BeanLecturasCruiser;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class AlmacenDespachoPPTTActivity extends AppCompatActivity {

    //Interfaz
    private ImageButton ibObtenerFecha;
    private Button btnSalir, btnDespachar, btnLeerCodigo, btnOrdenVenta, btnAlmacen, btnComienzo,
            btnResetear, btnArticulo, btnTerminar, btnReporte;
    private TextView tvMensaje, tvNomCliente, tvDescAlmacen, tvDescArticulo, tvOrgAMP, tvNroAMP,
            tvNroRegistros;
    private EditText etNroPallet, etFechaDespacho, etOrdenVenta, etAlmacen, etArticulo;
    private TabHost tabHost;

    //Objeto para manejar la interfaz GUI
    private ParteDespachoUI parteDespachoUI = null;

    //Variables para trabajar
    String strNroPallet, codigoCU, palletOrCU;


    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);

    public View getBtnDespachar() {
        return btnDespachar;
    }
    public TextView getTvNroRegistros() {
        return tvNroRegistros;
    }
    public View getBtnResetear() {
        return btnResetear;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_despacho);

        InitControllers();

        AsignarEventos();

        LoadDataDefault();
    }

    private void InitControllers() {

        //Objeto encargado de dibujar la UI
        parteDespachoUI = new ParteDespachoUI(this);
        ParteDespachoUI.listadoCU = new ArrayList<BeanCodigoCU>();

        //EditText
        etNroPallet = (EditText) findViewById(R.id.etNroPallet);
        etFechaDespacho = (EditText) findViewById(R.id.etFechaDespacho);
        etOrdenVenta = (EditText) findViewById(R.id.etOrdenVenta);
        etAlmacen = (EditText) findViewById(R.id.etAlmacen);
        etArticulo = (EditText) findViewById(R.id.etArticulo);

        //TextView
        tvMensaje = (TextView) findViewById(R.id.tvMensaje);
        tvNomCliente = (TextView) findViewById(R.id.tvNomCliente);
        tvDescAlmacen = (TextView) findViewById(R.id.tvDescAlmacen);
        tvDescArticulo = (TextView) findViewById(R.id.tvDescArticulo);
        tvOrgAMP = (TextView) findViewById(R.id.tvOrgAMP);
        tvNroAMP = (TextView) findViewById(R.id.tvNroAMP);
        tvNroRegistros = (TextView) findViewById(R.id.tvNroRegistros);

        //Button
        btnSalir = (Button) findViewById(R.id.btnSalir);
        btnLeerCodigo = (Button) findViewById(R.id.btnLeerCodigo);
        btnDespachar = (Button) findViewById(R.id.btnDespachar);
        btnOrdenVenta = (Button) findViewById(R.id.btnOrdenVenta);
        btnAlmacen = (Button) findViewById(R.id.btnAlmacen);
        btnComienzo = (Button) findViewById(R.id.btnComienzo);
        btnResetear = (Button) findViewById(R.id.btnResetear);
        btnArticulo = (Button) findViewById(R.id.btnArticulo);
        btnTerminar = (Button) findViewById(R.id.btnTerminar);
        btnReporte = (Button) findViewById(R.id.btnReporte);

        //ImageButton
        ibObtenerFecha = (ImageButton)findViewById(R.id.ibObtenerFecha);

        //TAbHost
        tabHost = (TabHost) findViewById(R.id.tabHost); //llamamos al Tabhost
    }

    private void LoadDataDefault() {

        //Activamos el TAbHost
        tabHost.setup();

        TabHost.TabSpec tab1 = tabHost.newTabSpec("tab1");  //aspectos de cada Tab (pestaña)
        TabHost.TabSpec tab2 = tabHost.newTabSpec("tab2");  //aspectos de cada Tab (pestaña)
        TabHost.TabSpec tab3 = tabHost.newTabSpec("tab3");  //aspectos de cada Tab (pestaña)

        tab1.setIndicator("Lectura de Nro Pallet / Codigo CU");    //qué queremos que aparezca en las pestañas
        tab1.setContent(R.id.tab1); //definimos el id de cada Tab (pestaña)

        tab2.setIndicator("Listado de CUs Leidos");    //qué queremos que aparezca en las pestañas
        tab2.setContent(R.id.tab2); //definimos el id de cada Tab (pestaña)

        tab3.setIndicator("Resumen de Lectura");    //qué queremos que aparezca en las pestañas
        tab3.setContent(R.id.tab3); //definimos el id de cada Tab (pestaña)

        tabHost.addTab(tab1); //añadimos los tabs ya programados
        tabHost.addTab(tab2); //añadimos los tabs ya programados
        tabHost.addTab(tab3); //añadimos los tabs ya programados

        etNroPallet.setText("");
        etOrdenVenta.setText("");
        etAlmacen.setText("");
        etArticulo.setText("");

        tvMensaje.setText("");
        tvNomCliente.setText("");
        tvDescAlmacen.setText("");
        tvDescArticulo.setText("");
        tvOrgAMP.setText("");
        tvNroAMP.setText("");
        tvNroRegistros.setText("0.00");

        parteDespachoUI.drawTableListadoCUS();

        parteDespachoUI.drawTableResumenLectura();

        new LoadDataDefaultTask().execute();

    }

    private void AsignarEventos() {

        btnAlmacen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchAlmacenPPTT(AlmacenDespachoPPTTActivity.this).openDialog();
            }
        });

        btnOrdenVenta.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchOrdenVenta(AlmacenDespachoPPTTActivity.this).openDialog();
            }
        });

        btnArticulo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchArticuloOV(AlmacenDespachoPPTTActivity.this).openDialog();
            }
        });

        btnComienzo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Comenzar(v);
            }
        });

        btnTerminar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Terminar(v);
            }
        });

        btnResetear.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TE hace la pregunta si deseas aceptar o cancelar
                final AlertDialog.Builder alertDialog = new AlertDialog.Builder(AlmacenDespachoPPTTActivity.this);
                alertDialog.setMessage("Desea eliminar todos los registros de Lectura ?");
                alertDialog.setTitle("Eliminar registro");
                alertDialog.setIcon(R.drawable.cancelar);
                alertDialog.setCancelable(false);
                alertDialog.setPositiveButton("Sí", new DialogInterface.OnClickListener()
                {
                    public void onClick(DialogInterface dialog, int which)
                    {
                        LimpiarLectura();
                    }
                });
                alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener()
                {
                    public void onClick(DialogInterface dialog, int which)
                    {
                        //código java si se ha pulsado no
                        dialog.cancel();
                    }
                });
                alertDialog.show();
            }
        });


        btnLeerCodigo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                validarLecturaPallet(view);
            }
        });

        btnDespachar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View view) {
                AlertDialog.Builder dialogo1 = new AlertDialog.Builder(AlmacenDespachoPPTTActivity.this);
                dialogo1.setTitle("Termino del despacho");
                dialogo1.setMessage("¿Desea realizar el despacho con los datos ingresados?");
                dialogo1.setCancelable(false);
                dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialogo1, int id) {

                        DespacharPedido(view);
                    }
                });
                dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialogo1, int id) {

                    }
                });
                dialogo1.show();


            }
        });

        btnReporte.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ResumenAgrupado(view);
            }
        });

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                finish();
            }
        });

        //Boton para el boton de obtener fecha
        ibObtenerFecha.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenDespachoPPTTActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaDespacho.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


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

                        validarLecturaPallet(v);
                        return true;
                    }

                }
                return false;
            }
        });
    }

    private void LimpiarLectura() {
        tvNroRegistros.setText("0");
        ParteDespachoUI.listadoCU.clear();
        parteDespachoUI.drawTableListadoCUS();

        etNroPallet.setText("");

        UTIL.SonidoCorrecto(AlmacenDespachoPPTTActivity.this);
        MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Informacion", "Se ha limpiado todas las lecturas", true);

        etNroPallet.requestFocus();
    }

    private void ResumenAgrupado(View view) {
        new LoadResumenAgrupadoTask().execute();
    }

    private void Terminar(View v) {
        ParteDespachoUI.listadoCU.clear();
        parteDespachoUI.drawTableListadoCUS();

        etNroPallet.setText("");
        etAlmacen.setText("");
        etOrdenVenta.setText("");
        etArticulo.setText("");

        tvOrgAMP.setText("");
        tvNroAMP.setText("");
        tvDescAlmacen.setText("");
        tvDescArticulo.setText("");
        tvNomCliente.setText("");
        tvMensaje.setText("");

        btnDespachar.setEnabled(false);
        btnTerminar.setEnabled(false);
        btnComienzo.setEnabled(true);
        btnLeerCodigo.setEnabled(false);
        btnReporte.setEnabled(false);

        etAlmacen.requestFocus();
    }

    private void Comenzar(View v) {
        if (!ValidarInputs()) return;

        btnComienzo.setEnabled(false);
        btnTerminar.setEnabled(true);
        btnReporte.setEnabled(true);

        btnLeerCodigo.setEnabled(true);
        etNroPallet.setEnabled(true);

        etNroPallet.requestFocus();
    }

    private boolean ValidarInputs() {
        if (etAlmacen.getText() == null || etAlmacen.getText().toString().equals("")){
            UTIL.SonidoError(AlmacenDespachoPPTTActivity.this);
            MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error", "No ha seleccionado un ALMACEN DE DESPACHO, verifique!", false);
            etAlmacen.requestFocus();
            return false;
        }

        if (etOrdenVenta.getText() == null || etOrdenVenta.getText().toString().equals("")){
            UTIL.SonidoError(AlmacenDespachoPPTTActivity.this);
            MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error", "No ha seleccionado una ORDEN DE VENTA, verifique!", false);
            etOrdenVenta.requestFocus();
            return false;
        }

        if (etArticulo.getText() == null || etArticulo.getText().toString().equals("")){
            UTIL.SonidoError(AlmacenDespachoPPTTActivity.this);
            MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error", "No ha especificado ningun ARTICULO DE DESPACHO, por favor verifique!", false);
            etAlmacen.requestFocus();
            return false;
        }

        return true;
    }

    private void validarLecturaPallet(View view) {
        String strLectura = "";

        if (!ValidarInputs()) return;

        strLectura = etNroPallet.getText().toString();

        etNroPallet.setText("");

        if (strLectura == null || strLectura.equals("")){
            UTIL.SonidoError(AlmacenDespachoPPTTActivity.this);
            MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error", "No ha ingresado ningun NRO DE PALLET o CU para validar", false);
            etAlmacen.requestFocus();
            return;
        }



        new ValidarLecturaTask(etAlmacen.getText().toString(),
                                etOrdenVenta.getText().toString(),
                                tvOrgAMP.getText().toString(),
                                Long.parseLong(tvNroAMP.getText().toString()),
                                etArticulo.getText().toString(),
                                strLectura).execute();


    }

    private void DespacharPedido(View view) {
        new RealizarDespachoTask().execute();
    }

    public void addListado(List<BeanCodigoCU> tmpListadoCU) throws Exception {
        if (ParteDespachoUI.listadoCU == null){
            ParteDespachoUI.listadoCU = new ArrayList<BeanCodigoCU>();
        }

        for(BeanCodigoCU tmp : tmpListadoCU){
            Boolean find = false;
            for(BeanCodigoCU bean : ParteDespachoUI.listadoCU){
                if (bean.getCUS().equals(tmp.getCUS())){
                    find = true;
                    break;
                }
            }

            //Si existe el bean entonces lanzo el error
            if (find){
                throw  new Exception("El codigo CU ya existe en el listado existente."
                                   + "\r\nCodigo CU " + tmp.getCUS()
                                   + "\r\nNro LOTE: " + tmp.getNroLote()
                                   + "\r\nNro Pallet: "+ tmp.getNroPallet());
            }

            //Si no existe entonces lo añado
            ParteDespachoUI.listadoCU.add(tmp);
        }
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadDataDefaultTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, isFechaRecepcion;

        ImplUtil implUtil = null;
        ImplParteDespacho implParteDespacho = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenDespachoPPTTActivity.this);
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

                //Creo los objetos necesarios
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                implUtil = new ImplUtil(ImplEmpresa.empresaDefault.getCodigo());


                isFechaRecepcion = UTIL.parseSqlDatetoString(implUtil.TimeServidor(), "dd/MM/yyyy");

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar datos iniciales: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implUtil = null;
                implParteDespacho = null;
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    etFechaDespacho.setText(isFechaRecepcion);
                    etAlmacen.requestFocus();

                }else{
                    MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error al selecionar Fecha del Servidor", mensaje, false);
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
    private class LoadResumenAgrupadoTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, _fecDespacho, _codUsuario, _deviceID;

        BeanUsuario userLogin = null;
        ImplParteDespacho implParteDespacho = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();

            _fecDespacho = etFechaDespacho.getText().toString();

            pDialog = new ProgressDialog(AlmacenDespachoPPTTActivity.this);
            pDialog.setMessage("Cargando RESUMEN AGRUPADO por favor espere...");
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

                //Obtengo los datos que necesito
                _codUsuario = userLogin.getUsuario();
                _deviceID = ImplSegLoginDevice.currentDevice.getDeviceID();


                //Creo los objetos necesarios
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                ParteDespachoUI.resumenLecturas = implParteDespacho.getResumenLectura(_codUsuario, _deviceID, _fecDespacho);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar RESUMEN AGRUPADO: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteDespacho = null;
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    if (ParteDespachoUI.resumenLecturas.size() == 0){
                        MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error al Consultar RESUMEN LECTURAS", "No hay registros de LEctura", false);
                        return;
                    }

                    parteDespachoUI.drawTableResumenLectura();


                }else{
                    MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error al selecionar Fecha del Servidor", mensaje, false);
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
        String mensaje, _lectura, _almacen, _nroOV, _orgAMP, _codArt;
        Long _nroAMP;

        //Listado Temporal de CUs para agregar
        List<BeanCodigoCU> _tmpListadoCU = null;

        ImplLecturasCruiser implLecturasCruiser = null;
        ImplParteDespacho implParteDespacho = null;
        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        public ValidarLecturaTask(String pAlmacen, String pNroOV, String pOrgAMP, Long pNroAMP,
                                  String pCodArt, String pLectura){
            _almacen = pAlmacen;
            _nroOV = pNroOV;
            _lectura = pLectura;
            _orgAMP = pOrgAMP;
            _nroAMP = pNroAMP;
            _codArt = pCodArt;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenDespachoPPTTActivity.this);
            pDialog.setMessage("Validando Nro Lote / Codigo CU por favor espere...");
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

                obj.setLectura(_lectura);
                obj.setEquipo(UTIL.getDeviceName(AlmacenDespachoPPTTActivity.this));
                obj.setUsuario(userLogin.getUsuario());
                obj.setDeviceID(ImplSegLoginDevice.currentDevice.getDeviceID());

                 //Grabo la lectura
                implLecturasCruiser = new ImplLecturasCruiser(ImplEmpresa.empresaDefault.getCodigo());
                implLecturasCruiser.Insertar(obj);

                //Valido el numero de Pallet
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                _tmpListadoCU =  implParteDespacho.getCodigosCULectura(_almacen, _nroOV, _orgAMP, _nroAMP, _lectura);

                if(_tmpListadoCU.size() == 0)
                {
                    mensaje = "No hay registro alguno con los datos indicados. "
                            + "\r\nALMACEN = " + _almacen
                            + "\r\nNro OV = " + _nroOV
                            + "\r\nArticulo = " + _codArt;
                    return false;
                }

                if (!_tmpListadoCU.get(0).getIsOk()){
                    mensaje = "Ha ocurrido una excepcion: " + _tmpListadoCU.get(0).getMensaje();
                    return false;
                }

                return true;

            } catch (Exception ex) {
                mensaje = "Error al validar Lectura: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implLecturasCruiser = null;
                implParteDespacho = null;
                userLogin = null;

                //Limpiando la memoria
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {

                    //Obtengo el nro de Pallet correto
                    strNroPallet = _tmpListadoCU.get(0).getNroPallet();
                    palletOrCU = _tmpListadoCU.get(0).getPalletOrCU();
                    codigoCU = _tmpListadoCU.get(0).getCUS();

                    //Asigno el nro del pallet en el fragment
                    if (palletOrCU.equals("C")){
                        tvMensaje.setText("CU Leido: " + codigoCU);
                    }else if (palletOrCU.equals("P")){
                        tvMensaje.setText("Pallet Leido: " + strNroPallet);
                    }else{
                        tvMensaje.setText("Lectura incorrecta no corresponde a un PALLET o CU");
                    }

                    if (_tmpListadoCU.size() == 1 && _tmpListadoCU.get(0).getUnd().equals("CJA") && _tmpListadoCU.get(0).getSaldoUnd1() > 1 ){
                        //Abro el cuadro de dialogo
                        new DialogEditCodigoCU(AlmacenDespachoPPTTActivity.this, _tmpListadoCU, parteDespachoUI).openDialog(_tmpListadoCU.get(0));
                    }else{
                        //Agregar el listado temporal obtenido al listado general
                        addListado(_tmpListadoCU);

                        parteDespachoUI.drawTableListadoCUS();


                        if (ParteDespachoUI.listadoCU.size() > 0){
                            btnDespachar.setEnabled(true);
                            btnResetear.setEnabled(true);
                            tvNroRegistros.setText(UTIL.ConvetToString(ParteDespachoUI.listadoCU.size(), "###,##0"));
                        }else{
                            btnDespachar.setEnabled(false);
                            btnResetear.setEnabled(false);
                            tvNroRegistros.setText("0.00");
                        }
                    }



                }else{
                    MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error al validar Nro Pallet", mensaje, false);
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

    //Clase Asincrona para hacer el despacho
    private class RealizarDespachoTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        //Datos para el parte de Despacho
        String _nroVale, _codArt, _almacen, _nroOV, _sListadoCU, _deviceID,
               _codUsuario, _fecDespacho, _orgAMP, _orgDevice;
        Long _nroAMP;

        BeanArticuloMovProy _amp = null;
        BeanOrdenVenta _ovSelect = null;

        ImplParteDespacho implParteDespacho = null;
        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        public RealizarDespachoTask(){

        }

        protected void onPreExecute() {

            //Obteniendo los datos que se necesitan
            _fecDespacho = etFechaDespacho.getText().toString();
            _almacen  = etAlmacen.getText().toString();
            _nroOV = etOrdenVenta.getText().toString();
            _orgAMP = tvOrgAMP.getText().toString();
            _nroAMP = Long.parseLong(tvNroAMP.getText().toString());
            _codArt = etArticulo.getText().toString();

            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenDespachoPPTTActivity.this);
            pDialog.setMessage("Grabando el Despacho Simplificado, por favor espere...");
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
                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }

                //Obtengo los datos que necesito
                _codUsuario = userLogin.getUsuario();
                _deviceID = ImplSegLoginDevice.currentDevice.getDeviceID();
                _orgDevice = ImplSegLoginDevice.currentDevice.getCodOrigen();

                //Transformo el Listado de Cajas en un String JSON

                if(ParteDespachoUI.listadoCU == null || ParteDespachoUI.listadoCU.size() == 0)
                {
                    mensaje = "NO se ha especificado un PACKING LIST (Listado de Cajas) para despachar, por favor verifique!";
                    return false;
                }

                Gson gson = new GsonBuilder().setPrettyPrinting().setDateFormat("dd/MM/yyyy HH:mm:ss").create();
                _sListadoCU = gson.toJson(ParteDespachoUI.listadoCU);
                System.out.println("Listado de Cajas Seleccionados: " + _sListadoCU);

                //Creo el objeto Parte Despacho
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                /*
                 String pOrigenDevice,
                 String pDeviceID,
                 String pFecDespacho,
                 String pOrgAMP,
                 Long pNroAMP,
                 String pCodArt,
                 String pAlmacen,
                 String pNroOV,
                 String pCodUsuario,
                 String pListadoCU
                 */
                if (!implParteDespacho.InsertarParteDespacho(_orgDevice,
                                                             _deviceID,
                                                             _fecDespacho,
                                                             _orgAMP,
                                                             _nroAMP,
                                                             _codArt,
                                                             _almacen,
                                                             _nroOV,
                                                            _codUsuario,
                                                            _sListadoCU)){
                    return false;
                }

                //Obtengo el nro de Pallet correto
                _nroVale =implParteDespacho.getNroVale();


                return true;

            } catch (Exception ex) {
                mensaje = "Error al insertar Parte de Despacho. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteDespacho = null;
                userLogin = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    UTIL.SonidoCorrecto(AlmacenDespachoPPTTActivity.this);
                    MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Parte de Despacho",
                            "Vale de Salida " + _nroVale + " ha sido generado satisfactoriamente", true);

                    ParteDespachoUI.listadoCU.clear();
                    parteDespachoUI.drawTableListadoCUS();
                    tvNroRegistros.setText("0.00");
                    etNroPallet.requestFocus();

                }else{
                    MessageBox.AlertDialog(AlmacenDespachoPPTTActivity.this, "Error al generar Vale de Despacho", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                }

            }

        }

    }


}
