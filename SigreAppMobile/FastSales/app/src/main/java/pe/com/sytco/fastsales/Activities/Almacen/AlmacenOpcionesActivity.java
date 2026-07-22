package pe.com.sytco.fastsales.Activities.Almacen;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;

import java.io.Serializable;

import pe.com.sytco.fastsales.Activities.AboutActivity;
import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.Parametros;

public class AlmacenOpcionesActivity extends AppCompatActivity implements Serializable {

    String OpcionesMenu[];

    //Controles de la ventana
    private ImageButton ibAbout = null;
    private ListView lvMenu = null;
    private TextView tvOrigen;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_opciones);

        InitControllers();

        AsignarEventos();

        LoadDataDefault();

    }

    private void LoadDataDefault() {
        if(ImplSegLoginDevice.currentDevice == null)
        {
            MessageBox.AlertDialog(AlmacenOpcionesActivity.this, "Error en Origen",
                    "No se ha especificado Dispositivo Actual, por favor verifique!", false);
        }

        if(ImplSegLoginDevice.currentDevice.getCodOrigen() == null || ImplSegLoginDevice.currentDevice.getCodOrigen().equals("") )
        {
            MessageBox.AlertDialog(AlmacenOpcionesActivity.this, "Error en Origen",
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
                new ArrayAdapter(AlmacenOpcionesActivity.this,
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
                    startActivity(new Intent(getApplicationContext(), AlmacenConsultaSKUActivity.class));
                    finish();
                }else if (ls_opcion.substring(0, 2).equals("03")) {
                    startActivity(new Intent(getApplicationContext(), AlmacenTomaInventarioActivity.class));
                    finish();
                }else if (ls_opcion.substring(0, 2).equals("02")) {
                    Parametros strParam = new Parametros();

                    strParam.setIsOK(false);

                    Intent intent = new Intent(getApplicationContext(), AlmacenParteRecepcionActivity.class);
                    intent.putExtra("strParam", new Gson().toJson(strParam));
                    startActivity(intent);
                    finish();

                }else if (ls_opcion.substring(0, 2).equals("06")) {
                    startActivity(new Intent(getApplicationContext(), AlmacenRecepcionPPTTActivity.class));
                    finish();
                }else if (ls_opcion.substring(0, 2).equals("07")) {
                    startActivity(new Intent(getApplicationContext(), AlmacenTransferenciaPPTTActivity.class));
                    finish();
                }else if (ls_opcion.substring(0, 2).equals("08")) {
                    startActivity(new Intent(getApplicationContext(), AlmacenDespachoPPTTActivity.class));
                    finish();
                }else if (ls_opcion.substring(0, 2).equals("09")) {
                    startActivity(new Intent(getApplicationContext(), InventarioPalletsActivity.class));
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
        OpcionesMenu = getResources().getStringArray(R.array.opciones_almacen);

        tvOrigen = (TextView) findViewById(R.id.tvOrigen);
    }

    private void onClickAbout(View v) {
        //Ingreso nuevamente a la session
        GlobalClass global = (GlobalClass) getApplicationContext();
        global.setActivity(this);

        Intent intent = new Intent(AlmacenOpcionesActivity.this, AboutActivity.class);
        startActivity (intent);
        finish();
    }
}
