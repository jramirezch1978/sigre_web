package pe.com.sytco.fastsales.Dialog;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TableLayout;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenRecepcionPPTTActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteEmpaque;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.DialogListadoCajaUI;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogListadoCajas {
    Context context = null;

    //Datos
    private String _nroPallet = null;
    private List<BeanCaja> _listadoCajas = null;

    //Controles de la interfaz
    private EditText etNroPallet;
    private Button btnLeerCodigo, btnCerrar;
    private TableLayout tblListadoCUS;
    private TextView tvTotalCajas, tvTotalLeidos, tvTotalValidos;

    //VAriables para el cuadrio de dialogo
    private View dialoglayout;
    private AlertDialog dialogListadoCajas = null;

    private AlertDialog.Builder builder;

    private DialogListadoCajas(){

    }

    public DialogListadoCajas(Context value){
        this.context = value;
    }

    private void InitControllers() {
        //Botones
        btnCerrar = (Button) dialoglayout.findViewById(R.id.btnCerrar);
        btnLeerCodigo = (Button) dialoglayout.findViewById(R.id.btnLeerCodigo);

        //Controles de la interfaz
        tblListadoCUS = (TableLayout) dialoglayout.findViewById(R.id.tblListadoCUS);
        etNroPallet = (EditText) dialoglayout.findViewById(R.id.etNroPallet);

        tvTotalCajas = (TextView) dialoglayout.findViewById(R.id.tvTotalCajas);
        tvTotalLeidos = (TextView) dialoglayout.findViewById(R.id.tvTotalLeidos);
        tvTotalValidos = (TextView) dialoglayout.findViewById(R.id.tvTotalValidos);

        etNroPallet.setText("");

    }

    private void LoadData() {
        new LoadCajasTask(this._nroPallet).execute();
    }

    public void openDialog(final String value){
        this._nroPallet = value;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((AlmacenRecepcionPPTTActivity)context).getLayoutInflater();

        dialoglayout = inflater.inflate(R.layout.dialog_listado_cajas, null);

        builder.setView(dialoglayout);

        InitControllers();
        AsignarEventos();

        LoadData();

    }


    public void ShowDialog(){

        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogListadoCajas = builder.create();


        dialogListadoCajas.show();


    }

    private void AsignarEventos() {
        //Activo la opcion de cierre
        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialogListadoCajas.dismiss();
                    }
                }
        );


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

    }

    private void validarLecturaPallet(){
        String strLectura = etNroPallet.getText().toString();

        if (strLectura.trim().equals("")){
            MessageBox.AlertDialog("No ha ingresado ningun NRO DE PALLET para validar", "Error en filtro", context);
            return;
        }

        //new ValidarLecturaTask(strLectura).execute();

        etNroPallet.setText("");
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadCajasTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplParteEmpaque implParteEmpaque = null;


        private ProgressDialog pDialog;
        private String strNroPallet;

        private LoadCajasTask()
        {

        }

        public LoadCajasTask(String value){
            strNroPallet = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando datos del pallet " + strNroPallet + " por favor espere...");
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
                implParteEmpaque = new ImplParteEmpaque(ImplEmpresa.empresaDefault.getCodigo());
                _listadoCajas = implParteEmpaque.getCajasByPallet(strNroPallet);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar data del pallet: " + strNroPallet + ". Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteEmpaque = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result){
                    MessageBox.AlertDialog(mensaje, "Error", context);
                    return;
                }
                if (_listadoCajas.size() == 0) {
                    MessageBox.AlertDialog("No existen Cajas para el pallet " + strNroPallet, "Error", context);
                    return;
                }

                ShowDialog();

                new DialogListadoCajaUI(context, dialoglayout).drawTblListadoCajas(_listadoCajas);

                tvTotalCajas.setText(UTIL.ConvetToString(_listadoCajas.size(), "###,##0"));

                UTIL.OcultarTeclado(context, etNroPallet);


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
