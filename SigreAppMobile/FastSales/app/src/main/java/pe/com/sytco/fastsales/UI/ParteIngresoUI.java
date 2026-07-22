package pe.com.sytco.fastsales.UI;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenParteRecepcionActivity;
import pe.com.sytco.fastsales.Activities.Almacen.AlmacenParteRecepcionPopupActivity;
import pe.com.sytco.fastsales.Dialog.DialogChangeFoto;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.UI.Ancestors.TRowClass;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngresoDet;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngresoUnd;
import pe.com.sytco.fastsales.beans.ParteEmpaque.BeanParteEmpaqueUnd;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.Parametros;
import pe.com.sytco.fastsales.util.UTIL;

public class ParteIngresoUI extends AncestorUI {
    private TableLayout tblDetalleArticulo, tblListadoCUS, tblResumenAgrupado;
    private TableLayout tblParteRecepcion;

    public static TRowClass _rowSelected = null;

    public ParteIngresoUI(AlmacenParteRecepcionPopupActivity value) {
        super();
        this.context = value;

        tblResumenAgrupado = (TableLayout) value.findViewById(R.id.tblResumenAgrupado);
        tblDetalleArticulo = (TableLayout) value.findViewById(R.id.tblDetalleArticulo);
        tblListadoCUS = (TableLayout) value.findViewById(R.id.tblListadoCUS);
    }

    public ParteIngresoUI(AlmacenParteRecepcionActivity value) {
        super();
        this.context = value;

        tblParteRecepcion = (TableLayout) value.findViewById(R.id.tblParteRecepcion);

    }

    private void drawHeaderResumenAgrupado() {

        tblResumenAgrupado.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n" ));

        //Nro Item
        tr_head.addView(this.createHeaderTV(17, "Numero\nItem" ));

        //Codigo Categoria
        tr_head.addView(this.createHeaderTV(18, "Codigo\nCategoria" ));

        //Descripcion Categoria
        tr_head.addView(this.createHeaderTV(19, "Descripcion\nCategoria" ));

        //Codigo Subcategoria
        tr_head.addView(this.createHeaderTV(20, "Codigo\nSubcategoria" ));

        //Descripcion Subcategoria
        tr_head.addView(this.createHeaderTV(21, "Descripcion\nSubcategoria" ));

        //Codigo Marca
        tr_head.addView(this.createHeaderTV(22, "Código\nMarca" ));

        //Descripcion Marca
        tr_head.addView(this.createHeaderTV(23, "Descripcion\nMarca"));

        //Estilo
        tr_head.addView(this.createHeaderTV(24, "Estilo\n"));

        //Codigo Linea
        tr_head.addView(this.createHeaderTV(25, "Codigo\nLinea"));

        //Descripcion Linea
        tr_head.addView(this.createHeaderTV(26, "Descripcion\nLinea"));

        //Codigo Sub Linea
        tr_head.addView(this.createHeaderTV(27, "Codigo\nSubLinea"));

        //Descripcion Sub Linea
        tr_head.addView(this.createHeaderTV(28, "Descripcion\nSublinea"));

        //Codigo Suela
        tr_head.addView(this.createHeaderTV(29, "Codigo\nSuela"));

        //Descripcion Suela
        tr_head.addView(this.createHeaderTV(30, "Descripcion\nSuela"));

        //Codigo Acabado
        tr_head.addView(this.createHeaderTV(31, "Codigo\nAcabado"));

        //Descripcion Acabado
        tr_head.addView(this.createHeaderTV(32, "Descripcion\nAcabado"));

        //Color Primario
        tr_head.addView(this.createHeaderTV(33, "Codigo Color\nPrimario"));

        //Descripcion Color Primario
        tr_head.addView(this.createHeaderTV(34, "Descripcion Color\nPrimario"));

        //Codigo Color Secundario
        tr_head.addView(this.createHeaderTV(35, "Codigo Color\nSecundario"));

        //Descripcion Color Secundario
        tr_head.addView(this.createHeaderTV(36, "Descripcion Color\nSecundario"));

        //Taco
        tr_head.addView(this.createHeaderTV(37, "TACO\n"));

        //Clase Articulo
        tr_head.addView(this.createHeaderTV(38, "Clase\nArticulo"));

        //Descripcion Clase Articulo
        tr_head.addView(this.createHeaderTV(38, "Descripcion Clase\nArticulo"));

        //Und
        tr_head.addView(this.createHeaderTV(38, "Und\n"));

        //Cantidad
        tr_head.addView(this.createHeaderTV(38, "Cantidad\nUnidades"));

        //Importe Compra
        tr_head.addView(this.createHeaderTV(38, "Importe\nCompra"));

        //Importe Venta
        tr_head.addView(this.createHeaderTV(38, "Importe\nVenta"));

        //Codigo Usuario
        tr_head.addView(this.createHeaderTV(38, "Cod.\nUsr."));

        //Flag Estado
        tr_head.addView(this.createHeaderTV(38, "Flag\nEstado"));

        //Fecha Registro
        tr_head.addView(this.createHeaderTV(38, "Fecha\nRegistro"));

        //Adiciono el Table Row al Table Layout
        tblResumenAgrupado.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

    }

