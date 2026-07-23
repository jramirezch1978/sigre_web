package pe.com.hermes.appmobile.ui.compras.solicitudes;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.data.compras.ComprasVistasCatalog;
import pe.com.hermes.appmobile.ui.compras.ComprasListadoActivity;

/** Compat: redirige a {@link ComprasListadoActivity} (CM003). */
public class SolicitudesListActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        var vista = ComprasVistasCatalog.porCodigoVentana("CM003");
        startActivity(ComprasListadoActivity.intent(this,
                vista != null ? vista.codigo : "COMPRAS_OPERACIONES_SOLICITUD_DE_COMPRA"));
        finish();
    }
}
