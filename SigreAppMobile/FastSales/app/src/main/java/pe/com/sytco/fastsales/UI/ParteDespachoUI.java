package pe.com.sytco.fastsales.UI;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenDespachoPPTTActivity;
import pe.com.sytco.fastsales.Dialog.DialogEditCodigoCU;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.UI.Ancestors.TRowClass;
import pe.com.sytco.fastsales.beans.Almacen.BeanCodigoCU;
import pe.com.sytco.fastsales.beans.Almacen.BeanLecturas;
import pe.com.sytco.fastsales.util.UTIL;

public class ParteDespachoUI extends AncestorUI {
    private TableLayout tblListadoCUS, tblResumenLectura;

    public static TRowClass _rowSelected = null;
    public static TRowClass _rowSelectedLectura = null;

    private BeanCodigoCU _beanSelected = null;
    private BeanLecturas _beanSelectedLectura = null;

    //Arreglos de datos
    public static List<BeanCodigoCU> listadoCU = new ArrayList<BeanCodigoCU>();
    public static List<BeanLecturas> resumenLecturas = new ArrayList<BeanLecturas>();

    public ParteDespachoUI(Activity value) {
        super();
        this.context = value;

        tblListadoCUS = (TableLayout) value.findViewById(R.id.tblListadoCUS);
        tblResumenLectura = (TableLayout) value.findViewById(R.id.tblResumenLectura);

    }

    //Dibuja la tabla de Listado de CUs
    private void drawHeaderListadoCUS() {

        tblListadoCUS.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n"));

        //Nro Lote
        tr_head.addView(this.createHeaderTV(17, "Numero\nLote"));

        //Nro Pallet
        tr_head.addView(this.createHeaderTV(17, "Numero\nPallet"));

        //Codigo CU
        tr_head.addView(this.createHeaderTV(17, "Codigo\nCU"));

        //Anaquel
        tr_head.addView(this.createHeaderTV(17, "Anaquel\n"));

        //Fila
        tr_head.addView(this.createHeaderTV(17, "Fila\n"));

        //Columna
        tr_head.addView(this.createHeaderTV(17, "Columna\n"));

        //Saldo Und1
        tr_head.addView(this.createHeaderTV(17, "Saldo\nUnd1"));

        //Und1
        tr_head.addView(this.createHeaderTV(17, "Und1\n"));

        //Saldo Und2
        tr_head.addView(this.createHeaderTV(17, "Saldo\nUnd2"));

        //Und2
        tr_head.addView(this.createHeaderTV(17, "Und2\n"));


        //Adiciono el Table Row al Table Layout
        tblListadoCUS.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

    }

    public void drawTableListadoCUS() {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibView = null, ibEditar, ibEliminar;
        TableRow trRow = null;

        drawHeaderListadoCUS();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        this.ValidRowsSelect(ParteDespachoUI.listadoCU);

        //Recorro el detalle
        if (ParteDespachoUI.listadoCU.size() > 0) {
            for (final BeanCodigoCU row : ParteDespachoUI.listadoCU) {

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

                //Boton para marcar el registro activo el pedido
                ibView = createImmageButton(R.drawable.icono_lupa);
                if (row.isSelected()) {
                    setImageResource(ibView, R.drawable.flecha_derecha_icono);
                } else {
                    setImageResource(ibView, R.drawable.rombo);
                }

                //Variables finales
                final Integer finalLi_row = li_row;
                final TableRow finalTrRow = trRow;
                final ImageButton finalIbView = ibView;

                ibView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if (_beanSelected != null) {
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(ParteDespachoUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        ParteDespachoUI._rowSelected = rowClass;


                    }
                });
                linearLayout.addView(ibView);


                if ((row.getUnd().equals("CJA") && row.getSaldoUnd1() > 1) || ((row.getUnd2().equals("CJA") || row.getUnd2().equals("SAC")) && row.getSaldoUnd2() > 1)) {
                    //Boton para editar el registro
                    ibEditar = createImmageButton(R.drawable.editar);
                    ibEditar.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            if (_beanSelected != null) {
                                _beanSelected.setSelected(false);
                                _beanSelected = null;
                            }

                            _beanSelected = row;
                            _beanSelected.setSelected(true);

                            rowFocusChanged(ParteDespachoUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                            TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                            ParteDespachoUI._rowSelected = rowClass;

                            //Abro el cuadro de dialogo
                            new DialogEditCodigoCU((AlmacenDespachoPPTTActivity) context, ParteDespachoUI.listadoCU, ParteDespachoUI.this).openDialog(ParteDespachoUI.listadoCU.get(0));


                        }
                    });
                    linearLayout.addView(ibEditar);
                }


