package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplArticuloClase;
import pe.com.sytco.fastsales.Controller.Compras.ImplMarca;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Compras.BeanArticuloClase;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchClase extends DialogSearchAncestor {
    private List<BeanArticuloClase> listado = null;

    private EditText etClase;
    private TextView tvDescClase;

    private DialogSearchClase(){

    }

    public DialogSearchClase(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etClase = (EditText) layoutReference.findViewById(R.id.etClase);
        tvDescClase = (TextView) layoutReference.findViewById(R.id.tvDescClase);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanArticuloClase item = listado.get(position);

                    etClase.setText(item.getCodClase());
                    tvDescClase.setText(item.getDescClase());


                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de CLASES DE ARTICULOS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE CLASES DE ARTICULOS");
        etBusqueda.setText("");

        new LoadArticuloClasesTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadArticuloClasesTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadArticuloClasesTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplArticuloClase implArticuloClase = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadArticuloClasesTask()
        {

        }

        public LoadArticuloClasesTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando CLASES DE ARTICULOS, por favor espere...");
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
                implArticuloClase = new ImplArticuloClase(ImplEmpresa.empresaDefault.getCodigo());
                listado = implArticuloClase.getActivosByFiltro(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar las MARCAS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implArticuloClase = null;
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
                    MessageBox.AlertDialog("No existen CLASES DE ARTICULOS alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromClases(listado));
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
