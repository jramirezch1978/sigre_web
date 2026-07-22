package pe.com.sytco.fastsales.Activities.Almacen;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TabHost;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;

import java.io.IOException;
import java.util.Calendar;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplOrigen;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteIngreso;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Dialog.DialogIngresoResumido;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchAlmacen;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchDireccion;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchDocTipo;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchFormaPago;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchMoneda;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchProveedor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.ParteIngresoUI;
import pe.com.sytco.fastsales.beans.BeanOrigen;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.Parametros;
import pe.com.sytco.fastsales.util.UTIL;

public class AlmacenParteRecepcionPopupActivity extends AppCompatActivity {

    private TabHost TbH;

    //Interfaz del usuario
    private TextView tvFecRegistro, tvCodUsr, tvOrigen, tvNroParte, tvOrdenCompra, tvValeIngreso, tvDescAlmacen,
                     tvRazonSocial, tvDireccion, tvCantidad, tvImporte, tvMoneda, tvDescFormaPago, tvEstadoParte;
    private EditText etFechaParte, etAlmacen, etProveedor, etDirecion, etReceptor, etTipoRef, etSerieRef, etNumeroRef, etObservaciones;
    private Button btnAlmacen, btnProveedor, btnDireccion, btnFormaPago, btnMoneda, btnInsertarDetalle, btnAceptar, btnCancelar, btnTipoRef;
    private ImageButton ibtObtenerFecha;

