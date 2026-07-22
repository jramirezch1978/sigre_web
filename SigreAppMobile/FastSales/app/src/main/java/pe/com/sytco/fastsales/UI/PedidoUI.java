package pe.com.sytco.fastsales.UI;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.HorizontalScrollView;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.PedidoSession;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.UI.Ancestors.TRowClass;
import pe.com.sytco.fastsales.adapter.PedidoDetallePosAdapter;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProformaDet;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class PedidoUI extends AncestorUI {
    //Representa al pedido General
    private ImplPedido implPedido = null;
    private PedidoSession session;

    private TableLayout tablePedido;
    private ListView lvPedidoDetalle;
    private PedidoDetallePosAdapter posAdapter;
    private TextView tvImporteVenta, tvIGV, tvBaseImponible;

    public static TRowClass _rowSelected = null;

    public PedidoUI(PedidoSession value) {
        super();

        this.session = value;
        this.implPedido = value.getImplPedido();
        this.context = value.getHostActivity();

        View root = value.getContentRoot();
        tablePedido = (TableLayout) root.findViewById(R.id.tablePedido);
        lvPedidoDetalle = root.findViewById(R.id.lvPedidoDetalle);
        tvImporteVenta = (TextView) root.findViewById(R.id.tvImporteVenta);
        tvIGV = (TextView) root.findViewById(R.id.tvIGV);
        tvBaseImponible = (TextView) root.findViewById(R.id.tvBaseImponible);
        configureTableForHorizontalScroll(root);
        configurePosList();
    }

    private boolean isPosListMode() {
        return lvPedidoDetalle != null;
    }

    private void configurePosList() {
        if (lvPedidoDetalle == null) {
            return;
        }
        posAdapter = new PedidoDetallePosAdapter(context, new PedidoDetallePosAdapter.Actions() {
            @Override
            public void onSelect(BeanProformaDet row, int position) {
                selectPosItem(row);
            }

            @Override
            public void onEdit(BeanProformaDet row) {
                editarDetail(row);
            }

            @Override
            public void onDelete(BeanProformaDet row) {
                deleteDetail(row);
            }
        });
        lvPedidoDetalle.setAdapter(posAdapter);
        lvPedidoDetalle.setEmptyView(null);
    }

    private void selectPosItem(BeanProformaDet selected) {
        if (implPedido == null || implPedido.getDetalleNoDelete() == null) {
            return;
        }
        for (BeanProformaDet row : implPedido.getDetalleNoDelete()) {
            row.setSelected(row == selected);
        }
        if (posAdapter != null) {
            posAdapter.notifyDataSetChanged();
        }
        PedidoUI._rowSelected = null;
    }

    /** Tabla más ancha que la pantalla + scrollbar horizontal visible. */
    private void configureTableForHorizontalScroll(View root) {
        if (tablePedido == null) {
            return;
        }
        tablePedido.setStretchAllColumns(false);
        tablePedido.setShrinkAllColumns(false);
        HorizontalScrollView hsv = root.findViewById(R.id.hsvPedidoDetalle);
        if (hsv != null) {
            hsv.setHorizontalScrollBarEnabled(true);
            hsv.setScrollbarFadingEnabled(false);
        }
    }

    private int dp(int value) {
        return (int) TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP, value,
                context.getResources().getDisplayMetrics());
    }

    private TextView withMinWidth(TextView tv, int minDp) {
        tv.setMinWidth(dp(minDp));
        return tv;
    }

    private TextView withMinWidthCell(TextView tv, int minDp) {
        tv.setMinWidth(dp(minDp));
        tv.setSingleLine(true);
        return tv;
    }

    private void notifySessionChanged() {
        if (session != null) {
            session.persistCache();
            session.notifyPedidoChanged();
        }
    }

    public static String formatAfectoIgv(String flag) {
        if (flag == null) {
            return "";
        }
        if ("1".equals(flag)) {
            return "AFECTO";
        }
        if ("2".equals(flag)) {
            return "INAFECTO";
        }
        if ("3".equals(flag)) {
            return "EXONERADO";
        }
        if ("4".equals(flag)) {
            return "EXPORTACION";
        }
        if ("0".equals(flag)) {
            return "GRATUITO - NO ONEROSO";
        }
        return flag;
    }

    public void drawHeaderPedido() {
        if (isPosListMode() || tablePedido == null) {
            return;
        }

        tablePedido.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(99, " \n"), 110));

        //Nro Item
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(10, "Nro\nItem"), 48));

        //Almacen
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(11, "Almacén\nOrigen"), 90));

        //Descripción del Bien o Servicio
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(12, "Descripcion\nBien o Servicio"), 260));

        //Cantidad Unitaria
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(13, "Cantidad\nUnitaria"), 80));

        //Unidad
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(14, "Unidad\nVenta"), 70));

        //Cantidad Unitaria Und2
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(15, "Cantidad\n2da Unidad"), 90));

        //2nd Unidad
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(16, "2da\nUnidad"), 70));

        //Precio Unitario
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(17, "Precio\nUnitario"), 80));

        //AFECTO IGV
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(18, "Afecto\nIGV"), 100));

        //Porcentaje IGV
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(19, "Porc.\nIGV"), 70));

        //Importe IGV
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(20, "Importe\nIGV"), 80));

        //Flag Bolsa Plastico
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(21, "Usa Bolsa\nPlastico"), 80));

        //ICBPER
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(22, "Importe\nICBPER"), 80));

        //SubTotal
        tr_head.addView(withMinWidth((TextView) this.createHeaderTV(23, "Sub\nTotal"), 80));

        //Adiciono el Table Row al Table Layout
        tablePedido.addView(tr_head, new TableLayout.LayoutParams(
                TableLayout.LayoutParams.WRAP_CONTENT, TableLayout.LayoutParams.WRAP_CONTENT));

    }

    //Funciones para la logica de negocio
    //Dibuja la tabla / listado POS para el pedido
    public void drawDetailPedido(final ImplPedido implPedido) {
        this.implPedido = implPedido;
        this.ValidRowsSelect(implPedido.getDetalleNoDelete());

        if (isPosListMode()) {
            drawDetailPedidoPos(implPedido);
            return;
        }
        drawDetailPedidoTable(implPedido);
    }

    private void drawDetailPedidoPos(final ImplPedido implPedido) {
        if (posAdapter != null) {
            posAdapter.setItems(implPedido.getDetalleNoDelete());
        }
        updateTotales(implPedido);
        PedidoUI._rowSelected = null;
    }

    private void drawDetailPedidoTable(final ImplPedido implPedido) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar, ibView, ibEditar;
        TableRow trRow = null;

        drawHeaderPedido();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        if (implPedido.getDetalleNoDelete().size() > 0) {
            for (final BeanProformaDet row : implPedido.getDetalleNoDelete()) {

                //Create table row header to hold the column headings
                trRow = new TableRow(this.context);
                //trRow.setId(10);
                if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
                trRow.setLayoutParams(params);

                //Layout
                LinearLayout linearLayout = new LinearLayout(trRow.getContext());
                TableRow.LayoutParams optionsLp = new TableRow.LayoutParams(
                        TableRow.LayoutParams.WRAP_CONTENT, TableRow.LayoutParams.WRAP_CONTENT);
                linearLayout.setLayoutParams(optionsLp);
                linearLayout.setMinimumWidth(dp(110));
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

                        rowFocusChanged(PedidoUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        PedidoUI._rowSelected = rowClass;

                    }
                });
                linearLayout.addView(ibView);

                //Boton para eliminar el pedido
                ibEliminar = createImmageButton(31 + li_row * 10, R.drawable.cancelar);
                ibEliminar.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        deleteDetail(row);

                    }
                });
                linearLayout.addView(ibEliminar);

                //Boton para eliminar el pedido
                ibEditar = createImmageButton(31 + li_row * 10, R.drawable.editar);
                ibEditar.setOnClickListener(new View.OnClickListener(){
                    @Override
                    public void onClick(View v) {
                        editarDetail(row);

                    }
                } );
                linearLayout.addView(ibEditar);

                //Añado el Layout
                trRow.addView(linearLayout);

                //Nro Item
                trRow.addView(withMinWidthCell(this.createTextViewCenter(li_row, row.getNroItem().toString()), 48));

                //Almacén Origen
                trRow.addView(withMinWidthCell(this.createTextViewCenter(li_row, row.getAlmacen()), 90));

                //Descripcion Bien o Servicio
                trRow.addView(withMinWidthCell(this.createTextViewLeft(li_row, row.getDescripcion()), 260));

                //Cantidad Unitaria
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getCantidad(), "###,##0.00")), 80));

                //Unidad
                trRow.addView(withMinWidthCell(this.createTextViewCenter(li_row, row.getUnd()), 70));

                //Cantidad Unitaria Und2
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getCantidadUnd2(), "###,##0.00")), 90));

                //Unidad 2
                trRow.addView(withMinWidthCell(this.createTextViewCenter(li_row, row.getUnd2()), 70));

                //Precio Unitario
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getPrecioVta(), "###,##0.00")), 80));

                //AFECTO IGV
                trRow.addView(withMinWidthCell(this.createTextViewLeft(li_row,
                        formatAfectoIgv(row.getFlagAfectoIGV())), 100));

                //Porcentaje IGV
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getPorcIGV(), "###,##0.00")), 70));

                //Importe IGV
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getIgv(), "###,##0.00")), 80));

                //Flag Bolsa Plastico
                String lsFlagBolsa = "";
                if(row.getFlagBolsaPlastico().equals("1")){
                    lsFlagBolsa = "SI";
                }else{
                    lsFlagBolsa = "NO";
                }
                trRow.addView(withMinWidthCell(this.createTextViewCenter(li_row, lsFlagBolsa), 80));

                //ICBPER
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getICBPER(), "###,##0.00")), 80));

                //SubTotal
                trRow.addView(withMinWidthCell(this.createTextViewRight(li_row,
                        UTIL.ConvetToString(row.getSubTotal(), "###,##0.00")), 80));


                trRow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        rowFocusChanged(PedidoUI._rowSelected, (TableRow) v, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass((TableRow) v, finalIbView, finalLi_row);
                        PedidoUI._rowSelected = rowClass;

                        System.gc();

                    }
                });

                //Adiciono el Table Row al Table Layout
                tablePedido.addView(trRow, new TableLayout.LayoutParams(
                        TableLayout.LayoutParams.WRAP_CONTENT, TableLayout.LayoutParams.WRAP_CONTENT));

                if (row.isSelected()) {

                    //Selecciono la fila correspondiente
                    selectRow(trRow);

                    //Asigno el trRow asi como el ImageButton para hacer el cambio
                    TRowClass rowClass = new TRowClass(trRow, ibView, li_row);

                    PedidoUI._rowSelected = rowClass;
                }

                li_row++;

            }

        }

        //Libero la memoria
        System.gc();

        updateTotales(implPedido);
    }

    private void updateTotales(ImplPedido implPedido) {
        tvImporteVenta.setText(UTIL.ConvetToString(implPedido.getImporteVenta(), "###,##0.00"));
        tvIGV.setText(UTIL.ConvetToString(implPedido.getTotalIGV(), "###,##0.00"));
        tvBaseImponible.setText(UTIL.ConvetToString(implPedido.getBaseImponible(), "###,##0.00"));
    }

    //Esta función es para eliminar un registro del pedido
    public void editarDetail(final BeanProformaDet row){

        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
        dialogo1.setTitle("Editar precio de Venta");
        dialogo1.setMessage("¿ Desea editar el precio del articulo " + row.getDescripcion() + "?");
        dialogo1.setCancelable(false);
        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {
                autorizaCambioClave(row);
            }
        });
        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

            }
        });
        dialogo1.show();

    }

    private void autorizaCambioClave(final BeanProformaDet row) {
        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);
        View layoutLocal;
        Button btnAceptar, btnCancelar;
        final EditText etClave;

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        layoutLocal = inflater.inflate(R.layout.dialog_confirm_clave, null);

        builderLocal.setView(layoutLocal);

        //Obtengo referencia a los Botones
        btnAceptar = (Button) layoutLocal.findViewById(R.id.btnAceptar);
        btnCancelar = (Button) layoutLocal.findViewById(R.id.btnCancelar);
        etClave = (EditText) layoutLocal.findViewById(R.id.etClave);

        //Programo los Click de los botones
        builderLocal.setCancelable(false);

        final AlertDialog dialogLocal = builderLocal.create();

        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        MessageBox.AlertDialog("Mensaje de advertencia", "Ha cancelado la operacion, si no ingresa la clave no puede editar el precio", context);
                        dialogLocal.dismiss();
                    }
                }
        );

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        try {
                            final GlobalClass globalVariable = (GlobalClass) context.getApplicationContext();

                            if (!etClave.getText().toString().trim().equals(globalVariable.getEditPassword())) {
                                MessageBox.AlertDialog("Mensaje de advertencia", "La clave ingresada no es corecta, por favor verifique!", context);
                                return;
                            }


                            //Lamo a la función
                            dialogEditPrecio(row);

                        } catch (Exception ex) {
                            MessageBox.AlertDialog("Error al confirmar contraseña de edición. Mensaje: " + ex.getMessage(), "Error", context);
                        } finally {
                            dialogLocal.dismiss();
                        }

                    }
                }

        );

        dialogLocal.show();

    }



    //Esta función es para eliminar un registro del pedido
    public void deleteDetail(final BeanProformaDet row){
        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(context);
        dialogo1.setTitle("Eliminación de registro");
        dialogo1.setMessage("¿ Desea eliminar el articulo " + row.getDescripcion() + " del pedido?");
        dialogo1.setCancelable(false);
        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

                implPedido.deleteDetail(row);

                drawDetailPedido(implPedido);
                notifySessionChanged();
            }
        });
        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

            }
        });
        dialogo1.show();

    }

    private void dialogEditPrecio(final BeanProformaDet row){
        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);
        View layoutLocal;
        Button btnAceptar, btnCancelar;
        final EditText etNewPrecio;

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        layoutLocal = inflater.inflate(R.layout.dialog_edit_precio, null);

        builderLocal.setView(layoutLocal);

        //Obtengo referencia a los Botones
        btnAceptar = (Button) layoutLocal.findViewById(R.id.btnAceptar);
        btnCancelar = (Button) layoutLocal.findViewById(R.id.btnCancelar);
        etNewPrecio = (EditText) layoutLocal.findViewById(R.id.etNewPrecio);

        //Pongo el precio actual
        etNewPrecio.setText(UTIL.ConvetToString(row.getPrecioVta() + row.getIgv(), "###,##0.00"));
        etNewPrecio.requestFocus();
        etNewPrecio.selectAll();

        //Programo los Click de los botones
        builderLocal.setCancelable(false);

        final AlertDialog dialogLocal = builderLocal.create();

        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        MessageBox.AlertDialog("Mensaje de advertencia", "Ha cancelado la operacion", context);
                        dialogLocal.dismiss();
                    }
                }
        );

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        Double ldblPrecio;

                        try {
                            final GlobalClass globalVariable = (GlobalClass) context.getApplicationContext();

                            if (etNewPrecio.getText() == null || etNewPrecio.getText().toString().trim().equals("")) {
                                MessageBox.AlertDialog("Mensaje de advertencia", "Debe ingresar un precio válido", context);
                                return;
                            }

                            if (etNewPrecio.getText().toString().trim().equals("0.00")) {
                                MessageBox.AlertDialog("Mensaje de advertencia", "Debe ingresar un precio válido", context);
                                return;
                            }

                            //Lo convierto
                            ldblPrecio = Double.parseDouble(etNewPrecio.getText().toString().trim());
                            if (ldblPrecio <= 0.00) {
                                MessageBox.AlertDialog("Mensaje de advertencia", "Debe ingresar un precio válido mayor que cero", context);
                                return;
                            }

                            row.changePrecio(ldblPrecio, globalVariable.getPorcIGV(), row.getFlagAfectoIGV());

                            //Dibujo el pedido
                            drawDetailPedido(implPedido);
                            notifySessionChanged();

                        } catch (Exception ex) {
                            MessageBox.AlertDialog("Error al confirmar contraseña de edición. Mensaje: " + ex.getMessage(), "Error", context);
                        } finally {
                            dialogLocal.dismiss();
                        }

                    }
                }

        );

        dialogLocal.show();
    }


    private void ValidRowsSelect(List<BeanProformaDet> listado) {
        boolean selected = false;

        if (listado == null) return;

        for(final BeanProformaDet row : listado){
            if(row.isSelected()){
                selected = true;
            }
        }

        if (!selected && listado.size() > 0){
            listado.get(0).setSelected(true);
        }

    }
}
