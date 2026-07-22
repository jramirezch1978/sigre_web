package pe.com.sytco.fastsales.adapter;

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

import java.util.List;

import pe.com.sytco.fastsales.Activities.ServerRemoteActivity;
import pe.com.sytco.fastsales.Controller.ImplServerRemote;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 05/11/2017.
 */
public class ListViewServersAdapter extends ArrayAdapter<BeanServerRemote> {
    Context context;
    ServerRemoteActivity activity;

    //Controles
    TextView tvNameServer, tvHostIP, tvProtocolo, tvPort;
    ImageView ivDefault;
    Button btnDelete;

    //Objeto ImplServidor
    ImplServerRemote implServerRemote;

    public ListViewServersAdapter(Context value, List<BeanServerRemote> objects, ServerRemoteActivity pActivity) {

        super(value, 0, objects);

        this.context = value;
        this.activity = pActivity;

        //Obtengo objeto ImplServerRemote de la clase global
        implServerRemote = UTIL.getGlobalClass(context).getImplServerRemote();

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
            listItemView = inflater.inflate(R.layout.item_row_server_remote, parent, false);
        }

        //Obteniendo instancias de los elementos
        tvNameServer = (TextView)listItemView.findViewById(R.id.tvNameServer);
        tvHostIP = (TextView)listItemView.findViewById(R.id.tvHostIP);
        tvProtocolo = (TextView)listItemView.findViewById(R.id.tvProtocolo);
        tvPort = (TextView)listItemView.findViewById(R.id.tvPort);
        ivDefault = (ImageView)listItemView.findViewById(R.id.ivDefault);
        btnDelete = (Button)listItemView.findViewById(R.id.btnDelete);

        //Obteniendo instancia de la Tarea en la posicion actual
        final BeanServerRemote item = getItem(position);

        // Capture position and set to the TextViews
        tvNameServer.setText(item.getNombre());
        tvHostIP.setText(item.getHostIP());
        tvProtocolo.setText(item.getProtocolo());
        tvPort.setText(item.getPort());

        //Asignación de la imagen Default
        setImageDefault(item);

        //Adiciono el click a la imagen
        ivDefault.setClickable(true);
        ivDefault.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                //MessageBox.AlertDialog("Ha hecho click en la imagen del Servidor", "Aviso", context);
                if (item.getFlagDefault().equals("0")) {
                    //Valido si hay otro servidor por defecto
                    /*
                    if (implServerRemote.ExisteServerDefault()){
                        MessageBox.AlertDialog(context, "Error", "Ya existe un servidor por defecto, por favor verifique!", false);
                        return;
                    }
                    */
                    // Coloco todos los servidores en default = '0'
                    for(BeanServerRemote server : implServerRemote.getServers()){
                        server.setFlagDefault("0");
                    }
                    item.setFlagDefault("1");
                } else {
                    item.setFlagDefault("0");
                }
                activity.setUpdate(true);
                //setImageDefault(item);
                activity.ListarServidores();

            }
        });

        //Agrego el evento click en el boton btnDelete
        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirmDeleteRow(item);
            }
        });


        return listItemView;
    }

    private void confirmDeleteRow(final BeanServerRemote item) {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);

        builder.setMessage("¿Desea eliminar la configuracion del Servidor Remoto " + item.getNombre() + "?");
        builder.setTitle("Confirmacion");
        builder.setCancelable(false);

        builder.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                implServerRemote.deleteServer(item);
                activity.ListarServidores();
                activity.setUpdate(true);
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

    private void setImageDefault(BeanServerRemote item) {
        if(item.getFlagDefault().equals("1"))
            ivDefault.setImageResource(R.drawable.exito);
        else
            ivDefault.setImageResource(R.drawable.fail);

    }

}
