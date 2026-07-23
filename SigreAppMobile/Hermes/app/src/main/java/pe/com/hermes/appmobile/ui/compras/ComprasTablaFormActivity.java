package pe.com.hermes.appmobile.ui.compras;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.textfield.TextInputEditText;
import java.util.HashMap;
import java.util.Map;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.compras.ComprasFuenteDatos;
import pe.com.hermes.appmobile.data.repository.ComprasRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenFormBinding;
import pe.com.hermes.appmobile.util.AppUtils;

public class ComprasTablaFormActivity extends AppCompatActivity {

    public static final String EXTRA_FUENTE = "fuente";
    public static final String EXTRA_ID = "id";
    public static final String EXTRA_TITULO = "titulo";

    private ActivityAlmacenFormBinding binding;
    private ComprasRepository repository;
    private ComprasFuenteDatos fuente;
    private long id;
    private Map<String, TextInputEditText> edits;

    public static Intent intent(Context ctx, ComprasFuenteDatos fuente, long id, String titulo,
                                Map<String, String> prefill) {
        Intent i = new Intent(ctx, ComprasTablaFormActivity.class)
                .putExtra(EXTRA_FUENTE, fuente.name())
                .putExtra(EXTRA_ID, id)
                .putExtra(EXTRA_TITULO, titulo);
        if (prefill != null) {
            for (Map.Entry<String, String> e : prefill.entrySet()) {
                i.putExtra("p." + e.getKey(), e.getValue());
            }
            i.putExtra("p.keys", prefill.keySet().toArray(new String[0]));
        }
        return i;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenFormBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        fuente = ComprasFuenteDatos.valueOf(getIntent().getStringExtra(EXTRA_FUENTE));
        id = getIntent().getLongExtra(EXTRA_ID, 0L);
        String titulo = getIntent().getStringExtra(EXTRA_TITULO);
        binding.toolbar.setTitle(titulo != null ? titulo : (id > 0 ? "Editar" : "Nuevo"));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        repository = new ComprasRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        Map<String, String> prefill = new HashMap<>();
        String[] keys = getIntent().getStringArrayExtra("p.keys");
        if (keys != null) {
            for (String k : keys) {
                String v = getIntent().getStringExtra("p." + k);
                if (v != null) prefill.put(k, v);
            }
        }
        if (!prefill.containsKey("flagEstado")) prefill.put("flagEstado", "1");
        if (!prefill.containsKey("tipoDocIdentidadId")) prefill.put("tipoDocIdentidadId", "1");
        if (!prefill.containsKey("tipo")) prefill.put("tipo", "B");

        edits = ComprasFormHelper.construirCampos(this, binding.formContainer, fuente, prefill);
        binding.btnGuardar.setOnClickListener(v -> guardar());
    }

    private void guardar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        binding.btnGuardar.setEnabled(false);
        repository.guardarTabla(fuente, id, ComprasFormHelper.leer(edits), new ResultCallback<>() {
            @Override
            public void onSuccess(String data) {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(ComprasTablaFormActivity.this,
                        data != null ? data : getString(R.string.compras_guardado_ok));
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                binding.btnGuardar.setEnabled(true);
                AppUtils.toast(ComprasTablaFormActivity.this, mensaje);
            }
        });
    }
}
