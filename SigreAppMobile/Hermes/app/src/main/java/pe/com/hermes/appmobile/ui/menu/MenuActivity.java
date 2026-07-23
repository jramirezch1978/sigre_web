package pe.com.hermes.appmobile.ui.menu;

import android.content.Intent;
import android.os.Bundle;
import android.widget.PopupMenu;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.Arrays;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.device.DeviceRegistrationFactory;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.databinding.ActivityMenuBinding;
import pe.com.hermes.appmobile.ui.almacen.AlmacenOpcionesActivity;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.compras.ComprasOpcionesActivity;
import pe.com.hermes.appmobile.ui.configuracion.ConfiguracionActivity;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.ui.preferencias.PreferenciasActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.common.ui.ConfirmDialog;
import pe.com.hermes.common.util.AsyncRunner;

/** Menú principal. Avatar superior izquierdo abre opciones de cuenta. */
public class MenuActivity extends AppCompatActivity {

    private static final long ID_ALMACEN = 1L;
    private static final long ID_COMPRAS = 2L;

    private ActivityMenuBinding binding;
    private AuthRepository authRepository;
    private boolean cerrandoSesion;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMenuBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

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

    @Override
    protected void onResume() {
        super.onResume();
        String nombreUsuario = AppUtils.app(this).getSession().getNombreCompleto();
        binding.tvAvatarIniciales.setText(inicialesDe(nombreUsuario));
    }

    private void mostrarMenuUsuario() {
        if (cerrandoSesion) {
            return;
        }
        PopupMenu popup = new PopupMenu(this, binding.btnAvatarUsuario);
        popup.getMenuInflater().inflate(R.menu.menu_usuario, popup.getMenu());
        popup.setOnMenuItemClickListener(item -> {
            int id = item.getItemId();
            if (id == R.id.action_preferencias) {
                startActivity(new Intent(this, PreferenciasActivity.class));
                return true;
            }
            if (id == R.id.action_configuracion) {
                startActivity(new Intent(this, ConfiguracionActivity.class));
                return true;
            }
            if (id == R.id.action_cerrar_sesion) {
                confirmarCerrarSesion();
                return true;
            }
            return false;
        });
        popup.show();
    }

    private void confirmarCerrarSesion() {
        String nombre = AppUtils.app(this).getSession().getNombreCompleto();
        if (nombre == null || nombre.trim().isEmpty()) {
            nombre = "usuario";
        }
        ConfirmDialog.mostrar(
                this,
                getString(R.string.logout_confirmar_titulo),
                getString(R.string.logout_confirmar_mensaje, nombre.trim()),
                true,
                this::cerrarSesion);
    }

    /**
     * Cierra JWT y la sesión de dispositivo (fec_logout), abre un nuevo nro_registro
     * y vuelve al login — igual que cancelar empresa/sucursal.
     */
    private void cerrarSesion() {
        if (cerrandoSesion) {
            return;
        }
        cerrandoSesion = true;
        String nroActual = AppUtils.app(this).getDeviceRegistry().getNroRegistro();
        authRepository.logout(() -> renovarSesionDispositivoTrasLogout(nroActual));
    }

    private void renovarSesionDispositivoTrasLogout(String nroActual) {
        AsyncRunner.ejecutar(
                () -> DeviceRegistrationFactory.crear(this),
                new AsyncRunner.OnResultado<RegistrarDispositivoRequest>() {
                    @Override
                    public void onExito(RegistrarDispositivoRequest request) {
                        enviarRenovacionYSalir(request, nroActual);
                    }

                    @Override
                    public void onError(Exception error) {
                        enviarRenovacionYSalir(DeviceRegistrationFactory.crear(MenuActivity.this), nroActual);
                    }
                }
        );
    }

    private void enviarRenovacionYSalir(RegistrarDispositivoRequest request, String nroActual) {
        authRepository.renovarSesionDispositivo(request, nroActual, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                AppUtils.app(MenuActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                irALogin();
            }

            @Override
            public void onError(String mensaje) {
                irALogin();
            }
        });
    }

    private void irALogin() {
        Intent intent = new Intent(MenuActivity.this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
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
