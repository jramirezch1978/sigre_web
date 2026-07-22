package pe.com.sytco.fastsales.Activities.RRHH;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.R;

public class RRHHOpcionesActivity extends AppCompatActivity {

    private Button btnActualizarFotos, btnParteDestajo, btnJornalCampo, btnSalir;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rrhh_opciones);

        // Toolbar
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("RRHH - Recursos Humanos");

        initControls();
        assignEvents();
    }

    private void initControls() {
        btnActualizarFotos = findViewById(R.id.btnActualizarFotos);
        btnParteDestajo = findViewById(R.id.btnParteDestajo);
        btnJornalCampo = findViewById(R.id.btnJornalCampo);
        btnSalir = findViewById(R.id.btnSalir);
    }

    private void assignEvents() {
        btnActualizarFotos.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getApplicationContext(), ActualizarFotoPersonalActivity.class);
                startActivity(intent);
            }
        });

        btnParteDestajo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(getApplicationContext(), ParteDestajoActivity.class));
            }
        });

        btnJornalCampo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(getApplicationContext(), ParteJornalCampoActivity.class));
            }
        });

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                finish();
            }
        });
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        startActivity(new Intent(getApplicationContext(), HomeActivity.class));
        finish();
    }
}

