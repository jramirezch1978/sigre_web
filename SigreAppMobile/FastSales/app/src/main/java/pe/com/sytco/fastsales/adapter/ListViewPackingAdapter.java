package pe.com.sytco.fastsales.adapter;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.util.UTIL;

public class ListViewPackingAdapter extends ArrayAdapter<BeanCaja> {
    Context context;
    Activity _activity;

    //Controles para la interfaz
    TextView    tvCodigoCU, tvFecProduccion, tvUnd, tvSaldoUnd, tvUnd2, tvSaldoUnd2, tvAnaquel, tvFila,
                tvColumna, tvNroLote;
    ImageView ivImagen;
    Button btnDelete;

    public ListViewPackingAdapter(@NonNull Context context, int resource) {
        super(context, resource);
    }


    public ListViewPackingAdapter(Context context, List<BeanCaja> objects, Activity pActivity) {

        super(context, 0, objects);

        this.context = context;
        this._activity = pActivity;

        //Obtengo objeto ImplServerRemote de la clase global
        //implListadoCajas = UTIL.getGlobalClass(context).getListadoCajas();

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
            listItemView = inflater.inflate(R.layout.item_row_packing_list, parent, false);
        }

        //Obteniendo instancias de los elementos
        tvCodigoCU = (TextView)listItemView.findViewById(R.id.tvCodigoCU);
        tvFecProduccion = (TextView)listItemView.findViewById(R.id.tvFecProduccion);
        tvUnd = (TextView)listItemView.findViewById(R.id.tvUnd);
        tvSaldoUnd = (TextView)listItemView.findViewById(R.id.tvSaldoUnd);
        tvUnd2 = (TextView)listItemView.findViewById(R.id.tvUnd2);
        tvSaldoUnd2 = (TextView)listItemView.findViewById(R.id.tvSaldoUnd2);
        tvAnaquel = (TextView)listItemView.findViewById(R.id.tvAnaquel);
        tvFila = (TextView)listItemView.findViewById(R.id.tvFila);
        tvColumna = (TextView)listItemView.findViewById(R.id.tvColumna);
        tvNroLote = (TextView)listItemView.findViewById(R.id.tvNroLote);

        ivImagen = (ImageView)listItemView.findViewById(R.id.ivImagen);

        //Obteniendo instancia de la Tarea en la posicion actual
        final BeanCaja item = getItem(position);

        // Capture position and set to the TextViews
        tvCodigoCU.setText(item.getCodigoCU());
        tvFecProduccion.setText(UTIL.parseSqlDatetoString(item.getFecProduccion(), "dd/MM/yyyy"));
        tvUnd.setText(item.getUnd());
        tvUnd2.setText(item.getUnd2());
        tvSaldoUnd.setText(UTIL.ConvetToString(item.getSaldoUnd(), "###,##0.00"));
        tvSaldoUnd2.setText(UTIL.ConvetToString(item.getSaldoUnd2(), "###,##0.00"));
        tvAnaquel.setText(item.getAnaquel());
        tvFila.setText(item.getFila());
        tvColumna.setText(item.getColumna());
        tvNroLote.setText(item.getNroTrazabilidad());

        //Asignación de la imagen
        ivImagen.setImageResource(R.drawable.caja);

        //Adiciono el click
        ivImagen.setClickable(true);
        ivImagen.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                //MessageBox.AlertDialog("Ha hecho click en el detalle de articulos", "Aviso", context);
                //DialogArticuloDetails(item);
            }
        });

        btnDelete = (Button)listItemView.findViewById(R.id.btnDelete);

        //Agrego el evento click en el boton btnDelete
        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirmDeleteRow(item);
            }
        });


        return listItemView;
    }

    private void confirmDeleteRow(final BeanCaja item) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);

        builder.setMessage("¿Desea eliminar la CAJA " + item.getCodigoCU() + " del listado del PALLET?");
        builder.setTitle("Confirmacion");
        builder.setCancelable(false);

        builder.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                //ImplListadoCajas.deleteCaja(item);

                //if (_activity instanceof AlmacenTransferenciaPPTTActivity){
                //    ((AlmacenTransferenciaPPTTActivity) _activity).RefrescarCajas();
                //}

                dialog.cancel();
            }
        });
        builder.setNegativeButton("Cancelar", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
            }
        });

        builder.create();
        builder.show();
    }

}
