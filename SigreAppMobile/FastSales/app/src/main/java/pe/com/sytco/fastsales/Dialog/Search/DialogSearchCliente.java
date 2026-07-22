package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplProveedor;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplUbigeo;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Compras.BeanProveedor;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchCliente extends DialogSearchAncestor {
    private List<BeanProveedor> listadoClientes = null;
    private String flagBoletaFactura, ubigeo;

    private TextView tvRazonSocial, tvDireccion, tvCliente, tvItemDireccion;

    public DialogSearchCliente(View pLayoutReference) {
        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }

    public void openDialog(String pFlagBoletaFactura, String pUbigeo) {
        super.openDialog();
        this.flagBoletaFactura = pFlagBoletaFactura;
        this.ubigeo = pUbigeo;
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanProveedor item = listadoClientes.get(position);

                    tvCliente = (TextView) layoutReference.findViewById(R.id.tvCliente);
                    tvItemDireccion = (TextView) layoutReference.findViewById(R.id.tvItemDireccion);
                    tvRazonSocial = (TextView) layoutReference.findViewById(R.id.tvRazonSocial);
                    tvDireccion = (TextView) layoutReference.findViewById(R.id.tvDireccion);

                    tvCliente.setText(item.getProveedor());
                    tvRazonSocial.setText(item.getNomProveedor());
                    tvItemDireccion.setText(String.valueOf(item.getItemDireccion()));
                    tvDireccion.setText(item.getDireccion());
                    pe.com.sytco.fastsales.util.ValidInputHelper.Rule filled =
                            pe.com.sytco.fastsales.util.ValidInputHelper.notBlank();
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvCliente, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvRazonSocial, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvItemDireccion, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvDireccion, filled);

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de CLIENTE. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }



    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE CLIENTES");
        etBusqueda.setText("");

        new SearchClientesTask("%%").execute();

    }

    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new SearchClientesTask(lsFiltro).execute();

    }

    //Clase Asincrona para tareas en segundo plano
    private class SearchClientesTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplProveedor implProveedor = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private SearchClientesTask()
        {

        }

        public SearchClientesTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Buscando CLIENTES, por favor espere...");
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
                implProveedor = new ImplProveedor(ImplEmpresa.empresaDefault.getCodigo());
                listadoClientes = implProveedor.getClientesByFiltroAndUbigeo(_filtro, ubigeo, flagBoletaFactura);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los UBIGEOS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implProveedor = null;
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
                if (listadoClientes.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen CLIENTES que tengan direccion en el UBIGEO " + ubigeo + " y cumplan elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromClientes(listadoClientes));
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
}
