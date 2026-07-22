package pe.com.sytco.fastsales.Dialog;

import android.annotation.SuppressLint;
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
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.InventarioPalletsActivity;
import pe.com.sytco.fastsales.Controller.ImplLecturasCruiser;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanInventarioPallet;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.data.InventarioPallets;
import pe.com.sytco.fastsales.data.SigreAppHelper;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogLeerPallets {
    public static int ACTION_NEXT = 1;
    public static int ACTION_ADD = 2;

    Context context = null;

    //Datos
    List<BeanInventarioPallet> _columnas = null;
    private SigreAppHelper sigreAppHelper;

    String _strLectura = "";
    Integer liPosicion = 0;

    //Controles de la interfaz
    Button btnSalir, btnSiguiente, btnAddLectura;
    EditText etNroPallet, etCantidad;
    TextView tvColumna, tvColumnaFinal;

    //VAriables para el cuadrio de dialogo
    private View dialoglayout;
    private AlertDialog dialogMain;
    private AlertDialog.Builder builder;

    private DialogLeerPallets(){

    }

    public DialogLeerPallets(Context value, List<BeanInventarioPallet> value2, SigreAppHelper obj){
        this.context = value;
        this._columnas = value2;
        this.sigreAppHelper = obj;

    }

    private void InitControllers(){
        //Obtengo referencia a los controles
        etNroPallet = (EditText) dialoglayout.findViewById(R.id.etNroPallet);
        etCantidad = (EditText) dialoglayout.findViewById(R.id.etCantidad);

        tvColumna = (TextView) dialoglayout.findViewById(R.id.tvColumna);
        tvColumnaFinal = (TextView) dialoglayout.findViewById(R.id.tvColumnaFinal);

        //Botones
        btnSalir = (Button) dialoglayout.findViewById(R.id.btnSalir);
        btnSiguiente = (Button) dialoglayout.findViewById(R.id.btnSiguiente);
        btnAddLectura = (Button) dialoglayout.findViewById(R.id.btnAddLectura);

    }

    private void AsignarEventos() {
        //Activo la opcion de cierre
        btnSiguiente.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (!etNroPallet.getText().toString().trim().equals("")){
                            new SaveInventarioPalletTask(DialogLeerPallets.ACTION_NEXT).execute();

                        }else {
                            //Si la lectura esat en blanco entonces simplemente lo elimino
                            etCantidad.setText("");
                            etNroPallet.setText("");
                            etNroPallet.requestFocus();

                            liPosicion++;
                            if (liPosicion < _columnas.size()) {
                                tvColumna.setText(_columnas.get(liPosicion).getColumna());
                            }
                            _strLectura = "";
                        }
                    }
                }
        );

        btnAddLectura.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (!etNroPallet.getText().toString().trim().equals("")){
                            new SaveInventarioPalletTask(DialogLeerPallets.ACTION_ADD).execute();

                        }
                    }
                }
        );

        //Capturo el enter en el lector de codigo de barra
        etNroPallet.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                String ls_FechaInventario;
                try {
                    // If the event is a key-down event on the "enter" button
                    if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                            keyCode == EditorInfo.IME_ACTION_DONE ||
                            (event.getAction() == KeyEvent.ACTION_DOWN &&
                                    event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                        // Perform action on key press
                        if (etNroPallet.getText() != null) {
                            _strLectura = etNroPallet.getText().toString();

                            etNroPallet.setText(ImplLecturasCruiser.getNroLote(_strLectura));

                            //Obtengo la fehca de inventario
                            ls_FechaInventario = _columnas.get(liPosicion).getFecha();

                            if (sigreAppHelper.ValidarNroPallet(etNroPallet.getText().toString(), ls_FechaInventario)){
                                UTIL.SonidoError(context);
                                MessageBox.AlertDialog("Nro de Pallet " + etNroPallet.getText().toString() +
                                                                 " ya ha sido regsitrado, por favor verifique!",
                                                          "Informacion", context);
                                etNroPallet.setText("");
                                etCantidad.setText("");
                                etNroPallet.requestFocus();

                            }else{

                                etCantidad.setText("");
                                etCantidad.requestFocus();

                            }



                            return true;
                        }else{
                            _strLectura = "";
                        }

                    }

                } catch (Exception e) {
                    MessageBox.AlertDialog(context, "Error", "Error al validar pallet. Mensaje: " + e.getMessage(), false);
                    e.printStackTrace();
                }

                return false;
            }

        });
    }

    private void LoadDefault() {
        etCantidad.setText("");
        etNroPallet.setText("");
        etNroPallet.requestFocus();

        liPosicion = 0;
        tvColumna.setText(_columnas.get(liPosicion).getColumna());
        tvColumnaFinal.setText(_columnas.get(_columnas.size() - 1).getColumna());
    }

    public void ConfirmDialog(){


        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((InventarioPalletsActivity)context).getLayoutInflater();

        dialoglayout = inflater.inflate(R.layout.dialog_leer_pallets, null);

        InitControllers();

        AsignarEventos();

        LoadDefault();

        builder.setView(dialoglayout);


        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();



        //Activo la opcion de cierre
        btnSalir.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );


        dialogMain.show();

    }

    //Clase Asincrona para tareas en segundo plano
    private class SaveInventarioPalletTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        Integer iAction = -1;

        private ProgressDialog pDialog;

        public SaveInventarioPalletTask(int valueAction){
            this.iAction = valueAction;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Grabando el registro, un momento por favor");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @SuppressLint("WrongThread")
        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //Obtengo el usuario logueado
                final GlobalClass globalVariable = (GlobalClass) context.getApplicationContext();
                BeanUsuario userLogin = globalVariable.getUserLogin();

                //Creo un registro para inventario por Pallet
                InventarioPallets reg = new InventarioPallets();

                reg.setFecha(_columnas.get(liPosicion).getFecha());
                reg.setAlmacen(_columnas.get(liPosicion).getAlmacen());
                reg.setAnaquel(_columnas.get(liPosicion).getAnaquel());
                reg.setFila(_columnas.get(liPosicion).getFila());
                reg.setColumna(_columnas.get(liPosicion).getColumna());
                reg.setNroPallet(etNroPallet.getText().toString());
                reg.setNroCajas(Double.valueOf(etCantidad.getText().toString()));
                reg.setLectura(_strLectura);
                reg.setCodUsr(userLogin.getUsuario());

                if (iAction == DialogLeerPallets.ACTION_NEXT)
                    sigreAppHelper.eliminarLectura(reg);

                sigreAppHelper.insertLectura(reg);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al obtener el Listado de Cajas del Pallet: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {

            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            String lsNroPallet;
            try {
                if (result) {

                    lsNroPallet = etNroPallet.getText().toString();

                    etCantidad.setText("");
                    etNroPallet.setText("");
                    etNroPallet.requestFocus();

                    if (iAction == DialogLeerPallets.ACTION_NEXT) {
                        liPosicion++;
                        if (liPosicion < _columnas.size()) {
                            tvColumna.setText(_columnas.get(liPosicion).getColumna());
                        }
                    }

                    UTIL.SonidoCorrecto(context);
                    //Refresco la lista
                    ((InventarioPalletsActivity) context).LeerColumnas();

                    //Mensaje que todo esta ok
                    MessageBox.AlertDialog(context, "Informacion", "Pallet " + lsNroPallet + "  guardado correctamente.", false);

                }else{
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Error al grabar el inventario", mensaje, false);
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