    private ParteIngresoUI parteIngresoUI;
    private BeanParteIngreso beanParteIngreso = null;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);

    //Listado que viene de la ventana anterior
    private Parametros _strParam;

    // Control imagen para la captura de la foto
    private ImageView ivImagen;
    private TextView tvRutaFoto, tvResolucion;
    private Uri uriImagenPath;
    private ImageButton ibGuardarFoto;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_parte_recepcion_popup);

        InitControllers();

        AsignarEventos();

        LoadDataDefault();
    }

    private void InitControllers() {

        //Cargo el strParam que se trae del otro Activity

        if (getIntent().getExtras().getString("strParam") == null ){
            MessageBox.AlertDialog(getApplicationContext(), "Error", "No se ha identificado la acción para la ventana", false);
            closeActivity();
            return;
        }

        String lstrJSON = getIntent().getExtras().getString("strParam");

        _strParam = new Gson().fromJson(lstrJSON, Parametros.class);

        //Creo el objeto para el UI de esta ventana
        parteIngresoUI = new ParteIngresoUI(this);

        TbH = (TabHost) findViewById(R.id.tabHost); //llamamos al Tabhost

        //Obtengo las referencias a los TextViews
        tvFecRegistro = (TextView) findViewById(R.id.tvFecRegistro);
        tvCodUsr = (TextView) findViewById(R.id.tvCodUsr);
        tvOrigen = (TextView) findViewById(R.id.tvOrigen);
        tvNroParte = (TextView) findViewById(R.id.tvNroParte);
        tvOrdenCompra = (TextView) findViewById(R.id.tvOrdenCompra);
        tvValeIngreso = (TextView) findViewById(R.id.tvValeIngreso);
        tvDescAlmacen = (TextView) findViewById(R.id.tvDescAlmacen);
        tvRazonSocial = (TextView) findViewById(R.id.tvRazonSocial);
        tvDireccion = (TextView) findViewById(R.id.tvDireccion);
        tvCantidad = (TextView) findViewById(R.id.tvCantidad);
        tvImporte = (TextView) findViewById(R.id.tvImporte);
        tvMoneda = (TextView) findViewById(R.id.tvMoneda);
        tvDescFormaPago = (TextView) findViewById(R.id.tvDescFormaPago);
        tvEstadoParte = (TextView) findViewById(R.id.tvEstadoParte);

        //Obtengo las referencias a los EditText
        etFechaParte = (EditText) findViewById(R.id.etFechaParte);
        etAlmacen = (EditText) findViewById(R.id.etAlmacen);
        etProveedor = (EditText) findViewById(R.id.etProveedor);
        etDirecion = (EditText) findViewById(R.id.etDirecion);
        etReceptor = (EditText) findViewById(R.id.etReceptor);
        etTipoRef = (EditText) findViewById(R.id.etTipoRef);
        etSerieRef = (EditText) findViewById(R.id.etSerieRef);
        etNumeroRef = (EditText) findViewById(R.id.etNumeroRef);
        etObservaciones = (EditText) findViewById(R.id.etObservaciones);

        //Obtengo las referencias a los Botones
        btnAlmacen = (Button) findViewById(R.id.btnAlmacen);
        btnProveedor = (Button) findViewById(R.id.btnProveedor);
        btnDireccion = (Button) findViewById(R.id.btnDireccion);
        btnTipoRef = (Button) findViewById(R.id.btnTipoRef);
        btnFormaPago = (Button) findViewById(R.id.btnFormaPago);
        btnMoneda = (Button) findViewById(R.id.btnMoneda);
        btnInsertarDetalle = (Button) findViewById(R.id.btnInsertarDetalle);
        btnAceptar = (Button) findViewById(R.id.btnAceptar);
        btnCancelar = (Button) findViewById(R.id.btnCancelar);

        ibtObtenerFecha = (ImageButton)findViewById(R.id.ibtObtenerFecha);



    }

    private void AsignarEventos() {
        //Boton para el boton de obtener fecha
        ibtObtenerFecha.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenParteRecepcionPopupActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaParte.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


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

        btnCancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                closeActivity();
            }
        });

        btnAlmacen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchAlmacen(AlmacenParteRecepcionPopupActivity.this).openDialog(beanParteIngreso);
            }
        });

        btnFormaPago.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchFormaPago(AlmacenParteRecepcionPopupActivity.this).openDialog(beanParteIngreso);
            }
        });

        btnProveedor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchProveedor(AlmacenParteRecepcionPopupActivity.this).openDialog(beanParteIngreso);
            }
        });

        btnTipoRef.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchDocTipo(AlmacenParteRecepcionPopupActivity.this).openDialog(beanParteIngreso);
            }
        });

        btnMoneda.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchMoneda(AlmacenParteRecepcionPopupActivity.this).openDialog(beanParteIngreso);
            }
        });

        btnDireccion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchDireccion(AlmacenParteRecepcionPopupActivity.this).openDialog(beanParteIngreso);
            }
        });

        btnInsertarDetalle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String Proveedor = etProveedor.getText().toString();

                new DialogIngresoResumido(AlmacenParteRecepcionPopupActivity.this, Proveedor).openDialog(beanParteIngreso);
            }
        });

        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                _strParam.setIsOK(true);

                Intent intent = new Intent(getApplicationContext(), AlmacenParteRecepcionActivity.class);
                intent.putExtra("strParam", new Gson().toJson(_strParam));
                startActivity(intent);
                finish();
            }
        });
    }

    private void closeActivity() {

        _strParam.setIsOK(false);

        Intent intent = new Intent(getApplicationContext(), AlmacenParteRecepcionActivity.class);
        intent.putExtra("strParam", new Gson().toJson(_strParam));
        startActivity(intent);
        finish();

    }


    private void LoadDataDefault() {
        //Creamos el tab
        TbH.setup();                                                         //lo activamos

        TabHost.TabSpec tab1 = TbH.newTabSpec("tab1");  //aspectos de cada Tab (pestaña)
        TabHost.TabSpec tab2 = TbH.newTabSpec("tab2");  //aspectos de cada Tab (pestaña)
        TabHost.TabSpec tab3 = TbH.newTabSpec("tab3");  //aspectos de cada Tab (pestaña)

        tab1.setIndicator("CABECERA DEL PARTE");    //qué queremos que aparezca en las pestañas
        tab1.setContent(R.id.tab1); //definimos el id de cada Tab (pestaña)

        tab2.setIndicator("DETALLE DEL PARTE");    //qué queremos que aparezca en las pestañas
        tab2.setContent(R.id.tab2); //definimos el id de cada Tab (pestaña)

        tab3.setIndicator("LISTADO DE CUS");    //qué queremos que aparezca en las pestañas
        tab3.setContent(R.id.tab3); //definimos el id de cada Tab (pestaña)

        TbH.addTab(tab1); //añadimos los tabs ya programados
        TbH.addTab(tab2); //añadimos los tabs ya programados
        TbH.addTab(tab3); //añadimos los tabs ya programados

        //Datos Inicializados
        tvValeIngreso.setText("");
        tvOrdenCompra.setText("");
        tvNroParte.setText("");

        //Datos por defecto
        etAlmacen.setText("");
        tvDescAlmacen.setText("");

        etProveedor.setText("");
        tvRazonSocial.setText("");

        etDirecion.setText("");
        tvDireccion.setText("");

        etReceptor.setText("");
        etTipoRef.setText("");
        etSerieRef.setText("");
        etNumeroRef.setText("");

        tvCantidad.setText("0.00");
        tvImporte.setText("0.00");
        tvMoneda.setText("");

        tvDescFormaPago.setText("");
        etObservaciones.setText("");

        if(_strParam == null || _strParam.getAction() == null || _strParam.getAction().trim().equals("")){
            MessageBox.AlertDialog("No se ha definido acción en argumentos de parametros", "Error en Parametros", AlmacenParteRecepcionPopupActivity.this);
            return;
        }else if(_strParam.getAction().toUpperCase().equals("NEW")){

            new NewDataTask().execute();

        }else if(_strParam.getAction().toUpperCase().equals("EDIT")){

            new CargarDatosTask(_strParam.getString1()).execute();
        }


    }

    private void CargarDatos() {

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == 0 && resultCode == RESULT_OK) {
            Bitmap imageBitmap = null;
            try {
                imageBitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uriImagenPath);

                tvRutaFoto.setText(uriImagenPath.getPath());
                tvResolucion.setText(String.valueOf(imageBitmap.getWidth()) + " x " + String.valueOf(imageBitmap.getHeight()));

                //ivImagen.setImageBitmap(imageBitmap.createScaledBitmap(imageBitmap, 1800, 1800, false));
                ivImagen.setImageBitmap(imageBitmap);

                ibGuardarFoto.setVisibility(ImageButton.VISIBLE);



            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

    public void setImagenView(ImageView value) {
        this.ivImagen = value;
    }

    public void setUriImagenPath(Uri value) {
        this.uriImagenPath = value;
    }

    public void setRutaFoto(TextView value) {
        this.tvRutaFoto = value;
    }

    public void setBtnGuardarFoto(ImageButton value) {
        this.ibGuardarFoto= value;
    }

    public void setTvResolucion(TextView value) {
        this.tvResolucion = value;
    }

    public void refreshData() {
        tvFecRegistro.setText(beanParteIngreso.getFecRegistro());
        tvCodUsr.setText(beanParteIngreso.getCodUsuario());
        tvOrigen.setText(beanParteIngreso.getDescOrigen());
        tvNroParte.setText(beanParteIngreso.getNroParte());
        tvOrdenCompra.setText(beanParteIngreso.getNroOC());
        tvValeIngreso.setText(beanParteIngreso.getNroVale());

        etFechaParte.setText(beanParteIngreso.getFecParte());
        tvEstadoParte.setText(beanParteIngreso.getDescEstado());

        etAlmacen.setText(beanParteIngreso.getAlmacen());
        tvDescAlmacen.setText(beanParteIngreso.getDescAlmacen());

        etProveedor.setText(beanParteIngreso.getProveedor());
        tvRazonSocial.setText(beanParteIngreso.getNomProveedor());

        if (beanParteIngreso.getItemDireccion()!= null)
            etDirecion.setText(beanParteIngreso.getItemDireccion().toString());

        if (beanParteIngreso.getDireccionCliente()!= null)
            tvDireccion.setText(beanParteIngreso.getDireccionCliente());

        if (beanParteIngreso.getNomReceptor()!= null)
            etReceptor.setText(beanParteIngreso.getNomReceptor());

        if (beanParteIngreso.getTipoDoc()!= null)
            etTipoRef.setText(beanParteIngreso.getTipoDoc());

        if (beanParteIngreso.getSerie()!= null)
            etSerieRef.setText(beanParteIngreso.getSerie());

        if (beanParteIngreso.getNumero()!= null)
            etNumeroRef.setText(beanParteIngreso.getNumero());

        if (beanParteIngreso.getCantidad()!= null)
            tvCantidad.setText(UTIL.ConvetToString(beanParteIngreso.getCantidad(), "###,##0.00"));

        if (beanParteIngreso.getImporte()!= null)
            tvImporte.setText(UTIL.ConvetToString(beanParteIngreso.getImporte(), "###,##0.00"));

        if (beanParteIngreso.getDescFormaPago()!= null)
            tvDescFormaPago.setText(beanParteIngreso.getDescFormaPago());

        if (beanParteIngreso.getDescMoneda()!= null)
            tvMoneda.setText(beanParteIngreso.getDescMoneda());

        if (beanParteIngreso.getObservacion()!= null)
            etObservaciones.setText(beanParteIngreso.getObservacion());

        parteIngresoUI.drawResumenAgrupado(beanParteIngreso.getDetalle());
        parteIngresoUI.drawListadoCUs(beanParteIngreso.getListadoCU());
    }


    //Clase Asincrona para tareas en segundo plano
    private class NewDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        java.sql.Date idtFechaServidor;

        ImplUtil implUtil = null;
        ImplOrigen implOrigen = null;

        BeanUsuario userLogin = null;
        BeanOrigen beanOrigen = null;


        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();

            pDialog = new ProgressDialog(AlmacenParteRecepcionPopupActivity.this);
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

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }

                //Creo los objetos
                implUtil = new ImplUtil(ImplEmpresa.empresaDefault.getCodigo());
                implOrigen = new ImplOrigen(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo la fecha de recepcion
                idtFechaServidor = implUtil.TimeServidor();
                beanOrigen = implOrigen.getOne(ImplEmpresa.empresaDefault.getCodOrigen());

                if (!beanOrigen.getIsOk()){
                    mensaje = "Error al momento de consultar el Origen, Mensaje; " + beanOrigen.getMensaje();
                    return false;
                }


                return true;

            } catch (Exception ex) {
                mensaje = "Error en evento NewTask. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implUtil = null;
                implOrigen = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    beanParteIngreso = new BeanParteIngreso();
                    beanParteIngreso.setNew(true);

                    beanParteIngreso.setFecRegistro(UTIL.parseSqlDatetoString(idtFechaServidor, "dd/MM/yyyy HH:mm:ss"));
                    beanParteIngreso.setFecParte(UTIL.parseSqlDatetoString(idtFechaServidor, "dd/MM/yyyy"));
                    beanParteIngreso.setCodUsuario(userLogin.getUsuario());
                    beanParteIngreso.setCodOrigen(beanOrigen.getCodOrigen());
                    beanParteIngreso.setDescOrigen(beanOrigen.getNombre());

                    refreshData();
                    etFechaParte.requestFocus();

                }else{
                    MessageBox.AlertDialog(AlmacenParteRecepcionPopupActivity.this, "Error al cargar datos por defecto", mensaje, false);
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
    private class CargarDatosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        String nroParte;

        ImplParteIngreso implParteIngreso = null;

        private ProgressDialog pDialog;

        public CargarDatosTask(String pNroParte){
            this.nroParte = pNroParte;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenParteRecepcionPopupActivity.this);
            pDialog.setMessage("Cargando datos del registro " + nroParte + " ...");
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


                implParteIngreso = new ImplParteIngreso(ImplEmpresa.empresaDefault.getCodigo());

                beanParteIngreso = implParteIngreso.getOneJSON(this.nroParte);



                return true;

            } catch (Exception ex) {

                mensaje = "Error al recuperar registro. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;

            } finally {
                implParteIngreso = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    refreshData();


                }else{
                    MessageBox.AlertDialog(AlmacenParteRecepcionPopupActivity.this, "Error al cargar datos por defecto", mensaje, false);
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
