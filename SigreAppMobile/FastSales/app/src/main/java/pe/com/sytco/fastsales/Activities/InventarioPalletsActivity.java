package pe.com.sytco.fastsales.Activities;

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
import android.widget.Spinner;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Calendar;
import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenOpcionesActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteTransferencia;
import pe.com.sytco.fastsales.Controller.Almacen.ImplPosiciones;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplInventarioPallet;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Dialog.DialogLeerPallets;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewPosicionesAdapter;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Almacen.BeanPosiciones;
import pe.com.sytco.fastsales.beans.BeanInventarioPallet;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.data.SigreAppHelper;
import pe.com.sytco.fastsales.data.TgPosiciones;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class InventarioPalletsActivity extends AppCompatActivity {

    private SigreAppHelper sigreAppHelper;

    //Interfax de usuario
    private Spinner spAlmacen, spFila, spAnaquel;
    TextView tvMensaje;
    private ImageButton ibObtenerFecha;
    private Button  btnLeerColumnas, btnSalir, btnCargarDatos, btnLeerPallets, btnActulizarDatos;
    EditText etFechaInventario;
    ListView lvListadoColumnas;

    //Datos necesarios
    BeanAlmacen almacenSelect;
    List<BeanAlmacen> almacenes;

    //Calendario para obtener fecha & hora
    public final Calendar c = Calendar.getInstance();

    //Variables para obtener la fecha
    final int mes = c.get(Calendar.MONTH);
    final int dia = c.get(Calendar.DAY_OF_MONTH);
    final int year = c.get(Calendar.YEAR);

    //Listado de Cajas
    ArrayAdapter adaptador;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_inventario_pallets);

        //Creo la base de datos
        // Instancia de helper
        sigreAppHelper = new SigreAppHelper(getApplicationContext());

        InitControllers();

        // Carga de datos
        LoadDataDefault();

        AsignarEventos();

    }


    private void InitControllers() {
        spAlmacen = (Spinner)findViewById(R.id.spAlmacen);
        spFila = (Spinner)findViewById(R.id.spFila);
        spAnaquel = (Spinner)findViewById(R.id.spAnaquel);

        etFechaInventario = (EditText) findViewById(R.id.etFechaInventario);

        tvMensaje= (TextView) findViewById(R.id.tvMensaje);

        ibObtenerFecha = (ImageButton)findViewById(R.id.ibObtenerFecha);

        btnLeerColumnas = (Button) findViewById(R.id.btnLeerColumnas);
        btnLeerPallets = (Button) findViewById(R.id.btnLeerPallets);
        btnCargarDatos = (Button) findViewById(R.id.btnCargarDatos);
        btnActulizarDatos = (Button) findViewById(R.id.btnActulizarDatos);
        btnSalir = (Button) findViewById(R.id.btnSalir);

        lvListadoColumnas = (ListView) findViewById(R.id.lvListadoColumnas);
    }

    private void AsignarEventos() {

        spAlmacen.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                almacenSelect = (BeanAlmacen) adapterView.getItemAtPosition(position);
                new InventarioPalletsActivity.LoadAnaquelesTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenSelect = null;
            }
        });

        spAnaquel.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                almacenSelect = (BeanAlmacen) spAlmacen.getSelectedItem();
                new InventarioPalletsActivity.LoadFilasTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                almacenSelect = null;
            }
        });

        spFila.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                LeerColumnas();
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
                DatePickerDialog recogerFecha = new DatePickerDialog(InventarioPalletsActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        //Esta variable lo que realiza es aumentar en uno el mes ya que comienza desde 0 = enero
                        final int mesActual = month + 1;

                        //Muestro la fecha con el formato deseado
                        etFechaInventario.setText(UTIL.DateToString(dayOfMonth, mesActual, year));


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

        btnCargarDatos.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new CargarDatosTask().execute();
            }
        });

        btnLeerColumnas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LeerColumnas();
            }
        });

        btnLeerPallets.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openDialogLeerPallets();
            }
        });

        btnActulizarDatos.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                actualizarDatos();
            }
        });

    }

    private void actualizarDatos() {
        new ActualizarDatosToServerTask().execute();
    }

    public void LeerColumnas() {
        new ListarColumnasTask().execute();
    }


    private void openDialogLeerPallets() {
        new DialogLeerPallets(InventarioPalletsActivity.this, ImplInventarioPallet.getListadoColumnas(), sigreAppHelper).ConfirmDialog();


    }

    private void LoadDataDefault() {
        new LoadDataDefaultTask().execute();
    }

    private class LoadDataDefaultTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, isFechaRecepcion;

        ImplPosiciones implPosiciones = null;
        ImplUtil implUtil = null;

        List<BeanPosiciones> posiciones = null;


        private ProgressDialog pDialog;


        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(InventarioPalletsActivity.this);
            pDialog.setMessage("Cargando datos del servidor por favor espere...");
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

                //Ahora obtengo el listado de almacenes
                almacenes = sigreAppHelper.getAlmacenes();


                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar datos del servidor: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implPosiciones = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    etFechaInventario.setText(isFechaRecepcion);

                    //CArgo el listado de almacenes
                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(InventarioPalletsActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, almacenes);

                    spAlmacen.setAdapter(adapter);

                }else{
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Error al cargar datos por defecto", mensaje, false);
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

    private class CargarDatosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, isFechaRecepcion;

        ImplPosiciones implPosiciones = null;
        ImplUtil implUtil = null;
        BeanUsuario userLogin = null;
        String lsOrigen;

        List<BeanPosiciones> posiciones = null;


        private ProgressDialog pDialog;


        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(InventarioPalletsActivity.this);
            pDialog.setMessage("Cargando datos del servidor por favor espere...");
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

                //Obtengo el usuario que se ha logueado
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }

                //Obtengo el origen
                if (userLogin.getOrigenAlt() == null)
                    lsOrigen = ImplEmpresa.empresaDefault.getCodOrigen();
                else
                    lsOrigen = userLogin.getOrigenAlt();

                //Obtengo la fecha de recepcion
                implUtil = new ImplUtil(ImplEmpresa.empresaDefault.getCodigo());
                isFechaRecepcion = UTIL.parseSqlDatetoString(implUtil.TimeServidor(), "dd/MM/yyyy");

                //Declaro el objeto para las Posiciones
                implPosiciones = new ImplPosiciones(ImplEmpresa.empresaDefault.getCodigo());

                //Debo obtener las posiciones por usuario y por origen
                posiciones = implPosiciones.getAll(userLogin.getUsuario(), lsOrigen);

                sigreAppHelper.deletePosiciones();

                for(BeanPosiciones bean : posiciones){
                    sigreAppHelper.insertPosicion(TgPosiciones.instanceOf(bean));
                }

                //Ahora obtengo el listado de almacenes
                almacenes = sigreAppHelper.getAlmacenes();


                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar datos del servidor: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implPosiciones = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    etFechaInventario.setText(isFechaRecepcion);

                    //CArgo el listado de almacenes
                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(InventarioPalletsActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, almacenes);

                    spAlmacen.setAdapter(adapter);

                }else{
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Error al cargar datos por defecto", mensaje, false);
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
    private class LoadAnaquelesTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteTransferencia implParteTransferencia = null;
        private List<String> anaqueles;
        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(InventarioPalletsActivity.this);
            pDialog.setMessage("Obteniendo ANAQUELES por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //Obtengo el nro de Pallet correto
                anaqueles = sigreAppHelper.getAnaqueles(almacenSelect.getAlmacen());

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
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(InventarioPalletsActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, anaqueles);

                    spAnaquel.setAdapter(adapter);
                }else{
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Error al cargar anaqueles de origen", mensaje, false);
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
    private class LoadFilasTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, Anaquel;

        ImplParteTransferencia implParteTransferencia = null;
        private List<String> filas;
        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();

            Anaquel = spAnaquel.getSelectedItem().toString();

            pDialog = new ProgressDialog(InventarioPalletsActivity.this);
            pDialog.setMessage("Obteniendo FILAS por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //Obtengo el nro de Pallet correto
                filas = sigreAppHelper.getFilas(almacenSelect.getAlmacen(), Anaquel);

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
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(InventarioPalletsActivity.this,
                            R.layout.support_simple_spinner_dropdown_item, filas);

                    spFila.setAdapter(adapter);
                }else{
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Error al cargar filas ", mensaje, false);
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
    private class ListarColumnasTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, almacen, anaquel, fila, fecInventario;

        ImplParteTransferencia implParteTransferencia = null;

        private ProgressDialog pDialog;


        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(InventarioPalletsActivity.this);
            pDialog.setMessage("Obteniendo Listado de Columnas por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                almacen = ((BeanAlmacen)spAlmacen.getSelectedItem()).getAlmacen();
                anaquel = (String) spAnaquel.getSelectedItem();
                fila = (String) spFila.getSelectedItem();
                fecInventario = etFechaInventario.getText().toString();

                //Valido el numero de Pallet
                List<BeanInventarioPallet> columnas = sigreAppHelper.getColumnas(fecInventario, almacen, anaquel, fila);
                ImplInventarioPallet.setListadoColumnas(columnas);
                ImplInventarioPallet.setFechaInventario(fecInventario);

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
                    if (ImplInventarioPallet.getListadoColumnas().size() == 0){
                        btnLeerPallets.setEnabled(false);
                    }else{
                        btnLeerPallets.setEnabled(true);
                    }


                    //Indico el adaptador para el listado de Servidores
                    adaptador = new ListViewPosicionesAdapter(InventarioPalletsActivity.this, ImplInventarioPallet.getListadoColumnas(),
                                                            InventarioPalletsActivity.this, sigreAppHelper);
                    lvListadoColumnas.setAdapter(adaptador);

                    //tvNroRegistros.setText(UTIL.ConvetToString(ImplListadoCajas.getListadoCajas().size(), "###,##0"));

                    //Le pongo el foco a la lista de Servidores
                    lvListadoColumnas.requestFocus();


                }else{
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Error en ListarColumnasTask(), Listar columnas", mensaje, false);
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
    private class ActualizarDatosToServerTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, fecInventario;

        ImplInventarioPallet implInventarioPallet = null;

        private ProgressDialog pDialog;



        protected void onPreExecute() {
            super.onPreExecute();

            fecInventario = etFechaInventario.getText().toString();

            pDialog = new ProgressDialog(InventarioPalletsActivity.this);
            pDialog.setMessage("Actualizando los datos directos al servidor, por favor espere...");
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
                List<BeanInventarioPallet> _inventario = sigreAppHelper.getInventario(fecInventario);
                implInventarioPallet = new ImplInventarioPallet(ImplEmpresa.empresaDefault.getCodigo(), InventarioPalletsActivity.this);

                implInventarioPallet.saveInventario(_inventario);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al grabar datos del inventario en la base de datos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implInventarioPallet = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    UTIL.SonidoCorrecto(InventarioPalletsActivity.this);
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Grabacion correcta", "Datos Guardados correctamente", true);

                }else{
                    MessageBox.AlertDialog(InventarioPalletsActivity.this, "Error en ActualizarDatosToServerTask()", mensaje, false);
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
