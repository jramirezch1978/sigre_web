package pe.com.hermes.appmobile.ui.compras.solicitudes;

import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse;
import pe.com.hermes.appmobile.data.repository.ComprasRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.util.AppUtils;

/** Listado real de Solicitudes de Compra (GET /api/compras/solicitudes-compra) — solo lectura por
 * ahora, misma fuente de datos que la pantalla Angular ya construida (CM003). */
public class SolicitudesListActivity extends AppCompatActivity {

    private ActivityGenericListBinding binding;
    private ComprasRepository repository;
    private SimpleListAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        repository = new ComprasRepository(AppUtils.app(this).getApiClient());

        binding.toolbar.setTitle(getString(R.string.solicitudes_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new SimpleListAdapter(item -> { /* detalle: pendiente */ });
        binding.recyclerView.setAdapter(adapter);
        binding.swipeRefresh.setOnRefreshListener(this::cargar);

        cargar();
    }

    private static String etiquetaEstado(String flagEstado) {
        if (flagEstado == null) return "?";
        switch (flagEstado) {
            case "1": return "Activa";
            case "0": return "Rechazada/Anulada";
            case "2": return "Convertida";
            default: return flagEstado;
        }
    }

    private void cargar() {
        mostrarCargando(true);
        repository.listarSolicitudes(new ResultCallback<List<SolicitudCompraResponse>>() {
            @Override
            public void onSuccess(List<SolicitudCompraResponse> lista) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                List<SimpleItem> items = new ArrayList<>();
                for (SolicitudCompraResponse s : lista) {
                    items.add(new SimpleItem(
                            s.id,
                            s.numero != null ? s.numero : "Solicitud " + s.id,
                            (s.fecha != null ? s.fecha : "—") + " · " + s.totalItems + " ítem(s) · " + etiquetaEstado(s.flagEstado)
                    ));
                }
                adapter.actualizar(items);
                mostrarVacio(lista.isEmpty());
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                AppUtils.toast(SolicitudesListActivity.this, mensaje != null ? mensaje : getString(R.string.lista_error));
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
