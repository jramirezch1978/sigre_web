package pe.com.hermes.appmobile.ui.menu;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.Arrays;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.almacen.AlmacenOpcionesActivity;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.compras.ComprasOpcionesActivity;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.util.AppUtils;

/** Menu principal: por ahora Almacen y Compras (logistica), como pidio el usuario. */
public class MenuActivity extends AppCompatActivity {

    private static final long ID_ALMACEN = 1L;
    private static final long ID_COMPRAS = 2L;

    private ActivityGenericListBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        String empresaNombre = AppUtils.app(this).getSession().getEmpresaNombre();
        binding.toolbar.setTitle(getString(R.string.menu_titulo) + " — " + (empresaNombre != null ? empresaNombre : ""));
        setSupportActionBar(binding.toolbar);

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        String sucursalNombre = AppUtils.app(this).getSession().getSucursalNombre();
        binding.recyclerView.setAdapter(new SimpleListAdapter(
                Arrays.asList(
                        new SimpleItem(ID_ALMACEN, getString(R.string.menu_almacen), sucursalNombre),
                        new SimpleItem(ID_COMPRAS, getString(R.string.menu_compras), sucursalNombre)
                ),
                item -> {
                    if (item.id == ID_ALMACEN) {
                        startActivity(new Intent(this, AlmacenOpcionesActivity.class));
                    } else if (item.id == ID_COMPRAS) {
                        startActivity(new Intent(this, ComprasOpcionesActivity.class));
                    }
                }
        ));
        binding.swipeRefresh.setEnabled(false);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_toolbar_logout, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.action_logout) {
            new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession()).logout(() -> {
                startActivity(new Intent(MenuActivity.this, LoginActivity.class));
                finish();
            });
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
