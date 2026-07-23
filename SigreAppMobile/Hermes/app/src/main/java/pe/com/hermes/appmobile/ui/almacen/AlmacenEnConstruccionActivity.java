package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenEnConstruccionBinding;

/** Opción del menú Almacén aún sin pantalla móvil (igual que path_url null en web). */
public class AlmacenEnConstruccionActivity extends AppCompatActivity {

    public static Intent intent(Context ctx, String nombre, String codigo, String path) {
        return new Intent(ctx, AlmacenEnConstruccionActivity.class)
                .putExtra("nombre", nombre)
                .putExtra("codigo", codigo)
                .putExtra("path", path);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityAlmacenEnConstruccionBinding binding = ActivityAlmacenEnConstruccionBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        String nombre = getIntent().getStringExtra("nombre");
        String codigo = getIntent().getStringExtra("codigo");
        String path = getIntent().getStringExtra("path");

        binding.toolbar.setTitle(nombre != null ? nombre : getString(R.string.menu_opcion_en_construccion_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        binding.tvMensaje.setText(getString(R.string.almacen_en_construccion_msg,
                nombre != null ? nombre : "—",
                codigo != null ? codigo : "—",
                path != null ? path : "—"));
    }
}
