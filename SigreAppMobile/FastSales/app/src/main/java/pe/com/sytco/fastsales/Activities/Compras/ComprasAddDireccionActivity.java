package pe.com.sytco.fastsales.Activities.Compras;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.InputFilter;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.List;

import dmax.dialog.SpotsDialog;
import pe.com.sytco.fastsales.Controller.Compras.ImplDirecciones;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchUbigeo;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchZonaDespacho;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchZonaVenta;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanOpcion;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanDirecciones;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class ComprasAddDireccionActivity extends AppCompatActivity {

    //Interfaz de UI
    TextView tvItemDireccion, tvCodTienda, tvLongitud, tvLatitud, tvUbigeo, tvDirDepartamento,
             tvDirProvincia, tvDirDistrito, tvZonaVenta, tvDescZonaVenta,tvCodPaisSunat, tvZonaDespacho,
             tvDescZonaDespacho, tvDescPaisSunat;
    Spinner spDescripcion, spFlagUsos;
    EditText etDirCiudad, etDirDireccion,
             etDirMnz, etDirLote, etDirNro, etDirInterior, etDirCodPostal, etDirSiglasPais, etDirReferencia,
             etDirUrbanizacion;
    Button btnUbigeo, btnDirSiglasPais, btnCodPaisSunat, btnAceptar, btnCancelar, btnZonaVenta, btnZonaDespacho;

    //Variable que guarda el codigo
    String codProveedor;

    //Variables para la direccion
    private BeanDirecciones direccionSelected = null;
    private List<BeanOpcion> listaDescripcion = null, listaFlagTipoUso;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_compras_add_direccion);

        Bundle bundle = getIntent().getExtras();
        if (bundle != null)
            direccionSelected =(BeanDirecciones) bundle.getSerializable("direccionSelected");

        InitControllers();

        AsignarEventos();

        LoadDataDefault();
    }
    private void InitControllers() {

        spDescripcion = (Spinner) findViewById(R.id.spDescripcion);
        spFlagUsos = (Spinner) findViewById(R.id.spFlagUsos);

        tvItemDireccion = (TextView) findViewById(R.id.tvItemDireccion);
        tvCodTienda = (TextView) findViewById(R.id.tvCodTienda);
        tvLongitud = (TextView) findViewById(R.id.tvLongitud);
        tvLatitud = (TextView) findViewById(R.id.tvLatitud);
        tvUbigeo = (TextView) findViewById(R.id.tvUbigeo);
        tvDirDepartamento = (TextView) findViewById(R.id.tvDirDepartamento);
        tvDirProvincia = (TextView) findViewById(R.id.tvDirProvincia);
        tvDirDistrito = (TextView) findViewById(R.id.tvDirDistrito);
        tvZonaVenta = (TextView) findViewById(R.id.tvZonaVenta);
        tvDescZonaVenta = (TextView) findViewById(R.id.tvDescZonaVenta);
        tvCodPaisSunat = (TextView) findViewById(R.id.tvCodPaisSunat);
        tvDescZonaDespacho = (TextView) findViewById(R.id.tvDescZonaDespacho);
        tvZonaDespacho = (TextView) findViewById(R.id.tvZonaDespacho);
        tvDescZonaDespacho = (TextView) findViewById(R.id.tvDescZonaDespacho);
        tvDescPaisSunat= (TextView) findViewById(R.id.tvDescPaisSunat);

        etDirCiudad = (EditText) findViewById(R.id.etDirCiudad);
        etDirDireccion = (EditText) findViewById(R.id.etDirDireccion);
        etDirMnz = (EditText) findViewById(R.id.etDirMnz);
        etDirLote = (EditText) findViewById(R.id.etDirLote);
        etDirNro = (EditText) findViewById(R.id.etDirNro);
        etDirInterior = (EditText) findViewById(R.id.etDirInterior);
        etDirSiglasPais = (EditText) findViewById(R.id.etDirSiglasPais);
        etDirReferencia = (EditText) findViewById(R.id.etDirReferencia);
        etDirUrbanizacion = (EditText) findViewById(R.id.etDirUrbanizacion);
        etDirCodPostal = (EditText) findViewById(R.id.etDirCodPostal);

        btnUbigeo = (Button) findViewById(R.id.btnUbigeo);
        btnDirSiglasPais = (Button) findViewById(R.id.btnDirSiglasPais);
        btnCodPaisSunat = (Button) findViewById(R.id.btnCodPaisSunat);
        btnZonaVenta = (Button) findViewById(R.id.btnZonaVenta);
        btnZonaDespacho = (Button) findViewById(R.id.btnZonaDespacho);
        btnAceptar = (Button) findViewById(R.id.btnAceptar);
        btnCancelar = (Button) findViewById(R.id.btnCancelar);

        //Uppercase
        etDirCiudad.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirDireccion.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirMnz.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirLote.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirNro.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirInterior.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirSiglasPais.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirReferencia.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirUrbanizacion.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        etDirCodPostal.setFilters(new InputFilter[]{new InputFilter.AllCaps()});



    }

    private void AsignarEventos() {
        btnCancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(ComprasAddDireccionActivity.this, ComprasProvClientesActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("codCliente", direccionSelected.getCodigo());
                intent.putExtras(bundle);

                UTIL.SonidoCampanilla(ComprasAddDireccionActivity.this);

                //MessageBox.AlertDialog("No se puede Modificar la proforma " + item.getNroProforma(),"Error",getContext() );
                startActivity(intent);
                finish();
            }
        });

        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ControlsToObject();
                new GrabarDireccionTask().execute();
            }
        });

        btnUbigeo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (spDescripcion.getSelectedItem() == null){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar una descripcion de la Direccion", true);

                    return;
                }

                if (spFlagUsos.getSelectedItem() == null){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar un Tipo de USO de la Direccion", true);

                    return;
                }

                new DialogSearchUbigeo(ComprasAddDireccionActivity.this.getWindow().getDecorView().findViewById(android.R.id.content) ).openDialog();
            }
        });

        btnZonaVenta.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (spDescripcion.getSelectedItem() == null){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar una descripcion de la Direccion", true);

                    return;
                }

                if (spFlagUsos.getSelectedItem() == null){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar un Tipo de USO de la Direccion", true);

                    return;
                }

                if (tvUbigeo.getText().toString() == null || tvUbigeo.getText().toString().isEmpty()){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar un UBIGEO de la Direccion", true);

                    return;
                }

                new DialogSearchZonaVenta(ComprasAddDireccionActivity.this.getWindow().getDecorView().findViewById(android.R.id.content) ).openDialog();
            }
        });

        btnZonaDespacho.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (spDescripcion.getSelectedItem() == null){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar una descripcion de la Direccion", true);

                    return;
                }

                if (spFlagUsos.getSelectedItem() == null){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar un Tipo de USO de la Direccion", true);

                    return;
                }

                if (tvUbigeo.getText().toString() == null || tvUbigeo.getText().toString().isEmpty()){

                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    MessageBox.AlertDialog(getBaseContext(), "Error", "Debe Seleccionar un UBIGEO de la Direccion", true);

                    return;
                }

                new DialogSearchZonaDespacho(ComprasAddDireccionActivity.this.getWindow().getDecorView().findViewById(android.R.id.content) ).openDialog();
            }
        });

    }

    private void LoadDataDefault() {

        ResetDatos();
        new LoadDataTask().execute();

    }

    private void ObjectToControls() {
        if (direccionSelected != null){
            codProveedor = direccionSelected.getCodigo();

            tvItemDireccion.setText(direccionSelected.getItemDireccion().toString());
            tvCodTienda.setText(direccionSelected.getCodTienda());
            tvLongitud.setText(UTIL.ConvetToString(direccionSelected.getLongitud(), "###,##0.00000000"));
            tvLatitud.setText(UTIL.ConvetToString(direccionSelected.getLatitud(), "###,##0.00000000"));
            tvUbigeo.setText(direccionSelected.getUbigeo());
            tvDirDepartamento.setText(direccionSelected.getDirDepartamento());
            tvDirProvincia.setText(direccionSelected.getDirProvincia());
            tvDirDistrito.setText(direccionSelected.getDirDistrito());
            tvZonaVenta.setText(direccionSelected.getZonaVenta());
            tvDescZonaVenta.setText(direccionSelected.getDescZonaVenta());
            tvCodPaisSunat.setText(direccionSelected.getCodPaisSunat());
            tvDescPaisSunat.setText(direccionSelected.getDescPaisSunat());
            tvDescZonaDespacho.setText(direccionSelected.getDescZonaDespacho());
            tvZonaDespacho.setText(direccionSelected.getZonaDespacho());

            etDirCiudad.setText(direccionSelected.getDirCiudad());
            etDirDireccion.setText(direccionSelected.getDirDireccion());
            etDirMnz.setText(direccionSelected.getDirMnz());
            etDirLote.setText(direccionSelected.getDirLote());
            etDirNro.setText(direccionSelected.getDirNumero());
            etDirInterior.setText(direccionSelected.getDirInterior());
            etDirSiglasPais.setText(direccionSelected.getDirSiglasPais());
            etDirReferencia.setText(direccionSelected.getDirReferencia());
            etDirCodPostal.setText(direccionSelected.getDirCodPostal());
            etDirUrbanizacion.setText(direccionSelected.getDirUrbanizacion());

            //Elemento de FlagUsos
            spFlagUsos.setSelection(BeanOpcion.getPos(listaFlagTipoUso, direccionSelected.getFlagUso()));
            spDescripcion.setSelection(BeanOpcion.getPos(listaDescripcion, direccionSelected.getDescripcion()));

        }
    }

    private void ControlsToObject() {
        BeanOpcion opcion = null;

        if (direccionSelected == null) {
            direccionSelected = new BeanDirecciones();
        }

        direccionSelected.setCodigo(codProveedor);

        if (tvItemDireccion.getText().toString() == null || tvItemDireccion.getText().toString().isEmpty()){
            direccionSelected.setItemDireccion(0);
        }else{
            direccionSelected.setItemDireccion(Integer.parseInt(tvItemDireccion.getText().toString()));
        }

        direccionSelected.setLongitud(Double.parseDouble(tvLongitud.getText().toString()));
        direccionSelected.setLatitud(Double.parseDouble(tvLatitud.getText().toString()));
        direccionSelected.setUbigeo(tvUbigeo.getText().toString());
        direccionSelected.setDirDepartamento(tvDirDepartamento.getText().toString());
        direccionSelected.setDirProvincia(tvDirProvincia.getText().toString());
        direccionSelected.setDirDistrito(tvDirDistrito.getText().toString());

        direccionSelected.setZonaVenta(tvZonaVenta.getText().toString());
        direccionSelected.setDescZonaVenta(tvDescZonaVenta.getText().toString());
        direccionSelected.setCodPaisSunat(tvCodPaisSunat.getText().toString());
        direccionSelected.setDescPaisSunat(tvDescPaisSunat.getText().toString());
        direccionSelected.setDescZonaDespacho(tvDescZonaDespacho.getText().toString());
        direccionSelected.setZonaDespacho(tvZonaDespacho.getText().toString());

        direccionSelected.setDirCiudad(etDirCiudad.getText().toString());
        direccionSelected.setDirDireccion(etDirDireccion.getText().toString());
        direccionSelected.setDirMnz(etDirMnz.getText().toString());
        direccionSelected.setDirLote(etDirLote.getText().toString());
        direccionSelected.setDirNumero(etDirNro.getText().toString());
        direccionSelected.setDirInterior(etDirInterior.getText().toString());
        direccionSelected.setDirSiglasPais(etDirSiglasPais.getText().toString());
        direccionSelected.setDirReferencia(etDirReferencia.getText().toString());
        direccionSelected.setDirCodPostal(etDirCodPostal.getText().toString());
        direccionSelected.setDirUrbanizacion(etDirUrbanizacion.getText().toString());

        opcion = (BeanOpcion)spFlagUsos.getSelectedItem();
        direccionSelected.setFlagUso(opcion.getCodigo());

        opcion = (BeanOpcion)spDescripcion.getSelectedItem();
        direccionSelected.setDescripcion(opcion.getDescripcion());


    }

    private void ResetDatos() {
        tvItemDireccion.setText("");
        tvCodTienda.setText("");
        tvLongitud.setText("0.00000000");
        tvLatitud.setText("0.00000000");
        tvUbigeo.setText("");
        tvDirDepartamento.setText("");
        tvDirProvincia.setText("");
        tvDirDistrito.setText("");
        tvZonaVenta.setText("");
        tvDescZonaVenta.setText("");
        tvZonaDespacho.setText("");
        tvDescZonaDespacho.setText("");

        etDirCiudad.setText("");
        etDirDireccion.setText("");
        etDirMnz.setText("");
        etDirLote.setText("");
        etDirNro.setText("");
        etDirInterior.setText("");
        etDirSiglasPais.setText("PE");
        etDirReferencia.setText("");
        etDirUrbanizacion.setText("");
        tvCodPaisSunat.setText("9589");
        tvDescPaisSunat.setText("PERU");


    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplDirecciones implDirecciones = null;
        private AlertDialog mDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog
                        .Builder(ComprasAddDireccionActivity.this)
                        .setMessage("Se esta buscando los tipos de Documento")
                        .create();
            mDialog.show();
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
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());
                listaDescripcion = implDirecciones.getDescDirecciones();
                listaFlagTipoUso = implDirecciones.getFlagUsos();
                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase LoadDataTask. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implDirecciones = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            ArrayAdapter<BeanOpcion> adapter = null;
            try {
                if (result) {
                    //asigno el Arrat de documentos
                    adapter = new ArrayAdapter<BeanOpcion>(ComprasAddDireccionActivity.this, R.layout.spinner_text, listaDescripcion);
                    adapter.setDropDownViewResource(R.layout.simple_spinner_dropdown);
                    spDescripcion.setAdapter(adapter);

                    adapter = new ArrayAdapter<BeanOpcion>(ComprasAddDireccionActivity.this, R.layout.spinner_text, listaFlagTipoUso);
                    adapter.setDropDownViewResource(R.layout.simple_spinner_dropdown);
                    spFlagUsos.setAdapter(adapter);

                    ObjectToControls();

                }else{
                    MessageBox.AlertDialog(ComprasAddDireccionActivity.this, "Error al cargar Datos Iniciales", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();

                } catch (Exception ex) {
                }

            }

        }

    }

    private class GrabarDireccionTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        private AlertDialog mDialog;
        private ImplDirecciones implDirecciones;
        BeanUsuario userLogin;



        protected void onPreExecute() {
            super.onPreExecute();
            mDialog = new SpotsDialog.Builder(ComprasAddDireccionActivity.this)
                            .setMessage("Espere un momento")
                            .create();
            mDialog.show();
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
                final GlobalClass globalVariable = (GlobalClass) getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                //LLenado de Lista para los articulos
                implDirecciones = new ImplDirecciones(ImplEmpresa.empresaDefault.getCodigo());
                implDirecciones.updateDireccion(direccionSelected);

                return true;

            } catch (Exception ex) {
                mensaje = "Error en Clase GrabarDireccionTask. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implDirecciones = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(ComprasAddDireccionActivity.this);
                    AlertDialog alertDialog = MessageBox.createAlertDialog(ComprasAddDireccionActivity.this, "Aviso", "Los datos se grabaron correctamente", true);

                    alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            Intent intent = new Intent(ComprasAddDireccionActivity.this, ComprasProvClientesActivity.class);
                            Bundle bundle = new Bundle();
                            bundle.putSerializable("codCliente", direccionSelected.getCodigo());
                            intent.putExtras(bundle);

                            UTIL.SonidoCampanilla(ComprasAddDireccionActivity.this);

                            //MessageBox.AlertDialog("No se puede Modificar la proforma " + item.getNroProforma(),"Error",getContext() );
                            startActivity(intent);
                            finish();
                        }
                    });

                    alertDialog.show();



                }else{
                    MessageBox.AlertDialog(ComprasAddDireccionActivity.this, "Error al cargar Tipos de Documentos", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    mDialog.dismiss();


                } catch (Exception ex) {
                }

            }

        }

    }
}