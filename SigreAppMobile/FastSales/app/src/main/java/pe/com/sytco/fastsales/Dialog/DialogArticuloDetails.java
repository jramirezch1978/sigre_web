package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogArticuloDetails extends DialogAncestor {
    TextView tvCodArt, tvDescArt, tvMarca, tvStock, tvPrecioVentaUnidad, tvPrecioVentaMayor, tvMoneda, tvUnidad;
    ImageView ivImagen;
    Button btnCerrar;

    public DialogArticuloDetails(Context value) {
        this.context = value;
    }

    public void openDialog(BeanAncestor value) {

        this.bean = value;

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_articulo_details, null);

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

        dialogMain.show();


    }

    @Override
    protected void InitControllers() {
        super.InitControllers();

        //Obtengo referencia a los controles del Dialog
        tvCodArt= (TextView) dialogLayout.findViewById(R.id.tvCodArt);
        tvDescArt = (TextView) dialogLayout.findViewById(R.id.tvDescArt);
        tvMarca = (TextView) dialogLayout.findViewById(R.id.tvMarca);
        tvMoneda = (TextView) dialogLayout.findViewById(R.id.tvMoneda);
        tvPrecioVentaUnidad = (TextView) dialogLayout.findViewById(R.id.tvPrecioVentaUnidad);
        tvPrecioVentaMayor = (TextView) dialogLayout.findViewById(R.id.tvPrecioVentaMayor);
        tvUnidad = (TextView) dialogLayout.findViewById(R.id.tvUnidad);
        tvStock = (TextView) dialogLayout.findViewById(R.id.tvStock);
        btnCerrar = (Button) dialogLayout.findViewById(R.id.btnCerrar);
        ivImagen= (ImageView) dialogLayout.findViewById(R.id.ivImagen);
    }

    @Override
    public void LoadData() {
        super.LoadData();

        BeanArticulo articulo = (BeanArticulo) bean;

        //Asigno la data necesaria
        tvCodArt.setText(articulo.getCodArt());
        tvDescArt.setText(articulo.getDescArticulo());
        tvMarca.setText(articulo.getMarca().getNomMarca());
        tvStock.setText(UTIL.ConvetToString(articulo.getSaldoTotal(), "###,##0.00"));
        tvPrecioVentaUnidad.setText(UTIL.ConvetToString(articulo.getPrecioVtaUnidad(), "###,##0.00"));
        tvPrecioVentaMayor.setText(UTIL.ConvetToString(articulo.getPrecioVtaMayor(), "###,##0.00"));

        //Asignación de la imagen
        if (articulo.getImagen() != null)
            UTIL.setImageViewWithByteArray(ivImagen, articulo.getImagen());
        else
            ivImagen.setImageResource(R.drawable.noimagen);
    }
}
