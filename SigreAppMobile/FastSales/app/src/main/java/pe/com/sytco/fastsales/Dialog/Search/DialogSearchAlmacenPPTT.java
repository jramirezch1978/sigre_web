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

import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.Compras.ImplSubCategoria;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanSubCategoria;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchAlmacenPPTT extends DialogSearchAncestor {
    private List<BeanAlmacen> listado = null;

    private EditText etAlmacen;
    private TextView tvDescAlmacen;

    private DialogSearchAlmacenPPTT(){

    }

    public DialogSearchAlmacenPPTT(Context value) {
        this.context = value;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etAlmacen = (EditText) ((Activity)context).findViewById(R.id.etAlmacen);
        tvDescAlmacen = (TextView) ((Activity)context).findViewById(R.id.tvDescAlmacen);

    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {

                    BeanAlmacen item = listado.get(position);

                    etAlmacen.setText(item.getAlmacen());
                    tvDescAlmacen.setText(item.getDescAlmacen());

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de ALMACENES. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE ALMACENES");
        etBusqueda.setText("");

        new LoadAlmacenesPPTTTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadAlmacenesPPTTTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadAlmacenesPPTTTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplAlmacen implAlmacen = null;
        private ArrayAdapter adaptador;

        BeanUsuario userLogin = null;

        private ProgressDialog pDialog;

        private LoadAlmacenesPPTTTask()
        {

        }

        public LoadAlmacenesPPTTTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando ALMACENES PPTT, por favor espere...");
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

                //Obtengo el usuario
                final GlobalClass globalVariable = (GlobalClass) ((Activity)context).getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                if(userLogin == null)
                {
                    mensaje = "No se ha especificado el usuario que ha Logueado";
                    return false;
                }

                //LLenado de Lista para los articulos
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                listado = implAlmacen.getAlmacenByUsuario(userLogin.getUsuario(), _filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar ALMACENES. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implAlmacen = null;
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
                if (listado.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Error", "No existen ALMACENES alguno que cumpla elfiltro ", false);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromAlmacenes(listado));
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
                    if (pDialog != null)
                        pDialog.dismiss();

                } catch (Exception ex) {
                }

            }

        }

    }
}