                //Boton para eliminar el registro
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

                //Nro Lote
                trRow.addView(this.createTextViewCenter(li_row, row.getNroLote()));

                //Nro Pallet
                trRow.addView(this.createTextViewCenter(li_row, row.getNroPallet()));

                //Codigo CU
                trRow.addView(this.createTextViewCenter(li_row, row.getCUS()));

                //Anaquel
                trRow.addView(this.createTextViewCenter(li_row, row.getAnaquel()));

                //Fila
                trRow.addView(this.createTextViewCenter(li_row, row.getFila()));

                //Columna
                trRow.addView(this.createTextViewCenter(li_row, row.getColumna()));

                //Saldo Und1
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getSaldoUnd1(), "###,##0.00")));

                //Und1
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd()));

                //Saldo Und2
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getSaldoUnd2(), "###,##0.00")));

                //Und2
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd2()));

                trRow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if (_beanSelected != null) {
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(ParteDespachoUI._rowSelected, (TableRow) v, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass((TableRow) v, finalIbView, finalLi_row);
                        ParteDespachoUI._rowSelected = rowClass;

                        System.gc();

                    }
                });

                //Adiciono el Table Row al Table Layout
                //trRow.setMinimumHeight(200);
                tblListadoCUS.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

                if (row.isSelected()) {

                    if (_beanSelected != null) {
                        _beanSelected.setSelected(false);
                        _beanSelected = null;
                    }

                    _beanSelected = row;
                    _beanSelected.setSelected(true);

                    //Selecciono la fila correspondiente
                    selectRow(trRow);

                    //Asigno el trRow asi como el ImageButton para hacer el cambio
                    TRowClass rowClass = new TRowClass(trRow, ibView, li_row);

                    ParteDespachoUI._rowSelected = rowClass;

                }

                li_row++;

            }
        }

        this.drawTotalListadoCUS();

        //Libero la memoria
        System.gc();
    }

    private void drawTotalListadoCUS() {
        TableRow.LayoutParams params;
        TableRow trSummary = null;

        try {
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
            params.span = 7;
            trSummary.addView(this.createSummaryRight("TOTAL:"), params);

            //Inserto el Total de Cantidad
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanCodigoCU.getSaldoUnd1(ParteDespachoUI.listadoCU), "###,##0.00")));

            //Inserto la unidad
            if (ParteDespachoUI.listadoCU.size() > 0) {
                trSummary.addView(this.createSummaryCenter(ParteDespachoUI.listadoCU.get(0).getUnd()));
            }

            //Inserto el Sub Total de Compra Nuevo
            params = new TableRow.LayoutParams();
            params.column = 9;
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanCodigoCU.getSaldoUnd2(ParteDespachoUI.listadoCU), "###,##0.00")), params);

            //Inserto la unidad2
            if (ParteDespachoUI.listadoCU.size() > 0) {
                trSummary.addView(this.createSummaryCenter(ParteDespachoUI.listadoCU.get(0).getUnd2()));
            }

            //Adiciono el Table Row Summary
            tblListadoCUS.addView(trSummary, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

        } catch (Exception ex) {
            throw ex;
        } finally {
            trSummary = null;
            params = null;
        }
    }

    //Funciones para la tabla de Resumen de Lectura
    private void drawHeaderResumenLectura() {

        tblResumenLectura.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n"));

        //Almacen Despacho
        tr_head.addView(this.createHeaderTV(17, "Almacen\nDespacho"));

        //Nro OV
        tr_head.addView(this.createHeaderTV(17, "Orden\nde Venta"));

        //Nro Pallet
        tr_head.addView(this.createHeaderTV(17, "Numero\nPallet"));

        //Anaquel
        tr_head.addView(this.createHeaderTV(17, "Anaquel\n"));

        //Fila
        tr_head.addView(this.createHeaderTV(17, "Fila\n"));

        //Columna
        tr_head.addView(this.createHeaderTV(17, "Columna\n"));

        //Nro CUS
        tr_head.addView(this.createHeaderTV(17, "Numero\nCUS"));

        //Saldo Und1
        tr_head.addView(this.createHeaderTV(17, "Saldo\nUnd1"));

        //Und1
        tr_head.addView(this.createHeaderTV(17, "Und1\n"));

        //Saldo Und2
        tr_head.addView(this.createHeaderTV(17, "Saldo\nUnd2"));

        //Und2
        tr_head.addView(this.createHeaderTV(17, "Und2\n"));


        //Adiciono el Table Row al Table Layout
        tblResumenLectura.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

    }

    public void drawTableResumenLectura() {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibView = null, ibEditar, ibEliminar;
        TableRow trRow = null;

        drawHeaderResumenLectura();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        this.ValidRowsSelectLecturas(ParteDespachoUI.resumenLecturas);

        //Recorro el detalle
        if (ParteDespachoUI.resumenLecturas.size() > 0) {
            for (final BeanLecturas row : ParteDespachoUI.resumenLecturas) {

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

                //Boton para marcar el registro activo el pedido
                ibView = createImmageButton(R.drawable.icono_lupa);
                if (row.isSelected()) {
                    setImageResource(ibView, R.drawable.flecha_derecha_icono);
                } else {
                    setImageResource(ibView, R.drawable.rombo);
                }

                //Variables finales
                final Integer finalLi_row = li_row;
                final TableRow finalTrRow = trRow;
                final ImageButton finalIbView = ibView;

                ibView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if (_beanSelectedLectura != null) {
                            _beanSelectedLectura.setSelected(false);
                            _beanSelectedLectura = null;
                        }

                        _beanSelectedLectura = row;
                        _beanSelectedLectura.setSelected(true);

                        rowFocusChanged(ParteDespachoUI._rowSelectedLectura, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        ParteDespachoUI._rowSelectedLectura = rowClass;


                    }
                });
                linearLayout.addView(ibView);


                //Añado el Layout
                trRow.addView(linearLayout);

                //Almacen Despacho
                trRow.addView(this.createTextViewCenter(li_row, row.getAlmacen()));

                //Nro OV
                trRow.addView(this.createTextViewCenter(li_row, row.getNroOV()));

                //Nro Pallet
                trRow.addView(this.createTextViewCenter(li_row, row.getNroPallet()));

                //Anaquel
                trRow.addView(this.createTextViewCenter(li_row, row.getAnaquel()));

                //Fila
                trRow.addView(this.createTextViewCenter(li_row, row.getFila()));

                //Columna
                trRow.addView(this.createTextViewCenter(li_row, row.getColumna()));

                //Nor CUS
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getNroCUS(), "###,##0")));

                //Saldo Und1
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getSaldoUnd1(), "###,##0.00")));

                //Und1
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd1()));

                //Saldo Und2
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getSaldoUnd2(), "###,##0.00")));

                //Und2
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd2()));


                trRow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if (_beanSelectedLectura != null) {
                            _beanSelectedLectura.setSelected(false);
                            _beanSelectedLectura = null;
                        }

                        _beanSelectedLectura = row;
                        _beanSelectedLectura.setSelected(true);

                        rowFocusChanged(ParteDespachoUI._rowSelectedLectura, (TableRow) v, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass((TableRow) v, finalIbView, finalLi_row);
                        ParteDespachoUI._rowSelectedLectura = rowClass;

                        System.gc();

                    }
                });

                //Adiciono el Table Row al Table Layout
                //trRow.setMinimumHeight(200);
                tblResumenLectura.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

                if (row.isSelected()) {

                    if (_beanSelectedLectura != null) {
                        _beanSelectedLectura.setSelected(false);
                        _beanSelectedLectura = null;
                    }

                    _beanSelectedLectura = row;
                    _beanSelectedLectura.setSelected(true);

                    //Selecciono la fila correspondiente
                    selectRow(trRow);

                    //Asigno el trRow asi como el ImageButton para hacer el cambio
                    TRowClass rowClass = new TRowClass(trRow, ibView, li_row);

                    ParteDespachoUI._rowSelectedLectura = rowClass;

                }

                li_row++;

            }
        }

        this.drawTotalResumenLectura();

        //Libero la memoria
        System.gc();
    }

    private void drawTotalResumenLectura() {
        TableRow.LayoutParams params;
        TableRow trSummary = null;

        try {
            //Layout params para el resto de controles
            params = new TableRow.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

            //Create table row header to hold the column headings
            trSummary = new TableRow(this.context);
            //trSummary.setId(30);
            trSummary.setBackgroundColor(Color.GRAY);
            trSummary.setLayoutParams(params);

            //Layout

            //Añado el Total con un columnSpan = 6
            params = new TableRow.LayoutParams();
            params.span = 7;
            trSummary.addView(this.createSummaryRight("TOTAL GENERAL:"), params);

            //Inserto el Total de Nro Cus
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanLecturas.getNroCUS(ParteDespachoUI.resumenLecturas), "###,##0.00")));

            //Inserto el Sub Total de Saldo Und1
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanLecturas.getSaldoUnd1(ParteDespachoUI.resumenLecturas), "###,##0.00")));

            //Inserto la unidad
            if (ParteDespachoUI.resumenLecturas.size() > 0) {
                trSummary.addView(this.createSummaryCenter(ParteDespachoUI.resumenLecturas.get(0).getUnd1()));
            }

            //Inserto el Sub Total de Saldo Und2
            params = new TableRow.LayoutParams();
            params.column = 9;
            trSummary.addView(this.createSummaryRight(UTIL.ConvetToString(BeanLecturas.getSaldoUnd2(ParteDespachoUI.resumenLecturas), "###,##0.00")), params);

            //Inserto la unidad2
            if (ParteDespachoUI.resumenLecturas.size() > 0) {
                trSummary.addView(this.createSummaryCenter(ParteDespachoUI.resumenLecturas.get(0).getUnd2()));
            }

            //Adiciono el Table Row Summary
            tblResumenLectura.addView(trSummary, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

        } catch (Exception ex) {
            throw ex;
        } finally {
            trSummary = null;
            params = null;
        }
    }

    private void ValidRowsSelect(List<BeanCodigoCU> pListado) {
        boolean selected = false;

        if (pListado == null) return;

        for (final BeanCodigoCU row : pListado) {
            if (row.isSelected()) {
                selected = true;
                _beanSelected = row;
                break;
            }
        }

        if (!selected && pListado.size() > 0) {
            pListado.get(0).setSelected(true);
            _beanSelected = pListado.get(0);
        }

        //Si ya existe una fila seleccionada, entonces simplemente pongo todas las filas como
        //no seleccionadas
        if (_beanSelected != null && selected) {
            for (final BeanCodigoCU row : pListado) {
                if (row != _beanSelected) {
                    row.setSelected(false);
                }
            }
        }
    }

    private void ValidRowsSelectLecturas(List<BeanLecturas> pListado) {
        boolean selected = false;

        if (pListado == null) return;

        for (final BeanLecturas row : pListado) {
            if (row.isSelected()) {
                selected = true;
                _beanSelectedLectura = row;
                break;
            }
        }

        if (!selected && pListado.size() > 0) {
            pListado.get(0).setSelected(true);
            _beanSelectedLectura = pListado.get(0);
        }

        //Si ya existe una fila seleccionada, entonces simplemente pongo todas las filas como
        //no seleccionadas
        if (_beanSelectedLectura != null && selected) {
            for (final BeanLecturas row : pListado) {
                if (row != _beanSelectedLectura) {
                    row.setSelected(false);
                }
            }
        }
    }

    private void eliminarRegistro(final BeanCodigoCU row) {
        //TE hace la pregunta si deseas aceptar o cancelar
        final AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
        alertDialog.setMessage("Desea Eliminar el Registro con CU " + row.getCUS() + "?");
        alertDialog.setTitle("Eliminar registro");
        alertDialog.setIcon(R.drawable.cancelar);
        alertDialog.setCancelable(false);
        alertDialog.setPositiveButton("Sí", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int which)
            {
                ParteDespachoUI.listadoCU.remove(row);
                drawTableListadoCUS();

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
