package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.almacen.AlmacenVista;
import pe.com.hermes.appmobile.data.almacen.AlmacenVistasCatalog;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenProcesoBinding;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.common.ui.ConfirmDialog;

/** Ejecuta un proceso Almacén (POST) con confirmación. */
public class AlmacenProcesoActivity extends AppCompatActivity {

    public static final String EXTRA_VISTA_CODIGO = "vista_codigo";

    private ActivityAlmacenProcesoBinding binding;
    private AlmacenRepository repository;
    private AlmacenVista vista;

    public static Intent intent(Context ctx, String vistaCodigo) {
        return new Intent(ctx, AlmacenProcesoActivity.class).putExtra(EXTRA_VISTA_CODIGO, vistaCodigo);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenProcesoBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        vista = AlmacenVistasCatalog.porCodigo(getIntent().getStringExtra(EXTRA_VISTA_CODIGO));
        if (vista == null || !vista.esProceso()) {
            AppUtils.toast(this, getString(R.string.almacen_vista_invalida));
            finish();
            return;
        }

        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        binding.toolbar.setTitle(vista.nombre);
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        binding.tvDescripcion.setText(getString(R.string.almacen_proceso_ayuda, vista.nombre));
        binding.btnEjecutar.setOnClickListener(v -> confirmar());
    }

    private void confirmar() {
        ConfirmDialog.mostrar(
                this,
                getString(R.string.almacen_proceso_confirmar_titulo),
                getString(R.string.almacen_proceso_confirmar_mensaje, vista.nombre),
                true,
                this::ejecutar);
    }

    private void ejecutar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        binding.btnEjecutar.setEnabled(false);
        repository.ejecutarProceso(vista.procesoPath, new ResultCallback<String>() {
            @Override
            public void onSuccess(String data) {
                binding.progressBar.setVisibility(View.GONE);
                binding.btnEjecutar.setEnabled(true);
                AppUtils.toast(AlmacenProcesoActivity.this, data);
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                binding.btnEjecutar.setEnabled(true);
                AppUtils.toast(AlmacenProcesoActivity.this,
                        mensaje != null ? mensaje : getString(R.string.lista_error));
            }
        });
    }
}
