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
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Compras.ImplProveedor;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.Compras.BeanProveedor;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchProveedor extends DialogSearchAncestor {

    private List<BeanProveedor> listadoProveedor = null;

    private DialogSearchProveedor(){

    }

    public DialogSearchProveedor(Context value) {
        this.context = value;
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanProveedor item = listadoProveedor.get(position);

                    if(bean instanceof BeanParteIngreso){
                        BeanParteIngreso obj = (BeanParteIngreso) bean;
                        obj.setProveedor(item.getProveedor());
                        obj.setNomProveedor(item.getNomProveedor());
                        obj.setRucDni(item.getRucDni());
                        obj.setItemDireccion(item.getItemDireccion());
                        obj.setDireccionCliente(item.getDireccion());
                        obj.setModificado(true);
                    }

                    ((AlmacenParteRecepcionPopupActivity) context).refreshData();

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item del Listado de PROVEEDORES. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });

    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE PROVEEDORES");
        etBusqueda.setText("");

        new LoadProveedoresTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadProveedoresTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadProveedoresTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplProveedor implProveedor = null;
        private ArrayAdapter adaptador;

        //Usuario que se ha logueado
        private BeanUsuario userLogin = null;


        private ProgressDialog pDialog;

        private LoadProveedoresTask()
        {

        }

        public LoadProveedoresTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando PROVEEDORES segun filtro, por favor espere...");
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
                implProveedor = new ImplProveedor(ImplEmpresa.empresaDefault.getCodigo());
                listadoProveedor = implProveedor.getProveedoresByFiltro(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los ALMACENES. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implProveedor = null;
                System.gc();
            }



        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result){
                    MessageBox.AlertDialog(mensaje, "Error", context);
                    return;
                }
                if (listadoProveedor.size() == 0) {
                    MessageBox.AlertDialog("No existen PROVEEDORES alguno que cumpla el filtro " + _filtro, "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromProveedor(listadoProveedor));
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

