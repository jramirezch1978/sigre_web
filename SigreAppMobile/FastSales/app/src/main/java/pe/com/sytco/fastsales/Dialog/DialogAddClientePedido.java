package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

import pe.com.sytco.fastsales.Activities.PedidoSession;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchCliente;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchDireccionCliente;
import pe.com.sytco.fastsales.Dialog.Search.DialogSearchUbigeo;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanParametros;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ValidInputHelper;

public class DialogAddClientePedido extends DialogAncestor {

    //VAriables para la logica de negocio
    private ImplPedido implPedido = null;
    private BeanUsuario userLogin = null;

    //Interfaz
    TextView tvDescUbigeo, tvRazonSocial,tvDireccion, tvUbigeo, tvCliente, tvItemDireccion;
    Button btnAceptar, btnCerrar, btnUbigeo, btnCliente, btnDireccion, btnAddDireccion;

    //VAriables
    String flagFacturaBoleta;

    private PedidoSession session = null;

    public DialogAddClientePedido(PedidoSession value) {
        this.session = value;
        this.context = value.getHostActivity();
        implPedido = value.getImplPedido();
        userLogin = value.getUserLogin();
        flagFacturaBoleta = implPedido.getCabecera().getFlagBoletaFactura();
    }

    public void openDialog() {

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_add_cliente_pedido, null);

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

    @Override
    protected void InitControllers() {
        super.InitControllers();

        //Obtengo referencia al RadioGroup que voy a necesitar despues
        tvUbigeo = (TextView) dialogLayout.findViewById(R.id.tvUbigeo);
        tvCliente = (TextView) dialogLayout.findViewById(R.id.tvCliente);
        tvItemDireccion = (TextView) dialogLayout.findViewById(R.id.tvItemDireccion);
        tvDescUbigeo = (TextView) dialogLayout.findViewById(R.id.tvDescUbigeo);
        tvRazonSocial = (TextView) dialogLayout.findViewById(R.id.tvRazonSocial);
        tvDireccion = (TextView) dialogLayout.findViewById(R.id.tvDireccion);

        btnAceptar = (Button) dialogLayout.findViewById(R.id.btnAceptar);
        btnCerrar = (Button) dialogLayout.findViewById(R.id.btnCerrar);
        btnUbigeo = (Button) dialogLayout.findViewById(R.id.btnUbigeo);
        btnCliente = (Button) dialogLayout.findViewById(R.id.btnCliente);
        btnDireccion = (Button) dialogLayout.findViewById(R.id.btnDireccion);
        btnAddDireccion = (Button) dialogLayout.findViewById(R.id.btnAddDireccion);
    }

    @Override
    public void LoadData() {
        super.LoadData();

        tvUbigeo.setText("");
        tvCliente.setText("");
        tvItemDireccion.setText("");

        tvDescUbigeo.setText("");
        tvRazonSocial.setText("");
        tvDireccion.setText("");

        if (implPedido.getCabecera().getUbigeo() != null && !implPedido.getCabecera().getUbigeo().isEmpty()){
            tvUbigeo.setText(implPedido.getCabecera().getUbigeo());
        }

        if (implPedido.getCabecera().getDescUbigeo() != null && !implPedido.getCabecera().getDescUbigeo().isEmpty()){
            tvDescUbigeo.setText(implPedido.getCabecera().getDescUbigeo());
        }

        if (implPedido.getCabecera().getCliente() != null && !implPedido.getCabecera().getCliente().isEmpty()){
            tvCliente.setText(implPedido.getCabecera().getCliente());
        }

        if (implPedido.getCabecera().getNomCliente() != null && !implPedido.getCabecera().getNomCliente().isEmpty()){
            tvRazonSocial.setText(implPedido.getCabecera().getNomCliente());
        }

        if (implPedido.getCabecera().getItemDireccion() != null && implPedido.getCabecera().getItemDireccion() > 0){
            tvItemDireccion.setText(implPedido.getCabecera().getItemDireccion().toString());
        }

        if (implPedido.getCabecera().getDireccion() != null && !implPedido.getCabecera().getDireccion().isEmpty()){
            tvDireccion.setText(implPedido.getCabecera().getDireccion());
        }

        refreshInputChecks();

        //Muetro el Cuadro de Dialogo
        dialogMain.show();
    }

