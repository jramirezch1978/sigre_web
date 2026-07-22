package pe.com.sytco.fastsales.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanEmpresa;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 12/11/2017.
 */
public class ListViewEmpresasAdapter extends ArrayAdapter<BeanEmpresa> {
    private Context context;
    private ImplEmpresa implEmpresa;
    private Boolean showDeleteButton = false;

    private TextView tvRazonSocial, tvCodigo, tvNroDocIdentidad, tvAmbienteProd, tvAmbienteTest;
    private Button btnDelete;
    private ImageView ivDefault;

    public ListViewEmpresasAdapter(Context value, List<BeanEmpresa> objects) {

        super(value, 0, objects);

        this.context = value;

        //Obtengo objeto ImplServerRemote de la clase global
        implEmpresa = UTIL.getGlobalClass(context).getImplEmpresa();

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
            listItemView = inflater.inflate(R.layout.item_row_empresa, parent, false);
        }

        //Obteniendo instancias de los elementos
        tvRazonSocial = (TextView)listItemView.findViewById(R.id.tvRazonSocial);
        tvCodigo = (TextView)listItemView.findViewById(R.id.tvCodigo);
        tvNroDocIdentidad = (TextView)listItemView.findViewById(R.id.tvNroDocIdentidad);
        tvAmbienteProd = (TextView)listItemView.findViewById(R.id.tvAmbienteProd);
        tvAmbienteTest = (TextView)listItemView.findViewById(R.id.tvAmbienteTest);

        ivDefault = (ImageView)listItemView.findViewById(R.id.ivDefault);
        btnDelete = (Button)listItemView.findViewById(R.id.btnDelete);


        //Obteniendo instancia de la Tarea en la posicion actual
        RowInControles(position);

        return listItemView;
    }

    private void RowInControles(int position) {
        final BeanEmpresa item = getItem(position);

        // Capture position and set to the TextViews
        tvRazonSocial.setText(item.getRazonSocial());
        tvCodigo.setText(item.getCodigo());
        tvNroDocIdentidad.setText(item.getTipoDocIdentidad() + "-" + item.getNroDocIdentidad());

        if (item.isProdEnvironment())
            tvAmbienteProd.setText("PRODUCTION (Si)");
        else
            tvAmbienteProd.setText("PRODUCTION (No)");

        if (item.isTestEnvironment())
            tvAmbienteProd.setText("TEST (No)");
        else
            tvAmbienteProd.setText("TEST (No)");

        if (this.showDeleteButton)
            btnDelete.setVisibility(View.VISIBLE);
        else
            btnDelete.setVisibility(View.GONE);

        //La Imagen
        BeanEmpresa empresa = ImplEmpresa.empresaDefault;

        if (empresa == null){
            ivDefault.setImageResource(R.drawable.fail);
        }else{
            if (empresa.getCodigo().toUpperCase().equals((item.getCodigo().toUpperCase()))){
                ivDefault.setImageResource(R.drawable.exito);
            }else{
                ivDefault.setImageResource(R.drawable.fail);
            }
        }


    }

    public Boolean getShowDeleteButton() {
        return showDeleteButton;
    }

    public void setShowDeleteButton(Boolean showDeleteButton) {
        this.showDeleteButton = showDeleteButton;
    }
}
