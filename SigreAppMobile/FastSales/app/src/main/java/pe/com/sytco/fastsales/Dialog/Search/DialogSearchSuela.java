package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ZC.ImplSuelas;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.ZC.BeanZCSuela;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchSuela extends DialogSearchAncestor {
    private List<BeanZCSuela> listadoSuela = null;

    private EditText etSuela;
    private TextView tvDescSuela;

    private DialogSearchSuela(){

    }

    public DialogSearchSuela(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etSuela = (EditText) layoutReference.findViewById(R.id.etSuela);
        tvDescSuela = (TextView) layoutReference.findViewById(R.id.tvDescSuela);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanZCSuela item = listadoSuela.get(position);

                    etSuela.setText(item.getCodSuela());
                    tvDescSuela.setText(item.getDescSuela());


                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de SUELAS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE SUELAS");
        etBusqueda.setText("");

        new LoadSuelasTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadSuelasTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadSuelasTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplSuelas implSuelas = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadSuelasTask()
        {

        }

        public LoadSuelasTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando SUELAS, por favor espere...");
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
                implSuelas = new ImplSuelas(ImplEmpresa.empresaDefault.getCodigo());
                listadoSuela = implSuelas.getActivosByFiltro(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar las MARCAS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implSuelas = null;
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
                if (listadoSuela.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen MARCAS alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromSuelas(listadoSuela));
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
