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
import pe.com.sytco.fastsales.Controller.ImplUbigeo;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.BeanUbigeo;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchUbigeo extends DialogSearchAncestor {
    private List<BeanUbigeo> listadoUbigeo = null;

    private TextView tvDescUbigeo, tvUbigeo, tvDirDepartamento, tvDirProvincia, tvDirDistrito;

    private DialogSearchUbigeo(){

    }

    public DialogSearchUbigeo(View pLayoutReference) {

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
                    BeanUbigeo item = listadoUbigeo.get(position);

                    tvUbigeo = (TextView) layoutReference.findViewById(R.id.tvUbigeo);
                    tvDescUbigeo = (TextView) layoutReference.findViewById(R.id.tvDescUbigeo);

                    tvDirDepartamento = (TextView) layoutReference.findViewById(R.id.tvDirDepartamento);
                    tvDirProvincia = (TextView) layoutReference.findViewById(R.id.tvDirProvincia);
                    tvDirDistrito = (TextView) layoutReference.findViewById(R.id.tvDirDistrito);

                    if (tvUbigeo != null)
                        tvUbigeo.setText(item.getUbigeo());

                    if (tvDescUbigeo != null)
                        tvDescUbigeo.setText(item.getDescUbigeo());

                    if (tvDirDepartamento != null)
                        tvDirDepartamento.setText(item.getDepartamento());

                    if (tvDirProvincia != null)
                        tvDirProvincia.setText(item.getProvincia());

                    if (tvDirDistrito != null)
                        tvDirDistrito.setText(item.getDistrito());

                    pe.com.sytco.fastsales.util.ValidInputHelper.Rule filled =
                            pe.com.sytco.fastsales.util.ValidInputHelper.notBlank();
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvUbigeo, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvDescUbigeo, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvDirDepartamento, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvDirProvincia, filled);
                    pe.com.sytco.fastsales.util.ValidInputHelper.refreshDisplay(tvDirDistrito, filled);

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de UBIGEO. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE UBIGEOS");
        etBusqueda.setText("");

        new SearchUbigeoTask("%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        new SearchUbigeoTask(lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class SearchUbigeoTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro;
        private ImplUbigeo implUbigeo = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private SearchUbigeoTask()
        {

        }

        public SearchUbigeoTask(String value){
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando UBIGEOS, por favor espere...");
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
                implUbigeo = new ImplUbigeo(ImplEmpresa.empresaDefault.getCodigo());
                listadoUbigeo = implUbigeo.getAllByFiltro(_filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar los UBIGEOS. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implUbigeo = null;
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
                if (listadoUbigeo.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen UBIGEO alguno que cumpla elfiltro ", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromUbigeo(listadoUbigeo));
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
