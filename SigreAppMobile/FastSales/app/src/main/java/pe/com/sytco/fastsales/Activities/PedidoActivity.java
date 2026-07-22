package pe.com.sytco.fastsales.Activities;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

/**
 * Compatibilidad: redirige a {@link PedidoHostActivity} (tomapedidos multipestaña).
 */
public class PedidoActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent forward = new Intent(this, PedidoHostActivity.class);
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            forward.putExtras(extras);
        }
        startActivity(forward);
        finish();
    }
}
