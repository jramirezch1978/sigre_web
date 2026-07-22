package pe.com.sytco.fastsales.UI;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.AsyncTask;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.UI.Ancestors.TRowClass;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanSugerencias;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSugerenciasUI extends AncestorUI {

    private TableLayout tblSugerencias;
    private View dialogLayout;
    private ImageView ivImagen;

    public static TRowClass _rowSelected = null;
    public List<BeanSugerencias> _listadoSugerencias;
    private BeanSugerencias _beanSelected = null;

    public DialogSugerenciasUI(Context context, View pDialogLoayout, List<BeanSugerencias> pListado) {
        super();
        this.context = context;
        this.dialogLayout = pDialogLoayout;
        this._listadoSugerencias = pListado;

        tblSugerencias = (TableLayout) dialogLayout.findViewById(R.id.tblSugerencias);
        ivImagen = (ImageView)dialogLayout.findViewById(R.id.ivImagen);

    }

    public void drawHeaderSugerencias() {

        tblSugerencias.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n" ));

        //Id Foto
        tr_head.addView(this.createHeaderTV(17, "Id\nFoto" ));

        //Foto Cargada
        tr_head.addView(this.createHeaderTV(17, "Foto\nCargada" ));

        //Estilo
        tr_head.addView(this.createHeaderTV(17, "Estilo\n" ));

        //Linea
        tr_head.addView(this.createHeaderTV(17, "Descripcion\nLinea" ));

        //SubLinea
        tr_head.addView(this.createHeaderTV(17, "Descripcion\nSub Linea" ));

        //Suela
        tr_head.addView(this.createHeaderTV(17, "Descripcion\nSuela" ));

        //Acabado
        tr_head.addView(this.createHeaderTV(17, "Descripcion\nAcabado" ));

        //Color Primario
        tr_head.addView(this.createHeaderTV(17, "Color\nPrimario" ));

        //Color Secundario
        tr_head.addView(this.createHeaderTV(17, "Color\nSecundario" ));

        //Taco
        tr_head.addView(this.createHeaderTV(17, "Taco\n" ));

        //Und
        tr_head.addView(this.createHeaderTV(17, "Unidad\n" ));

        //Talla Min
        tr_head.addView(this.createHeaderTV(17, "Talla\nMinima" ));

        //Talla Max
        tr_head.addView(this.createHeaderTV(17, "Talla\nMaxima" ));

        //Clase Articulo
        tr_head.addView(this.createHeaderTV(17, "Clase\nArticulo" ));

        //Adiciono el Table Row al Table Layout
        tblSugerencias.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));


    }

    //Dibuja la tabla para el pedido
    public void drawTableSugerencias() {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibView;
        TableRow trRow = null;

        drawHeaderSugerencias();

        //LayoutParams para los botones
        TableRow.LayoutParams lp = new TableRow.LayoutParams(40, 40);
        lp.setMargins(3, 3, 3, 3);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        this.ValidRowsSelect(_listadoSugerencias);

        //Recorro el detalle
        if (_listadoSugerencias.size() > 0) {
            for (final BeanSugerencias row : _listadoSugerencias) {

                //Create table row header to hold the column headings
                trRow = new TableRow(this.context);
                //trRow.setId(10);
                if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
                trRow.setLayoutParams(params);

                //Creo la imagenView
                final ImageView ivImagen = createImageViewCenter(li_row, row.getImagenBlob());

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

                        if(_beanSelected != null){
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(DialogSugerenciasUI._rowSelected, finalTrRow, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass(finalTrRow, finalIbView, finalLi_row);
                        DialogSugerenciasUI._rowSelected = rowClass;

                        showFoto(row, ivImagen);

                    }
                });
                linearLayout.addView(ibView);

                //Añado el Layout
                trRow.addView(linearLayout);

                //Id Foto
                trRow.addView(this.createTextViewRight(li_row, row.getIdFoto().toString()));

                //Foto Cargada
                trRow.addView(ivImagen);

                //Estilo
                trRow.addView(this.createTextViewLeft(li_row, row.getEstilo().toString()));

                //Linea
                trRow.addView(this.createTextViewLeft(li_row, row.getDescLinea().toString()));

                //SubLinea
                trRow.addView(this.createTextViewLeft(li_row, row.getDescSubLinea().toString()));

                //Suela
                trRow.addView(this.createTextViewLeft(li_row, row.getDescSuela().toString()));

                //Acabado
                trRow.addView(this.createTextViewLeft(li_row, row.getDescAcabado().toString()));

                //Color Primario
                trRow.addView(this.createTextViewLeft(li_row, row.getDescColor1().toString()));

                //Color Secundario
                trRow.addView(this.createTextViewLeft(li_row, row.getDescColor2().toString()));

                //Taco
                trRow.addView(this.createTextViewLeft(li_row, row.getDescTaco().toString()));

                //Und
                trRow.addView(this.createTextViewCenter(li_row, row.getUnd()));

                //Talla Min
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getTallaMin(), "###,##0")));

                //Talla Max
                trRow.addView(this.createTextViewRight(li_row, UTIL.ConvetToString(row.getTallaMax(), "###,##0")));

                //Clase Articulo
                trRow.addView(this.createTextViewLeft(li_row, row.getDescClase().toString()));

                trRow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        if(_beanSelected != null){
                            _beanSelected.setSelected(false);
                            _beanSelected = null;
                        }

                        _beanSelected = row;
                        _beanSelected.setSelected(true);

                        rowFocusChanged(DialogSugerenciasUI._rowSelected, (TableRow) v, finalIbView, finalLi_row);

                        TRowClass rowClass = new TRowClass((TableRow) v, finalIbView, finalLi_row);
                        DialogSugerenciasUI._rowSelected = rowClass;

                        showFoto(row, ivImagen);

                        System.gc();

                    }
                });

                //Adiciono el Table Row al Table Layout
                //trRow.setMinimumHeight(200);
                tblSugerencias.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT));

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

                    DialogSugerenciasUI._rowSelected = rowClass;

                    showFoto(row, ivImagen);
                }

                li_row++;

            }

        }

        //Libero la memoria
        System.gc();
    }

    private void ValidRowsSelect(List<BeanSugerencias> listado) {
        boolean selected = false;

        if (listado == null) return;

        for(final BeanSugerencias row : listado){
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
            for (final BeanSugerencias row : listado) {
                if (row != _beanSelected) {
                    row.setSelected(false);
                }
            }
        }

    }

    private void showFoto(BeanSugerencias row, ImageView pIvImagen) {
        //Asignación de la imagen
        if (row.getIdFoto() != null && row.getIdFoto() > 0) {
            if (row.getImagenBlob() == null){
                //new LoadImagenTask(row).execute();
                dialogConfirmLoadImage(row, pIvImagen);
            }else{
                UTIL.SonidoCorrecto(context);
                UTIL.setImageViewWithByteArray(ivImagen, row.getImagenBlob());

            }

        }
        else {
            ivImagen.setImageResource(R.drawable.noimagen);
        }
    }

    private void dialogConfirmLoadImage(final BeanSugerencias row, final ImageView pIvImagen) {
        //TE hace la pregunta si deseas aceptar o cancelar
        final AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
        alertDialog.setMessage("Desea cargar la IMAGEN del con el Id Nro: " + row.getIdFoto().toString() + "?, " +
                               "esto puede demorar unos minutos dependiendo de la información contenida");
        alertDialog.setTitle("Cargar Imagen de la base de datos");
        alertDialog.setIcon(R.drawable.exito);
        alertDialog.setCancelable(false);
        alertDialog.setPositiveButton("Sí", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int which)
            {

                new LoadImagenTask(row, pIvImagen).execute();
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadImagenTask extends AsyncTask<Integer, Void, Boolean> {
        private String mensaje = "";
        private ProgressDialog pDialog;
        private BeanSugerencias _beanSugerencias;
        private ImplArticulo _implArticulo = null;
        private BeanArticulo _beanArticulo = null;
        private ImageView _ivImagen = null;

        private LoadImagenTask(){

        }


        public LoadImagenTask(BeanSugerencias pObj, ImageView pIvImagen) {
            this._beanSugerencias = pObj;
            this._ivImagen = pIvImagen;

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Buscando la imagen para los datos ingresados por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {

            try {

                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //LLenado de Lista para los articulos
                _implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());

                _beanArticulo = _implArticulo.getImagenGrupalScaledMedium(_beanSugerencias.getIdFoto());

                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar el archivo de la FOTO con los datos ingresados. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                _implArticulo = null;
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result){
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Ha ocurrido una exception", mensaje, false);
                }else{
                    UTIL.SonidoCorrecto(context);

                    UTIL.setImageViewWithByteArray(ivImagen, _beanArticulo.getImagen());

                    if (_beanArticulo.getImagen() != null){
                        _beanSugerencias.setImagenBlob(_beanArticulo.getImagen());
                    }

                    //Dibujo la tabla
                    UTIL.setImagenResize(context, _beanArticulo.getImagen(), _ivImagen);

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
