package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.almacen.AlmacenVista;
import pe.com.hermes.appmobile.data.almacen.AlmacenVistasCatalog;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;

/**
 * Hub Almacén: solo opciones navegables (con path + Activity registrada AL###).
 */
public class AlmacenOpcionesActivity extends AppCompatActivity {

    public static final String EXTRA_GRUPO = "grupo";

    private ActivityGenericListBinding binding;
    private final List<AlmacenVista> vistasVisibles = new ArrayList<>();

    public static Intent intent(Context ctx, String grupo) {
        Intent i = new Intent(ctx, AlmacenOpcionesActivity.class);
        if (grupo != null) i.putExtra(EXTRA_GRUPO, grupo);
        return i;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        String grupo = getIntent().getStringExtra(EXTRA_GRUPO);
        binding.toolbar.setTitle(grupo != null ? ("Almacén · " + grupo) : getString(R.string.almacen_opciones_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        binding.swipeRefresh.setEnabled(false);

        List<AlmacenVista> fuente = grupo != null
                ? AlmacenVistasCatalog.porGrupo(grupo)
                : AlmacenVistasCatalog.navegables();
        vistasVisibles.clear();
        vistasVisibles.addAll(fuente);

        List<SimpleItem> items = new ArrayList<>();
        if (grupo == null) {
            Set<String> grupos = new LinkedHashSet<>();
            for (AlmacenVista v : AlmacenVistasCatalog.navegables()) {
                grupos.add(v.grupo);
            }
            long gid = -1;
            for (String g : grupos) {
                items.add(new SimpleItem(gid--, "▸ " + g, getString(R.string.almacen_grupo_ayuda)));
            }
        }
        for (int i = 0; i < vistasVisibles.size(); i++) {
            AlmacenVista v = vistasVisibles.get(i);
            items.add(new SimpleItem(
                    i,
                    v.nombre,
                    v.codigoVentana + " · " + v.grupo));
        }

        binding.recyclerView.setAdapter(new SimpleListAdapter(items, item -> {
            if (item.id < 0) {
                String g = item.titulo.replace("▸ ", "").trim();
                startActivity(intent(this, g));
                return;
            }
            int idx = (int) item.id;
            if (idx >= 0 && idx < vistasVisibles.size()) {
                AlmacenNavRouter.abrirVista(this, vistasVisibles.get(idx));
            }
        }));
    }
}
