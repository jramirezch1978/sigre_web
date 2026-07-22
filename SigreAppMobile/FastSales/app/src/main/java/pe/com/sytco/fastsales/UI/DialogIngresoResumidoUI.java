package pe.com.sytco.fastsales.UI;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.text.InputType;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

import java.util.List;

import pe.com.sytco.fastsales.Dialog.DialogEditIngresoResumido;
import pe.com.sytco.fastsales.Dialog.DialogIngresoResumido;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.UI.Ancestors.TRowClass;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanIngresoResumido;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanSugerencias;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogIngresoResumidoUI extends AncestorUI {

    private TableLayout tblIngresoResumido;
    private View dialogLayout;

    public static TRowClass _rowSelected = null;
    public List<BeanIngresoResumido> _listadoIngresoResumido = null;
    private BeanIngresoResumido _beanSelected = null;

    public DialogIngresoResumidoUI(Context context, View pDialogLoayout, List<BeanIngresoResumido> pListado) {
        super();
        this.context = context;
        this.dialogLayout = pDialogLoayout;
        this._listadoIngresoResumido = pListado;

        tblIngresoResumido = (TableLayout) dialogLayout.findViewById(R.id.tblIngresoResumido);

    }

    public void drawHeaderIngresoResumido() {

        tblIngresoResumido.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n" ));

        //Codigo SKU
        tr_head.addView(this.createHeaderTV(17, "Codigo\nSKU" ));

        //Descripcion del Articulo
        tr_head.addView(this.createHeaderTV(17, "Descripcion\nArticulo" ));

        //Unidad
        tr_head.addView(this.createHeaderTV(17, "Unidad\n" ));

        //Talla
        tr_head.addView(this.createHeaderTV(17, "Talla\n" ));

        //Cantidad
        tr_head.addView(this.createHeaderTV(17, "Cantidad\n" ));

        //Old precio Compra con IGV
        tr_head.addView(this.createHeaderTV(17, "Antiguo Precio\nCompra con IGV" ));

        //New precio Compra con IGV
        tr_head.addView(this.createHeaderTV(17, "Nuevo Precio\nCompra con IGV" ));

        //SubTotal Compra
        tr_head.addView(this.createHeaderTV(17, "SubTotal\nCompra" ));

        //Old precio Venta con IGV
        tr_head.addView(this.createHeaderTV(17, "Antiguo Precio\nVenta con IGV" ));

        //New precio Venta con IGV
        tr_head.addView(this.createHeaderTV(17, "Nuevo Precio\nVenta con IGV" ));

        //SubTotal Venta
        tr_head.addView(this.createHeaderTV(17, "SubTotal\nVenta" ));


        //Adiciono el Table Row al Table Layout
        tblIngresoResumido.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));


    }

    //Dibuja la tabla para el pedido
    public void drawTableIngresoResumido(List<BeanIngresoResumido> pListado) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibView, ibEditar, ibEliminar;
        TableRow trRow = null;

        this._listadoIngresoResumido = pListado;

        drawHeaderIngresoResumido();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        this.ValidRowsSelect(_listadoIngresoResumido);

        //Recorro el detalle
        if (_listadoIngresoResumido.size() > 0) {
            for (final BeanIngresoResumido row : _listadoIngresoResumido) {

                //Create table row header to hold the column headings
                trRow = new TableRow(this.context);
                //trRow.setId(10);
                if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
                trRow.setLayoutParams(params);

                //Layout
                LinearLayout linearLayout = new LinearLayout(trRow.getContext());
                linearLayout.setLayoutParams(new TableRow.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
                linearLayout.setOrientation(LinearLayout.HORIZONTAL);
                linearLayout.setGravity(Gravity.CENTER_HORIZONTAL);

                //Boton para Ver el detalle el pedido
                ibView = createImmageButton(R.drawable.icono_lupa);
                if (row.isSelected()) {
                    setImageResource(ibView, R.drawable.flecha_derecha_icono);
                } else {
                    setImageResource(ibView, R.drawable.rombo);
                }

                //Añado el click de tableRow
                final Integer finalLi_row = li_row;
                final ImageButton finalIbView = ibView;
                final TableRow finalTrRow = trRow;

                ibView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if(_beanSelected != null){
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(DialogIngresoResumidoUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        DialogIngresoResumidoUI._rowSelected = rowClass;


                    }
                });
                linearLayout.addView(ibView);

                //Boton para editar el registro
                ibEditar = createImmageButton(R.drawable.editar);
                ibEditar.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if(_beanSelected != null){
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(DialogIngresoResumidoUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        DialogIngresoResumidoUI._rowSelected = rowClass;

                        //Abro el cuadro de dialogo
                        new DialogEditIngresoResumido(context, DialogIngresoResumidoUI.this, _listadoIngresoResumido).openDialog(row);


                    }
                });
                linearLayout.addView(ibEditar);

                //Boton para editar el registro
                ibEliminar = createImmageButton(R.drawable.delete);
                ibEliminar.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        eliminarRegistro(row);
                    }
                });
                linearLayout.addView(ibEliminar);

                //Añado el Layout
                trRow.addView(linearLayout);

                //Codigo SKU
                trRow.addView(this.createTextViewCenter(li_row, row.getCodSKU()));

                //Descripcion del Articulo
                trRow.addView(this.createTextViewLeft(li_row, row.getDescArticulo()));

                //Unidad
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd()));

                //Talla
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getTalla(), "###,##0")));

                //Cantidad
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getCantidad(), "###,##0")));

                //Old precio Compra con IGV
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getOldPrecioCompra(), "###,##0.00")));

                //New precio Compra con IGV
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getNewPrecioCompra(), "###,##0.00")));

                //SubTotal Compra
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getNewPrecioCompra() * row.getCantidad(), "###,##0.00")));

                //Old precio Venta con IGV
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getOldPrecioVenta(), "###,##0.00")));

                //New precio Venta con IGV
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getNewPrecioVenta(), "###,##0.00")));

                //SubTotal Venta
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getNewPrecioVenta() * row.getCantidad(), "###,##0.00")));

                trRow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if(_beanSelected != null){
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(DialogIngresoResumidoUI._rowSelected, (TableRow) v, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass((TableRow) v, finalIbView, finalLi_row);
                        DialogIngresoResumidoUI._rowSelected = rowClass;

                        System.gc();

                    }
                });

                //Adiciono el Table Row al Table Layout
                //trRow.setMinimumHeight(200);
                tblIngresoResumido.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

                if (row.isSelected()) {

                    if(_beanSelected != null){
                        _beanSelected.setSelected(false);
                        _beanSelected = null;
                    }

                    _beanSelected = row;
                    _beanSelected.setSelected(true);

                    //Selecciono la fila correspondiente
                    selectRow(trRow);

                    //Asigno el trRow asi como el ImageButton para hacer el cambio
                    TRowClass rowClass = new TRowClass(trRow, ibView, li_row);

                    DialogIngresoResumidoUI._rowSelected = rowClass;

                }

                li_row++;

            }
        }

        this.drawTotalIngresoResumido();

        //Libero la memoria
        System.gc();
    }

    //Funcion para eliminar el registro
    private void eliminarRegistro(final BeanIngresoResumido row) {
        //TE hace la pregunta si deseas aceptar o cancelar
        final AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
        alertDialog.setMessage("Desea Eliminar el Registro " + row.getDescArticulo() + "?");
        alertDialog.setTitle("Eliminar registro");
        alertDialog.setIcon(R.drawable.cancelar);
        alertDialog.setCancelable(false);
        alertDialog.setPositiveButton("Sí", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int which)
            {
                _listadoIngresoResumido.remove(row);
                drawTableIngresoResumido(_listadoIngresoResumido);

            }
        });
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int which)
            {
                //código java si se ha pulsado no
                dialog.cancel();
            }
        });
        alertDialog.show();
    }

    private void ValidRowsSelect(List<BeanIngresoResumido> listado) {
        boolean selected = false;

        if (listado == null) return;

        for(final BeanIngresoResumido row : listado){
            if(row.isSelected()){
                selected = true;
                _beanSelected = row;
                break;
            }
        }

        if (!selected && listado.size() > 0){
            listado.get(0).setSelected(true);
            _beanSelected = listado.get(0);
        }

        //Si ya existe una fila seleccionada, entonces simplemente pongo todas las filas como
        //no seleccionadas
        if(_beanSelected != null && selected) {
            for (final BeanIngresoResumido row : listado) {
                if (row != _beanSelected) {
                    row.setSelected(false);
                }
            }
        }

    }

    public void drawTotalIngresoResumido() {
        TableRow.LayoutParams params;
        TableRow trSummary = null;

        try{
            //Layout params para el resto de controles
            params = new TableRow.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

            //Create table row header to hold the column headings
            trSummary = new TableRow(this.context);
            //trSummary.setId(30);
            trSummary.setBackgroundColor(Color.GRAY);
            trSummary.setLayoutParams(params);

            //Layout

            //Añado el Total con un columnSpan = 5
            params = new TableRow.LayoutParams();
            params.span = 5;
            trSummary.addView(this.createSummaryRight("TOTAL:"), params);

            //Inserto el Total de Cantidad
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanIngresoResumido.getTotalUnidades(_listadoIngresoResumido), "###,##0.00")));

            //Inserto el Sub Total de Compra Nuevo
            params = new TableRow.LayoutParams();
            params.column = 8;
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanIngresoResumido.getNewTotalCompra(_listadoIngresoResumido), "###,##0.00")), params);

            //Inserto el Sub Total de Venta Nuevo
            params = new TableRow.LayoutParams();
            params.column = 11;
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanIngresoResumido.getNewTotalCompra(_listadoIngresoResumido), "###,##0.00")), params);

            //Adiciono el Table Row Summary
            tblIngresoResumido.addView(trSummary, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

        }catch(Exception ex){
            throw ex;
        }finally{
            trSummary = null;
            params = null;
        }
    }
}
