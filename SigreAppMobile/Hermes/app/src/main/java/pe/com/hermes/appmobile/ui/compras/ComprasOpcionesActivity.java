package pe.com.hermes.appmobile.ui.compras;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.Collections;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.compras.solicitudes.SolicitudesListActivity;

/** Submenu de Compras. Por ahora solo Solicitudes de Compra; se iran agregando Cotizacion/OC/OS. */
public class ComprasOpcionesActivity extends AppCompatActivity {

    private static final long ID_SOLICITUDES = 1L;

    private ActivityGenericListBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.toolbar.setTitle(getString(R.string.compras_opciones_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        binding.swipeRefresh.setEnabled(false);

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        binding.recyclerView.setAdapter(new SimpleListAdapter(
                Collections.singletonList(new SimpleItem(ID_SOLICITUDES, getString(R.string.compras_solicitudes))),
                item -> {
                    if (item.id == ID_SOLICITUDES) {
                        startActivity(new Intent(this, SolicitudesListActivity.class));
                    }
                }
        ));
    }
}