    //Dibuja la tabla para el pedido
    public void drawResumenAgrupado(final List<BeanParteIngresoDet> listado) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar, ibView, ibFoto;
        TableRow trRow = null;

        drawHeaderResumenAgrupado();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        this.ValidRowsSelect(listado);

        //Recorro el detalle
        if (listado.size() > 0) {
            for (final BeanParteIngresoDet row : listado) {

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
                ibView = createImmageButton(32 + li_row * 10, R.drawable.icono_lupa);
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

                        rowFocusChanged(ParteIngresoUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        ParteIngresoUI._rowSelected = rowClass;

                        drawMostrarDetalle(row.getUnidades());

                    }
                });
                linearLayout.addView(ibView);

                //Boton para eliminar el pedido
                ibEliminar = createImmageButton(31 + li_row * 10, R.drawable.cancelar);
                ibEliminar.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        deleteResumenAgrupado(row);

                    }
                });
                linearLayout.addView(ibEliminar);

                //Añado el boton para ver o tomar la foto
                ibFoto = createImmageButton(33 + li_row * 10, R.drawable.camara_color);
                ibFoto.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        openDialogChangeFoto(row);

                    }
                });
                linearLayout.addView(ibFoto);

                //Añado el Layout
                trRow.addView(linearLayout);

                //Nro Item
                trRow.addView(this.createTextViewCenter(li_row, row.getNroItem().toString()));// add the column to the table row here

                //Codigo Categoria
                trRow.addView(this.createTextViewCenter(li_row, row.getCatArticulo()));// add the column to the table row here

                //Descripcion Categoria
                trRow.addView(this.createTextViewLeft(li_row, row.getDescCategoria()));// add the column to the table row here

                //Codigo Subcategoria
                trRow.addView(this.createTextViewCenter(li_row, row.getSubCategoria()));// add the column to the table row here

                //Descripcion Subcategoria
                trRow.addView(this.createTextViewLeft(li_row, row.getDescSubCategoria()));

                //Codigo Marca
                trRow.addView(this.createTextViewCenter(li_row, row.getMarca()));// add the column to the table row here

                //Descripcion Marca
                trRow.addView(this.createTextViewLeft(li_row, row.getNomMarca()));// add the column to the table row here

                //Estilo
                trRow.addView(this.createTextViewLeft(li_row, row.getEstilo()));// add the column to the table row here

                //Codigo Linea
                trRow.addView(this.createTextViewCenter(li_row, row.getCodLinea()));// add the column to the table row here

                //Descripcion Linea
                trRow.addView(this.createTextViewLeft(li_row, row.getDescLinea()));// add the column to the table row here

                //Codigo Sub Linea
                trRow.addView(this.createTextViewCenter(li_row, row.getSubLinea()));// add the column to the table row here

                //Descripcion Sub Linea
                trRow.addView(this.createTextViewLeft(li_row, row.getDescSubLinea()));// add the column to the table row here

                //Codigo Suela
                trRow.addView(this.createTextViewCenter(li_row, row.getSuela()));// add the column to the table row here

                //Descripcion Suela
                trRow.addView(this.createTextViewLeft(li_row, row.getDescSuela()));// add the column to the table row here

                //Codigo Acabado
                trRow.addView(this.createTextViewCenter(li_row, row.getAcabado()));// add the column to the table row here

                //Descripcion Acabado
                trRow.addView(this.createTextViewLeft(li_row, row.getDescAcabado()));// add the column to the table row here

                //Color Primario
                trRow.addView(this.createTextViewCenter(li_row, row.getColorPrimario()));// add the column to the table row here

                //Descripcion Color Primario
                trRow.addView(this.createTextViewLeft(li_row, row.getDescColorPrimario()));// add the column to the table row here

                //Codigo Color Secundario
                trRow.addView(this.createTextViewCenter(li_row, row.getColorSecundario()));

                //Descripcion Color Secundario
                trRow.addView(this.createTextViewLeft(li_row, row.getDescColorSecundario()));

                //Taco
                trRow.addView(this.createTextViewCenter(li_row, row.getTaco()));

                //Clase Articulo
                trRow.addView(this.createTextViewCenter(li_row, row.getClase()));

                //Descripcion Clase Articulo
                trRow.addView(this.createTextViewLeft(li_row, row.getDescClase()));

                //Und
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd()));

                //Cantidad Unidades
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getCantidadUnd(), "###,##0.00")));

                //Importe Compra
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getImporteCompra(), "###,##0.00")));

                //Importe Venta
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getImporteVenta(), "###,##0.00")));

                //Codigo Usuario
                trRow.addView(this.createTextViewCenter(li_row, row.getUsuario()));

                //Flag Estado
                trRow.addView(this.createTextViewCenter(li_row, row.getDescEstado()));

                //Fecha Registro
                trRow.addView(this.createTextViewCenter(li_row, row.getFecRegistro()));

                trRow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        rowFocusChanged(ParteIngresoUI._rowSelected, (TableRow) v, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass((TableRow) v, finalIbView, finalLi_row);
                        ParteIngresoUI._rowSelected = rowClass;

                        drawMostrarDetalle(row.getUnidades());

                        System.gc();

                    }
                });

                //Adiciono el Table Row al Table Layout
                //trRow.setMinimumHeight(200);
                tblResumenAgrupado.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

                if (row.isSelected()) {

                    //Selecciono la fila correspondiente
                    selectRow(trRow);

                    //Asigno el trRow asi como el ImageButton para hacer el cambio
                    TRowClass rowClass = new TRowClass(trRow, ibView, li_row);

                    ParteIngresoUI._rowSelected = rowClass;
                    drawMostrarDetalle(row.getUnidades());
                }

                li_row++;

            }

            drawTotalResumenAgrupado(listado, li_row);
        }else{

            drawTotalResumenAgrupado(new ArrayList<BeanParteIngresoDet>(), 50);

            AddHeaderDetalleUnidades();
            drawTotalUnidades(new ArrayList<BeanParteIngresoUnd>(), 100);
        }
        //Libero la memoria
        System.gc();
    }

    private void openDialogChangeFoto(BeanParteIngresoDet row) {

        new DialogChangeFoto(this.context).openDialog(row);
    }

    private void drawTotalResumenAgrupado(List<BeanParteIngresoDet> listado, Integer aRow) {
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

            //Añado el Total con un columnSpan = 7
            params = new TableRow.LayoutParams();
            params.span = 25;
            trSummary.addView(this.createSummaryRight(aRow, "TOTAL:", 30), params);

            //Inserto el Total de unidades
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoDet.getTotalUnidades(listado), "###,##0.00")));

            //Inserto el Total de Compra SubTotal
            params = new TableRow.LayoutParams();
            params.column = 9;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoDet.getTotalValorCompra(listado), "###,##0.00")), params);

            //Inserto el Total de Precio de Venta Nuewo
            params = new TableRow.LayoutParams();
            params.column = 15;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoDet.getTotalValorVenta(listado), "###,##0.00")), params);

            //Adiciono el Table Row Summary al
            tblResumenAgrupado.addView(trSummary, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

        }catch(Exception ex){
            throw ex;
        }finally{
            trSummary = null;
            params = null;
        }
    }

    private void ValidRowsSelect(List<BeanParteIngresoDet> listado) {
        boolean selected = false;

        if (listado == null) return;

        for(final BeanParteIngresoDet row : listado){
            if(row.isSelected()){
                selected = true;
            }
        }

        if (!selected && listado.size() > 0){
            listado.get(0).setSelected(true);
        }

    }

    private void AddHeaderDetalleUnidades() {
        tblDetalleArticulo.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n" ));

        //Nro Registro
        tr_head.addView(this.createHeaderTV(17, "Numero\nRegistro" ));

        //Fecha Registro
        tr_head.addView(this.createHeaderTV(18, "Fecha\nRegistro" ));

        //Talla
        tr_head.addView(this.createHeaderTV(19, "Talla\n" ));

        //Cod Art
        tr_head.addView(this.createHeaderTV(20, "Codigo\nArticulo" ));

        //Descripcion Articulo
        tr_head.addView(this.createHeaderTV(21, "Descripcion\nArticulo" ));

        //Unidad
        tr_head.addView(this.createHeaderTV(22, "Unidad\n" ));

        //Cantidad
        tr_head.addView(this.createHeaderTV(23, "Cantidad\n"));

        //Precio Compra Base
        tr_head.addView(this.createHeaderTV(24, "Precio Compra\nBase"));

        //Compras Subtotal
        tr_head.addView(this.createHeaderTV(25, "Compra\nSubTotal"));

        //Importe Impuesto
        tr_head.addView(this.createHeaderTV(26, "Importe\nImpuesto"));

        //Total Compra
        tr_head.addView(this.createHeaderTV(27, "Total\nCompra"));

        //Compra Precio Anterior
        tr_head.addView(this.createHeaderTV(29, "Precio Compra\nAnterior"));

        //Nuevo Precio Compra
        tr_head.addView(this.createHeaderTV(30, "Precio Compra\nNuevo"));

        //Precio Venta Anterior
        tr_head.addView(this.createHeaderTV(31, "Precio Venta\nAnterior"));

        //Precio Venta Nuevo
        tr_head.addView(this.createHeaderTV(32, "Precio Venta\nNuevo"));

        //Cod Usr
        tr_head.addView(this.createHeaderTV(33, "Codigo\nUsuario"));

        //Org AMP
        tr_head.addView(this.createHeaderTV(34, "Origen\nAMP"));

        //Numero AMP
        tr_head.addView(this.createHeaderTV(35, "Numero\nAMP"));

        //Tipo Impuesto
        tr_head.addView(this.createHeaderTV(36, "Tipo\nImpuesto"));

        //Adiciono el Table Row al Table Layout
        tblDetalleArticulo.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));
    }

    private void drawMostrarDetalle(List<BeanParteIngresoUnd> listado) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar;
        final ImageButton ibView;
        TableRow trRow = null;
        TextView tv = null;

        AddHeaderDetalleUnidades();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        for (final BeanParteIngresoUnd row : listado) {

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
            ibEliminar = createImmageButton(31 + li_row * 10, R.drawable.cancelar);
            ibEliminar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    deleteDetalleArticulo(row);

                }
            });
            linearLayout.addView(ibEliminar);

            //Añado el Layout
            trRow.addView(linearLayout);

            //Nro Registro - Reckey
            trRow.addView(this.createTextViewRight(li_row, row.getRegkey().toString()));// add the column to the table row here

            //Fecha Registro
            trRow.addView(this.createTextViewCenter(li_row, row.getFecRegistro()));// add the column to the table row here

            //Talla
            trRow.addView(this.createTextViewRight(li_row, row.getTalla().toString()));// add the column to the table row here

            //Cod Art
            trRow.addView(this.createTextViewCenter(li_row, row.getCodArticulo()));// add the column to the table row here

            //Descripcion Articulo
            trRow.addView(this.createTextViewLeft(li_row, row.getDescArticulo()));// add the column to the table row here

            //Unidad
            trRow.addView(this.createTextViewCenter(li_row, row.getUnd()));

            //Cantidad
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getCantidad(), "###,##0.00")));// add the column to the table row here

            //Precio Compra Base
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioBase(), "###,##0.00")));// add the column to the table row here

            //Compras Subtotal
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioBase() * row.getCantidad(), "###,##0.00")));// add the column to the table row here

            //Importe Impuesto
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getImporteImpuesto(), "###,##0.00")));// add the column to the table row here

            //Total Compra
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioBase() * row.getCantidad() + row.getImporteImpuesto(), "###,##0.00")));// add the column to the table row here

            //Compra Precio Anterior
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioCompraAnt(), "###,##0.00")));// add the column to the table row here

            //Nuevo Precio Compra
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioCompraNew(), "###,##0.00")));// add the column to the table row here

            //Precio Venta Anterior
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioVentaAnt(), "###,##0.00")));// add the column to the table row here

            //Precio Venta Nuevo
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getPrecioVentaNew(), "###,##0.00")));// add the column to the table row here

            //Cod Usr
            trRow.addView(this.createTextViewCenter(li_row, row.getUsuario()));

            //Org AMP
            trRow.addView(this.createTextViewCenter(li_row, row.getOrgAMP()));

            //Numero AMP
            trRow.addView(this.createTextViewRight(li_row, row.getNroAMP().toString()));

            //Tipo Impuesto
            trRow.addView(this.createTextViewCenter(li_row, row.getTipoImpuesto()));

            final TableRow finalTrRow = trRow;
            trRow.setOnClickListener(
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            // TODO: do your logic here
                                        finalTrRow.setBackgroundResource(android.R.drawable.list_selector_background);
                        }
                    }
            );


            //Adiciono el Table Row al Table Layout
            tblDetalleArticulo.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

            li_row++;

        }

        drawTotalUnidades(listado, li_row);
    }

    private void drawTotalUnidades(List<BeanParteIngresoUnd> listado, Integer aRow) {
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

            //Añado el Total con un columnSpan = 7
            params = new TableRow.LayoutParams();
            params.span = 7;
            trSummary.addView(this.createSummaryRight(aRow, "TOTAL:", 30), params);

            //Inserto el Total de unidades
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalUnidades(listado), "###,##0.00")));

            //Inserto el Total de Compra SubTotal
            params = new TableRow.LayoutParams();
            params.column = 9;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalBaseCompra(listado), "###,##0.00")), params);

            //Inserto el Total de Impuestos
            params = new TableRow.LayoutParams();
            params.column = 10;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalImpuestos(listado), "###,##0.00")), params);

            //Inserto el Total de Impuestos
            params = new TableRow.LayoutParams();
            params.column = 11;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalCompra(listado), "###,##0.00")), params);

            //Inserto el Total de Precio de Compra Ant
            params = new TableRow.LayoutParams();
            params.column = 12;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalPrecioCompraAnt(listado), "###,##0.00")), params);

            //Inserto el Total de Precio de Compra Nuewo
            params = new TableRow.LayoutParams();
            params.column = 13;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalPrecioCompraNew(listado), "###,##0.00")), params);

            //Inserto el Total de Precio de Venta Ant
            params = new TableRow.LayoutParams();
            params.column = 14;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalPrecioVentaAnt(listado), "###,##0.00")), params);

            //Inserto el Total de Precio de Venta Nuewo
            params = new TableRow.LayoutParams();
            params.column = 15;
            trSummary.addView(this.createSummaryRight(aRow, UTIL.ConvetToString(BeanParteIngresoUnd.getTotalPrecioVentaNew(listado), "###,##0.00")), params);

            //Adiciono el Table Row Summary al
            tblDetalleArticulo.addView(trSummary, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

        }catch(Exception ex){
            throw ex;
        }finally{
            trSummary = null;
            params = null;
        }

    }

    private void deleteDetalleArticulo(BeanParteIngresoUnd row) {

    }

    private void deleteResumenAgrupado(BeanParteIngresoDet row) {

    }

    public void drawListadoCUs(List<BeanParteEmpaqueUnd> listadoCU) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibCambiar = null;
        TableRow trRow = null;

        AddHeaderListadoCUs();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        for (final BeanParteEmpaqueUnd row : listadoCU) {

            //Create table row header to hold the column headings
            trRow = new TableRow(this.context);
            trRow.setId(10);
            if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
            trRow.setLayoutParams(params);

            //Nro Orden
            trRow.addView(this.createTextViewRight(li_row, li_row.toString()));// add the column to the table row here

            //Nro Item
            trRow.addView(this.createTextViewRight(li_row, row.getNroItem().toString()));// add the column to the table row here

            //Codigo CU
            trRow.addView(this.createTextViewCenter(li_row, row.getCodigoCU()));// add the column to the table row here

            //Numero Registro
            trRow.addView(this.createTextViewCenter(li_row, row.getRegkey()));// add the column to the table row here

            //Codigo SKU
            trRow.addView(this.createTextViewCenter(li_row, row.getCodSKU()));// add the column to the table row here

            //Descripcion Articulo
            trRow.addView(this.createTextViewLeft(li_row, row.getDescArticulo()));// add the column to the table row here

            //Fecha Registro
            trRow.addView(this.createTextViewCenter(li_row, row.getFecRegistro()));// add the column to the table row here

            //Codigo Usuario
            trRow.addView(this.createTextViewCenter(li_row, row.getCodUsuario()));// add the column to the table row here

            //Añado el boton de Cambiar
            LinearLayout linearLayout = new LinearLayout(trRow.getContext());
            linearLayout.setLayoutParams(new TableRow.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
            linearLayout.setOrientation(LinearLayout.HORIZONTAL);
            linearLayout.setGravity(Gravity.CENTER_HORIZONTAL);

            //Boton para eliminar el pedido
            ibCambiar = createImmageButton(31 + li_row * 10, R.drawable.cambiar);
            ibCambiar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    CambiarCU(row);

                }
            });
            linearLayout.addView(ibCambiar);


            //Añado el Layout
            trRow.addView(linearLayout);

            //Adiciono el Table Row al Table Layout
            tblListadoCUS.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

            li_row++;

        }


    }

    private void CambiarCU(BeanParteEmpaqueUnd row) {
    }

    private void AddHeaderListadoCUs() {
        tblListadoCUS.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Nro Orden
        tr_head.addView(this.createHeaderTV(17, "Numero\nOrden" ));

        //Nro Item
        tr_head.addView(this.createHeaderTV(18, "Numero\nItem" ));

        //Codigo CU
        tr_head.addView(this.createHeaderTV(19, "Codigo\nCU" ));

        //Numero Registro
        tr_head.addView(this.createHeaderTV(20, "Numero\nRegistro" ));

        //Codigo SKU
        tr_head.addView(this.createHeaderTV(21, "Codigo\nSKU" ));

        //Descripcion Articulo
        tr_head.addView(this.createHeaderTV(22, "Descripcion\nArticulo" ));

        //Fecha Registro
        tr_head.addView(this.createHeaderTV(23, "Fecha\nRegistro"));

        //Codigo Usuario
        tr_head.addView(this.createHeaderTV(24, "Codigo\nUsuario"));

        //Adiciono el Table Row al Table Layout
        tblListadoCUS.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));
    }

    //Dibujar la cabecera del Table de Partes de Ingreso
    public void addHeaderParteRecepcion() {

        tblParteRecepcion.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n" ));


        //Nro Parte
        tr_head.addView(this.createHeaderTV(11, "Numero\nParte" ));

        //Fecha Registro
        tr_head.addView(this.createHeaderTV(12, "Fecha\nRegistro" ));

        //Fecha Parte
        tr_head.addView(this.createHeaderTV(13, "Fecha\nParte" ));

        //Codigo Proveedor
        tr_head.addView(this.createHeaderTV(14, "Codigo\nProveedor" ));

        //Razon Social del Proveedor
        tr_head.addView(this.createHeaderTV(15, "Razon Social\ndel Proveedor" ));

        //RUC DNI
        tr_head.addView(this.createHeaderTV(15, "Nro de RUC\no DNI" ));

        //Tipo Doc
        tr_head.addView(this.createHeaderTV(15, "Tipo\nDoc" ));

        //Serie ded Documento
        tr_head.addView(this.createHeaderTV(15, "Serie\nDocumento" ));

        //Nro de Documento
        tr_head.addView(this.createHeaderTV(15, "Numero\nDocumento" ));

        //Cantidad de Cajas
        tr_head.addView(this.createHeaderTV(15, "Cantidad\nde Cajas" ));

        //Valor de Compra
        tr_head.addView(this.createHeaderTV(15, "Valor\nCompra" ));

        //Valor de Venta
        tr_head.addView(this.createHeaderTV(15, "Valor\nVenta" ));

        //Cod Usuario
        tr_head.addView(this.createHeaderTV(15, "Cod.\nUsr." ));

        //Estado Parte
        tr_head.addView(this.createHeaderTV(15, "Estado\nParte" ));

        //Adiciono el Table Row al Table Layout
        tblParteRecepcion.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

    }

    public void drawListadoPartes(final List<BeanParteIngreso> listado) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar, ibEditar;
        TableRow trRow = null;

        this.addHeaderParteRecepcion();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        for (final BeanParteIngreso row : listado) {

            //Create table row header to hold the column headings
            trRow = new TableRow(context);
            trRow.setId(10);
            if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
            trRow.setLayoutParams(params);

            //Layout
            LinearLayout linearLayout = new LinearLayout(trRow.getContext());
            linearLayout.setLayoutParams(new TableRow.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
            linearLayout.setOrientation(LinearLayout.HORIZONTAL);
            linearLayout.setGravity(Gravity.CENTER_HORIZONTAL);

            //Boton para eliminar el pedido
            ibEliminar = createImmageButton(32 + li_row * 10, R.drawable.cancelar);
            ibEliminar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    deleteDetail(row);

                }
            });

            //trRow.addView(ibEliminar);
            linearLayout.addView(ibEliminar);


            //Boton para editar el pedido
            ibEditar = createImmageButton(33 + li_row * 10, R.drawable.modificar);
            ibEditar.setOnClickListener(new View.OnClickListener(){
                @Override
                public void onClick(View v) {

                    editarDetail(row, listado);

                }
            } );
            linearLayout.addView(ibEditar);

            //Añado el Layout
            trRow.addView(linearLayout);

            //Nro Parte
            trRow.addView(this.createTextViewCenter(li_row, row.getNroParte()));

            //Fecha Registro
            trRow.addView(this.createTextViewCenter(li_row, row.getFecRegistro()));

            //Fecha Parte
            trRow.addView(this.createTextViewCenter(li_row, UTIL.parseSqlDatetoString(row.getDateFecParte(), "dd/MM/yyyy")));

            //Codigo Proveedor
            trRow.addView(this.createTextViewCenter(li_row, row.getProveedor()));

            //Razon Social del proveedor
            trRow.addView(this.createTextViewLeft(li_row, row.getNomProveedor()));

            //RUC o DNI del proveedor
            trRow.addView(this.createTextViewCenter(li_row, row.getRucDni()));

            //Tipo Documento
            trRow.addView(this.createTextViewCenter(li_row, row.getTipoDoc()));

            //Serie Documento
            trRow.addView(this.createTextViewCenter(li_row, row.getSerie()));

            //Numero Documento
            trRow.addView(this.createTextViewCenter(li_row, row.getNumero()));

            //Cantidad de Cajas
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getCantidad(), "###,##0.00")));

            //Valor Compra
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getValorCompra(), "###,##0.00")));

            //Valor venta
            trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getValorVenta(), "###,##0.00")));

            //Codigo Usuario
            trRow.addView(this.createTextViewCenter(li_row, row.getCodUsuario()));

            //Estado Parte
            trRow.addView(this.createTextViewCenter(li_row, row.getDescEstado()));

            //Adiciono el Table Row al Table Layout
            tblParteRecepcion.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

            li_row++;

        }

    }

    private void editarDetail(final BeanParteIngreso row, final List<BeanParteIngreso> aListado) {


        //TE hace la pregunta si deseas aceptar o cancelar
        final AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
        alertDialog.setMessage("Desea Abrir Registro " + row.getNroParte() + "?, esto puede demorar unos minutos dependiendo de la información contenida");
        alertDialog.setTitle("Abrir registro");
        alertDialog.setIcon(R.drawable.exito);
        alertDialog.setCancelable(false);
        alertDialog.setPositiveButton("Sí", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int which)
            {
                String lstr_JSON = "";
                Parametros strParam = new Parametros();

                strParam.setAction("EDIT");
                strParam.setString1(row.getNroParte());
                strParam.setListado(aListado);

                lstr_JSON = new Gson().toJson(strParam);

                Intent intent = new Intent(context, AlmacenParteRecepcionPopupActivity.class);
                intent.putExtra("strParam", lstr_JSON);
                ((Activity) context).startActivity(intent);
                ((Activity) context).finish();
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

    private void deleteDetail(BeanParteIngreso row) {
        //TE hace la pregunta si deseas aceptar o cancelar
        final AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
        alertDialog.setMessage("Desea Eliminar el Registro " + row.getNroParte() + "?, esto puede demorar unos minutos dependiendo de la información contenida");
        alertDialog.setTitle("Eliminar registro");
        alertDialog.setIcon(R.drawable.cancelar);
        alertDialog.setCancelable(false);
        alertDialog.setPositiveButton("Sí", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int which)
            {
                MessageBox.AlertDialog("El registro ya ha sido eliminado", "Confirmacion", context );
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

}
