package pe.com.sytco.fastsales.Activities.Ventas;

import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenRecepcionPPTTActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewProformaAdapter;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class VentasListarProformasActivity extends AppCompatActivity {

    //Controles de la interfaz
    private ListView lvListaProforma;
    private Button btnCerrar, btnReporte;
    private TextView tvNroProformas, tvTotalVenta;
    private ImageButton ibObtenerFecha;
    private EditText etFechaProforma;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);

    //Listados
    List<BeanProforma> listaProformas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {

            if(ImplEmpresa.empresaDefault == null) {
                throw new Exception("No se ha especificado la empresa");
            }

            // Hide title bar
            setContentView(R.layout.activity_ventas_listar_proformas);

            //Referencia a controles
            InitControllers();

            AsignarEventos();

            LoadDataDefault();

        } catch (Exception e) {
            e.printStackTrace();
            MessageBox.AlertDialog(VentasListarProformasActivity.this, "Ha ocurrido un error",
                    "Mensaje de Error: " + e.getMessage(), false);
        }

    }

    private void InitControllers() {
        //Lista de Proformas
        lvListaProforma = (ListView) findViewById(R.id.lvListaProforma);
        btnCerrar = (Button) findViewById(R.id.btnCerrar);
        ibObtenerFecha = (ImageButton) findViewById(R.id.ibObtenerFecha);
        etFechaProforma = (EditText) findViewById(R.id.etFechaProforma);
        btnReporte = (Button) findViewById(R.id.btnReporte);

        tvNroProformas= (TextView) findViewById(R.id.tvNroProformas);
        tvTotalVenta= (TextView) findViewById(R.id.tvTotalVenta);

    }

    private void AsignarEventos() {
        //ASigno el listener para el click en un item del listView
        lvListaProforma.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanProforma item = listaProformas.get(position);

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al insertar un detalle al pedido. Exception: " + ex.getMessage(), "Function insertarPedido", getBaseContext());
                }
            }
        });

        btnCerrar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), VentasOpcionesActivity.class));
                finish();
            }
        });

        //Boton para el boton de obtener fecha
        ibObtenerFecha.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog recogerFecha = new DatePickerDialog(VentasListarProformasActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaProforma.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


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

        btnReporte.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BuscarProformas();
            }
        });
    }

    public void BuscarProformas() {
        new BuscarProformasTask().execute();
    }

    private void LoadDataDefault() {
        new LoadTask().execute();
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, isFechaRecepcion;

        ImplAlmacen implAlmacen = null;
        ImplUtil implUtil = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(VentasListarProformasActivity.this);
            pDialog.setMessage("Buscando proformas para la fecha indicada, por favor espere...");
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
                mensaje = "Error en LoadTask(). Mensaje: " + ex.getMessage();
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


                    etFechaProforma.setText(isFechaRecepcion);

                }else{
                    MessageBox.AlertDialog(VentasListarProformasActivity.this, "Error", mensaje, false);
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
    private class BuscarProformasTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, fechaProforma;
        private ImplPedido implPedido = null;
        private ProgressDialog pDialog;
        private BeanUsuario userLogin = null;

        public BuscarProformasTask()
        {

        }


        protected void onPreExecute() {
            super.onPreExecute();

            fechaProforma = etFechaProforma.getText().toString();

            pDialog = new ProgressDialog(VentasListarProformasActivity.this);
            pDialog.setMessage("Buscando Proformas creadas por usted, por favor espere...");
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

                if (userLogin == null) {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }

                //LLenado de Lista para los articulos
                implPedido = new ImplPedido(ImplEmpresa.empresaDefault.getCodigo());
                listaProformas = implPedido.getProformasByVendedorAndFecha(userLogin.getUsuario(), fechaProforma);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implPedido = null;
            }


        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                implPedido = new ImplPedido(ImplEmpresa.empresaDefault.getCodigo());

                if (result) {

                    ArrayAdapter<BeanProforma> adapter = new ListViewProformaAdapter(VentasListarProformasActivity.this, listaProformas);

                    lvListaProforma.setAdapter(adapter);

                    tvNroProformas.setText(UTIL.ConvetToString(listaProformas.size(), "###,##0"));
                    tvTotalVenta.setText(UTIL.ConvetToString(implPedido.getTotalVenta(listaProformas), "###,##0.00"));
                }else{
                    MessageBox.AlertDialog(VentasListarProformasActivity.this, "Error al Listar proformas", mensaje, false);
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