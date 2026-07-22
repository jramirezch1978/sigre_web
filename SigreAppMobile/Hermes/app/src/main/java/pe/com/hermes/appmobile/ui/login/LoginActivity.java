package pe.com.hermes.appmobile.ui.login;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.data.device.DeviceRegistry;
import pe.com.hermes.appmobile.data.ping.ConnectionMonitor;
import pe.com.hermes.appmobile.data.ping.PingHistoryStore;
import pe.com.hermes.appmobile.data.ping.PingSample;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding;
import pe.com.hermes.appmobile.ui.empresa.SeleccionEmpresaActivity;
import pe.com.hermes.appmobile.ui.ping.PingMonitorDialog;
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;

/** Pantalla de ingreso. El login SIEMPRE devuelve un token temporal (ver AuthServiceImpl.login) —
 * la seleccion de empresa/sucursal ocurre siempre despues, nunca se salta (a diferencia de
 * FastSales, cuya pantalla de login muestra tambien la ultima empresa cacheada: aqui no aplica
 * porque el listado real de empresas del usuario solo se conoce autenticado). */
public class LoginActivity extends AppCompatActivity implements ConnectionMonitor.Listener {

    private ActivityLoginBinding binding;
    private AuthRepository authRepository;
    private final PingHistoryStore pingHistory = new PingHistoryStore();
    private ConnectionMonitor connectionMonitor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityLoginBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        connectionMonitor = new ConnectionMonitor(AppUtils.app(this).getApiClient(), pingHistory, this);

        binding.tvVersion.setText(AppVersion.etiqueta(this));

        binding.btnLogin.setOnClickListener(v -> intentarLogin());
        binding.btnCambiarServidor.setOnClickListener(v -> mostrarServidorDefault());
        binding.tvServidorNombre.setOnClickListener(v -> mostrarServidorDefault());
        binding.btnRefrescarServidor.setOnClickListener(v -> refrescarServidorYSesion());
        binding.badgeConexion.setOnClickListener(v -> mostrarDiagnosticoConexion());

