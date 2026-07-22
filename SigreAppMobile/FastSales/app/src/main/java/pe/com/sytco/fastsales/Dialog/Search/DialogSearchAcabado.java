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
import pe.com.sytco.fastsales.Controller.ZC.ImplAcabados;
import pe.com.sytco.fastsales.Controller.ZC.ImplSuelas;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.ZC.BeanZCAcabado;
import pe.com.sytco.fastsales.beans.ZC.BeanZCSuela;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchAcabado extends DialogSearchAncestor {
    private List<BeanZCAcabado> listado = null;

    private EditText etAcabado;
    private TextView tvDescAcabado;

    private DialogSearchAcabado(){

    }

    public DialogSearchAcabado(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etAcabado = (EditText) layoutReference.findViewById(R.id.etAcabado);
        tvDescAcabado = (TextView) layoutReference.findViewById(R.id.tvDescAcabado);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanZCAcabado item = listado.get(position);

                    etAcabado.setText(item.getCodAcabado());
                    tvDescAcabado.setText(item.getDescAcabado());


                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de ACABADOS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE ACABADOS");
        etBusqueda.setText("");

        new LoadAcabadosTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadAcabadosTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadAcabadosTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplAcabados implAcabados = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadAcabadosTask()
        {

        }

        public LoadAcabadosTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando ACABADOS, por favor espere...");
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
                implAcabados = new ImplAcabados(ImplEmpresa.empresaDefault.getCodigo());
                listado = implAcabados.getActivosByFiltro(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar las ACABADOS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implAcabados = null;
                System.gc();
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
                    MessageBox.AlertDialog("No existen ACABADOS alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromAcabados(listado));
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
