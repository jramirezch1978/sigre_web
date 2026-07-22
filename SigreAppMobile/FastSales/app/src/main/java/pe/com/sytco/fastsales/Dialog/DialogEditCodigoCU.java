package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenDespachoPPTTActivity;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.ParteDespachoUI;
import pe.com.sytco.fastsales.beans.Almacen.BeanCodigoCU;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogEditCodigoCU extends DialogAncestor {

    //Controles para la interfaz del GUI
    private EditText etCantidad1, etCantidad2;
    private Button btnAceptar, btnCerrar;
    private TextView tvCodSKU, tvCodArt, tvDescArt, tvNroPallet, tvNroLote, tvFactorConvUnd, tvUnidad1, tvUnidad2;

    private BeanCodigoCU _row;
    private List<BeanCodigoCU> _listadoCU;
    private ParteDespachoUI _parteDescpachoUI;
    private AlmacenDespachoPPTTActivity _activity;

    private DialogEditCodigoCU(){

    }

    public DialogEditCodigoCU(AlmacenDespachoPPTTActivity pActivity, List<BeanCodigoCU> pListadoCU, ParteDespachoUI pObj) {
        this._activity = pActivity;
        this._parteDescpachoUI = pObj;
        this._listadoCU = pListadoCU;
        this.context = pActivity;
    }

    public void openDialog(BeanCodigoCU pRow) {

        this._row = pRow;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_edit_cu, null);

        InitControllers();

        AsignarEventos();

        builder.setView(dialogLayout);

        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();

        //Activo la opcion de cierre
        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );

        LoadData();


    }

    protected void InitControllers() {
        //Inicializo el listado de Sugerencias

        //Botones
        btnCerrar = (Button) dialogLayout.findViewById(R.id.btnCerrar);
        btnAceptar = (Button) dialogLayout.findViewById(R.id.btnAceptar);

        //EditText
        etCantidad1 = (EditText) dialogLayout.findViewById(R.id.etCantidad1);
        etCantidad2 = (EditText) dialogLayout.findViewById(R.id.etCantidad2);

        //TextView
        tvCodSKU = (TextView) dialogLayout.findViewById(R.id.tvCodSKU);
        tvCodArt = (TextView) dialogLayout.findViewById(R.id.tvCodArt);
        tvNroLote = (TextView) dialogLayout.findViewById(R.id.tvNroLote);
        tvDescArt = (TextView) dialogLayout.findViewById(R.id.tvDescArt);
        tvNroPallet = (TextView) dialogLayout.findViewById(R.id.tvNroPallet);
        tvFactorConvUnd = (TextView) dialogLayout.findViewById(R.id.tvFactorConvUnd);
        tvUnidad1 = (TextView) dialogLayout.findViewById(R.id.tvUnidad1);
        tvUnidad2 = (TextView) dialogLayout.findViewById(R.id.tvUnidad2);

    }

    protected void AsignarEventos() {

        //Activo la opcion de cierre
        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
                        dialogo1.setTitle("Edicion del Codigo CU");
                        dialogo1.setMessage("¿ Desea cerrar la VENTANA de EDICION DEL CODIGO CU?");
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

        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {

                    if (Double.parseDouble(etCantidad1.getText().toString()) < 0){
                        MessageBox.AlertDialog(context, "Error", "Debe indicar una cantidad Und1 mayor que Cero", false);
                        return;
                    }

                    if (Double.parseDouble(etCantidad2.getText().toString().replaceAll(",", "")) < 0){
                        MessageBox.AlertDialog(context, "Error", "Debe indicar una cantidad Und2 mayor que Cero", false);
                        return;
                    }

                    AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
                    dialogo1.setTitle("Edicion del Codigo CU");
                    dialogo1.setMessage("¿ Desea cerrar la VENTANA de EDICION DEL CODIGO CU?");
                    dialogo1.setCancelable(false);
                    dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialogo1, int id) {

                            try {
                                GrabarDatos();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                        }
                    });
                    dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialogo1, int id) {
                            dialogo1.dismiss();
                        }
                    });
                    dialogo1.show();


                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etCantidad1.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    // Perform action on key press
                    Double ldbl_Cantidad1 = Double.parseDouble(etCantidad1.getText().toString());

                    if (ldbl_Cantidad1 < 0){
                        MessageBox.AlertDialog(context, "Error", "Debe indicar una cantidad Und1 mayor que Cero", false);

                        etCantidad1.setText(UTIL.ConvetToString(_row.getSaldoUnd1(), "###,##0"));

                        return true;
                    }

                    if (ldbl_Cantidad1 > _row.getSaldoUnd1()){

                        MessageBox.AlertDialog(context, "Error", "La cantidad en Und1 no puede ser mayor de "
                                                + UTIL.ConvetToString(_row.getSaldoUnd1(), "###,##0"), false);

                        etCantidad1.setText(UTIL.ConvetToString(_row.getSaldoUnd1(), "###,##0"));

                        return true;

                    }



                    if (etCantidad1.getText() != null  && ldbl_Cantidad1 > 0) {

                        Double ldbl_Cantidad2 = ldbl_Cantidad1 * _row.getFactorConvUnd();

                        etCantidad2.setText(UTIL.ConvetToString(ldbl_Cantidad2, "###,##0"));

                        return true;
                    }

                }
                return false;
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etCantidad2.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    Double ldbl_Cantidad2 = Double.parseDouble(etCantidad2.getText().toString());
                    Double ldbl_Cantidad1 = Double.parseDouble(etCantidad1.getText().toString());

                    if ( ldbl_Cantidad2 < 0){
                        MessageBox.AlertDialog(context, "Error", "Debe indicar una cantidad Und2 mayor que Cero", false);

                        etCantidad2.setText(UTIL.ConvetToString(_row.getSaldoUnd2(), "###,##0"));

                        return false;
                    }

                    if (ldbl_Cantidad2 > ldbl_Cantidad1 * _row.getFactorConvUnd()){

                        MessageBox.AlertDialog(context, "Error", "La cantidad en Und2 no puede ser mayor de "
                                + UTIL.ConvetToString(ldbl_Cantidad1 * _row.getFactorConvUnd(), "###,##0"), false);

                        etCantidad2.setText(UTIL.ConvetToString(ldbl_Cantidad1 * _row.getFactorConvUnd(), "###,##0"));

                        return true;

                    }

                }
                return false;
            }
        });

    }

    private void GrabarDatos() throws Exception {
        _row.setSaldoUnd1(Double.parseDouble(etCantidad1.getText().toString()));
        _row.setSaldoUnd2(Double.parseDouble(etCantidad2.getText().toString().replaceAll(",", "")));

        //Agregar el listado temporal obtenido al listado general

        _activity.addListado(_listadoCU);


        _parteDescpachoUI.drawTableListadoCUS();


        if (ParteDespachoUI.listadoCU.size() > 0){
            _activity.getBtnDespachar().setEnabled(true);
            _activity.getBtnResetear().setEnabled(true);
            _activity.getTvNroRegistros().setText(UTIL.ConvetToString(_listadoCU.size(), "###,##0"));
        }else{
            _activity.getBtnDespachar().setEnabled(false);
            _activity.getBtnResetear().setEnabled(false);
            _activity.getTvNroRegistros().setText("0.00");
        }

        dialogMain.dismiss();
    }

    public void LoadData() {

        etCantidad1.setText(UTIL.ConvetToString(_row.getSaldoUnd1(), "###,##0"));
        etCantidad2.setText(UTIL.ConvetToString(_row.getSaldoUnd2(), "###,##0"));

        tvCodSKU.setText(_row.getCUS());
        tvCodArt.setText(_row.getCodArt());
        tvDescArt.setText(_row.getDescArt());
        tvUnidad1.setText(_row.getUnd());
        tvUnidad2.setText(_row.getUnd2());
        tvFactorConvUnd.setText(UTIL.ConvetToString(_row.getFactorConvUnd(), "###,##0.00000000"));
        tvNroPallet.setText(_row.getNroPallet());
        tvNroLote.setText(_row.getNroLote());

        //Mostrar la caja de dialogo
        if(isFirstTime()) {
            showDialog();
        }

    }
}
