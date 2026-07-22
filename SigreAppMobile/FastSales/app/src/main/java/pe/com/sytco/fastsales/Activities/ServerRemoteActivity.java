package pe.com.sytco.fastsales.Activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import pe.com.sytco.fastsales.Controller.ImplServerRemote;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewServersAdapter;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class ServerRemoteActivity extends AppCompatActivity {

    //Listado de Servidores
    ImplServerRemote implServerRemote;
    ArrayAdapter adaptador;

    //Controles
    Button btnCerrar, btnAdd, btnSave;
    ListView lvListServerRemote;
    TextView tvNroRegistros;

    private Boolean ibUpdate;

    public Boolean getUpdate() {
        return ibUpdate;
    }

    public void setUpdate(Boolean value) {
        this.ibUpdate = value;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {

            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_server_remote);

            implServerRemote = new ImplServerRemote(ServerRemoteActivity.this);

            //Obtengo el listado de servidores acutuales
            implServerRemote.loadFromPrefererences();

            //guardo el objeto implServerRemote
            GlobalClass globalClass = (GlobalClass)this.getApplicationContext();
            globalClass.setImplServerRemote(implServerRemote);

            //Por defecto no hay modificaciones
            this.setUpdate(false);

            //Obtengo los controles
            lvListServerRemote= (ListView) findViewById(R.id.lvListServerRemote);
            tvNroRegistros = (TextView) findViewById(R.id.tvNroRegistros);
            btnCerrar = (Button)findViewById(R.id.btnCerrar);
            btnAdd = (Button)findViewById(R.id.btnAdd);
            btnSave = (Button)findViewById(R.id.btnSave);

            //Evento Click del ListView
            lvListServerRemote.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    try {
                        BeanServerRemote item = implServerRemote.getServers().get(position);
                        implServerRemote.editServer(item, ServerRemoteActivity.this);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        MessageBox.AlertDialog("Ha ocurrido un error al insertar un detalle al pedido. Exception: " + ex.getMessage(), "Function insertarPedido", getBaseContext());
                    }
                }
            });

            //Añado el evento Click del boton Cerrar
            btnCerrar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    confirmarCierre(v);

                }
            });

            btnAdd.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    implServerRemote.dialogAddServer(ServerRemoteActivity.this, false, ServerRemoteActivity.this);
                }
            });

            btnSave.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    implServerRemote.confirmSave(ServerRemoteActivity.this);
                }
            });

            //Listo los servidores en el ListView

            ListarServidores();


        } catch (Exception e) {
            MessageBox.AlertDialog("Error en evento onCreate. Mensaje: " + e.getMessage(), "Error en ServerRemoteActivity",
                    ServerRemoteActivity.this);
            e.printStackTrace();
        }

    }

    private void confirmarCierre(View v) {

        if (this.getUpdate()){
            AlertDialog.Builder builder = new AlertDialog.Builder(ServerRemoteActivity.this);

            builder.setMessage("Hay modificaciones pendientes de grabar, ¿Desea salir de la ventana sin grabar?");
            builder.setTitle("Confirmacion");
            builder.setCancelable(false);

            builder.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    cerrarActivity();
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

        }else{
            cerrarActivity();
        }

    }

    private void cerrarActivity() {
        Intent intent = new Intent(ServerRemoteActivity.this, LoginActivity.class);
        startActivity(intent);
        finish();
    }

    public void ListarServidores() {
        //Indico el adaptador para el listado de Servidores
        adaptador = new ListViewServersAdapter(ServerRemoteActivity.this, implServerRemote.getServers(), this);
        lvListServerRemote.setAdapter(adaptador);

        tvNroRegistros.setText(UTIL.ConvetToString(implServerRemote.getServers().size(), "###,##0"));

        //Le pongo el foco a la lista de Servidores
        lvListServerRemote.requestFocus();

    }

}
