package pe.com.sytco.fastsales.Dialog;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Color;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.InventarioPalletsActivity;
import pe.com.sytco.fastsales.Controller.ImplInventarioPallet;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanInventarioPallet;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogShowPalletsPosicion {
    //Contexto
    private Context context = null;

    //Controles de la interfaz
    private TextView tvAlmacen, tvAnaquel, tvFila, tvColumna, tvNroPallets, tvNroCajas;
    private Button btnSalir, btnModificar;
    private TableLayout tableListadoPallets;

    //Datos de la Posicion
    private List<BeanInventarioPallet> _inventario;

    //VAriables para el cuadrio de dialogo
    private View dialoglayout;
    private AlertDialog dialogMain;
    private AlertDialog.Builder builder;

    private DialogShowPalletsPosicion(){

    }

    public DialogShowPalletsPosicion(Context value, List<BeanInventarioPallet> inventario){
        this.context = value;
        this._inventario = inventario;
    }

    public void ConfirmDialog(){


        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((InventarioPalletsActivity)context).getLayoutInflater();

        dialoglayout = inflater.inflate(R.layout.dialog_show_pallets_posicion, null);

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

    private void LoadDefault() {
        tvAlmacen.setText(_inventario.get(0).getAlmacen());
        tvAnaquel.setText(_inventario.get(0).getAnaquel());
        tvFila.setText(_inventario.get(0).getFila());
        tvColumna.setText(_inventario.get(0).getColumna());

        tvNroPallets.setText(UTIL.ConvetToString(_inventario.size(), "###,#00"));
        tvNroCajas.setText(UTIL.ConvetToString(ImplInventarioPallet.getTotalCajas(_inventario), "###,#00"));

        DrawTablePalletsPosicion();
    }

    private void AddHeadearPalletsPosicion() {
        tableListadoPallets.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.GREEN);
        tr_head.setLayoutParams(params);

        //Nro Pallets
        TextView tv = new TextView(context);
        tv.setId(17);
        tv.setText("Numero\nPallets");
        tv.setTextColor(Color.BLUE);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
        tr_head.addView(tv);// add the column to the table row here

        //Cantidad de Cajas
        tv = new TextView(context);
        tv.setId(18);
        tv.setText("Cantidad\nCajas");
        tv.setTextColor(Color.BLUE);
        tv.setWidth(200);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
        tr_head.addView(tv);// add the column to the table row here


        //Opciones
        tv = new TextView(context);
        tv.setId(99);// define id that must be unique
        tv.setText(""); // set the text for the header
        tv.setTextColor(Color.BLUE); // set the color
        tv.setPadding(5, 5, 5, 5); // set the padding (if required)
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
        tr_head.addView(tv); // add the column to the table row here

        //Adiciono el Table Row al Table Layout
        tableListadoPallets.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));
    }

    //Dibuja la tabla para todos los Pallets
    public void DrawTablePalletsPosicion() {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar, ibEditar;

        AddHeadearPalletsPosicion();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        for (final BeanInventarioPallet row : this._inventario) {

            //Create table row header to hold the column headings
            TableRow trRow = new TableRow(context);
            trRow.setId(10);
            if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
            trRow.setLayoutParams(params);

            //Nro Pallets
            TextView tv = new TextView(context);
            tv.setId(25 + li_row * 10);
            tv.setText(row.getNroPallet());
            tv.setTextColor(Color.WHITE);
            tv.setTextSize(22);
            tv.setPadding(5, 5, 5, 5);
            tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
            trRow.addView(tv);// add the column to the table row here

            //Nro Cajas
            tv = new TextView(context);
            tv.setId(26 + li_row * 10);
            tv.setText(UTIL.ConvetToString(row.getNroCajas(), "###,##0.0000"));
            tv.setTextColor(Color.WHITE);
            tv.setTextSize(22);
            tv.setPadding(5, 5, 5, 5);
            tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
            trRow.addView(tv);// add the column to the table row here



            //Boton para eliminar el pedido
            ibEliminar = new ImageButton(context);
            ibEliminar.setId(32 + li_row * 10);
            //Cambio el tamaño del botton
            ibEliminar.setImageResource(R.drawable.menos);
            lp.gravity=Gravity.RIGHT | Gravity.CENTER_VERTICAL;
            ibEliminar.setLayoutParams(lp);
            ibEliminar.setBackgroundResource(0);
            ibEliminar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    deleteDetail(row);

                }
            });
            trRow.addView(ibEliminar);


            //Adiciono el Table Row al Table Layout
            tableListadoPallets.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

            li_row++;

        }

    }

    private void editarDetail(BeanInventarioPallet row) {

    }

    private void deleteDetail(BeanInventarioPallet row) {
        
    }

    private void AsignarEventos() {

    }

    private void InitControllers() {
        //Obtengo referencia a los controles
        tvAlmacen = (TextView) dialoglayout.findViewById(R.id.tvAlmacen);
        tvAnaquel = (TextView) dialoglayout.findViewById(R.id.tvAnaquel);
        tvFila = (TextView) dialoglayout.findViewById(R.id.tvFila);
        tvColumna = (TextView) dialoglayout.findViewById(R.id.tvColumna);
        tvNroPallets = (TextView) dialoglayout.findViewById(R.id.tvNroPallets);
        tvNroCajas = (TextView) dialoglayout.findViewById(R.id.tvNroCajas);

        //Listado de la tabla
        tableListadoPallets = (TableLayout) dialoglayout.findViewById(R.id.tableListadoPallets);

        //Botones
        btnSalir = (Button) dialoglayout.findViewById(R.id.btnSalir);
        btnModificar = (Button) dialoglayout.findViewById(R.id.btnModificar);
    }

}
