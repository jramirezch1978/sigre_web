package pe.com.sytco.fastsales.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Compras.ComprasAddDireccionActivity;
import pe.com.sytco.fastsales.Activities.Compras.ComprasOpcionesActivity;
import pe.com.sytco.fastsales.Activities.PedidoHostActivity;
import pe.com.sytco.fastsales.Activities.Ventas.VentasListarProformasActivity;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Dialog.DialogArticuloDetails;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class ListViewProformaAdapter extends ArrayAdapter<BeanProforma> {
    // Declare Variables
    private VentasListarProformasActivity activity;

    // Progress Dialog
    private ProgressDialog pDialog;

    BeanUsuario userLogin;

    //Controles para el detalle de los articulos
    TextView tvNroProforma, tvFecRegistro, tvRucDni, tvNomCliente, tvDireccion, tvImporteVenta, tvMoneda,
            tvNroLineas, tvTasaCambio, tvFlagTranfGratuita;
    Button btnEditar, btnDelete;

    public ListViewProformaAdapter(VentasListarProformasActivity value, List<BeanProforma> objects) {
        super(value, 0, objects);

        activity = value;

        //Obtengo la clase Global
        GlobalClass globalClass = (GlobalClass)activity.getApplicationContext();

        //Usuario Logueado
        userLogin = globalClass.getUserLogin();


    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        //Obteniendo una instancia del inflater
        LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        //Salvando la referencia del View de la fila
        View listItemView = convertView;

        //Comprobando si el View no existe
        if (null == convertView) {
            //Si no existe, entonces inflarlo con image_list_view.xml
            listItemView = inflater.inflate(R.layout.item_row_proforma, parent, false);
        }

        InitialiteControllers(listItemView);

        LoadDataDefault(position);


        return listItemView;
    }

    private void LoadDataDefault(int position) {

        //Obteniendo instancia de la Tarea en la posicion actual
        final BeanProforma item = getItem(position);

        // Capture position and set to the TextViews
        tvNroProforma.setText(item.getNroProforma());
        tvFecRegistro.setText(item.getFecRegistro());
        tvRucDni.setText(item.getRucDNI());
        tvNomCliente.setText(item.getNomCliente());
        tvDireccion.setText(item.getDireccion());
        tvMoneda.setText(item.getMoneda());

        if (item.getFlagTranfGratuita().equals("0") || item.getTotalVenta() == 0.00){
            tvFlagTranfGratuita.setVisibility(View.VISIBLE);
        }else{
            tvFlagTranfGratuita.setVisibility(View.GONE);
        }


        tvImporteVenta.setText(UTIL.ConvetToString(item.getTotalVenta(), "###,##0.00"));
        tvNroLineas.setText(UTIL.ConvetToString(item.getNroRegistros(), "###,##0"));
        tvTasaCambio.setText(UTIL.ConvetToString(item.getTasaCambio(), "###,##0.0000"));

        btnEditar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(activity.getApplicationContext(), PedidoHostActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("proformaSelected", item);
                intent.putExtras(bundle);

                UTIL.SonidoCampanilla(getContext());
                //MessageBox.AlertDialog("No se puede Modificar la proforma " + item.getNroProforma(),"Error",getContext() );
                activity.startActivity(intent);
                activity.finish();
            }
        });

        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AskDelete(item);
            }
        });
    }

    private void AskDelete(final BeanProforma item) {
        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(getContext());
        dialogo1.setTitle("Eliminación de Proforma");
        dialogo1.setMessage("¿ Desea Anular / Eliminar la proforma " + item.getNroProforma() + "?. Tener en cuenta que una vez eliminado no se puede recuperar.");
        dialogo1.setCancelable(false);
        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

                //Ocultar el teclado
                new AnularProformaTask(item.getNroProforma()).execute();
            }
        });
        dialogo1.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

            }
        });
        dialogo1.show();
    }

    private void InitialiteControllers(View listItemView) {
        //Obteniendo instancias de los elementos
        tvNroProforma = (TextView)listItemView.findViewById(R.id.tvNroProforma);
        tvFecRegistro = (TextView)listItemView.findViewById(R.id.tvFecRegistro);
        tvRucDni = (TextView)listItemView.findViewById(R.id.tvRucDni);
        tvNomCliente = (TextView)listItemView.findViewById(R.id.tvNomCliente);
        tvDireccion = (TextView)listItemView.findViewById(R.id.tvDireccion);
        tvImporteVenta = (TextView)listItemView.findViewById(R.id.tvImporteVenta);
        tvMoneda = (TextView)listItemView.findViewById(R.id.tvMoneda);
        tvNroLineas = (TextView)listItemView.findViewById(R.id.tvNroLineas);
        tvTasaCambio = (TextView)listItemView.findViewById(R.id.tvTasaCambio);
        tvFlagTranfGratuita = (TextView)listItemView.findViewById(R.id.tvFlagTranfGratuita);

        btnEditar = (Button)listItemView.findViewById(R.id.btnEditar);
        btnDelete = (Button)listItemView.findViewById(R.id.btnDelete);

        LimpiarData();

    }

    private void LimpiarData() {
        tvNroProforma.setText("");
        tvFecRegistro.setText("");
        tvRucDni.setText("");
        tvNomCliente.setText("");
        tvDireccion.setText("");
        tvImporteVenta.setText("0.00");
        tvMoneda.setText("");
        tvNroLineas.setText("0");
        tvTasaCambio.setText("0.00");

        tvFlagTranfGratuita.setVisibility(View.GONE);
    }

    //Clase Asincrona para tareas en segundo plano
    private class AnularProformaTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplPedido implPedido = null;
        private ProgressDialog pDialog;
        private String _nroProforma = null;

        private AnularProformaTask()
        {

        }

        public AnularProformaTask(String value){
            this._nroProforma = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();

            //UTIL.SonidoWithYou(Activity);
            pDialog = new ProgressDialog(activity);
            pDialog.setMessage("Eliminando / Anulando la proforma [" + _nroProforma + "] por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
           try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //Anulación Proforma
                implPedido = new ImplPedido(ImplEmpresa.empresaDefault.getCodigo());
                implPedido.anularProforma(_nroProforma);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al anular PROFORMA " + _nroProforma + ". Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implPedido = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result) {
                    MessageBox.AlertDialog(activity, "Error en AnularProformaTask()", mensaje, false);
                }else{
                    UTIL.SonidoCorrecto(activity);
                    MessageBox.AlertDialog(activity, "Proceso completo", "Proforma " + _nroProforma + " ha sido ANULADO", true);
                    activity.BuscarProformas();
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
