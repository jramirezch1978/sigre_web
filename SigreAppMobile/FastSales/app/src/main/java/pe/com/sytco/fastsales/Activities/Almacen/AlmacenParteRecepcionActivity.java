package pe.com.sytco.fastsales.Activities.Almacen;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.gson.Gson;

import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteIngreso;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteRecepcion;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.ParteIngresoUI;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.Parametros;
import pe.com.sytco.fastsales.util.UTIL;

public class AlmacenParteRecepcionActivity extends AppCompatActivity {

    //Interfaz de usuario
    private FloatingActionButton fab;
    private Toolbar toolbar;
    private ImageButton ibObtenerFechaDesde, ibObtenerFechaHasta;
    private EditText etFechaDesde, etFechaHasta;
    private Button btnBuscar, btnSalir;
    private TextView tvTotalVenta, tvTotalCompra, tvTotalCajas, tvTotalRegistros;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes2 = c.get(Calendar.MONTH);
    final int dia2 = c.get(Calendar.DAY_OF_MONTH);
    final int year2 = c.get(Calendar.YEAR);

    final int mes1 = c.get(Calendar.MONTH);
    final int dia1 = 1;
    final int year1 = c.get(Calendar.YEAR);

    //Listado de busqueda
    List<BeanParteIngreso> _listado = null;
    private Parametros _strParam = null;

    //Objeto para el UI de la Activity
    private ParteIngresoUI parteIngresoUI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            super.onCreate(savedInstanceState);

            if(ImplEmpresa.empresaDefault == null) {
                throw new Exception("No se ha especificado la empresa");
            }

            setContentView(R.layout.activity_almacen_parte_recepcion);


            InitControllers();

            AsignarEventos();

