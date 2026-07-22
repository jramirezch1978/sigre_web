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
import pe.com.sytco.fastsales.Controller.ImplMoneda;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Finanzas.BeanMoneda;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchMoneda extends DialogSearchAncestor {



    private List<BeanMoneda> listadoMoneda = null;

    private DialogSearchMoneda(){

    }

    public DialogSearchMoneda(Context value) {
        this.context = value;
    }

    protected void AsignarEventos() {

        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanMoneda item = listadoMoneda.get(position);

                    if(bean instanceof BeanParteIngreso){
                        BeanParteIngreso obj = (BeanParteIngreso) bean;
                        obj.setCodMoneda(item.getCodMoneda());
                        obj.setDescMoneda(item.getDescMoneda());
                        obj.setModificado(true);
                    }

                    ((AlmacenParteRecepcionPopupActivity) context).refreshData();

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item del Listado de MONEDAS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });


    }

    public void LoadData() {

        super.LoadData();

        tvTitle.setText("BUSQUEDA DE PROVEEDORES");
        etBusqueda.setText("");

        new LoadMonedasTask("%%").execute();

    }


    public void Filtrar() {

        super.Filtrar();

        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadMonedasTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadMonedasTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplMoneda implMoneda = null;
        private ArrayAdapter adaptador;

        //Usuario que se ha logueado
        private BeanUsuario userLogin = null;


        private ProgressDialog pDialog;

        private LoadMonedasTask()
        {

        }

        public LoadMonedasTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando MONEDAS segun filtro, por favor espere...");
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
                implMoneda = new ImplMoneda(ImplEmpresa.empresaDefault.getCodigo());
                listadoMoneda = implMoneda.getMonedaByFiltro(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los ALMACENES. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implMoneda = null;
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
                if (listadoMoneda.size() == 0) {
                    MessageBox.AlertDialog("No existen PROVEEDORES alguno que cumpla el filtro " + _filtro, "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromMonedas(listadoMoneda));
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

