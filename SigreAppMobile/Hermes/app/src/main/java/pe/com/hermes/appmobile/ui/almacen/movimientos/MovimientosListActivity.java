package pe.com.hermes.appmobile.ui.almacen.movimientos;

import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.util.AppUtils;

/** Listado real de movimientos de almacen (GET /api/almacen/movimientos) — solo lectura por ahora. */
public class MovimientosListActivity extends AppCompatActivity {

    private ActivityGenericListBinding binding;
    private AlmacenRepository repository;
    private SimpleListAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        binding.toolbar.setTitle(getString(R.string.movimientos_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new SimpleListAdapter(item -> { /* detalle: pendiente */ });
        binding.recyclerView.setAdapter(adapter);
        binding.swipeRefresh.setOnRefreshListener(this::cargar);

        cargar();
    }

    private void cargar() {
        mostrarCargando(true);
        repository.listarMovimientos(new ResultCallback<List<MovimientoListItemResponse>>() {
            @Override
            public void onSuccess(List<MovimientoListItemResponse> lista) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                List<SimpleItem> items = new ArrayList<>();
                for (MovimientoListItemResponse m : lista) {
                    items.add(new SimpleItem(
                            m.id,
                            m.nroVale != null ? m.nroVale : "Movimiento " + m.id,
                            (m.fechaMov != null ? m.fechaMov : "—") + " · estado " + (m.flagEstado != null ? m.flagEstado : "?")
                    ));
                }
                adapter.actualizar(items);
                mostrarVacio(lista.isEmpty());
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                AppUtils.toast(MovimientosListActivity.this, mensaje != null ? mensaje : getString(R.string.lista_error));
            }
        });
    }

    private void mostrarCargando(boolean cargando) {
        binding.progressBar.setVisibility(cargando ? View.VISIBLE : View.GONE);
    }

    private void mostrarVacio(boolean vacio) {
        binding.tvVacio.setText(getString(R.string.lista_vacia));
        binding.tvVacio.setVisibility(vacio ? View.VISIBLE : View.GONE);
    }
}
