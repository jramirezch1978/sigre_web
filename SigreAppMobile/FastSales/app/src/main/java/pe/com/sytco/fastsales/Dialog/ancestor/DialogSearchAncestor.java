package pe.com.sytco.fastsales.Dialog.ancestor;

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
import android.widget.ListView;
import android.widget.TextView;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchAncestor extends DialogAncestor{

    //Controles para el detalle de los articulos
    protected TextView tvTitle;
    protected EditText etBusqueda;
    protected ImageButton ibtBuscar;
    protected ListView lvListadoItems;

    public void openDialog(BeanAncestor value) {

        this.bean = value;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_search, null);

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

    public void openDialog() {

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_search, null);

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

    protected void AsignarEventos() {
        ibtBuscar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Filtrar();
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etBusqueda.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {

                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    try{
                        Filtrar();
                    }catch(Exception ex){
                        UTIL.SonidoError(context);
                        MessageBox.AlertDialog(context, "Error en filtro", ex.getMessage(), false);
                    }


                }
                return false;
            }
        });
    }

    public void Filtrar() {
    }

    public void LoadData() {
    }

    protected void InitControllers(){
        //Obtengo referencia a los controles
        tvTitle = (TextView) dialogLayout.findViewById(R.id.tvTitle);
        etBusqueda = (EditText) dialogLayout.findViewById(R.id.etBusqueda);
        ibtBuscar = (ImageButton) dialogLayout.findViewById(R.id.ibtBuscar);

        //Botones
        btnCerrar = (Button) dialogLayout.findViewById(R.id.btnCerrar);

        //Lista de Cursos
        lvListadoItems = (ListView) dialogLayout.findViewById(R.id.lvListadoItems);

    }
}
