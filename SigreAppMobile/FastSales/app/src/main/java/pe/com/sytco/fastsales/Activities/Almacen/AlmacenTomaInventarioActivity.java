package pe.com.sytco.fastsales.Activities.Almacen;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplConfiguracion;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplInventarioConteo;
import pe.com.sytco.fastsales.Dialog.DialogArticuloConfirm;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

import static android.provider.MediaStore.Images;

public class AlmacenTomaInventarioActivity extends AppCompatActivity {

    //Controles de la interfaz
    private Spinner spAlmacen;
    private ImageButton ibObtenerFecha;
    private BottomNavigationView navigation;
    private EditText etFechaConteo, etCodigoSKU, etNroConteo;
    private Button btnStart, btnLeerCodigo, btnSalir;
    private TextView tvUltimoSKU, tvTotalLeido, tvTotalUser, tvTotalLeidoPosicion, tvMensaje,
                     tvUltimoCU;
    private AutoCompleteTextView etPosicion ;

    //Arreglos de datos
    List<BeanAlmacen> almacenes;
    List<String> ubicaciones;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);
    Boolean bPrimeraVez = true;

    // Control imagen para la captura de la foto
    private ImageView ivImagen;
    private TextView tvRutaFoto;
    private Uri uriImagenPath;
    private ImageButton ibGuardarFoto;

    //Instancia de Articulo para la Lectura del mismo
    BeanArticulo    instanceArticulo = null;

    //Variables de parametros
    public boolean  ibTotalArticulosLeidos, ibTotalArticulosUsuario, ibShowFotografia;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_toma_inventario);

        //Referencia a controles
        InitControllers();

        //Cargo la data correspondiente
        LoadDataDefault();

        //Asigno los eventos
        AsignaEventos();

        this.setNextFocus();
        etNroConteo.requestFocus();
    }

    private void InitControllers() {
        spAlmacen = (Spinner)findViewById(R.id.spAlmacen);
        ibObtenerFecha = (ImageButton)findViewById(R.id.ibObtenerFecha);
        navigation = (BottomNavigationView) findViewById(R.id.navigation);

        etPosicion = (AutoCompleteTextView) findViewById(R.id.etPosicion);

        btnStart = (Button) findViewById(R.id.btnStart);
        btnLeerCodigo = (Button) findViewById(R.id.btnLeerCodigo);
        btnSalir = (Button) findViewById(R.id.btnSalir);

        etFechaConteo = (EditText) findViewById(R.id.etFechaConteo);
        etCodigoSKU= (EditText) findViewById(R.id.etCodigoSKU);
        etNroConteo= (EditText) findViewById(R.id.etNroConteo);

        tvUltimoSKU = (TextView) findViewById(R.id.tvUltimoSKU);
        tvUltimoCU = (TextView) findViewById(R.id.tvUltimoCU);
        tvTotalLeido = (TextView) findViewById(R.id.tvTotalLeido);
        tvTotalUser = (TextView) findViewById(R.id.tvTotalUser);
        tvTotalLeidoPosicion= (TextView) findViewById(R.id.tvTotalLeidoPosicion);
        tvMensaje= (TextView) findViewById(R.id.tvMensaje);

    }

    private void LoadDataDefault() {
        etFechaConteo.setText(UTIL.DateToString(dia, mes + 1, year));
        etCodigoSKU.setText("");
        etPosicion.setText("");
        tvMensaje.setText("");
        new LoadDataTask().execute();
    }

    private void AsignaEventos() {
        //Asigno los eventos
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
        ibObtenerFecha.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenTomaInventarioActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaConteo.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


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

        btnStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                //Desactivo los controles
                spAlmacen.setEnabled(false);
                etFechaConteo.setEnabled(false);
                ibObtenerFecha.setEnabled(false);
                etNroConteo.setEnabled(false);
                btnStart.setEnabled(false);

                //Activo para comenzar
                etPosicion.setEnabled(true);
                btnLeerCodigo.setEnabled(true);
                etCodigoSKU.setEnabled(true);

                ActualizarInventarioConteo();
                PosicionDefault();
            }
        });

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                finish();
            }
        });

        btnLeerCodigo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //openDialogArticuloConfirm();
                try {
                    LeerCodigo();
                } catch (Exception ex) {
                    UTIL.SonidoError(AlmacenTomaInventarioActivity.this);
                    MessageBox.AlertDialog(AlmacenTomaInventarioActivity.this, "Error en lectura", ex.getMessage(), false);
                }
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etCodigoSKU.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {

                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    try{
                        LeerCodigo();
                    }catch(Exception ex){
                        UTIL.SonidoError(AlmacenTomaInventarioActivity.this);
                        MessageBox.AlertDialog(AlmacenTomaInventarioActivity.this, "Error en lectura", ex.getMessage(), false);
                    }


                }
                return false;
            }
        });

        //Cuando se pierda el foco del texto de posicion, debe actualizar los totales de stock
        etPosicion.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                ArrayAdapter<String> adapter = (ArrayAdapter<String>) etPosicion.getAdapter();
                if (!hasFocus) {
                    // code to execute when EditText loses focus
                    ActualizarInventarioConteo();
                }else{
                    if (etPosicion.getText().toString().equals(""))
                        adapter.getFilter().filter(null);
                    etPosicion.showDropDown();
                }
            }
        });

        etPosicion.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                ArrayAdapter<String> adapter = (ArrayAdapter<String>) etPosicion.getAdapter();
                if (ubicaciones.size() > 0) {
                    // show all suggestions
                    if (etPosicion.getText().toString().equals(""))
                        adapter.getFilter().filter(null);
                    etPosicion.showDropDown();
                }
                return false;
            }
        });

    }

    private boolean LeerCodigo() throws Exception {
        String lsCadena;

        // Perform action on key press
        if (etCodigoSKU.getText() != null) {
            lsCadena = etCodigoSKU.getText().toString().toUpperCase();

            if (lsCadena.contains("|") || lsCadena.contains("]")){
                //La primera cadena es el codigo de
                instanceArticulo = ImplArticulo.getInstanceArticulo(lsCadena);

                etCodigoSKU.setText(instanceArticulo.getCodigoCU());
            }else{
                instanceArticulo = null;
                etCodigoSKU.setText(lsCadena);
            }

            openDialogArticuloConfirm();
            return true;
        }else
            return false;
    }

    private void PosicionDefault() {
        new PosicionDefaultTask().execute();
    }

    public void ActualizarInventarioConteo() {
        new InventarioConteoTask().execute();
    }

    private void openDialogArticuloConfirm() {
        String strSKU = etCodigoSKU.getText().toString().trim().toUpperCase();

        if (strSKU.equals("")){
            MessageBox.AlertDialog("No ha ingresado ningun codigo para validar", "Error en filtro", AlmacenTomaInventarioActivity.this);
            return;
        }

        tvUltimoSKU.setText(strSKU);

        if (instanceArticulo != null) {
            etCodigoSKU.setText(instanceArticulo.getCodigoCU());
            tvUltimoCU.setText(instanceArticulo.getCodigoCU());
            tvUltimoSKU.setText(instanceArticulo.getCodSKU());
        }else{
            tvUltimoCU.setText("");
            tvUltimoSKU.setText("");

        }

        new DialogArticuloConfirm(AlmacenTomaInventarioActivity.this).openDialog(strSKU, instanceArticulo);
            //.ConfirmDialog(new BeanArticulo());



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

    public void setNextFocus() {
        etCodigoSKU.setFocusable(true);
        etCodigoSKU.requestFocus();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == 0 && resultCode == RESULT_OK) {
            Bitmap imageBitmap = null;
            try {
                imageBitmap = Images.Media.getBitmap(this.getContentResolver(), uriImagenPath);

                tvRutaFoto.setText(uriImagenPath.getPath());

                //ivImagen.setImageBitmap(imageBitmap.createScaledBitmap(imageBitmap, 1800, 1800, false));
                ivImagen.setImageBitmap(imageBitmap);

                ibGuardarFoto.setVisibility(ImageButton.VISIBLE);


            } catch (IOException e) {
                e.printStackTrace();
            }

        }

        super.onActivityResult(requestCode, resultCode, data);
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

    public String getFechaConteo() {
        return etFechaConteo.getText().toString();
    }

    public String getAlmacen() {
        BeanAlmacen almacen = (BeanAlmacen) spAlmacen.getSelectedItem();

        return almacen.getAlmacen();
    }

    public String getUbicacion() {
        return etPosicion.getText().toString();
    }

    public Integer getNroUbicacion() {
        return Integer.valueOf(etNroConteo.getText().toString());
    }

    public void setMensaje(String pMensaje) {
        tvMensaje.setText(pMensaje);
    }

    public void setUltimoCU(String value) {
        tvUltimoCU.setText(value);
    }

    public String getNroConteo() {
        return etNroConteo.getText().toString();
    }

    public void setLectura(String value) {
        etCodigoSKU.setText(value);
    }

    public void setUltimoSKU(String value) {
        tvUltimoSKU.setText(value);
    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplAlmacen implAlmacen = null;
        ImplConfiguracion implConfiguracion = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenTomaInventarioActivity.this);
            pDialog.setMessage("Cargando datos por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            String ls_fechaConteo, ls_almacen, li_NroConteo;
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //Creacion de los controladores
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                implConfiguracion = new ImplConfiguracion(ImplEmpresa.empresaDefault.getCodigo());

                //Listado de Articulos
                almacenes = implAlmacen.getAlmacenesActivos();

                //Obtengo los parametros por defecto
                if (implConfiguracion.getParametro("ALMACEN_TOTAL_ARTICULOS_LEIDOS", "0").equals("0"))
                    ibTotalArticulosLeidos = false;
                else
                    ibTotalArticulosLeidos = true;

                if (implConfiguracion.getParametro("ALMACEN_TOTAL_ARTICULOS_USUARIO", "0").equals("0"))
                    ibTotalArticulosUsuario = false;
                else
                    ibTotalArticulosUsuario = true;

                if (implConfiguracion.getParametro("ALMACEN_SHOW_FOTOGRAFIA", "0").equals("0"))
                    ibShowFotografia = false;
                else
                    ibShowFotografia = true;
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
                ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(AlmacenTomaInventarioActivity.this,
                        R.layout.support_simple_spinner_dropdown_item, almacenes);

                spAlmacen.setAdapter(adapter);
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
    private class InventarioConteoTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplInventarioConteo implInventarioConteo = null;

        private ProgressDialog pDialog;

        Integer liTotalLeido, liTotalLeidoUsuario, liTotalLeidoPosicion;
        BeanAlmacen almacenSelected;
        BeanUsuario userLogin;
        String ls_fechaConteo, ls_almacen, ls_Posicion;
        Integer li_NroConteo;

        protected void onPreExecute() {
            super.onPreExecute();
            //Obtengo los datos necesarios
            almacenSelected = (BeanAlmacen)spAlmacen.getSelectedItem();

            ls_almacen = almacenSelected.getAlmacen();
            ls_fechaConteo = etFechaConteo.getText().toString();
            li_NroConteo = Integer.valueOf(etNroConteo.getText().toString());
            ls_Posicion = etPosicion.getText().toString();

            pDialog = new ProgressDialog(AlmacenTomaInventarioActivity.this);
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
                //Obtengo los datos necesarios para el conteo}
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                implInventarioConteo = new ImplInventarioConteo(ImplEmpresa.empresaDefault.getCodigo());

                if (ibTotalArticulosLeidos)
                    liTotalLeido = implInventarioConteo.getTotalLeido(ls_fechaConteo, ls_almacen, li_NroConteo);
                else
                    liTotalLeido = 0;

                if (ibTotalArticulosUsuario)
                    liTotalLeidoUsuario = implInventarioConteo.getTotalLeidoUsuario(ls_fechaConteo, ls_almacen, li_NroConteo, userLogin.getUsuario());
                else
                    liTotalLeidoUsuario = 0;

                liTotalLeidoPosicion = implInventarioConteo.getTotalbyUbicacion(ls_fechaConteo, ls_almacen, li_NroConteo, ls_Posicion);

                //Listado de ubicaciones
                ubicaciones = implInventarioConteo.getListadoPosicion(ls_almacen);
                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implInventarioConteo = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (liTotalLeido == null)
                    tvTotalLeido.setText("0");
                else
                    tvTotalLeido.setText(UTIL.ConvetToString(liTotalLeido, "###,##0"));

                if (liTotalLeido == null)
                    tvTotalUser.setText("0,000");
                else
                    tvTotalUser.setText(UTIL.ConvetToString(liTotalLeidoUsuario, "###,##0"));

                if (liTotalLeidoPosicion == null)
                    tvTotalLeidoPosicion.setText("0,000");
                else
                    tvTotalLeidoPosicion.setText(UTIL.ConvetToString(liTotalLeidoPosicion, "###,##0"));

                // Le pasamos las regiones al adaptador
                ArrayAdapter<String> adapter = new ArrayAdapter<String>(AlmacenTomaInventarioActivity.this, android.R.layout.simple_list_item_1, ubicaciones);

                // finalmente le asignamos el adaptador a nuestro elemento
                etPosicion.setAdapter(adapter);

                etCodigoSKU.requestFocus();

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
    private class PosicionDefaultTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, ls_almacen, lsPosicion;

        ImplInventarioConteo implInventarioConteo = null;

        private ProgressDialog pDialog;

        BeanAlmacen almacenSelected;

        protected void onPreExecute() {
            super.onPreExecute();
            //Obtengo los datos necesarios
            almacenSelected = (BeanAlmacen)spAlmacen.getSelectedItem();

            ls_almacen = almacenSelected.getAlmacen();

            pDialog = new ProgressDialog(AlmacenTomaInventarioActivity.this);
            pDialog.setMessage("Obteniendo la Posición por defecto para el almacen [" + ls_almacen + "], por favor espere...");
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
                //Obteniendo el almacen por defecto
                implInventarioConteo = new ImplInventarioConteo(ImplEmpresa.empresaDefault.getCodigo());

                lsPosicion = implInventarioConteo.getUbicacionMinima(ls_almacen);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implInventarioConteo = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if(result) {
                    if (lsPosicion != null)
                        etPosicion.setText(lsPosicion);
                }else{
                    MessageBox.AlertDialog(AlmacenTomaInventarioActivity.this, "Error",
                                          "Error en busqueda de posición minima. Mensaje " + mensaje,
                                            false);
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
