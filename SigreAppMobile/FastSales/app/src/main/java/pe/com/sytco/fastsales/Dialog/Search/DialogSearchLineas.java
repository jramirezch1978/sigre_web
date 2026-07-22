package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplMarca;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ZC.ImplLineas;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.ZC.BeanZCLinea;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchLineas extends DialogSearchAncestor {
    private List<BeanZCLinea> listadoLineas = null;

    private EditText etLinea, etSubLinea;
    private TextView tvDescLinea, tvDescSubLinea;

    private DialogSearchLineas(){

    }

    public DialogSearchLineas(View pLyoutReference) {

        this.context = pLyoutReference.getContext();
        this.layoutReference = pLyoutReference;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etLinea = (EditText) layoutReference.findViewById(R.id.etLinea);
        tvDescLinea = (TextView) layoutReference.findViewById(R.id.tvDescLinea);

        etSubLinea = (EditText) layoutReference.findViewById(R.id.etSubLinea);
        tvDescSubLinea = (TextView) layoutReference.findViewById(R.id.tvDescSubLinea);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    BeanZCLinea item = listadoLineas.get(position);

                    etLinea.setText(item.getCodLinea());
                    tvDescLinea.setText(item.getDescLinea());

                    etSubLinea.setText("");
                    tvDescSubLinea.setText("");


                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de LINEAS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE LINEAS");
        etBusqueda.setText("");

        new LoadLineasTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadLineasTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadLineasTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplLineas implLineas = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadLineasTask()
        {

        }

        public LoadLineasTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando LINEAS, por favor espere...");
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
                implLineas = new ImplLineas(ImplEmpresa.empresaDefault.getCodigo());
                listadoLineas = implLineas.getActivosByFiltro(_filtro);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar las LINEAS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implLineas = null;
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
                if (listadoLineas.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen LINEAS alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromLineas(listadoLineas));
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
