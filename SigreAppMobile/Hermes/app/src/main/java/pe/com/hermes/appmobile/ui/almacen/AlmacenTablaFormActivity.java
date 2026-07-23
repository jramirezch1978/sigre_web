package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.textfield.TextInputEditText;
import java.util.HashMap;
import java.util.Map;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenFormBinding;
import pe.com.hermes.appmobile.util.AppUtils;

/** Alta/edición de tablas maestras Almacén (AL001–AL012). */
public class AlmacenTablaFormActivity extends AppCompatActivity {

    public static final String EXTRA_FUENTE = "fuente";
    public static final String EXTRA_ID = "id";
    public static final String EXTRA_TITULO = "titulo";
    public static final String EXTRA_PREFILL = "prefill";

    private ActivityAlmacenFormBinding binding;
    private AlmacenRepository repository;
    private AlmacenFuenteDatos fuente;
    private long id;
    private Map<String, TextInputEditText> edits;

    public static Intent intent(Context ctx, AlmacenFuenteDatos fuente, long id, String titulo,
                                Map<String, String> prefill) {
        Intent i = new Intent(ctx, AlmacenTablaFormActivity.class)
                .putExtra(EXTRA_FUENTE, fuente.name())
                .putExtra(EXTRA_ID, id)
                .putExtra(EXTRA_TITULO, titulo);
        if (prefill != null) {
            for (Map.Entry<String, String> e : prefill.entrySet()) {
                i.putExtra(EXTRA_PREFILL + "." + e.getKey(), e.getValue());
            }
            i.putExtra(EXTRA_PREFILL + ".keys", prefill.keySet().toArray(new String[0]));
        }
        return i;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenFormBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        fuente = AlmacenFuenteDatos.valueOf(getIntent().getStringExtra(EXTRA_FUENTE));
        id = getIntent().getLongExtra(EXTRA_ID, 0L);
        String titulo = getIntent().getStringExtra(EXTRA_TITULO);
        binding.toolbar.setTitle(titulo != null ? titulo : (id > 0 ? "Editar" : "Nuevo"));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        Map<String, String> prefill = new HashMap<>();
        String[] keys = getIntent().getStringArrayExtra(EXTRA_PREFILL + ".keys");
        if (keys != null) {
            for (String k : keys) {
                String v = getIntent().getStringExtra(EXTRA_PREFILL + "." + k);
                if (v != null) prefill.put(k, v);
            }
        }
        if (!prefill.containsKey("sucursalId") && AppUtils.app(this).getSession().getSucursalId() > 0) {
            prefill.put("sucursalId", String.valueOf(AppUtils.app(this).getSession().getSucursalId()));
        }
        if (!prefill.containsKey("flagEstado")) prefill.put("flagEstado", "1");
        if (!prefill.containsKey("ano")) {
            prefill.put("ano", String.valueOf(java.time.Year.now().getValue()));
        }

        edits = AlmacenFormHelper.construirCamposTabla(this, binding.formContainer, fuente, prefill);
        binding.btnGuardar.setOnClickListener(v -> guardar());
    }

    private void guardar() {
        Map<String, String> campos = AlmacenFormHelper.leer(edits);
        binding.progressBar.setVisibility(View.VISIBLE);
        binding.btnGuardar.setEnabled(false);
        repository.guardarTabla(fuente, id, campos, new ResultCallback<>() {
            @Override
            public void onSuccess(String data) {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(AlmacenTablaFormActivity.this,
                        data != null ? data : getString(R.string.almacen_guardado_ok));
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                binding.btnGuardar.setEnabled(true);
                AppUtils.toast(AlmacenTablaFormActivity.this,
                        mensaje != null ? mensaje : getString(R.string.lista_error));
            }
        });
    }
}
