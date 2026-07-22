package pe.com.sytco.fastsales.Activities.Asistencia;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import java.io.Serializable;

import pe.com.sytco.fastsales.R;

public class AsistenciaComedorActivity extends AppCompatActivity implements Serializable {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_asistencia_comedor);
    }
}