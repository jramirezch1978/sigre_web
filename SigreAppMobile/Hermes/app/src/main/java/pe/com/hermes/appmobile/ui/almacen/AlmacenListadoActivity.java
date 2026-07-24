package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import java.util.HashMap;
import java.util.Map;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.appmobile.data.almacen.AlmacenVista;
import pe.com.hermes.appmobile.data.almacen.AlmacenVistasCatalog;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.util.AppUtils;

/** Listado genérico Almacén con alta/edición. */
public class AlmacenListadoActivity extends AppCompatActivity {

    public static final String EXTRA_VISTA_CODIGO = "vista_codigo";

    private ActivityGenericListBinding binding;
    private AlmacenRepository repository;
    private SimpleListAdapter adapter;
    private AlmacenVista vista;
    private AlmacenRepository.DetalleTipo detalleTipo = AlmacenRepository.DetalleTipo.NINGUNO;

    private final ActivityResultLauncher<Intent> formLauncher =
            registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), result -> {
                if (result.getResultCode() == RESULT_OK) cargar();
            });

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

        adapter = new SimpleListAdapter(item -> {
            if (item.id <= 0) return;
            if (detalleTipo != AlmacenRepository.DetalleTipo.NINGUNO) {
                formLauncher.launch(AlmacenDetalleActivity.intent(this, detalleTipo, item.id, item.titulo));
                return;
            }
            if (AlmacenFormHelper.permiteAlta(vista.fuente) && !AlmacenFormHelper.esDocumento(vista.fuente)) {
                Map<String, String> pre = new HashMap<>();
                if (vista.fuente == AlmacenFuenteDatos.PARAMETROS) {
                    pre.put("clave", item.titulo);
                    String valor = item.subtitulo != null && item.subtitulo.contains(" · ")
                            ? item.subtitulo.substring(item.subtitulo.lastIndexOf(" · ") + 3)
                            : "";
                    pre.put("valor", "—".equals(valor) ? "" : valor);
                }
                formLauncher.launch(AlmacenTablaFormActivity.intent(
                        this, vista.fuente, item.id, "Editar · " + item.titulo, pre));
            }
        });
        binding.recyclerView.setAdapter(adapter);
        binding.swipeRefresh.setOnRefreshListener(this::cargar);

        if (AlmacenFormHelper.permiteAlta(vista.fuente)) {
            binding.fabNuevo.setVisibility(View.VISIBLE);
            binding.fabNuevo.setOnClickListener(v -> abrirNuevo());
        }

        cargar();
    }

    private void abrirNuevo() {
        if (AlmacenFormHelper.esDocumento(vista.fuente)) {
            formLauncher.launch(AlmacenDocumentoFormActivity.intent(this, vista.fuente, 0L));
        } else {
            formLauncher.launch(AlmacenTablaFormActivity.intent(
                    this, vista.fuente, 0L, "Nuevo · " + vista.nombre, null));
        }
    }

    private void cargar() {
        mostrarCargando(true);
        repository.listarPorVista(vista.codigoVentana, vista.fuente, new ResultCallback<>() {
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
