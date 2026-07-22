package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.graphics.Color;
import android.os.AsyncTask;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.PedidoSession;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.PedidoUI;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanParametros;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanPreciosArticulo;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.Compras.BeanArticuloUnd;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ValidInputHelper;

public class DialogAddPedido extends DialogAncestor {


    //Controles interfaz
    TextView tvFlagAfectoIGV, tvPorcIGV, tvICBPER, tvMoneda, tvTituloArticulo;
    EditText etCantidad;
    RadioGroup rgAlmacen;
    Spinner spTipoPrecio, spUnidad;
    CheckBox cbEntregaBolsa = null;
    BeanAlmacen almacenSelected;
    Button btnAceptar, btnCancelar;
    LinearLayout llICBPER;

    //VAriables para la logica de negocio
    private ImplPedido implPedido = null;
    private BeanUsuario userLogin = null;
    List<BeanAlmacen> almacenes;
    List<BeanArticuloUnd> articuloUnds;
    BeanArticulo articuloSelected = null;

    //Parametros para el calculo
    private String _FlagBolsaPlastica = "0";
    private PedidoUI pedidoUI = null;
    private PedidoSession session = null;

    public DialogAddPedido(PedidoSession value) {
        this.session = value;
        this.context = value.getHostActivity();
        implPedido = value.getImplPedido();
        userLogin = value.getUserLogin();
        pedidoUI = value.getPedidoUI();
    }

    public void openDialog(BeanArticulo value) {

        this.articuloSelected = value;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_add_pedido, null);

        InitControllers();

        AsignarEventos();

        builder.setView(dialogLayout);

        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();

