package pe.com.hermes.appmobile.ui.menu;

import android.content.Intent;
import android.os.Bundle;
import android.widget.PopupMenu;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.Arrays;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.databinding.ActivityMenuBinding;
import pe.com.hermes.appmobile.ui.almacen.AlmacenOpcionesActivity;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.compras.ComprasOpcionesActivity;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.util.AppUtils;

/** Menú principal. Avatar superior izquierdo abre opciones de cuenta (incl. cerrar sesión). */
public class MenuActivity extends AppCompatActivity {

    private static final long ID_ALMACEN = 1L;
    private static final long ID_COMPRAS = 2L;

    private ActivityMenuBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMenuBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SessionManager session = AppUtils.app(this).getSession();
        String empresaNombre = session.getEmpresaNombre();
        String sucursalNombre = session.getSucursalNombre();
        String nombreUsuario = session.getNombreCompleto();

        binding.tvMenuTitulo.setText(getString(R.string.menu_titulo));
        binding.tvMenuSubtitulo.setText(formatearSubtitulo(empresaNombre, sucursalNombre));
        binding.tvAvatarIniciales.setText(inicialesDe(nombreUsuario));
        binding.btnAvatarUsuario.setOnClickListener(v -> mostrarMenuUsuario());

        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
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
    }

    private void mostrarMenuUsuario() {
        PopupMenu popup = new PopupMenu(this, binding.btnAvatarUsuario);
        popup.getMenuInflater().inflate(R.menu.menu_usuario, popup.getMenu());
        popup.setOnMenuItemClickListener(item -> {
            if (item.getItemId() == R.id.action_cerrar_sesion) {
                cerrarSesion();
                return true;
            }
            return false;
        });
        popup.show();
    }

    private void cerrarSesion() {
        new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession())
                .logout(() -> {
                    Intent intent = new Intent(MenuActivity.this, LoginActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(intent);
                    finish();
                });
    }

    private static String formatearSubtitulo(String empresa, String sucursal) {
        String emp = empresa != null ? empresa.trim() : "";
        String suc = sucursal != null ? sucursal.trim() : "";
        if (!emp.isEmpty() && !suc.isEmpty()) {
            return emp + " · " + suc;
        }
        if (!emp.isEmpty()) {
            return emp;
        }
        return suc;
    }

    /** Iniciales para el avatar (1–2 letras) a partir del nombre completo. */
    static String inicialesDe(String nombreCompleto) {
        if (nombreCompleto == null || nombreCompleto.trim().isEmpty()) {
            return "?";
        }
        String[] partes = nombreCompleto.trim().split("\\s+");
        if (partes.length == 1) {
            String p = partes[0];
            return p.substring(0, Math.min(2, p.length())).toUpperCase();
        }
        char a = Character.toUpperCase(partes[0].charAt(0));
        char b = Character.toUpperCase(partes[partes.length - 1].charAt(0));
        return "" + a + b;
    }
}
