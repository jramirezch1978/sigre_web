package pe.com.hermes.appmobile.ui.almacen.movimientos;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.ui.almacen.AlmacenListadoActivity;

/** Compat: redirige al listado genérico de movimientos generales. */
public class MovimientosListActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        startActivity(AlmacenListadoActivity.intent(this, "ALMACEN_OP_MOV_GENERAL"));
        finish();
    }
}
