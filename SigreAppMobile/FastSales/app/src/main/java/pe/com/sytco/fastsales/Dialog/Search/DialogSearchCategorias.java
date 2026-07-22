package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplCategoria;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchCategorias extends DialogSearchAncestor {
    private List<BeanCategoria> listadoCategoria = null;

    private EditText etCategoria, etSubCategoria;
    private TextView tvDescCategoria, tvDescSubCategoria;

    private DialogSearchCategorias(){

    }

    public DialogSearchCategorias(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }


    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanCategoria item = listadoCategoria.get(position);

                    etCategoria = (EditText) layoutReference.findViewById(R.id.etCategoria);
                    etSubCategoria = (EditText) layoutReference.findViewById(R.id.etSubCategoria);
                    tvDescCategoria = (TextView) layoutReference.findViewById(R.id.tvDescCategoria);
                    tvDescSubCategoria = (TextView) layoutReference.findViewById(R.id.tvDescSubCategoria);

                    etCategoria.setText(item.getCatArt());
                    tvDescCategoria.setText(item.getDescCategoria());

                    etSubCategoria.setText("");
                    tvDescSubCategoria.setText("");

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de CATEGORIAS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE CATEGORIAS");
        etBusqueda.setText("");

        new LoadCategoriasTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadCategoriasTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadCategoriasTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplCategoria implCategoria = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadCategoriasTask()
        {

        }

        public LoadCategoriasTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando CATEGORIAS, por favor espere...");
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
                implCategoria = new ImplCategoria(ImplEmpresa.empresaDefault.getCodigo());
                listadoCategoria = implCategoria.getActivosAndAbrev(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los CATEGORIAS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implCategoria = null;
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
                if (listadoCategoria.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen CATEGORIAS alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromCategorias(listadoCategoria));
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
