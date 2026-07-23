package pe.com.hermes.appmobile.ui.compras;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.compras.ComprasVista;
import pe.com.hermes.appmobile.data.compras.ComprasVistasCatalog;
import pe.com.hermes.appmobile.data.repository.ComprasRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.util.AppUtils;

public class ComprasListadoActivity extends AppCompatActivity {

    public static final String EXTRA_VISTA_CODIGO = "vista_codigo";

    private ActivityGenericListBinding binding;
    private ComprasRepository repository;
    private SimpleListAdapter adapter;
    private ComprasVista vista;
    private ComprasRepository.DetalleTipo detalleTipo = ComprasRepository.DetalleTipo.NINGUNO;

    private final ActivityResultLauncher<Intent> formLauncher =
            registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), result -> {
                if (result.getResultCode() == RESULT_OK) cargar();
            });

    public static Intent intent(Context ctx, String vistaCodigo) {
        return new Intent(ctx, ComprasListadoActivity.class).putExtra(EXTRA_VISTA_CODIGO, vistaCodigo);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        vista = ComprasVistasCatalog.porCodigo(getIntent().getStringExtra(EXTRA_VISTA_CODIGO));
        if (vista == null || !vista.esNavegable()) {
            AppUtils.toast(this, getString(R.string.compras_vista_invalida));
            finish();
            return;
        }

        repository = new ComprasRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        binding.toolbar.setTitle("(" + vista.codigoVentana + ") " + vista.nombre);
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new SimpleListAdapter(item -> {
            if (item.id <= 0) return;
            if (detalleTipo == ComprasRepository.DetalleTipo.SOLICITUD) {
                formLauncher.launch(ComprasDetalleActivity.intentSolicitud(this, item.id, item.titulo));
            } else if (ComprasFormHelper.permiteAlta(vista.fuente) && !vista.esDocumento()) {
                formLauncher.launch(ComprasTablaFormActivity.intent(
                        this, vista.fuente, item.id, "Editar · " + item.titulo, null));
            }
        });
        binding.recyclerView.setAdapter(adapter);
        binding.swipeRefresh.setOnRefreshListener(this::cargar);

        if (ComprasFormHelper.permiteAlta(vista.fuente)) {
            binding.fabNuevo.setVisibility(View.VISIBLE);
            binding.fabNuevo.setOnClickListener(v -> {
                if (vista.esDocumento()) {
                    formLauncher.launch(ComprasSolicitudFormActivity.intent(this, 0L));
                } else {
                    formLauncher.launch(ComprasTablaFormActivity.intent(
                            this, vista.fuente, 0L, "Nuevo · " + vista.nombre, null));
                }
            });
        }
        cargar();
    }

    private void cargar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        repository.listarPorFuente(vista.fuente, new ResultCallback<>() {
            @Override
            public void onSuccess(ComprasRepository.ListadoResult data) {
                binding.progressBar.setVisibility(View.GONE);
                binding.swipeRefresh.setRefreshing(false);
                detalleTipo = data.detalleTipo;
                adapter.actualizar(data.items);
                binding.tvVacio.setText(R.string.lista_vacia);
                binding.tvVacio.setVisibility(data.items.isEmpty() ? View.VISIBLE : View.GONE);
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                binding.swipeRefresh.setRefreshing(false);
                AppUtils.toast(ComprasListadoActivity.this,
                        mensaje != null ? mensaje : getString(R.string.lista_error));
            }
        });
    }
}
