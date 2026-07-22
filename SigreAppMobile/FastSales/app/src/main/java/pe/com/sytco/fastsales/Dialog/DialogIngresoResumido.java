package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Almacen.ImplParteIngreso;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticuloClase;
import pe.com.sytco.fastsales.Controller.Compras.ImplCategoria;
import pe.com.sytco.fastsales.Controller.Compras.ImplUnidad;
import pe.com.sytco.fastsales.Controller.ImplConfiguracion;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchAcabado;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchCategorias;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchClase;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchColor1;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchColor2;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchLineas;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchMarcas;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchSubCategorias;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchSubLineas;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchSuela;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchTaco;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchUnidad;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.DialogIngresoResumidoUI;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanIngresoResumido;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanSugerencias;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogIngresoResumido extends DialogAncestor {

    //Objeto para manejar la interfaz GUI
    //private ParteIngresoResumido parteIngresoResumido;
    private DialogIngresoResumidoUI dialogIngresoResumidoUI = null;

    //Controles para la interfaz del GUI
    private EditText etMarca, etEstilo, etSuela, etAcabado, etColor1, etColor2, etTaco, etUnidad,
                     etClase, etTallaMin, etTallaMax, etIncremento, etPrecioVenta, etPrecioCompra, etLinea, etSubLinea,
                     etCategoria, etSubCategoria;
    private Button btnMarca, btnCerrar,btnSuela, btnAcabado, btnColor1, btnColor2, btnTaco,
                   btnUnidad, btnClase, btnProcesar, btnAceptar, btnTransferir, btnFinalizar,
                   btnLinea, btnSubLinea, btnCategoria, btnSubCategoria;
    private ImageButton ibtAddSubLinea, ibtAddColor1, ibtAddColor2, ibtAddSuela, ibtAddAcabado;
    private ImageView ivImagen;
    private TextView tvDescMarca, tvLink, tvDesSuela, tvDescAcabado, tvDescColor1, tvDescColor2,
                     tvDescTaco, tvDescUnidad, tvDescClase, tvDescLinea, tvDescSubLinea, tvDescCategoria,
                     tvDescSubCategoria;

    private List<BeanSugerencias> listadoSugerencias = null;
    private List<BeanIngresoResumido> listadoIngresoResumido = null;
    private String _Proveedor;

    private DialogIngresoResumido(){

    }

    public DialogIngresoResumido(Context value, String pProveedor){

        this.context = value;
        this._Proveedor = pProveedor;
    }

    public void openDialog(BeanAncestor value) {

        this.bean = value;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_ingreso_resumido, null);

        InitControllers();

        AsignarEventos();

        builder.setView(dialogLayout);

        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();

        //Activo la opcion de cierre
        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );

        LoadData();


    }

    protected void InitControllers() {
        //Inicializo el listado de Sugerencias
        listadoSugerencias = new ArrayList<BeanSugerencias>();
        listadoIngresoResumido = new ArrayList<BeanIngresoResumido>();

        //Objeto encargado de dibujar la UI
        dialogIngresoResumidoUI = new DialogIngresoResumidoUI(context, dialogLayout, listadoIngresoResumido);

        //Botones
        btnCerrar = (Button) dialogLayout.findViewById(R.id.btnCerrar);
        btnMarca = (Button) dialogLayout.findViewById(R.id.btnMarca);
        btnSuela = (Button) dialogLayout.findViewById(R.id.btnSuela);
        btnAcabado = (Button) dialogLayout.findViewById(R.id.btnAcabado);
        btnColor1 = (Button) dialogLayout.findViewById(R.id.btnColor1);
        btnColor2 = (Button) dialogLayout.findViewById(R.id.btnColor2);
        btnTaco = (Button) dialogLayout.findViewById(R.id.btnTaco);
        btnUnidad = (Button) dialogLayout.findViewById(R.id.btnUnidad);
        btnClase = (Button) dialogLayout.findViewById(R.id.btnClase);
        btnProcesar = (Button) dialogLayout.findViewById(R.id.btnProcesar);
        btnAceptar = (Button) dialogLayout.findViewById(R.id.btnAceptar);
        btnTransferir = (Button) dialogLayout.findViewById(R.id.btnTransferir);
        btnFinalizar = (Button) dialogLayout.findViewById(R.id.btnFinalizar);
        btnLinea = (Button) dialogLayout.findViewById(R.id.btnLinea);
        btnSubLinea = (Button) dialogLayout.findViewById(R.id.btnSubLinea);
        btnCategoria = (Button) dialogLayout.findViewById(R.id.btnCategoria);
        btnSubCategoria = (Button) dialogLayout.findViewById(R.id.btnSubCategoria);

        //EditText
        etMarca = (EditText) dialogLayout.findViewById(R.id.etMarca);
        etEstilo = (EditText) dialogLayout.findViewById(R.id.etEstilo);
        etSuela = (EditText) dialogLayout.findViewById(R.id.etSuela);
        etAcabado = (EditText) dialogLayout.findViewById(R.id.etAcabado);
        etColor1 = (EditText) dialogLayout.findViewById(R.id.etColor1);
        etColor2 = (EditText) dialogLayout.findViewById(R.id.etColor2);
        etTaco = (EditText) dialogLayout.findViewById(R.id.etTaco);
        etUnidad = (EditText) dialogLayout.findViewById(R.id.etUnidad);
        etClase = (EditText) dialogLayout.findViewById(R.id.etClase);
        etTallaMin = (EditText) dialogLayout.findViewById(R.id.etTallaMin);
        etTallaMax = (EditText) dialogLayout.findViewById(R.id.etTallaMax);
        etIncremento = (EditText) dialogLayout.findViewById(R.id.etIncremento);
        etPrecioCompra = (EditText) dialogLayout.findViewById(R.id.etPrecioCompra);
        etPrecioVenta = (EditText) dialogLayout.findViewById(R.id.etPrecioVenta);
        etLinea = (EditText) dialogLayout.findViewById(R.id.etLinea);
        etSubLinea = (EditText) dialogLayout.findViewById(R.id.etSubLinea);
        etCategoria = (EditText) dialogLayout.findViewById(R.id.etCategoria);
        etSubCategoria = (EditText) dialogLayout.findViewById(R.id.etSubCategoria);

        //TextView
        tvDescMarca = (TextView) dialogLayout.findViewById(R.id.tvDescMarca);
        tvLink = (TextView) dialogLayout.findViewById(R.id.tvLink);
        tvDesSuela = (TextView) dialogLayout.findViewById(R.id.tvDescSuela);
        tvDescAcabado = (TextView) dialogLayout.findViewById(R.id.tvDescAcabado);
        tvDescColor1 = (TextView) dialogLayout.findViewById(R.id.tvDescColor1);
        tvDescColor2 = (TextView) dialogLayout.findViewById(R.id.tvDescColor2);
        tvDescTaco = (TextView) dialogLayout.findViewById(R.id.tvDescTaco);
        tvDescUnidad = (TextView) dialogLayout.findViewById(R.id.tvDescUnidad);
        tvDescClase = (TextView) dialogLayout.findViewById(R.id.tvDescClase);
        tvDescLinea = (TextView) dialogLayout.findViewById(R.id.tvDescLinea);
        tvDescSubLinea = (TextView) dialogLayout.findViewById(R.id.tvDescSubLinea);
        tvDescCategoria = (TextView) dialogLayout.findViewById(R.id.tvDescCategoria);
        tvDescSubCategoria = (TextView) dialogLayout.findViewById(R.id.tvDescSubCategoria);

        //ImageButton
        ibtAddSubLinea = (ImageButton) dialogLayout.findViewById(R.id.ibtAddSubLinea);
        ibtAddColor1 = (ImageButton) dialogLayout.findViewById(R.id.ibtAddColor1);
        ibtAddColor2 = (ImageButton) dialogLayout.findViewById(R.id.ibtAddColor2);
        ibtAddSuela = (ImageButton) dialogLayout.findViewById(R.id.ibtAddSuela);
        ibtAddAcabado = (ImageButton) dialogLayout.findViewById(R.id.ibtAddAcabado);

        //ImageView
        ivImagen = (ImageView) dialogLayout.findViewById(R.id.ivImagen);

    }

    protected void AsignarEventos() {

        //Cuando pongan el estilo apareceran las sugerencias
        etEstilo.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                try {
                    // If the event is a key-down event on the "enter" button
                    if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                            keyCode == EditorInfo.IME_ACTION_DONE ||
                            (event.getAction() == KeyEvent.ACTION_DOWN && event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                        etEstilo.requestFocus();

                        consultarSugerencias();

                    }

                } catch (Exception e) {
                    MessageBox.AlertDialog(context, "Error", "Error al validar pallet. Mensaje: " + e.getMessage(), false);
                    e.printStackTrace();
                }

                return false;
            }

        });

        btnCategoria.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchCategorias(dialogLayout).openDialog();
            }
        });

        btnSubCategoria.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchSubCategorias(dialogLayout).openDialog();
            }
        });

        btnMarca.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchMarcas(dialogLayout).openDialog();
            }
        });

        btnLinea.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchLineas(dialogLayout).openDialog();
            }
        });

        btnSubLinea.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchSubLineas(dialogLayout).openDialog();
            }
        });

        btnSuela.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchSuela(dialogLayout).openDialog();
            }
        });

        btnAcabado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchAcabado(dialogLayout).openDialog();
            }
        });

        btnColor1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchColor1(dialogLayout).openDialog();
            }
        });

        btnColor2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchColor2(dialogLayout).openDialog();
            }
        });

        btnTaco.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchTaco(dialogLayout).openDialog();
            }
        });

        btnUnidad.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchUnidad(dialogLayout).openDialog();
            }
        });

        btnClase.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                new DialogSearchClase(dialogLayout).openDialog();
            }
        });

        tvLink.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {

                new DialogSugerencias(dialogLayout, listadoSugerencias).openDialog();

            }
        });

        btnProcesar.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {

                procesar();

            }
        });

        etPrecioCompra.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((EditText)v).selectAll();
            }
        });

    }

    private void procesar() {
        int li_TallaMin = 0, li_TallaMax = 0;
        int li_Incremento = 0;
        float lf_PrecioCompra = 0;

        li_TallaMin = Integer.parseInt(etTallaMin.getText().toString());
        li_TallaMax = Integer.parseInt(etTallaMin.getText().toString());
        li_Incremento = Integer.parseInt(etIncremento.getText().toString());
        lf_PrecioCompra = Float.parseFloat(etPrecioCompra.getText().toString());

        if (li_TallaMin <= 0){
            MessageBox.AlertDialog(context, "Error", "No ha especificado la talla MINIMA, por favor corrija", false);
            etTallaMin.selectAll();
            etTallaMin.requestFocus();
            return;
        }

        if (li_TallaMax <= 0){
            MessageBox.AlertDialog(context, "Error", "No ha especificado la talla MAXIMA, por favor corrija", false);
            etTallaMax.selectAll();
            etTallaMax.requestFocus();
            return;
        }

        if (li_TallaMax < li_TallaMin){
            MessageBox.AlertDialog(context, "Error", "La Talla MAXIMA no puede ser menor a la Talla MINIMA, por favor corrija", false);
            etTallaMax.selectAll();
            etTallaMax.requestFocus();
            return;
        }

        if (li_Incremento <= 0){
            MessageBox.AlertDialog(context, "Error", "El INCREMENTO debe ser siempre POSITIVO y mayor que CERO, por favor corrija", false);
            etIncremento.selectAll();
            etIncremento.requestFocus();
            return;
        }

        if (lf_PrecioCompra <= 0.00){
            MessageBox.AlertDialog(context, "Error", "El Precio de Compra debe ser mayor que CERO, por favor corrija", false);
            etPrecioCompra.selectAll();
            etPrecioCompra.requestFocus();
            return;
        }

        new IngresosResumidosTask().execute();

    }


    public void LoadData() {

        // Cargo los datos la primera vez

        etMarca.setText("");
        etEstilo.setText("");
        etSuela.setText("");
        etAcabado.setText("");
        etColor1.setText("");
        etColor2.setText("");
        etTaco.setText("");
        etUnidad.setText("");
        etClase.setText("");
        etCategoria.setText("");
        etSubCategoria.setText("");
        etLinea.setText("");
        etSubLinea.setText("");

        etTallaMin.setText("0");
        etTallaMax.setText("1");
        etIncremento.setText("1");
        etPrecioCompra.setText("0.00");
        etPrecioVenta.setText("0.00");

        //TextView
        tvDescMarca.setText("");
        tvDesSuela.setText("");
        tvDescAcabado.setText("");
        tvDescColor1.setText("");
        tvDescColor2.setText("");
        tvDescTaco.setText("");
        tvDescUnidad.setText("");
        tvDescClase.setText("");
        tvDescCategoria.setText("");
        tvDescSubCategoria.setText("");
        tvDescLinea.setText("");
        tvDescSubLinea.setText("");

        tvLink.setVisibility(View.INVISIBLE);

        dialogIngresoResumidoUI.drawHeaderIngresoResumido();
        dialogIngresoResumidoUI.drawTotalIngresoResumido();

        new LoadDataTask().execute();
    }

    //Funciones adicionales
    public void consultarSugerencias(){
        String lsSubCategoria, lsCodMarca, lsEstilo;

        if (etSubCategoria.getText() == null || etSubCategoria.getText().toString().trim().equals(""))
            return;

        if (etMarca.getText() == null || etMarca.getText().toString().trim().equals(""))
            return;

        if (etEstilo.getText() == null || etEstilo.getText().toString().trim().equals(""))
            return;

        lsSubCategoria = etSubCategoria.getText().toString();
        lsCodMarca = etMarca.getText().toString();
        lsEstilo = etEstilo.getText().toString();

        new ConsultarSugerenciasTask(lsSubCategoria, lsCodMarca, lsEstilo).execute();
    }

    //Clase Asincrona para cargar las categorias
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, lsUnd = "", lsCodClase = "", lsDescUnidad = "", lsDescClase = "";

        ImplCategoria implCategoria = null;
        ImplConfiguracion implConfiguracion = null;
        ImplUnidad implUnidad = null;
        ImplArticuloClase implArticuloClase = null;

        BeanUsuario userLogin = null;
        List<BeanCategoria> listadoCategorias = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando Datos Iniciales por favor espere...");
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

                //Creo los objetos necesarios
                implCategoria = new ImplCategoria(ImplEmpresa.empresaDefault.getCodigo());
                implConfiguracion = new ImplConfiguracion(ImplEmpresa.empresaDefault.getCodigo());
                implUnidad = new ImplUnidad(ImplEmpresa.empresaDefault.getCodigo());
                implArticuloClase = new ImplArticuloClase(ImplEmpresa.empresaDefault.getCodigo());

                listadoCategorias = implCategoria.getActivosAndAbrev("%%");


                //Datos por defecto, la unidad y la clase de articulo
                lsUnd  = implConfiguracion.getParametro("UNIDAD_PARES", "PAR");
                lsCodClase = implConfiguracion.getParametro("CLASE_MERCADERIA", "01");

                lsDescUnidad = implUnidad.getDescUnidad(lsUnd);
                lsDescClase = implArticuloClase.getDescClase(lsCodClase);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Obtener datos iniciales. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;

            } finally {
                implCategoria = null;
                implConfiguracion = null;
                implUnidad = null;
                implArticuloClase = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    if (listadoCategorias.size() > 0){
                        etCategoria.setText(listadoCategorias.get(0).getCatArt());
                        tvDescCategoria.setText(listadoCategorias.get(0).getDescCategoria());
                    }

                    //Mostrar la caja de dialogo
                    if(isFirstTime()) {
                        showDialog();

                        etUnidad.setText(lsUnd);
                        tvDescUnidad.setText(lsDescUnidad);
                        etClase.setText(lsCodClase);
                        tvDescClase.setText(lsDescClase);

                    }

                }else{
                    etCategoria.requestFocus();
                    MessageBox.AlertDialog(context, "Error en evento LoadData", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();


                } catch (Exception ex) {
                }
                System.gc();

            }

        }

    }

    //Clase Asincrona para consultar las Sugerencias
    private class ConsultarSugerenciasTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, _SubCategoria, _CodMarca, _Estilo;

        ImplParteIngreso implParteIngreso = null;

        private ProgressDialog pDialog;

        public ConsultarSugerenciasTask(String pSubCategoria, String pCodMarca, String pEstilo) {
            this._SubCategoria = pSubCategoria;
            this._CodMarca = pCodMarca;
            this._Estilo = pEstilo;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Consultando las sugerencias con la base de datos por favor espere...");
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

                //Creo los objetos necesarios
                implParteIngreso = new ImplParteIngreso(ImplEmpresa.empresaDefault.getCodigo());


                listadoSugerencias = implParteIngreso.getSugerencias(_SubCategoria, _CodMarca, _Estilo);


                return true;

            } catch (Exception ex) {
                mensaje = "Error al consultar Sugerencias. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;

            } finally {
                implParteIngreso = null;

                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {

                    if (listadoSugerencias.size() == 0) {
                        tvLink.setText("No hay sugerencias");
                    }else{
                        tvLink.setText("Existen " + UTIL.ConvetToString(listadoSugerencias.size(), "###,##0") + " sugerencias.");
                    }
                    tvLink.setVisibility(View.VISIBLE);

                    etEstilo.requestFocus();

                }else{
                    tvLink.setVisibility(View.INVISIBLE);
                    UTIL.SonidoError(context);

                    MessageBox.AlertDialog(context, "Error en funcion consultarSugerencias", mensaje, false);
                }
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

    //Clase Asincrona para obtener los Ingresos Resumidos
    private class IngresosResumidosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        String _Categoria, _SubCategoria, _Und, _CodMarca, _CodLinea, _CodSubLinea, _Estilo,
               _CodAcabado, _CodSuela, _Color1, _Color2, _CodTaco, _PrecioCompra;
        Integer _TallaMin, _TallaMax, _Incremento;

        ImplParteIngreso implParteIngreso = null;

        private ProgressDialog pDialog;

        public IngresosResumidosTask() {

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Procesando los Ingresos RESUMIDOS de la base de datos por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();

            //Obtengo los datos necesarios
            _Categoria = etCategoria.getText().toString();
            _SubCategoria = etSubCategoria.getText().toString();
            _Und = etUnidad.getText().toString();
            _CodMarca = etMarca.getText().toString();
            _CodLinea = etLinea.getText().toString();
            _CodSubLinea = etSubLinea.getText().toString();
            _Estilo = etEstilo.getText().toString();
            _CodAcabado = etAcabado.getText().toString();
            _CodSuela = etSuela.getText().toString();
            _Color1 = etColor1.getText().toString();
            _Color2 = etColor2.getText().toString();
            _CodTaco = etTaco.getText().toString();
            _TallaMin = Integer.parseInt(etTallaMin.getText().toString());
            _TallaMax = Integer.parseInt(etTallaMax.getText().toString());
            _Incremento = Integer.parseInt(etIncremento.getText().toString());
            _PrecioCompra = etPrecioCompra.getText().toString();

        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Creo los objetos necesarios
                implParteIngreso = new ImplParteIngreso(ImplEmpresa.empresaDefault.getCodigo());


                listadoIngresoResumido = implParteIngreso.getSugerenciasArticulos(_Proveedor, _Categoria, _SubCategoria,
                        _Und, _CodMarca, _CodLinea, _CodSubLinea, _Estilo, _CodAcabado, _CodSuela, _Color1, _Color2,
                        _CodTaco, _TallaMin, _TallaMax, _Incremento, _PrecioCompra);


                return true;

            } catch (Exception ex) {
                mensaje = "Error al consultar SUGERENCIAS DE INGRESO RESUMIDO. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;

            } finally {
                implParteIngreso = null;

                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {

                    dialogIngresoResumidoUI.drawTableIngresoResumido(listadoIngresoResumido);

                }else{

                    UTIL.SonidoError(context);

                    MessageBox.AlertDialog(context, "Error en funcion IngresosResumidosTask", mensaje, false);
                }
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