        aplicarEstadoDispositivo();
    }

    @Override
    protected void onResume() {
        super.onResume();
        actualizarServidorInfo();
        aplicarEstadoDispositivo();
        iniciarMonitoreoConexion();
    }

    @Override
    protected void onPause() {
        super.onPause();
        detenerMonitoreoConexion();
    }

    private void actualizarServidorInfo() {
        ServerProfile def = AppUtils.app(this).getConfig().obtenerDefault();
        binding.tvServidorNombre.setText(def != null ? def.getNombre() : "(sin configurar)");
    }

    /** Ping HTTP cada 1s a /auth/health/ping (igual que FastSales ConnectionMonitorService). */
    private void iniciarMonitoreoConexion() {
        detenerMonitoreoConexion();
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            binding.tvBadgeConexion.setText("Sin servidor");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral);
            return;
        }
        binding.tvBadgeConexion.setText("Verificando…");
        binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral);
        connectionMonitor.start();
    }

    private void detenerMonitoreoConexion() {
        if (connectionMonitor != null) {
            connectionMonitor.stop();
        }
    }

    @Override
    public void onConnectionStatusChanged(boolean connected, Long latencyMs) {
        if (connected && latencyMs != null) {
            binding.tvBadgeConexion.setText("Conectado (" + latencyMs + "ms)");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_success);
        } else {
            binding.tvBadgeConexion.setText("Sin conexión");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_danger);
        }
    }

    @Override
    public void onPingUpdated(PingSample sample) {
        // El historial ya se guarda en ConnectionMonitor; el dialog lee de ahí.
    }

    private void mostrarDiagnosticoConexion() {
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            AppUtils.toast(this, "Configure un servidor remoto primero.");
            return;
        }
        new PingMonitorDialog(this, pingHistory).show();
    }

    /** Equivalente a ImplServerRemote.dialogServerDefault() de FastSales: info de solo lectura
     * del servidor activo + boton para ir al listado completo (donde se anaden/editan perfiles). */
    private void mostrarServidorDefault() {
        if (AppUtils.app(this).getConfig().listarServidores().isEmpty()) {
            irAListadoServidores();
            return;
        }

        View view = getLayoutInflater().inflate(R.layout.dialog_server_default, null);
        ServerProfile def = AppUtils.app(this).getConfig().obtenerDefault();

        ((TextView) view.findViewById(R.id.tvNombre)).setText(def != null ? def.getNombre() : "—");
        ((TextView) view.findViewById(R.id.tvHostIp)).setText(def != null ? def.getHostIp() : "—");
        ((TextView) view.findViewById(R.id.tvPort)).setText(def != null ? def.getPort() : "—");
        ((TextView) view.findViewById(R.id.tvProtocolo)).setText(def != null ? def.getProtocolo() : "—");

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setView(view)
                .setCancelable(false)
                .create();

        view.findViewById(R.id.btnCerrar).setOnClickListener(v -> dialog.dismiss());
        view.findViewById(R.id.btnListado).setOnClickListener(v -> {
            dialog.dismiss();
            irAListadoServidores();
        });

        dialog.show();
    }

    private void irAListadoServidores() {
        startActivity(new Intent(this, ServidorListActivity.class));
    }

    private void refrescarServidorYSesion() {
        actualizarServidorInfo();
        iniciarMonitoreoConexion();

        if (AppUtils.app(this).getConfig().listarServidores().isEmpty()) {
            AppUtils.toast(this, "No hay perfiles de conexión. Cree uno nuevo.");
            irAListadoServidores();
            return;
        }
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            AppUtils.toast(this, "Marque un servidor como predeterminado.");
            irAListadoServidores();
            return;
        }

        registrarNuevaSesionDispositivo();
    }

    private void registrarNuevaSesionDispositivo() {
        mostrarCargandoRefrescar(true);
        String deviceId = AppUtils.app(this).getDeviceRegistry().obtenerDeviceId(this);
        RegistrarDispositivoRequest request = new RegistrarDispositivoRequest(
                deviceId, Build.MANUFACTURER, Build.MODEL, Build.MANUFACTURER + " " + Build.MODEL,
                "Android " + Build.VERSION.RELEASE);
        authRepository.registrarDispositivo(request, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                mostrarCargandoRefrescar(false);
                AppUtils.app(LoginActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                aplicarEstadoDispositivo();
                if (!data.autorizado) {
                    AppUtils.toast(LoginActivity.this, getString(R.string.login_dispositivo_no_autorizado));
                } else {
                    String nro = data.nroRegistro != null ? data.nroRegistro : "";
                    AppUtils.toast(LoginActivity.this,
                            getString(R.string.splash_dispositivo_ok_nro, nro));
                }
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargandoRefrescar(false);
                AppUtils.toast(LoginActivity.this, getString(R.string.splash_error_registro));
            }
        });
    }

    private void aplicarEstadoDispositivo() {
        DeviceRegistry registry = AppUtils.app(this).getDeviceRegistry();
        boolean listo = registry.isDispositivoListo();
        binding.btnLogin.setEnabled(listo);
        binding.etUsuario.setEnabled(listo);
        binding.etClave.setEnabled(listo);
        String nro = registry.getNroRegistro();
        if (nro != null && !nro.isBlank()) {
            binding.tvNroRegistro.setText(getString(R.string.login_nro_registro, nro));
        } else {
            binding.tvNroRegistro.setText(R.string.login_nro_registro_pendiente);
        }
    }

    private void intentarLogin() {
        String usuario = binding.etUsuario.getText() != null ? binding.etUsuario.getText().toString().trim() : "";
        String clave = binding.etClave.getText() != null ? binding.etClave.getText().toString() : "";

        if (usuario.isEmpty() || clave.isEmpty()) {
            AppUtils.toast(this, getString(R.string.login_error_campos));
            return;
        }
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            AppUtils.toast(this, "Configure un servidor remoto antes de ingresar.");
            irAListadoServidores();
            return;
        }

        DeviceRegistry registry = AppUtils.app(this).getDeviceRegistry();
        if (!registry.isDispositivoListo()) {
            AppUtils.toast(this, registry.getNroRegistro() == null
                    ? getString(R.string.login_dispositivo_no_listo)
                    : getString(R.string.login_dispositivo_no_autorizado));
            return;
        }

        mostrarCargando(true);
        ejecutarLogin(usuario, clave, registry.getNroRegistro());
    }

    private void mostrarCargandoRefrescar(boolean cargando) {
        binding.progressRefrescarServidor.setVisibility(cargando ? View.VISIBLE : View.GONE);
        binding.btnRefrescarServidor.setEnabled(!cargando);
    }

    private void ejecutarLogin(String usuario, String clave, String nroRegistro) {
        authRepository.login(usuario, clave, nroRegistro, new ResultCallback<LoginResponse>() {
            @Override
            public void onSuccess(LoginResponse data) {
                mostrarCargando(false);
                pingHistory.clear();
                startActivity(new Intent(LoginActivity.this, SeleccionEmpresaActivity.class));
                finish();
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                AppUtils.toast(LoginActivity.this, mensaje != null ? mensaje : getString(R.string.login_error_credenciales));
            }
        });
    }

    private void mostrarCargando(boolean cargando) {
        binding.progressLogin.setVisibility(cargando ? View.VISIBLE : View.GONE);
        binding.btnLogin.setEnabled(!cargando && AppUtils.app(this).getDeviceRegistry().isDispositivoListo());
    }
}
