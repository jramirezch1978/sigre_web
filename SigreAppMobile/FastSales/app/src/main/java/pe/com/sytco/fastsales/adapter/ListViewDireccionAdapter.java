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
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Compras.ComprasAddDireccionActivity;
import pe.com.sytco.fastsales.Activities.Compras.ComprasProvClientesActivity;
import pe.com.sytco.fastsales.Controller.Compras.ImplDirecciones;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanDirecciones;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class ListViewDireccionAdapter extends ArrayAdapter<BeanDirecciones> {
    // Declare Variables
    private ComprasProvClientesActivity activity;

    // Progress Dialog
    private ProgressDialog pDialog;

    BeanDirecciones beanDireccion = null;
    BeanUsuario userLogin = null;

    //Controles para el detalle de los articulos
    TextView tvItemDireccion, tvCodTienda, tvFullDireccion, tvUbigeo, tvDescUbigeo, tvZonaVenta,
             tvDescZonaVenta, tvZonaDespacho, tvDescZonaDespacho ;
    Button btnEditar, btnDelete;

    public ListViewDireccionAdapter(ComprasProvClientesActivity value, List<BeanDirecciones> objects) {
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
            listItemView = inflater.inflate(R.layout.item_row_direccion, parent, false);
        }

        InitialiteControllers(listItemView);

        LoadDataDefault(position);


        return listItemView;
    }

    private void LoadDataDefault(int position) {

        //Obteniendo instancia de la Tarea en la posicion actual
        final BeanDirecciones item = getItem(position);

        // Capture position and set to the TextViews
        tvItemDireccion.setText(UTIL.ConvetToString(item.getItemDireccion(), "##0"));
        tvCodTienda.setText(item.getCodTienda());
        tvFullDireccion.setText(item.getFullDireccion());
        tvUbigeo.setText(item.getUbigeo());
        tvDescUbigeo.setText(item.getDescUbigeo());
        tvZonaVenta.setText(item.getZonaVenta());
        tvDescZonaVenta.setText(item.getDescZonaVenta());
        tvZonaDespacho.setText(item.getZonaDespacho());
        tvDescZonaDespacho.setText(item.getDescZonaDespacho());

        btnEditar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                UTIL.SonidoCorrecto(activity);

                Intent intent = new Intent(activity, ComprasAddDireccionActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("direccionSelected", item);
                intent.putExtras(bundle);


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

    private void AskDelete(final BeanDirecciones item) {
        AlertDialog.Builder dialogo1 = new AlertDialog.Builder(getContext());
        dialogo1.setTitle("Eliminación de Direccion");
        dialogo1.setMessage("¿ Desea Anular / Eliminar la direccion " + item.getFullDireccion() + "?. Tener en cuenta que una vez eliminado no se puede recuperar.");
        dialogo1.setCancelable(false);
        dialogo1.setPositiveButton("SI", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogo1, int id) {

                //Ocultar el teclado
                new AnularDireccionTask(item.getItemDireccion()).execute();
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
        tvItemDireccion = (TextView)listItemView.findViewById(R.id.tvItemDireccion);
        tvCodTienda = (TextView)listItemView.findViewById(R.id.tvCodTienda);
        tvFullDireccion = (TextView)listItemView.findViewById(R.id.tvFullDireccion);
        tvUbigeo = (TextView)listItemView.findViewById(R.id.tvUbigeo);
        tvDescUbigeo = (TextView)listItemView.findViewById(R.id.tvDescUbigeo);
        tvZonaVenta = (TextView)listItemView.findViewById(R.id.tvZonaVenta);
        tvDescZonaVenta = (TextView)listItemView.findViewById(R.id.tvDescZonaVenta);
        tvZonaDespacho = (TextView)listItemView.findViewById(R.id.tvZonaDespacho);
        tvDescZonaDespacho = (TextView)listItemView.findViewById(R.id.tvDescZonaDespacho);

        btnEditar = (Button)listItemView.findViewById(R.id.btnEditar);
        btnDelete = (Button)listItemView.findViewById(R.id.btnDelete);

        LimpiarData();

    }

    private void LimpiarData() {
        tvItemDireccion.setText("");
        tvCodTienda.setText("");
        tvFullDireccion.setText("");
        tvUbigeo.setText("");
        tvDescUbigeo.setText("");
        tvZonaVenta.setText("");
        tvDescZonaVenta.setText("");
        tvZonaDespacho.setText("");
        tvDescZonaDespacho.setText("");

    }

    //Clase Asincrona para tareas en segundo plano
    private class AnularDireccionTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplDirecciones implDirecciones = null;
        private ProgressDialog pDialog;
        private Integer _itemDireccion = null;

        private AnularDireccionTask()
        {

        }

        public AnularDireccionTask(Integer value){
            this._itemDireccion = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();

            //UTIL.SonidoWithYou(Activity);
            pDialog = new ProgressDialog(activity);
            pDialog.setMessage("Eliminando / Anulando la Direccion [" + _itemDireccion + "] por favor espere...");
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
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());
                implDirecciones.anularDireccion(_itemDireccion);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al eliminar Direccion: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implDirecciones = null;

            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result) {
                    MessageBox.AlertDialog(activity, "Error en LoadTask()", mensaje, false);
                }else{

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
