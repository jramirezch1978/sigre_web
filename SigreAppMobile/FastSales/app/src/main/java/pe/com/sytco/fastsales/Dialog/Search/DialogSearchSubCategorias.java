package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Message;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplCategoria;
import pe.com.sytco.fastsales.Controller.Compras.ImplSubCategoria;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.beans.Compras.BeanSubCategoria;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchSubCategorias extends DialogSearchAncestor {

    private List<BeanSubCategoria> listadoSubCategoria = null;

    private EditText etCategoria, etSubCategoria;
    private TextView tvDescSubCategoria;

    private DialogSearchSubCategorias(){

    }

    public DialogSearchSubCategorias(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etSubCategoria = (EditText) layoutReference.findViewById(R.id.etSubCategoria);
        tvDescSubCategoria = (TextView) layoutReference.findViewById(R.id.tvDescSubCategoria);
        etCategoria = (EditText) layoutReference.findViewById(R.id.etCategoria);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {

                    BeanSubCategoria item = listadoSubCategoria.get(position);

                    etSubCategoria.setText(item.getCodSubCategoria());
                    tvDescSubCategoria.setText(item.getDescSubCategoria());

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de SUB CATEGORIAS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        if (etCategoria.getText() == null || etCategoria.getText().toString().trim().equals("")){
            UTIL.SonidoError(context);
            MessageBox.AlertDialog(context, "Error", "No ha seleccionado una categoria, verifique!", false);
            etCategoria.requestFocus();
            dialogMain.dismiss();
            return;
        }

        tvTitle.setText("BUSQUEDA DE SUB CATEGORIAS");
        etBusqueda.setText("");

        new LoadSubCategorias(etCategoria.getText().toString(), "%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadSubCategorias(etCategoria.getText().toString(), lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadSubCategorias extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro, _Categoria;
        private ImplSubCategoria implSubCategoria = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadSubCategorias()
        {

        }

        public LoadSubCategorias(String pCategoria, String value){
            _filtro = value;
            _Categoria = pCategoria;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando SUBCATEGORIAS para la CATEGORIA [" + _Categoria + "], por favor espere...");
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
                implSubCategoria = new ImplSubCategoria(ImplEmpresa.empresaDefault.getCodigo());
                listadoSubCategoria = implSubCategoria.getAllByCategoria(_Categoria, _filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los CATEGORIAS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implSubCategoria = null;
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
                if (listadoSubCategoria.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Error", "No existen SUB CATEGORIAS alguno que cumpla elfiltro ", false);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromSubCategorias(listadoSubCategoria));
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
