package pe.com.sytco.fastsales.adapter;

import android.app.ProgressDialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Activities.PedidoSession;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Dialog.DialogArticuloDetails;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanParametros;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 01/05/2016.
 */
public class ListViewArticulosAdapter extends ArrayAdapter<BeanArticulo> {
    // Declare Variables
    private PedidoSession pedidoSession;

    // Progress Dialog
    private ProgressDialog pDialog;

    ImplPedido implPedido;
    BeanUsuario userLogin;

    //Controles para el detalle de los articulos
    TextView tvDescArt, tvMarca, tvStock, tvPrecioVentaUnidad, tvPrecioVentaMayor, tvUnidad, tvMonedaMin, tvMonedaMay;
    ImageView ivImagen;

    public ListViewArticulosAdapter(PedidoSession value, List<BeanArticulo> objects) {
        super(value.getHostActivity(), 0, objects);

        pedidoSession = value;

        //Obtengo la clase Global
        GlobalClass globalClass = (GlobalClass) pedidoSession.getHostActivity().getApplicationContext();

        //Usuario Logueado
        userLogin = globalClass.getUserLogin();

        // Pedido de la pestaña activa
        implPedido = pedidoSession.getImplPedido();
        if (implPedido == null) {
            implPedido = globalClass.getImplPedido();
        }
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        //Obteniendo una instancia del inflater
        LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        //Salvando la referencia del View de la fila
        View listItemView = convertView;

        //Comprobando si el View no existe
        if (null == convertView) {
            //Si no existe, entonces inflarlo con image_list_view.xml
            listItemView = inflater.inflate(R.layout.item_row_articulo, parent, false);
        }

        InitialiteControllers(listItemView);
        
        //Obteniendo instancia de la Tarea en la posicion actual
        final BeanArticulo item = getItem(position);

        // Capture position and set to the TextViews
        tvDescArt.setText(item.getDescFullArticulo());
        tvMarca.setText(item.getMarca().getNomMarca());
        tvMonedaMin.setText(item.getMonedaVenta());
        tvMonedaMay.setText(item.getMonedaVenta());
        tvPrecioVentaUnidad.setText(UTIL.ConvetToString(item.getPrecioVtaUnidad(), "###,##0.00"));
        tvPrecioVentaMayor.setText(UTIL.ConvetToString(item.getPrecioVtaMayor(), "###,##0.00"));
        tvStock.setText(UTIL.ConvetToString(item.getSaldoTotal(), "###,##0.00"));
        tvUnidad.setText(item.getUnd());

        //Asignación de la imagen
        if (item.getImagen() != null)
            UTIL.setImageViewWithByteArray(ivImagen, item.getImagen());
        else
            ivImagen.setImageResource(R.drawable.noimagen);

        //Adiciono el click
        ivImagen.setClickable(true);
        ivImagen.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                //MessageBox.AlertDialog("Ha hecho click en el detalle de articulos", "Aviso", context);
                new DialogArticuloDetails(pedidoSession.getHostActivity()).openDialog(item);
            }
        });


        return listItemView;
    }

    private void InitialiteControllers(View listItemView) {
        //Obteniendo instancias de los elementos
        tvDescArt = (TextView)listItemView.findViewById(R.id.tvDescArt);
        tvMarca = (TextView)listItemView.findViewById(R.id.tvMarca);
        tvMonedaMin = (TextView)listItemView.findViewById(R.id.tvMonedaMin);
        tvMonedaMay = (TextView)listItemView.findViewById(R.id.tvMonedaMay);
        tvPrecioVentaUnidad = (TextView)listItemView.findViewById(R.id.tvPrecioVentaUnidad);
        tvPrecioVentaMayor = (TextView)listItemView.findViewById(R.id.tvPrecioVentaMayor);
        tvMonedaMin = (TextView)listItemView.findViewById(R.id.tvMonedaMin);
        tvMonedaMay = (TextView)listItemView.findViewById(R.id.tvMonedaMay);
        tvUnidad = (TextView)listItemView.findViewById(R.id.tvUnidad);
        tvStock = (TextView)listItemView.findViewById(R.id.tvStock);

        ivImagen = (ImageView)listItemView.findViewById(R.id.ivImagen);

        //Oculto lo controles que no deben mostrarse
        if (ImplEmpresa.beanParametros.getShowPrecioMay().equals("0")){
            tvPrecioVentaMayor.setVisibility(View.GONE);
            tvMonedaMay.setVisibility(View.GONE);
        }else{
            tvPrecioVentaMayor.setVisibility(View.VISIBLE);
            tvMonedaMay.setVisibility(View.VISIBLE);
        }

        if (ImplEmpresa.beanParametros.getShowPrecioMin().equals("0")){
            tvPrecioVentaUnidad.setVisibility(View.GONE);
            tvMonedaMin.setVisibility(View.GONE);
        }else{
            tvPrecioVentaUnidad.setVisibility(View.VISIBLE);
            tvMonedaMin.setVisibility(View.VISIBLE);
        }
    }

}
