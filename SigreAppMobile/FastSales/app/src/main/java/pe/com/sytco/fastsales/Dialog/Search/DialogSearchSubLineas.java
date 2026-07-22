package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplSubCategoria;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ZC.ImplLineas;
import pe.com.sytco.fastsales.Controller.ZC.ImplSubLineas;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.ZC.BeanZCLinea;
import pe.com.sytco.fastsales.beans.ZC.BeanZCSubLineas;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchSubLineas extends DialogSearchAncestor {

    private List<BeanZCSubLineas> listadoSubLineas = null;

    private EditText etSubLinea, etSubCategoria;
    private TextView tvDescSubLinea;

    private DialogSearchSubLineas(){

    }

    public DialogSearchSubLineas(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        etSubCategoria = (EditText) layoutReference.findViewById(R.id.etSubCategoria);

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
                    BeanZCSubLineas item = listadoSubLineas.get(position);

                    etSubLinea.setText(item.getCodSubLinea());
                    tvDescSubLinea.setText(item.getDescSubLinea());

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de SUB LINEAS. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        if (etSubCategoria.getText() == null || etSubCategoria.getText().toString().trim().equals("")){
            UTIL.SonidoError(context);
            MessageBox.AlertDialog(context, "Error", "No ha seleccionado una categoria, verifique!", false);
            etSubCategoria.requestFocus();
            dialogMain.dismiss();
            return;
        }

        tvTitle.setText("BUSQUEDA DE SUB LINEAS");
        etBusqueda.setText("");

        new LoadSubLineasTask("%%", etSubCategoria.getText().toString() ).execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new LoadSubLineasTask(etSubCategoria.getText().toString(), lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadSubLineasTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro, _SubCategoria;
        private ImplSubLineas implSubLineas = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private LoadSubLineasTask()
        {

        }

        public LoadSubLineasTask(String value, String pSubCateg){

            _filtro = value;
            _SubCategoria = pSubCateg;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando SUB LINEAS con la SubCategoria [" + _SubCategoria + "], por favor espere...");
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
                implSubLineas = new ImplSubLineas(ImplEmpresa.empresaDefault.getCodigo());
                listadoSubLineas = implSubLineas.getActivosByFiltro(_SubCategoria, _filtro);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar las SUB LINEAS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implSubLineas = null;
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
                if (listadoSubLineas.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen SUB LINEAS alguno que cumpla el filtro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromSubLineas(listadoSubLineas));
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
