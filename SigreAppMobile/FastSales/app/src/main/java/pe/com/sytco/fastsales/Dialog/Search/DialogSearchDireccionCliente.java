package pe.com.sytco.fastsales.Dialog.Search;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenParteRecepcionPopupActivity;
import pe.com.sytco.fastsales.Controller.Compras.ImplDirecciones;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanDirecciones;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchDireccionCliente extends DialogSearchAncestor {
    private List<BeanDirecciones> listaDirecciones = null;

    private DialogSearchDireccionCliente(){

    }

    public DialogSearchDireccionCliente(View pLayoutReference) {
        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }


    public void openDialog(String lsCliente, String lsUbigeo) {
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanDirecciones item = listaDirecciones.get(position);

                    if(bean instanceof BeanParteIngreso){
                        BeanParteIngreso obj = (BeanParteIngreso) bean;
                        obj.setItemDireccion(item.getItemDireccion());
                        obj.setDireccionCliente(item.getFullDireccion());
                        obj.setModificado(true);
                    }

                    ((AlmacenParteRecepcionPopupActivity) context).refreshData();

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item del listado de DIRECCIONES. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        BeanParteIngreso beanParteIngreso = (BeanParteIngreso) bean;

        tvTitle.setText("BUSQUEDA DE ALMACENES");
        etBusqueda.setText("");

        new LoadDireccionesTask("%%", beanParteIngreso.getProveedor()).execute();

    }


    public void Filtrar() {
        String lsFiltro = "";
        BeanParteIngreso beanParteIngreso = (BeanParteIngreso) bean;

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadDireccionesTask(lsFiltro, beanParteIngreso.getProveedor()).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadDireccionesTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro, _proveedor;
        private ImplDirecciones implDirecciones = null;
        private ArrayAdapter adaptador;

        //Usuario que se ha logueado
        private BeanUsuario userLogin = null;


        private ProgressDialog pDialog;

        private LoadDireccionesTask()
        {

        }

        public LoadDireccionesTask(String value, String proveedor){

            _filtro = value;
            _proveedor = proveedor;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando DIRECCIONES, por favor espere...");
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

                //Guardo el Controlador del pedido general, para manipularlo por todo el activity
                final GlobalClass globalVariable = (GlobalClass) ((Activity) context).getApplicationContext();

                //Obtengo el usuario que ha hecho lo login
                userLogin = globalVariable.getUserLogin();

                //LLenado de Lista para los articulos
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());
                listaDirecciones = implDirecciones.getDireccionesByFiltro(_proveedor, _filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los ALMACENES. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implDirecciones = null;
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result){
                    MessageBox.AlertDialog(mensaje, "Error", context);
                    return;
                }
                if (listaDirecciones.size() == 0) {
                    MessageBox.AlertDialog("No existen Almacen alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromDirecciones(listaDirecciones));
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
