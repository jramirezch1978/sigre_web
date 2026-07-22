package pe.com.sytco.fastsales.UI;

import android.content.Context;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogListadoCajaUI extends AncestorUI {
    private TableLayout tblListadoCUS;

    public DialogListadoCajaUI(Context context, View dialoglayout) {
        super();
        this.context = context;

        tblListadoCUS = (TableLayout) dialoglayout.findViewById(R.id.tblListadoCUS);

    }

    private void AddHeaderListadoCajas() {

        tblListadoCUS.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Validado
        tr_head.addView(this.createHeaderTV(99, "CU\nValidado" ));

        //Codigo CU
        tr_head.addView(this.createHeaderTV(17, "CODIGO\nCU" ));

        //Fecha Produccion
        tr_head.addView(this.createHeaderTV(18, "Fecha\nProduccion" ));

        //Nro OT
        tr_head.addView(this.createHeaderTV(19, "Numero\nOT" ));

        //Nro Trazabilidad
        tr_head.addView(this.createHeaderTV(20, "Nro\nTrazabilidad" ));

        //Und
        tr_head.addView(this.createHeaderTV(21, "Und\n" ));

        //Cod Articulo
        tr_head.addView(this.createHeaderTV(22, "Codigo\nArt" ));

        //CAntidad Promedio
        tr_head.addView(this.createHeaderTV(23, "Cantidad\nPromedio"));


    }

    //Dibuja la tabla para el pedido
    public void drawTblListadoCajas(List<BeanCaja> listado) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar, ibView;
        TableRow trRow = null;
        TextView tv = null;

        AddHeaderListadoCajas();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        for (final BeanCaja row : listado) {

            //Create table row header to hold the column headings
            trRow = new TableRow(this.context);
            trRow.setId(10);
            if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
            trRow.setLayoutParams(params);

            //Layout
            LinearLayout linearLayout = new LinearLayout(trRow.getContext());
            linearLayout.setLayoutParams(new TableRow.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
            linearLayout.setOrientation(LinearLayout.HORIZONTAL);
            linearLayout.setGravity(Gravity.CENTER_HORIZONTAL);

            //Boton para eliminar el pedido
            ibEliminar = new ImageButton(this.context);
            ibEliminar.setId(32 + li_row * 10);

            //Cambio el tamaño del botton
            if (row.isValido())
                ibEliminar.setImageResource(R.drawable.exito);
            else
                ibEliminar.setImageResource(R.drawable.cancelar);

            lp.gravity=Gravity.RIGHT | Gravity.CENTER_VERTICAL;
            ibEliminar.setLayoutParams(lp);
            ibEliminar.setBackgroundResource(0);
            //ibEliminar.setScaleType(ImageView.ScaleType.FIT_CENTER);
            //ibEliminar.setLayoutParams(new ViewGroup.LayoutParams(40,40));
            ibEliminar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {



                }
            });

            //trRow.addView(ibEliminar);
            linearLayout.addView(ibEliminar);

            //Añado el Layout
            trRow.addView(linearLayout);

            //Codigo CU
            trRow.addView(this.createTextViewCenter(li_row, row.getCodigoCU()));// add the column to the table row here

            //Fecha Produccion
            trRow.addView(this.createTextViewCenter(li_row, UTIL.parseSqlShortDatetoString(row.getFecProduccion())));// add the column to the table row here

            //Nro OT
            trRow.addView(this.createTextViewCenter(li_row, row.getNroOT()));// add the column to the table row here

            //Nro Trazabilidad
            trRow.addView(this.createTextViewCenter(li_row, row.getNroTrazabilidad()));// add the column to the table row here

            //Und
            trRow.addView(this.createTextViewCenter(li_row, row.getUnd()));// add the column to the table row here

            //Cod Articulo
            trRow.addView(this.createTextViewCenter(li_row, row.getCodArticulo()));// add the column to the table row here

            //CAntidad Promedio
            trRow.addView(this.createTextViewCenter(li_row, UTIL.ConvetToString(row.getPesoPromedio(), "###,##0.00")));// add the column to the table row here

            //Adiciono el Table Row al Table Layout
            tblListadoCUS.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

            li_row++;

        }

        //Pongo los totales
        //tvTotalCajas.setText(UTIL.ConvetToString(ImplParteRecepcion.getTotalCajas(listado), "###,##0"));
        //tvTotalCompra.setText(UTIL.ConvetToString(ImplParteRecepcion.getTotalCompra(listado), "###,##0.00"));
        //tvTotalVenta.setText(UTIL.ConvetToString(ImplParteRecepcion.getTotalVenta(listado), "###,##0.00"));
        //tvTotalRegistros.setText(UTIL.ConvetToString(listado.size(), "###,##0"));

    }
}