        //Activo la opcion de cierre
        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );

        LoadData();

    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        //Obtengo referencia al RadioGroup que voy a necesitar despues
        rgAlmacen = (RadioGroup) dialogLayout.findViewById(R.id.rgAlmacen);
        cbEntregaBolsa = (CheckBox) dialogLayout.findViewById(R.id.cbEntregaBolsa);
        tvFlagAfectoIGV = (TextView) dialogLayout.findViewById(R.id.tvFlagAfectoIGV);
        tvPorcIGV = (TextView) dialogLayout.findViewById(R.id.tvPorcIGV);
        tvICBPER = (TextView) dialogLayout.findViewById(R.id.tvICBPER);
        tvMoneda = (TextView) dialogLayout.findViewById(R.id.tvMoneda);
        tvTituloArticulo = (TextView) dialogLayout.findViewById(R.id.tvTituloArticulo);
        spTipoPrecio = (Spinner) dialogLayout.findViewById(R.id.spTipoPrecio);
        spUnidad = (Spinner) dialogLayout.findViewById(R.id.spUnidad);

        llICBPER = (LinearLayout) dialogLayout.findViewById(R.id.llICBPER);

        btnAceptar = (Button) dialogLayout.findViewById(R.id.btnAceptar);
        btnCancelar = (Button) dialogLayout.findViewById(R.id.btnCancelar);

        if (tvTituloArticulo != null && articuloSelected != null) {
            String cod = articuloSelected.getCodArt() != null ? articuloSelected.getCodArt() : "";
            String desc = articuloSelected.getDescArticulo() != null
                    ? articuloSelected.getDescArticulo() : "";
            tvTituloArticulo.setText(cod + " · " + desc);
        }
    }

    @Override
    protected void AsignarEventos() {
        super.AsignarEventos();

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        clickAceptarDialogAddPedido(v);

                    }
                }

        );

        cbEntregaBolsa.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    tvICBPER.setText(UTIL.ConvetToString(ImplEmpresa.beanParametros.getICBPER(), "###,##0.00"));
                }else{
                    tvICBPER.setText("0.00");
                }
            }
        });
    }

    @Override
    public void LoadData() {
        super.LoadData();


        //Evito que el radio Button Ordene
        tvPorcIGV.setText("0.00");
        tvMoneda.setText(ImplEmpresa.beanParametros.getSoles());
        cbEntregaBolsa.setChecked(false);

        if (ImplEmpresa.beanParametros.getShowICBPER().equals("0"))
            llICBPER.setVisibility(View.GONE);
        else
            llICBPER.setVisibility(View.VISIBLE);

        new LoadDataTask().execute();
    }



    private void clickAceptarDialogAddPedido(View v) {
        try{
            //Variables para procesar
            Double ldbl_Cantidad, ldbl_PorcIGV, ldbl_ImporteIGV, ldbl_BaseImponible, ldbl_ICBPER, ldbl_PrecioVenta;
            String lsUnd;

            //Valido que hayas ingresado una cantidad
            if (etCantidad.getText().toString().trim().isEmpty()) {
                MessageBox.AlertDialog("Debe ingresar una cantidad valida, por favor verifque!", "Ingreso de Cantidad", context);
                etCantidad.requestFocus();
                return;
            }

            if (Double.parseDouble(etCantidad.getText().toString().trim()) == 0.0) {
                MessageBox.AlertDialog("La cantidad debe ser mayor que cero, por favor verifque!", "Ingreso de Cantidad", context);
                etCantidad.requestFocus();
                return;
            }

            //Cantidad por defecto
            ldbl_Cantidad = Double.parseDouble(etCantidad.getText().toString());

            if (ldbl_Cantidad > almacenSelected.getSaldoTotal() && ImplEmpresa.beanParametros.getValidarSotck().equals("1")){
                MessageBox.AlertDialog("Mensaje de advertencia", "La cantidad de salida no puede ser mayor al stock actual", context);
                return;
            }

            //Obtengo la Unidad
            BeanArticuloUnd und = (BeanArticuloUnd) spUnidad.getSelectedItem();
            if (und == null){
                MessageBox.AlertDialog("Mensaje de advertencia", "Debe Seleccionar una UNIDAD, por favor verifique!", context);
                return;
            }

            //Obtengo el Precio de Venta
            BeanPreciosArticulo tipoPrecio = (BeanPreciosArticulo)spTipoPrecio.getSelectedItem();

            if (tipoPrecio == null){
                MessageBox.AlertDialog("Mensaje de advertencia", "Debe Seleccionar un Precio del articulo, por favor verifique!", context);
                return;
            }

            if (tipoPrecio.getPrecio() == 0 && !articuloSelected.getCodClase().trim().equals(ImplEmpresa.beanParametros.getClaseBonif().trim())){
                MessageBox.AlertDialog("Mensaje de advertencia", "El ARTCULO debe tener un precio mayor que CERO, por favor verifique!", context);
                return;
            }

            ldbl_PrecioVenta = tipoPrecio.getPrecio();

            //Los articulos de bonificacion no deben de tener IGV
            if (articuloSelected.getFlagAfectoIGV().equals("1") && !articuloSelected.getCodClase().trim().equals(ImplEmpresa.beanParametros.getClaseBonif().trim())) {
                //El precio unitario ya incluye el IGV
                ldbl_PorcIGV = Double.valueOf(tvPorcIGV.getText().toString());

                ldbl_BaseImponible = UTIL.redondearDecimales(ldbl_PrecioVenta / (1 + ldbl_PorcIGV / 100), 8);
                ldbl_ImporteIGV = ldbl_PrecioVenta - ldbl_BaseImponible;

            }else{
                ldbl_PorcIGV = 0.00;

                ldbl_BaseImponible = UTIL.redondearDecimales(ldbl_PrecioVenta, 8);
                ldbl_ImporteIGV = 0.00;
            }

            //Si tiene Flag de bolsa Plastica
            if(cbEntregaBolsa.isChecked()){
                _FlagBolsaPlastica = "1";
                ldbl_ICBPER = Double.parseDouble(tvICBPER.getText().toString());
            }else{
                _FlagBolsaPlastica = "0";
                ldbl_ICBPER = 0.00;
            }

            //Inserto el pedido con la cantidad
            implPedido.InsertDetail(articuloSelected,
                                    almacenSelected,
                                    ldbl_Cantidad,
                                    und,
                                    ldbl_BaseImponible,
                                    ldbl_PorcIGV,
                                    ldbl_ImporteIGV,
                                    _FlagBolsaPlastica,
                                    ldbl_ICBPER,
                                    articuloSelected.getFlagAfectoIGV(),
                                    userLogin);

            pedidoUI.drawDetailPedido(implPedido);
            if (session != null) {
                session.persistCache();
                session.notifyPedidoChanged();
            }
            dialogMain.dismiss();

        }catch (Exception ex){
            MessageBox.AlertDialog("Error al insertar detalle en el pedido: " + ex.getMessage(), "Error al insertar", context);
        }

    }


    //Esta Clase interna es para llenar el almacen
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        private RadioButton newRadioButton;
        private ProgressDialog pDialog;


        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Consultando datos, puede demorar un momento. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            //Variables
            ImplAlmacen implAlmacen = null;
            ImplArticulo implArticulo = null;

            try {

                //Creo el almacen
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());

                almacenes = implAlmacen.getAlmacenByArticulo(articuloSelected.getCodArt(), userLogin.getUsuario());
                articuloUnds = implArticulo.getUndByCodArticulo(articuloSelected.getCodArt());

                return true;

            } catch (Exception ex) {
                ex.printStackTrace();
                mensaje = "Ha ocurrido una exception al recuperar datos necesarios. Error: " + ex.getMessage();
                return false;

            } finally {
                implAlmacen = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            postDialogAddPedido(result);
        }

        private void postDialogAddPedido(Boolean result) {
            Integer li = 1, li_index;
            try{
                etCantidad = (EditText) dialogLayout.findViewById(R.id.etCantidad);
                ValidInputHelper.bindEditText(etCantidad, ValidInputHelper.positiveNumber());

                LinearLayout.LayoutParams layoutParams = new RadioGroup.LayoutParams(
                        RadioGroup.LayoutParams.WRAP_CONTENT,
                        RadioGroup.LayoutParams.WRAP_CONTENT);

                if (result) {
                    //Si no hay almacenes entonces ya no hay stock de dicho producto en ningun almacén
                    if (almacenes.size() == 0){
                        MessageBox.AlertDialog("El Articulo " + articuloSelected.getDescArticulo() + " no tiene ningun almacen disponible. Por favor verifique!!!",
                                "Aviso de Stock de almacén", context);
                        return;
                    }

                    if (articuloUnds.size() == 0){
                        MessageBox.AlertDialog("El Articulo " + articuloSelected.getCodArt() + "-" + articuloSelected.getDescArticulo() + " no tiene ningun unidades para asignar. Por favor verifique!!!",
                                "Aviso de Stock de almacén", context);
                        return;
                    }
                    pDialog.setMessage("Datos Obtenidos, preparando las opciones. Por favor espere...");

                    //Creo losa radiobuttons por almacen
                    for (final BeanAlmacen objAlmacen : almacenes) {
                        newRadioButton = new RadioButton(context);
                        newRadioButton.setText(objAlmacen.getDescAlmacen() + "  ·  STOCK: "
                                + UTIL.ConvetToString(objAlmacen.getSaldoTotal(), "###,##0")
                                + " " + articuloSelected.getUnd());
                        newRadioButton.setId(100 + li);
                        newRadioButton.setTextColor(Color.parseColor("#37474F"));
                        newRadioButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);


                        //Asigno un evento Listener click para cuando se haga click
                        newRadioButton.setOnClickListener(new View.OnClickListener() {
                            public void onClick(View v) {
                                almacenSelected = objAlmacen;
                            }
                        });

                        if (li == 1) {
                            newRadioButton.setChecked(true);
                            almacenSelected = objAlmacen;
                        }

                        rgAlmacen.addView(newRadioButton, li - 1, layoutParams);

                        li++;

                    }

                    //Creo el arreglo de los precios
                    List<BeanPreciosArticulo> preciosArticulos = new ArrayList<BeanPreciosArticulo>();

                    if (articuloSelected.getPrecioVtaUnidad() > 0 && ImplEmpresa.beanParametros.getShowPrecioMin().equals("1")) {
                        preciosArticulos.add(new BeanPreciosArticulo("Precio Unitario", articuloSelected.getPrecioVtaUnidad()));
                    }

                    if (articuloSelected.getPrecioVtaMayor() > 0 && ImplEmpresa.beanParametros.getShowPrecioMay().equals("1")) {
                        preciosArticulos.add(new BeanPreciosArticulo("Precio Mayorista", articuloSelected.getPrecioVtaMayor()));
                    }

                    if (articuloSelected.getPrecioVtaOferta() > 0 && ImplEmpresa.beanParametros.getShowPrecioMin().equals("1")) {
                        preciosArticulos.add(new BeanPreciosArticulo("Precio Oferta", articuloSelected.getPrecioVtaOferta()));
                    }

                    if(preciosArticulos.size() == 0 && articuloSelected.getCodClase().trim().equals(ImplEmpresa.beanParametros.getClaseBonif().trim())){
                        preciosArticulos.add(new BeanPreciosArticulo("Precio Bonificacion", 0.00));
                    }

                    ArrayAdapter<BeanPreciosArticulo> preciosArticuloArrayAdapter = new ArrayAdapter<BeanPreciosArticulo>(context,
                            R.layout.spinner_text, preciosArticulos);
                    preciosArticuloArrayAdapter.setDropDownViewResource(R.layout.simple_spinner_dropdown);
                    spTipoPrecio.setAdapter(preciosArticuloArrayAdapter);


                    //Indico si esta afecto o no a IGV
                    if(articuloSelected.getFlagAfectoIGV().equals("1")){
                        tvFlagAfectoIGV.setText("AFECTO");
                        tvPorcIGV.setText(UTIL.ConvetToString(ImplEmpresa.beanParametros.getPorcIGV(), "0.00"));
                    }else if(articuloSelected.getFlagAfectoIGV().equals("2")){
                        tvFlagAfectoIGV.setText("INAFECTO");
                        tvPorcIGV.setText("0.00");
                    }else if(articuloSelected.getFlagAfectoIGV().equals("3")) {
                        tvFlagAfectoIGV.setText("EXONERADO");
                        tvPorcIGV.setText("0.00");
                    }else if(articuloSelected.getFlagAfectoIGV().equals("4")) {
                        tvFlagAfectoIGV.setText("EXPORTACION");
                        tvPorcIGV.setText("0.00");
                    }else if(articuloSelected.getFlagAfectoIGV().equals("0")) {
                        tvFlagAfectoIGV.setText("GRATUITO - NO ONEROSO");
                        tvPorcIGV.setText("0.00");
                    }

                    //Indico la unidad para el articulo
                    ArrayAdapter<BeanArticuloUnd> undArrayAdapter = new ArrayAdapter<BeanArticuloUnd>(context,
                            R.layout.spinner_text, articuloUnds);
                    undArrayAdapter.setDropDownViewResource(R.layout.simple_spinner_dropdown);
                    spUnidad.setAdapter(undArrayAdapter);

                    //Muetro el Cuadro de Dialogo
                    dialogMain.show();


                } else {
                    //Ha ocurrido un error y debo mostrarlo
                    MessageBox.AlertDialog(mensaje, "Error", context);
                }


            }catch(Exception ex){
                ex.printStackTrace();
                MessageBox.AlertDialog("Ha ocurrido una exception: " + ex.getMessage(), "Error", context);
            }finally{
                // dismiss the dialog after getting all products
                pDialog.dismiss();
            }

        }




    }

}
