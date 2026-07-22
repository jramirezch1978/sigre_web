package pe.com.hermes.appmobile.ui.almacen;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.Collections;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.almacen.movimientos.MovimientosListActivity;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;

/** Submenu de Almacen. Por ahora solo Movimientos; se iran agregando el resto de opciones. */
public class AlmacenOpcionesActivity extends AppCompatActivity {

    private static final long ID_MOVIMIENTOS = 1L;

    private ActivityGenericListBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.toolbar.setTitle(getString(R.string.almacen_opciones_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        binding.swipeRefresh.setEnabled(false);

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        binding.recyclerView.setAdapter(new SimpleListAdapter(
                Collections.singletonList(new SimpleItem(ID_MOVIMIENTOS, getString(R.string.almacen_movimientos))),
                item -> {
                    if (item.id == ID_MOVIMIENTOS) {
                        startActivity(new Intent(this, MovimientosListActivity.class));
                    }
                }
        ));
    }
}
