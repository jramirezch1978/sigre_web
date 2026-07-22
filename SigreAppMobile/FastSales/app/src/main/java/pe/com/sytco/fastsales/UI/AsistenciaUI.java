package pe.com.sytco.fastsales.UI;

import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Asistencia.AsistenciaGeneralActivity;
import pe.com.sytco.fastsales.Controller.Asistencia.ImplAsistencia;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.beans.Asistencia.BeanAsistenciaHT580;
import pe.com.sytco.fastsales.util.UTIL;

public class AsistenciaUI extends AncestorUI {

    private TableLayout tblAsistencia;

    public AsistenciaUI(AsistenciaGeneralActivity value) {
        super();
        this.context = value;

        tblAsistencia = (TableLayout) value.findViewById(R.id.tblAsistencia);

    }

    public void drawListadoAsistencia(List<BeanAsistenciaHT580> listaAsistencia) {
        TableLayout.LayoutParams params;
        Integer li_row = 1;
        ImageButton ibEliminar, ibEditar;
        TableRow trRow = null;

        this.addHeaderListadoAsistencia();

        //LayoutParams para los botones (36x36 para que sea visible)
        TableRow.LayoutParams lp = new TableRow.LayoutParams(36, 36);
        lp.setMargins(2, 2, 2, 2);

        //Layout params para el resto de controles
        params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT, TableLayout.LayoutParams.WRAP_CONTENT);

