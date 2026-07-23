package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.almacen.AlmacenVista;
import pe.com.hermes.appmobile.data.almacen.AlmacenVistasCatalog;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.util.AppUtils;

/** Listado genérico de una vista Almacén (operaciones, consultas, reportes, tablas). */
public class AlmacenListadoActivity extends AppCompatActivity {

    public static final String EXTRA_VISTA_CODIGO = "vista_codigo";

    private ActivityGenericListBinding binding;
    private AlmacenRepository repository;
    private SimpleListAdapter adapter;
    private AlmacenVista vista;
    private AlmacenRepository.DetalleTipo detalleTipo = AlmacenRepository.DetalleTipo.NINGUNO;

    public static Intent intent(Context ctx, String vistaCodigo) {
        return new Intent(ctx, AlmacenListadoActivity.class).putExtra(EXTRA_VISTA_CODIGO, vistaCodigo);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        String codigo = getIntent().getStringExtra(EXTRA_VISTA_CODIGO);
        vista = AlmacenVistasCatalog.porCodigo(codigo);
        if (vista == null || !vista.tieneListado()) {
            AppUtils.toast(this, getString(R.string.almacen_vista_invalida));
            finish();
            return;
        }

        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        String titulo = vista.codigoVentana != null
                ? "(" + vista.codigoVentana + ") " + vista.nombre
                : vista.nombre;
        binding.toolbar.setTitle(titulo);
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new SimpleListAdapter(item -> {
            if (detalleTipo == AlmacenRepository.DetalleTipo.NINGUNO || item.id <= 0) return;
            startActivity(AlmacenDetalleActivity.intent(this, detalleTipo, item.id, item.titulo));
        });
        binding.recyclerView.setAdapter(adapter);
        binding.swipeRefresh.setOnRefreshListener(this::cargar);
        cargar();
    }

    private void cargar() {
        mostrarCargando(true);
        repository.listarPorFuente(vista.fuente, new ResultCallback<>() {
            @Override
            public void onSuccess(AlmacenRepository.ListadoResult data) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                detalleTipo = data.detalleTipo;
                adapter.actualizar(data.items);
                mostrarVacio(data.items.isEmpty());
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                AppUtils.toast(AlmacenListadoActivity.this,
                        mensaje != null ? mensaje : getString(R.string.lista_error));
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
