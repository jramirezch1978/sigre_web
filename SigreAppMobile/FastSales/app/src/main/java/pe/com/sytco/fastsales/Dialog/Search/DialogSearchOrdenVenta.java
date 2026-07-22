package pe.com.sytco.fastsales.Dialog.Search;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplOrdenVenta;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanArticuloMovProy;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchOrdenVenta extends DialogSearchAncestor {
    private List<BeanOrdenVenta> listadoOV = null;

    //Detalle del articulo en caso que tenga
    private List<BeanArticuloMovProy> listadoAMP = null;

    private EditText etOrdenVenta, etAlmacen, etArticulo;
    private TextView tvNomCliente, tvDescArticulo, tvOrgAMP, tvNroAMP;

    private DialogSearchOrdenVenta(){

    }

    public DialogSearchOrdenVenta(Context value) {
        this.context = value;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etOrdenVenta = (EditText) ((Activity)context).findViewById(R.id.etOrdenVenta);
        etAlmacen = (EditText) ((Activity)context).findViewById(R.id.etAlmacen);
        etArticulo = (EditText) ((Activity)context).findViewById(R.id.etArticulo);

        tvNomCliente = (TextView) ((Activity)context).findViewById(R.id.tvNomCliente);
        tvDescArticulo = (TextView) ((Activity)context).findViewById(R.id.tvDescArticulo);
        tvOrgAMP = (TextView) ((Activity)context).findViewById(R.id.tvOrgAMP);
        tvNroAMP = (TextView) ((Activity)context).findViewById(R.id.tvNroAMP);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanOrdenVenta item = listadoOV.get(position);

                    etOrdenVenta.setText(item.getNroOrdenVenta());
                    tvNomCliente.setText(item.getNomCliente());

                    new LoadDetalleOVTask(etAlmacen.getText().toString(), etOrdenVenta.getText().toString(), "%%").execute();

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de ORDENES DE VENTA. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        if (etAlmacen.getText() == null || etAlmacen.getText().toString().trim().equals("")){
            UTIL.SonidoError(context);
            MessageBox.AlertDialog(context, "Error", "No ha seleccionado un ALMACEN DE DESPACHO, verifique!", false);
            etAlmacen.requestFocus();
            dialogMain.dismiss();
            return;
        }

        tvTitle.setText("BUSQUEDA DE ORDENES DE VENTA");
        etBusqueda.setText("");

        //System.out.println("ALMACEN:" + etAlmacen.getText().toString());

        new LoadOrdenesVentaTask(etAlmacen.getText().toString(), "%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadOrdenesVentaTask(etAlmacen.getText().toString(), lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadOrdenesVentaTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro, _almacen;
        private ImplOrdenVenta implOrdenVenta = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadOrdenesVentaTask()
        {

        }

        public LoadOrdenesVentaTask(String pAlmacen, String value){
            _almacen = pAlmacen;
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando ORDENES DE VENTA, por favor espere...");
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

                //LLenado de Lista para los articulos
                implOrdenVenta = new ImplOrdenVenta(ImplEmpresa.empresaDefault.getCodigo());
                listadoOV = implOrdenVenta.getOrdenesVentaByFiltro(_almacen, _filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los ORDENES DE VENTA. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implOrdenVenta = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result){
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(mensaje, "Error", context);
                    return;
                }
                if (listadoOV.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen ORDENES DE VENTA alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromOV(listadoOV));
                lvListadoItems.setAdapter(adaptador);

                if (isFirstTime())
                    showDialog();

                etBusqueda.requestFocus();
                UTIL.OcultarTeclado(context, etBusqueda);


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

    //Clase Asincrona para tareas en segundo plano
    private class LoadDetalleOVTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro, _almacen, _nroOV;
        private ImplOrdenVenta implOrdenVenta = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadDetalleOVTask()
        {

        }

        public LoadDetalleOVTask(String pAlmacen, String pNroOV, String pFiltro){
            _almacen = pAlmacen;
            _filtro = pFiltro;
            _nroOV = pNroOV;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando DETALLE DE LA ORDEN DE VENTA " + _nroOV + ", por favor espere...");
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

                //LLenado de Lista para los articulos
                implOrdenVenta = new ImplOrdenVenta(ImplEmpresa.empresaDefault.getCodigo());
                listadoAMP = implOrdenVenta.getDetalleOV(_nroOV, _almacen, _filtro);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los ORDENES DE VENTA. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implOrdenVenta = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result){
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(mensaje, "Error", context);
                    return;
                }
                if (listadoAMP.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("La ORDEN DE VENTA " + _nroOV + " no tiene detalle para el almacen " + _almacen, "Error", context);
                    return;
                }

                if (listadoAMP.size() == 1){
                    BeanArticuloMovProy item = listadoAMP.get(0);

                    etArticulo.setText(item.getCodArticulo());
                    tvDescArticulo.setText(item.getDescArticulo());
                    tvOrgAMP.setText(item.getCodOrigen());
                    tvNroAMP.setText(UTIL.ConvetToString(item.getNroMov(), "########0"));

                }else{

                    etArticulo.setText("");
                    tvDescArticulo.setText("");
                    tvOrgAMP.setText("");
                    tvNroAMP.setText("");

                }



                //Toast.makeText(context, "NRO AMP: " + tvNroAMP.getText().toString(), Toast.LENGTH_LONG).show();



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