        //Recorro el detalle
        int numeroFila = 1;
        for (final BeanAsistenciaHT580 row : listaAsistencia) {

            //Create table row header to hold the column headings
            trRow = new TableRow(context);
            trRow.setId(10);
            if (li_row % 2 == 0) trRow.setBackgroundColor(Color.GRAY);
            trRow.setLayoutParams(params);

            // Número de fila (ROWNUM)
            trRow.addView(this.createTextViewCenter(li_row, String.valueOf(numeroFila)));

            //Layout para centrar el botón X
            LinearLayout linearLayout = new LinearLayout(trRow.getContext());
            TableRow.LayoutParams layoutParams = new TableRow.LayoutParams(
                TableRow.LayoutParams.WRAP_CONTENT, 
                AncestorUI.heightRowDetailPx  // Altura igual a la fila
            );
            linearLayout.setLayoutParams(layoutParams);
            linearLayout.setOrientation(LinearLayout.HORIZONTAL);
            linearLayout.setGravity(Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL);  // Centrado horizontal y vertical

            //Boton para eliminar el pedido (36x36 bien centrado)
            ibEliminar = createImmageButton(32 + li_row * 10, R.drawable.cancelar);
            ibEliminar.setLayoutParams(lp);
            ibEliminar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    deleteDetail(row);

                }
            });

            //trRow.addView(ibEliminar);
            linearLayout.addView(ibEliminar);


            //Añado el Layout
            trRow.addView(linearLayout);

            //reckey
            trRow.addView(this.createTextViewRight(li_row, row.getRecKey()));

            //Codigo
            trRow.addView(this.createTextViewCenter(li_row, row.getCodigo()));

            //Nombre Trabajador
            trRow.addView(this.createTextViewLeft(li_row, row.getNomTrabajador()));

            //Turno
            String turno = row.getTurno();
            if (turno == null || turno.isEmpty() || turno.equals("null")) {
                turno = "-";
            } else {
                turno = turno.trim(); // Eliminar espacios al inicio y final
            }
            trRow.addView(this.createTextViewCenter(li_row, turno));

            //Hora del Registro (centrado, formato hh:mm am/pm)
            trRow.addView(this.createTextViewCenter(li_row, row.getHoraMovimiento()));

            //Adiciono el Table Row al Table Layout
            tblAsistencia.addView(trRow, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT,
                                                                      TableLayout.LayoutParams.WRAP_CONTENT));

            li_row++;
            numeroFila++;

        }

    }

    private void deleteDetail(final BeanAsistenciaHT580 row) {
        // Validar que el RECKEY no esté vacío
        if (row.getRecKey() == null || row.getRecKey().trim().isEmpty()) {
            android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(context);
            builder.setTitle("Error");
            builder.setMessage("No se puede eliminar el registro porque no tiene un identificador válido.");
            builder.setPositiveButton("OK", null);
            builder.show();
            return;
        }

        // Mostrar diálogo de confirmación
        android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(context);
        builder.setTitle("Confirmar Eliminación");
        
        String mensaje = String.format(
            "¿Está seguro que desea eliminar la asistencia?\n\n" +
            "Trabajador: %s\n" +
            "Fecha/Hora: %s\n" +
            "Tipo: %s",
            row.getNomTrabajador() != null ? row.getNomTrabajador() : row.getCodigo(),
            row.getFecRegistro() != null ? row.getFecRegistro() : "N/A",
            row.getFlagInOut().equals("1") ? "INGRESO" : "SALIDA"
        );
        
        builder.setMessage(mensaje);
        
        builder.setPositiveButton("SÍ, ELIMINAR", new android.content.DialogInterface.OnClickListener() {
            @Override
            public void onClick(android.content.DialogInterface dialog, int which) {
                // Ejecutar eliminación en segundo plano
                new EliminarAsistenciaTask().executeOnExecutor(android.os.AsyncTask.THREAD_POOL_EXECUTOR, row.getRecKey());
            }
        });
        
        builder.setNegativeButton("CANCELAR", new android.content.DialogInterface.OnClickListener() {
            @Override
            public void onClick(android.content.DialogInterface dialog, int which) {
                dialog.dismiss();
            }
        });
        
        builder.show();
    }
    
    // AsyncTask para eliminar asistencia
    private class EliminarAsistenciaTask extends android.os.AsyncTask<String, Void, Boolean> {
        private String reckey;
        private String mensajeError = "";
        private android.app.ProgressDialog progressDialog;
        private long taskCreationTime;
        
        {
            // Constructor: registrar el momento de creación del AsyncTask
            this.taskCreationTime = System.currentTimeMillis();
            android.util.Log.i("AsistenciaUI", "[MOBILE] EliminarAsistenciaTask CREADO | Tiempo creación: " + taskCreationTime);
        }
        
        @Override
        protected void onPreExecute() {
            long preExecuteTime = System.currentTimeMillis();
            long delayFromCreation = preExecuteTime - taskCreationTime;
            android.util.Log.i("AsistenciaUI", "[MOBILE] EliminarAsistenciaTask onPreExecute() ejecutado | Delay desde creación: " + delayFromCreation + " ms");
            
            super.onPreExecute();
            progressDialog = new android.app.ProgressDialog(context);
            progressDialog.setMessage("Eliminando registro...");
            progressDialog.setCancelable(false);
            progressDialog.show();
        }
        
        @Override
        protected Boolean doInBackground(String... params) {
            try {
                reckey = params[0];
                ImplAsistencia implAsistencia = new ImplAsistencia(ImplEmpresa.empresaDefault.getCodigo());
                return implAsistencia.deleteAsistencia(reckey);
            } catch (Exception e) {
                mensajeError = e.getMessage();
                return false;
            }
        }
        
        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);
            
            if (progressDialog != null && progressDialog.isShowing()) {
                progressDialog.dismiss();
            }
            
            if (result) {
                // OPTIMIZACIÓN: Invalidar caché de asistencia después de eliminar
                pe.com.sytco.fastsales.Activities.Asistencia.AsistenciaGeneralActivity.invalidarCacheAsistencia();
                
                android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(context);
                builder.setTitle("Éxito");
                builder.setMessage("El registro ha sido eliminado correctamente.");
                builder.setPositiveButton("OK", new android.content.DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(android.content.DialogInterface dialog, int which) {
                        // Recargar la lista de asistencias
                        if (context instanceof pe.com.sytco.fastsales.Activities.Asistencia.AsistenciaGeneralActivity) {
                            ((pe.com.sytco.fastsales.Activities.Asistencia.AsistenciaGeneralActivity) context).BuscarRegistros();
                        }
                    }
                });
                builder.show();
            } else {
                android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(context);
                builder.setTitle("Error");
                builder.setMessage("No se pudo eliminar el registro:\n\n" + mensajeError);
                builder.setPositiveButton("OK", null);
                builder.show();
            }
        }
    }

    private void addHeaderListadoAsistencia() {
        tblAsistencia.removeAllViews();

        TableLayout.LayoutParams params = new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT,
                                                                       TableLayout.LayoutParams.WRAP_CONTENT);

        //Create table row header to hold the column headings
        TableRow tr_head = new TableRow(context);
        tr_head.setId(10);
        tr_head.setBackgroundColor(Color.WHITE);
        tr_head.setLayoutParams(params);

        //Número de fila
        tr_head.addView(this.createHeaderTV(10, "#\n" ));

        //Opciones
        tr_head.addView(this.createHeaderTV(99, " \n" ));


        //Reckey
        tr_head.addView(this.createHeaderTV(11, "Codigo\nReckey" ));

        //Codigo
        tr_head.addView(this.createHeaderTV(13, "Codigo\nTrabajador" ));

        //Nombre del Trabajador
        tr_head.addView(this.createHeaderTV(14, "Nombre\nTrabajador" ));

        //Turno
        tr_head.addView(this.createHeaderTV(15, "Turno\nMarcacion" ));

        //Hora de marcación
        tr_head.addView(this.createHeaderTV(16, "Hora\nMarcación" ));


        //Adiciono el Table Row al Table Layout
        tblAsistencia.addView(tr_head, new TableLayout.LayoutParams(TableLayout.LayoutParams.MATCH_PARENT,
                                                                    TableLayout.LayoutParams.WRAP_CONTENT));

    }
}