    private void refreshInputChecks() {
        ValidInputHelper.Rule filled = ValidInputHelper.notBlank();
        ValidInputHelper.refreshDisplay(tvUbigeo, filled);
        ValidInputHelper.refreshDisplay(tvCliente, filled);
        ValidInputHelper.refreshDisplay(tvRazonSocial, filled);
        ValidInputHelper.refreshDisplay(tvDireccion, filled);
        ValidInputHelper.refreshDisplay(tvItemDireccion, filled);
        ValidInputHelper.refreshDisplay(tvDescUbigeo, filled);
    }

    @Override
    protected void AsignarEventos() {
        super.AsignarEventos();

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        AsignaClienteToPedido(v);

                    }
                }

        );

        btnUbigeo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new DialogSearchUbigeo(dialogLayout).openDialog();
            }
        });

        btnCliente.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String lsUbigeo = tvUbigeo.getText().toString();

                if (lsUbigeo == null || lsUbigeo.isEmpty() ){
                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(context);
                    MessageBox.AlertDialog(context, "Error", "Debe Seleccionar primero un UBIGEO", true);

                    return;
                }

                new DialogSearchCliente(dialogLayout).openDialog(implPedido.getCabecera().getFlagBoletaFactura(), lsUbigeo);
            }
        });

        btnDireccion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String lsUbigeo = tvUbigeo.getText().toString();
                String lsCliente = tvCliente.getText().toString();

                if (lsUbigeo == null || lsUbigeo.isEmpty() ){
                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(context);
                    MessageBox.AlertDialog(context, "Error", "Debe Seleccionar primero un UBIGEO, por favor verifique!", true);
                    tvUbigeo.requestFocus();
                    return;
                }
                if (lsCliente == null || lsCliente.isEmpty() ){
                    //Obtengo el almacen Origen
                    UTIL.SonidoCorrecto(context);
                    MessageBox.AlertDialog(context, "Error", "Debe Seleccionar primero un CLIENTE, por favor verifique!", true);
                    tvCliente.requestFocus();
                    return;
                }

                new DialogSearchDireccionCliente(dialogLayout).openDialog(lsCliente, lsUbigeo);
            }
        });


    }

    private void AsignaClienteToPedido(View v) {
        String lsUbigeo = tvUbigeo.getText().toString();
        String lsCliente = tvCliente.getText().toString();
        String lsFlagTranfGratuita = "0";
        Integer liItemDireccion = null;

        if (tvItemDireccion.getText() != null && !tvItemDireccion.getText().toString().trim().equals(""))
            liItemDireccion = Integer.parseInt(tvItemDireccion.getText().toString());

        if (lsUbigeo == null || lsUbigeo.isEmpty() ){
            //Obtengo el almacen Origen
            UTIL.SonidoCorrecto(context);
            MessageBox.AlertDialog(context, "Error", "Debe Seleccionar primero un UBIGEO", true);

            return;
        }

        if (lsCliente == null || lsCliente.isEmpty() ){
            //Obtengo el almacen Origen
            UTIL.SonidoCorrecto(context);
            MessageBox.AlertDialog(context, "Error", "Debe Seleccionar primero un CLIENTE", true);

            return;
        }

        if (liItemDireccion == null || liItemDireccion == 0 ){
            //Obtengo el almacen Origen
            UTIL.SonidoCorrecto(context);
            MessageBox.AlertDialog(context, "Error", "Debe Seleccionar primero una Direccion del Cliente", true);

            return;
        }

        lsFlagTranfGratuita = "0";


        //Ahora relleno el Pedido
        implPedido.getCabecera().setCliente(lsCliente);
        implPedido.getCabecera().setItemDireccion(liItemDireccion);
        implPedido.getCabecera().setFlagTranfGratuita(lsFlagTranfGratuita);

        if (session != null) {
            session.persistCache();
            session.notifyPedidoChanged();
            session.SavePedido();
        }

        dialogMain.dismiss();
    }
}
