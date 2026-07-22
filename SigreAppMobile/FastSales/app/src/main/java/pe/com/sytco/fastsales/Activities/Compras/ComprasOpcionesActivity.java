package pe.com.sytco.fastsales.Activities.Compras;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import pe.com.sytco.fastsales.Activities.AboutActivity;
import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.util.MessageBox;

public class ComprasOpcionesActivity extends AppCompatActivity {

    String OpcionesMenu[];

    //Controles de la ventana
    private ImageButton ibAbout = null;
    private ListView lvMenu = null;
    private TextView tvOrigen;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_compra_opciones);

        InitControllers();

        AsignarEventos();

        LoadDataDefault();

    }

    private void LoadDataDefault() {
        if(ImplSegLoginDevice.currentDevice == null)
        {
            MessageBox.AlertDialog(ComprasOpcionesActivity.this, "Error en Origen",
                    "No se ha especificado Dispositivo Actual, por favor verifique!", false);
        }

        if(ImplSegLoginDevice.currentDevice.getCodOrigen() == null || ImplSegLoginDevice.currentDevice.getCodOrigen().equals("") )
        {
            MessageBox.AlertDialog(ComprasOpcionesActivity.this, "Error en Origen",
                    "No se ha especificado el Origen del dispositivo ACTUAL, por favor verifique con Sistemas!", false);
        }

        tvOrigen.setText("Org [" + ImplEmpresa.empresaDefault.getCodOrigen() + ","
                + ImplSegLoginDevice.currentDevice.getCodOrigen() + "]");
    }

    private void AsignarEventos() {
        //Asignaciones de eventaos
        ibAbout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onClickAbout(view);
            }
        });

        //Adiciono las opciones al menu
        lvMenu.setAdapter(
                new ArrayAdapter(ComprasOpcionesActivity.this,
                        R.layout.item_row_opcion,
                        R.id.list_content, OpcionesMenu)
        );

        lvMenu.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                String ls_opcion = OpcionesMenu[i].toString();
                if (ls_opcion.substring(0, 2).equals("99")) {
                    //Opcion para salir del menu principal
                    startActivity (new Intent(getApplicationContext(), HomeActivity.class));
                    finish();
                }else if (ls_opcion.substring(0, 2).equals("01")) {
                    startActivity(new Intent(getApplicationContext(), ComprasProvClientesActivity.class));
                    finish();
                }
            }
        });
    }

    private void InitControllers() {
        //Controles de la ventana
        lvMenu = (ListView) findViewById(R.id.lvMenu);
        ibAbout = (ImageButton) findViewById(R.id.ibAbout);

        // Selección única:
        lvMenu.setChoiceMode(ListView.CHOICE_MODE_SINGLE);
        OpcionesMenu = getResources().getStringArray(R.array.opciones_compra);

        tvOrigen = (TextView) findViewById(R.id.tvOrigen);
    }

    private void onClickAbout(View v) {
        //Ingreso nuevamente a la session
        GlobalClass global = (GlobalClass) getApplicationContext();
        global.setActivity(this);

        Intent intent = new Intent(ComprasOpcionesActivity.this, AboutActivity.class);
        startActivity (intent);
        finish();
    }
}