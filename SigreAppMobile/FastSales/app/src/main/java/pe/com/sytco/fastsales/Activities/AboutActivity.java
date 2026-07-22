package pe.com.sytco.fastsales.Activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import org.w3c.dom.Text;

import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;

public class AboutActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);

        TextView vAbout = (TextView) findViewById(R.id.tvAbout);
        ImageButton ibSalir = (ImageButton) findViewById(R.id.ibSalir);

        vAbout.setText("FAST SALES Es una apicacion móvil que interactúa con el ERP SIGRE y permite"
                    + "realizar varias tareas desde cualquier movil. Por ahora esta solo desarrollado "
                    + "en ANDROID. Algunas de ellas son Tomapedidos, Toma de Inventario, Recepción de "
                    + "mercadería, Control de Hospedaje (HORECA), Reportes de Control Gerencial, "
                    + "Aprobación de documentos, etc."
                    + "\n\n\n"
                    + "Fast Sales, Hermes, SIGRE, SIGMA Son aplicaciones móviles que estan registradas a nombre "
                    + "del Ing Jhonny Ramirez y cuyos derechos de AUTOR le corresponden."
                    + "\n\n\n"
                    + "Copyright (c) 2018 Ing Jhonny Ramirez Chiroque.");

        ibSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onSalir(view);
            }
        });
    }

    private void onSalir(View view) {
        GlobalClass global = (GlobalClass) getApplicationContext();
        Activity backActivity = global.getActivity();

        if (backActivity == null) {
            startActivity(new Intent(AboutActivity.this, HomeActivity.class));
        }else{
            startActivity(new Intent(AboutActivity.this, backActivity.getClass()));
        }

        global.setActivity(null);
        finish();
    }
}