            LoadDataDefault();

        }catch (Exception e) {

            MessageBox.AlertDialog(AlmacenParteRecepcionActivity.this, "Ha ocurrido un error",
                    "Mensaje de Error: " + e.getMessage(), false);
            e.printStackTrace();

        }


    }

    private void InitControllers() {
        String lstrJSON = "";
        //Cargo el strParam que se trae del otro Activity
        if (getIntent().getExtras().getString("strParam") != null) {

            lstrJSON = getIntent().getExtras().getString("strParam");

            if (lstrJSON != null && !lstrJSON.equals("")){
                _strParam = new Gson().fromJson(lstrJSON, Parametros.class);
            }else{
                _strParam = null;
            }

        }

        //Creo el objeto para el UI de esta ventana
        parteIngresoUI = new ParteIngresoUI(this);

        fab = (FloatingActionButton) findViewById(R.id.fab);
        toolbar = (Toolbar) findViewById(R.id.toolbar);

        ibObtenerFechaDesde = (ImageButton)findViewById(R.id.ibObtenerFechaDesde);
        ibObtenerFechaHasta = (ImageButton)findViewById(R.id.ibObtenerFechaHasta);

        etFechaDesde = (EditText) findViewById(R.id.etFechaDesde);
        etFechaHasta = (EditText) findViewById(R.id.etFechaHasta);

        tvTotalVenta = (TextView) findViewById(R.id.tvTotalVenta);
        tvTotalCompra = (TextView) findViewById(R.id.tvTotalCompra);
        tvTotalCajas = (TextView) findViewById(R.id.tvTotalCajas);
        tvTotalRegistros = (TextView) findViewById(R.id.tvTotalRegistros);

        btnBuscar = (Button) findViewById(R.id.btnBuscar);
        btnSalir = (Button) findViewById(R.id.btnSalir);

    }

    private void AsignarEventos() {
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Parametros strParam = new Parametros();
                String lstr_JSON = "";

                strParam.setAction("NEW");


                strParam.setAction("NEW");
                strParam.setListado(_listado);

                lstr_JSON = new Gson().toJson(strParam);

                Intent intent = new Intent(getApplicationContext(), AlmacenParteRecepcionPopupActivity.class);
                intent.putExtra("strParam", lstr_JSON);
                startActivity(intent);
                finish();

            }
        });

        toolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                switch (item.getItemId()){
                    case R.id.salir:
                        actionExit();
                        return true;
                }
                return false;
            }
        });

        ibObtenerFechaDesde.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenParteRecepcionActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaDesde.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


                    }
                    //Estos valores deben ir en ese orden, de lo contrario no mostrara la fecha actual
                    /**
                     *También puede cargar los valores que usted desee
                     */
                },year1, mes1, dia1);

                //Muestro el widget
                recogerFecha.show();
            }
        });

        ibObtenerFechaHasta.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(AlmacenParteRecepcionActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaHasta.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


                    }
                    //Estos valores deben ir en ese orden, de lo contrario no mostrara la fecha actual
                    /**
                     *También puede cargar los valores que usted desee
                     */
                },year2, mes2, dia2);

                //Muestro el widget
                recogerFecha.show();
            }
        });

        btnBuscar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String pFechaInicio, pFechaFin;

                pFechaInicio = etFechaDesde.getText().toString();
                pFechaFin = etFechaHasta.getText().toString();

                new BuscarRegistrosTask(pFechaInicio, pFechaFin).execute();
            }
        });

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                finish();
            }
        });
    }

    private void LoadDataDefault() {
        //setSupportActionBar(toolbar);

        toolbar.inflateMenu(R.menu.left_menu);

        toolbar.setTitle(R.string.title_activity_almacen_parte_recepcion);

        etFechaDesde.setText(UTIL.DateToString(dia1, mes1 + 1, year1));
        etFechaHasta.setText(UTIL.DateToString(dia2, mes2 + 1, year2));

        parteIngresoUI.addHeaderParteRecepcion();

        if (_strParam != null){
            if (_strParam.getListado() != null && _strParam.getListado().size() > 0){
                this._listado = _strParam.getListado();
                drawPedido(this._listado);
            }
        }
    }

    //Accion de Salir
    private void actionExit() {
        startActivity(new Intent(getApplicationContext(), HomeActivity.class));
        finish();
    }


    //Funciones para la logica de negocio
    //Dibuja la tabla para el pedido
    private void drawPedido(List<BeanParteIngreso> listado) {

        parteIngresoUI.drawListadoPartes(listado);

        //Pongo los totales
        tvTotalCajas.setText(UTIL.ConvetToString(ImplParteRecepcion.getTotalCajas(listado), "###,##0"));
        tvTotalCompra.setText(UTIL.ConvetToString(ImplParteRecepcion.getTotalCompra(listado), "###,##0.00"));
        tvTotalVenta.setText(UTIL.ConvetToString(ImplParteRecepcion.getTotalVenta(listado), "###,##0.00"));
        tvTotalRegistros.setText(UTIL.ConvetToString(listado.size(), "###,##0"));

    }


    //Clase Asincrona para tareas en segundo plano
    private class BuscarRegistrosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, fechaInicio, fechaFin;
        private ProgressDialog pDialog;
        ImplParteIngreso implParteIngreso = null;


        public BuscarRegistrosTask(String pFechaInicio, String pFechaFin){
            this.fechaFin = pFechaFin;
            this.fechaInicio = pFechaInicio;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(AlmacenParteRecepcionActivity.this);
            pDialog.setMessage("Buscando la información según los parametros, por favor espere...");
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
                implParteIngreso = new ImplParteIngreso(ImplEmpresa.empresaDefault.getCodigo());

                //LLenado de Lista para los cursos
                _listado = implParteIngreso.getListadoByFechas(fechaInicio, fechaFin);

                return true;

            } catch (Exception ex) {
                mensaje =  ex.getMessage();
                ex.printStackTrace();
                return false;
            }finally {
                implParteIngreso = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    drawPedido(_listado);

                } else {
                    UTIL.SonidoError(AlmacenParteRecepcionActivity.this);
                    MessageBox.AlertDialog(AlmacenParteRecepcionActivity.this, "Error al recuperar registros", mensaje, false);
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
