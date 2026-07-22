package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Dialog.Search.DialogSearchAcabado;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchCategorias;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchClase;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchColor1;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchColor2;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchLineas;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchMarcas;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchSubCategorias;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchSubLineas;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchSuela;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchTaco;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchUnidad;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.DialogIngresoResumidoUI;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanIngresoResumido;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanSugerencias;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogEditIngresoResumido  extends DialogAncestor {

    //Controles para la interfaz del GUI
    private EditText etCantidad, etNewPrecioCompra, etNewPrecioVenta;
    private Button btnAceptar, btnCerrar;
    private TextView tvCodSKU, tvCodArt, tvTalla, tvDescArt, tvUnidad, tvOldPrecioCompra, tvOldPrecioVenta ;

    private BeanIngresoResumido _row;
    private List<BeanIngresoResumido> _listadoIngresoResumido;
    private DialogIngresoResumidoUI _dialogIngresoResumidoUI;

    private DialogEditIngresoResumido(){

    }

    public DialogEditIngresoResumido(Context value,
                                     DialogIngresoResumidoUI dialogIngresoResumidoUI,
                                     List<BeanIngresoResumido> listadoIngresoResumido) {
        this.context = value;
        this._dialogIngresoResumidoUI = dialogIngresoResumidoUI;
        this._listadoIngresoResumido = listadoIngresoResumido;
    }

    public void openDialog(BeanIngresoResumido pRow) {

        this._row = pRow;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_edit_ingreso_resumido, null);

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
        etCantidad = (EditText) dialogLayout.findViewById(R.id.etCantidad);
        etNewPrecioCompra = (EditText) dialogLayout.findViewById(R.id.etNewPrecioCompra);
        etNewPrecioVenta = (EditText) dialogLayout.findViewById(R.id.etNewPrecioVenta);

        //TextView
        tvCodSKU = (TextView) dialogLayout.findViewById(R.id.tvCodSKU);
        tvCodArt = (TextView) dialogLayout.findViewById(R.id.tvCodArt);
        tvTalla = (TextView) dialogLayout.findViewById(R.id.tvTalla);
        tvDescArt = (TextView) dialogLayout.findViewById(R.id.tvDescArt);
        tvUnidad = (TextView) dialogLayout.findViewById(R.id.tvUnidad);
        tvOldPrecioCompra = (TextView) dialogLayout.findViewById(R.id.tvOldPrecioCompra);
        tvOldPrecioVenta = (TextView) dialogLayout.findViewById(R.id.tvOldPrecioVenta);

    }

    protected void AsignarEventos() {

        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                _row.setCantidad(Double.parseDouble(etCantidad.getText().toString()));
                _row.setNewPrecioCompra(Double.parseDouble(etNewPrecioCompra.getText().toString()));
                _row.setNewPrecioVenta(Double.parseDouble(etNewPrecioVenta.getText().toString()));

                _dialogIngresoResumidoUI.drawTableIngresoResumido(_listadoIngresoResumido);

                dialogMain.dismiss();

            }
        });

    }

    public void LoadData() {

        etCantidad.setText(UTIL.ConvetToString(_row.getCantidad(), "###,##0"));
        etNewPrecioCompra.setText(UTIL.ConvetToString(_row.getNewPrecioCompra(), "###,##0.00"));
        etNewPrecioVenta.setText(UTIL.ConvetToString(_row.getNewPrecioVenta(), "###,##0.00"));

        tvCodSKU.setText(_row.getCodSKU());
        tvCodArt.setText(_row.getCodArticulo());
        tvTalla.setText(UTIL.ConvetToString(_row.getTalla(), "###,##0"));
        tvDescArt.setText(_row.getDescArticulo());
        tvUnidad.setText(_row.getUnd());
        tvOldPrecioCompra.setText(UTIL.ConvetToString(_row.getOldPrecioCompra(), "###,##0.00"));
        tvOldPrecioVenta.setText(UTIL.ConvetToString(_row.getOldPrecioVenta(), "###,##0.00"));

        //Mostrar la caja de dialogo
        if(isFirstTime()) {
            showDialog();
        }

    }
}
