package pe.com.sytco.fastsales.Dialog;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenRecepcionPPTTActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteEmpaque;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteRecepcion;
import pe.com.sytco.fastsales.Controller.ImplUtil;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.ParteRecepcion.BeanParteRecepcion;
import pe.com.sytco.fastsales.beans.ParteRecepcion.BeanParteRecepcionUnd;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogConfirmCajaCU {
    Context context = null;
    private String _almacenOrg, _nroPallet, _fecRecepcion, _almacenDst;

    //Datos
    List<BeanCaja> _listadoCajas = null;
    List<BeanAlmacen> almacenesDst;

    //Controles de la interfaz
    private TextView tvTotalRegistros;
    private Button btnAceptar, btnCerrar, btnListarCajas;
    private Spinner spAnaquel, spFila, spColumna, spAlmacenDst;

    //Variables por defecto
    ArrayAdapter adaptador;

    //VAriables para el cuadrio de dialogo
    private View dialoglayout;
    private AlertDialog dialogMain = null;
    
    private AlertDialog.Builder builder;

    private DialogConfirmCajaCU(){

    }

    public DialogConfirmCajaCU(Context value, String almacenOrg, String fecRecepcion){
        this.context = value;
        this._almacenOrg = almacenOrg;
        this._fecRecepcion = fecRecepcion;
    }

    private void InitControllers() {
        //Botones
        btnCerrar = (Button) dialoglayout.findViewById(R.id.btnCerrar);
        btnAceptar = (Button) dialoglayout.findViewById(R.id.btnAceptar);
        btnListarCajas = (Button) dialoglayout.findViewById(R.id.btnListarCajas);

        //Spinners
        spAlmacenDst = (Spinner)dialoglayout.findViewById(R.id.spAlmacenDst);
        spAnaquel = (Spinner) dialoglayout.findViewById(R.id.spAnaquel);
        spFila = (Spinner) dialoglayout.findViewById(R.id.spFila);
        spColumna = (Spinner) dialoglayout.findViewById(R.id.spColumna);

        tvTotalRegistros = (TextView) dialoglayout.findViewById(R.id.tvTotalRegistros);

    }

    private void LoadData() {
        new LoadDataTask().execute();
    }



    public void openDialog(final String value){
        this._nroPallet = value;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((AlmacenRecepcionPPTTActivity)context).getLayoutInflater();

        dialoglayout = inflater.inflate(R.layout.dialog_confirm_caja_cu, null);

        builder.setView(dialoglayout);

        InitControllers();
        AsignarEventos();

        LoadData();

    }


    public void ShowDialog(){

        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();


        dialogMain.show();


    }



    private void AsignarEventos() {
        //Activo la opcion de cierre
        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
                        dialogo1.setTitle("Cerrar destino de Recepcion");
                        dialogo1.setMessage("¿ Desea cerrar la VENTANA de ALMACEN DE DESTINO?");
                        dialogo1.setCancelable(false);
                        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialogo1, int id) {
                                dialogMain.dismiss();
                                //dialogo1.dismiss();

                            }
                        });
                        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialogo1, int id) {
                                //dialogo1.dismiss();
                            }
                        });
                        dialogo1.show();

                    }
                }
        );

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        guardarPallet();
                        //dialog.dismiss();
                    }
                }
        );



        //Activo la opcion de cierre
        btnListarCajas.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        //Cuadro de dialogo para mostrar todas las cajas

                        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
                        dialogo1.setTitle("Listado de Cajas");
                        dialogo1.setMessage("¿ Desea visualizar todas las cajas del PALLET?. Tener en cuenta que dicha carga va a demandar algo de tiempo.");
                        dialogo1.setCancelable(false);
                        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialogo1, int id) {

                                new DialogListadoCajas(context).openDialog(_nroPallet);
                            }
                        });
                        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialogo1, int id) {
                                dialogo1.dismiss();
                            }
                        });
                        dialogo1.show();


                    }
                }
        );
        spAlmacenDst.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                BeanAlmacen almacenSelect = (BeanAlmacen) adapterView.getItemAtPosition(position);
                _almacenDst = almacenSelect.getAlmacen();

                new LoadAnaquelesTask(_almacenDst).execute();

            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        //Añado los eventos al spinner
        spAnaquel.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                String anaquel = (String) adapterView.getItemAtPosition(position);
                new LoadFilasTask(anaquel).execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        //Añado los eventos al spinner
        spFila.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {

                String anaquel = (String) spAnaquel.getSelectedItem();
                String fila = (String) adapterView.getItemAtPosition(position);
                new LoadColumnasTask(anaquel, fila).execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    private void guardarPallet() {
        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
        dialogo1.setTitle("Guardar la recepcion");
        dialogo1.setMessage("¿ Desea guardar la recepcion del PALLET " + _nroPallet + "?.");
        dialogo1.setCancelable(false);
        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

                new SaveRecepcionTask().execute();
            }
        });
        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

            }
        });
        dialogo1.show();
    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadAnaquelesTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplParteRecepcion implParteRecepcion = null;
        private ProgressDialog pDialog;
        private String _almacen;

        private List<String> anaqueles;

        private LoadAnaquelesTask()
        {

        }

        private LoadAnaquelesTask(String almacenDst)
        {
            this._almacen = almacenDst;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando Anaqueles del Almacen " + _almacen + " por favor espere...");
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
                implParteRecepcion = new ImplParteRecepcion(ImplEmpresa.empresaDefault.getCodigo());
                anaqueles = implParteRecepcion.getAnaquelLibreByAlmacen(_almacen);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteRecepcion = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (anaqueles.size() == 0) {
                    MessageBox.AlertDialog("No existen Anaqueles para el almacen "
                                    + _almacen, "Error", context);
                    return;
                }

                //Oculto el teclado
                UTIL.OcultarTeclado(context, spAlmacenDst);

                //Cargo la informacion
                ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, R.layout.support_simple_spinner_dropdown_item, anaqueles);

                spAnaquel.setAdapter(adapter);

                spAnaquel.requestFocus();

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
        String mensaje;
        ImplParteRecepcion implParteRecepcion = null;
        private ProgressDialog pDialog;
        private String anaquel;

        private List<String> filas;

        private LoadFilasTask()
        {

        }

        public LoadFilasTask(String value){

            anaquel = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando Filas del Anaquel " + anaquel + " por favor espere...");
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
                implParteRecepcion = new ImplParteRecepcion(ImplEmpresa.empresaDefault.getCodigo());
                filas = implParteRecepcion.getFilaByAlmacen(_almacenDst, anaquel);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteRecepcion = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (filas.size() == 0) {
                    MessageBox.AlertDialog("No existen Filas para el Anaquel " + anaquel
                            + " del almacen " + _almacenDst, "Error", context);
                    return;
                }

                //Oculto el teclado
                UTIL.OcultarTeclado(context, spAlmacenDst);

                //Cargo la informacion
                ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, R.layout.support_simple_spinner_dropdown_item, filas);

                spFila.setAdapter(adapter);

                spFila.requestFocus();

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
    private class LoadColumnasTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplParteRecepcion implParteRecepcion = null;
        private ProgressDialog pDialog;
        private String anaquel, fila;

        private List<String> columnas;

        private LoadColumnasTask()
        {

        }

        public LoadColumnasTask(String value, String value2){

            anaquel = value;
            fila = value2;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando Columnas del Anaquel " + anaquel + ", Fila " + fila + " por favor espere...");
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
                implParteRecepcion = new ImplParteRecepcion(ImplEmpresa.empresaDefault.getCodigo());
                columnas = implParteRecepcion.getColumnaByAlmacen(_almacenDst, anaquel, fila);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteRecepcion = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (columnas.size() == 0) {
                    MessageBox.AlertDialog("No existen Columnas para la fila " + fila
                                    + " del Anaquel " + anaquel + " del almacen " + _almacenDst, "Error", context);
                    return;
                }

                //Oculto el teclado
                UTIL.OcultarTeclado(context, spAlmacenDst);

                //Cargo la informacion
                ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, R.layout.support_simple_spinner_dropdown_item, columnas);

                spColumna.setAdapter(adapter);

                spColumna.requestFocus();

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
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplAlmacen implAlmacen = null;
        ImplParteEmpaque implParteEmpaque = null;
        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando Almacenes de destino por favor espere...");
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

                if(_almacenOrg == null)
                {
                    mensaje = "No se ha especificado un almacen Origen, por favor corrija";
                    return false;
                }

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) ((AlmacenRecepcionPPTTActivity)context).getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }
                //LLenado de Lista para los articulos
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                almacenesDst = implAlmacen.getAlmacenPPTTByUser(_almacenOrg, userLogin.getUsuario());

                //Obtengo el total de las cajas
                implParteEmpaque = new ImplParteEmpaque(ImplEmpresa.empresaDefault.getCodigo());
                _listadoCajas = implParteEmpaque.getCajasByPallet(_nroPallet);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implAlmacen = null;
                implParteEmpaque = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(context,
                            R.layout.support_simple_spinner_dropdown_item, almacenesDst);

                    spAlmacenDst.setAdapter(adapter);

                    //Coloco el total de las cajas
                    tvTotalRegistros.setText(UTIL.ConvetToString(_listadoCajas.size(), "###,##0"));

                    //Mostrar la caja de dialogo
                    ShowDialog();

                }else{
                    spAlmacenDst.requestFocus();
                    MessageBox.AlertDialog(context, "Error al selecionar almacen destino", mensaje, false);
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
    private class SaveRecepcionTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplParteRecepcion implParteRecepcion = null;
        ImplUtil implUtil= null;
        private ProgressDialog pDialog;
        BeanUsuario userLogin;

        //Datos para grabar
        BeanParteRecepcion cabecera;
        List<BeanParteRecepcionUnd> detalle;

        private SaveRecepcionTask()
        {

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Guardando la recepcion del PALLET " + _nroPallet + ", por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @SuppressLint("WrongThread")
        @Override
        protected Boolean doInBackground(Integer... params) {

            //Datos que necesito
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                implParteRecepcion = new ImplParteRecepcion(ImplEmpresa.empresaDefault.getCodigo());
                implUtil = new ImplUtil(ImplEmpresa.empresaDefault.getCodigo());

                //Datos del usuario
                final GlobalClass globalVariable = (GlobalClass) context.getApplicationContext();
                userLogin = globalVariable.getUserLogin();


                cabecera = new BeanParteRecepcion();
                detalle = new ArrayList<BeanParteRecepcionUnd>();

                //Datos de la cabecera
                cabecera.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
                cabecera.setAlmacenOrg(_almacenOrg);
                cabecera.setAlmacenDst(_almacenDst);
                cabecera.setFecRecepcion(UTIL.parseStringToSqlDate(_fecRecepcion, "dd/MM/yyyy"));
                cabecera.setAnaquel((String) spAnaquel.getSelectedItem());
                cabecera.setFila((String) spFila.getSelectedItem());
                cabecera.setColumna((String) spColumna.getSelectedItem());
                cabecera.setCodUsr(userLogin.getUsuario());
                cabecera.setCantRecibida(implParteRecepcion.getCantidad(_listadoCajas));

                for(BeanCaja caja : _listadoCajas){
                    BeanParteRecepcionUnd obj = new BeanParteRecepcionUnd();
                    obj.setCodigoCU(caja.getCodigoCU());
                    obj.setNroPallet(_nroPallet);
                    obj.setCodUsuario(userLogin.getUsuario());
                    obj.setCodArticulo(implParteRecepcion.getCodArticulo(_listadoCajas));
                    detalle.add(obj);
                }

                Gson gson = new GsonBuilder().create();
                String strDetalle = gson.toJson(detalle);
                System.out.println("Detalle del parte de recepcion: " + strDetalle);

                implParteRecepcion.InsertarParteCompleto(cabecera, strDetalle);


                return true;

            } catch (Exception ex) {
                ex.printStackTrace();
                mensaje = ex.getMessage();
                return false;
            } finally {
                implParteRecepcion = null;
                implUtil = null;

            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    ((AlmacenRecepcionPPTTActivity) context).setMensaje("Grabacion del Pallet " + _nroPallet + " realizado satifactoriamente. \r\n"
                                                                + "Posicion: " + _almacenDst
                                                                +  " - " + (String) spAnaquel.getSelectedItem()
                                                                +  " - " + (String) spFila.getSelectedItem()
                                                                +  " - " + (String) spColumna.getSelectedItem());

                    UTIL.SonidoCorrecto(context);
                    MessageBox.AlertDialog(context, "Grabacion",
                            "Grabacion realizada satisfactoriamente. Se ha generado el NRO DE PARTE: " + cabecera.getNroParte(), true);

                    dialogMain.dismiss();
                }else{
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Error", "Error al grabar recepcion de PALLET " + _nroPallet
                                + ". Mensaje: " + mensaje, false);
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
