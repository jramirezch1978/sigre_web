package pe.com.sytco.fastsales.Dialog.Search;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplZonaDespacho;
import pe.com.sytco.fastsales.Controller.Ventas.ImplZonaVenta;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogSearchAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaDespacho;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaVenta;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSearchZonaDespacho extends DialogSearchAncestor {
    private List<BeanZonaDespacho> listaZonaDespacho = null;
    private TextView tvDescZonaDespacho, tvZonaDespacho, tvUbigeo;
    private String lsUbigeo = "";

    private DialogSearchZonaDespacho(){

    }

    public DialogSearchZonaDespacho(View pLayoutReference) {

        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;

    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        tvUbigeo = (TextView) layoutReference.findViewById(R.id.tvUbigeo);
        tvDescZonaDespacho = (TextView) layoutReference.findViewById(R.id.tvDescZonaDespacho);
        tvZonaDespacho = (TextView) layoutReference.findViewById(R.id.tvZonaDespacho);
    }

    protected void AsignarEventos() {
        super.AsignarEventos();

        //ASigno el listener para el click en un item del listView
        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {

                    BeanZonaDespacho item = listaZonaDespacho.get(position);

                    if (tvZonaDespacho != null)
                        tvZonaDespacho.setText(item.getZonaDespacho());

                    if (tvDescZonaDespacho != null)
                        tvDescZonaDespacho.setText(item.getDescZonaDespacho());

                    dialogMain.dismiss();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog("Ha ocurrido un error al seleccionar un item de ZONA DE DESPACHO. Exception: " + ex.getMessage(),
                            "Function lvListadoItems.setOnItemClickListener()", context);
                }
            }
        });
    }

    public void LoadData() {

        tvTitle.setText("BUSQUEDA DE ZONAS DE DESPACHO");
        etBusqueda.setText("");

        lsUbigeo = tvUbigeo.getText().toString();

        new SearchZonaDespachoTask(lsUbigeo, "%%").execute();

    }


    public void Filtrar() {
        String lsFiltro = "";

        if(etBusqueda.getText().toString().equals("")){
            lsFiltro = "%%";
        }else{
            lsFiltro = "%" + etBusqueda.getText().toString().trim().toUpperCase().replace(" ", "%") + "%";
        }

        lsUbigeo = tvUbigeo.getText().toString();

        new SearchZonaDespachoTask(lsUbigeo, lsFiltro).execute();

    }


    //Clase Asincrona para tareas en segundo plano
    private class SearchZonaDespachoTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje, _filtro, _ubigeo;
        private ImplZonaDespacho implZonaDespacho = null;
        private ArrayAdapter adaptador;

        private ProgressDialog pDialog;

        private SearchZonaDespachoTask()
        {

        }

        public SearchZonaDespachoTask(String ubigeo, String value){
            _ubigeo = ubigeo;
            _filtro = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando ZONAS DE DESPACHO, por favor espere...");
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
                implZonaDespacho = new ImplZonaDespacho(ImplEmpresa.empresaDefault.getCodigo());
                listaZonaDespacho = implZonaDespacho.getZonasDespachobyUbigeo(_ubigeo, _filtro);



                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar ZONAS DE VENTA. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implZonaDespacho = null;
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
                if (listaZonaDespacho.size() == 0) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("No existen ZONAS DE DESPACHO alguno que cumpla el filtro y el ubigeo [" + _ubigeo + "]", "Error", context);
                    return;
                }

                adaptador = new ListViewSearchAdapter(context, BeanItemSearch.createListFromZonaDespacho(listaZonaDespacho));
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
