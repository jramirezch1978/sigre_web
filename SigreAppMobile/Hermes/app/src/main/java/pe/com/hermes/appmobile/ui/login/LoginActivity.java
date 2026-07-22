package pe.com.hermes.appmobile.ui.login;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.BuildConfig;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding;
import pe.com.hermes.appmobile.ui.empresa.SeleccionEmpresaActivity;
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.ConnectivityChecker;
import pe.com.hermes.common.util.AsyncRunner;

/** Pantalla de ingreso. El login SIEMPRE devuelve un token temporal (ver AuthServiceImpl.login) —
 * la seleccion de empresa/sucursal ocurre siempre despues, nunca se salta (a diferencia de
 * FastSales, cuya pantalla de login muestra tambien la ultima empresa cacheada: aqui no aplica
 * porque el listado real de empresas del usuario solo se conoce autenticado). */
public class LoginActivity extends AppCompatActivity {

    private static final long INTERVALO_MONITOREO_MS = 8000L;

    private ActivityLoginBinding binding;
    private AuthRepository authRepository;
    private final Handler monitorHandler = new Handler(Looper.getMainLooper());
    private Runnable monitorRunnable;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityLoginBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        binding.tvVersion.setText("Versión: " + BuildConfig.VERSION_NAME);

        binding.btnLogin.setOnClickListener(v -> intentarLogin());
        binding.btnCambiarServidor.setOnClickListener(v -> mostrarServidorDefault());
        binding.tvServidorNombre.setOnClickListener(v -> mostrarServidorDefault());
    }

    @Override
    protected void onResume() {
        super.onResume();
        actualizarServidorInfo();
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

    /** Ping periodico al servidor por defecto mientras el Login esta visible — equivalente al
     * badge "Conectado (Xms)" y a iniciarMonitoreoConexion() de FastSales. */
    private void iniciarMonitoreoConexion() {
        detenerMonitoreoConexion();
        monitorRunnable = new Runnable() {
            @Override
            public void run() {
                actualizarBadgeConexion();
                monitorHandler.postDelayed(this, INTERVALO_MONITOREO_MS);
            }
        };
        monitorHandler.post(monitorRunnable);
    }

    private void detenerMonitoreoConexion() {
        if (monitorRunnable != null) {
            monitorHandler.removeCallbacks(monitorRunnable);
            monitorRunnable = null;
        }
    }

    private void actualizarBadgeConexion() {
        ServerProfile def = AppUtils.app(this).getConfig().obtenerDefault();
        if (def == null) {
            binding.tvBadgeConexion.setText("Sin servidor");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral);
            return;
        }
        binding.tvBadgeConexion.setText("Verificando…");
        binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral);

        AsyncRunner.ejecutar(
                () -> ConnectivityChecker.probar(def),
                new AsyncRunner.OnResultado<ConnectivityChecker.Resultado>() {
                    @Override
                    public void onExito(ConnectivityChecker.Resultado resultado) {
                        if (resultado.conectado) {
                            binding.tvBadgeConexion.setText("Conectado (" + resultado.latenciaMs + "ms)");
                            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_success);
                        } else {
                            binding.tvBadgeConexion.setText("Sin conexión");
                            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_danger);
                        }
                    }

                    @Override
                    public void onError(Exception error) {
                        binding.tvBadgeConexion.setText("Sin conexión");
                        binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_danger);
                    }
                }
        );
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

        mostrarCargando(true);
        String nroRegistro = AppUtils.app(this).getDeviceRegistry().getNroRegistro();
        if (nroRegistro == null) {
            // Splash no pudo registrar el equipo (sin red en ese momento) - reintenta ahora mismo.
            registrarDispositivoYLuegoLogin(usuario, clave);
            return;
        }
        ejecutarLogin(usuario, clave, nroRegistro);
    }

    private void registrarDispositivoYLuegoLogin(String usuario, String clave) {
        String deviceId = AppUtils.app(this).getDeviceRegistry().obtenerDeviceId(this);
        RegistrarDispositivoRequest request = new RegistrarDispositivoRequest(
                deviceId, Build.MANUFACTURER, Build.MODEL, Build.MANUFACTURER + " " + Build.MODEL,
                "Android " + Build.VERSION.RELEASE);
        authRepository.registrarDispositivo(request, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                AppUtils.app(LoginActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                ejecutarLogin(usuario, clave, data.nroRegistro);
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                AppUtils.toast(LoginActivity.this, "No se pudo registrar el dispositivo. Verifique su conexión.");
            }
        });
    }

    private void ejecutarLogin(String usuario, String clave, String nroRegistro) {
        authRepository.login(usuario, clave, nroRegistro, new ResultCallback<LoginResponse>() {
            @Override
            public void onSuccess(LoginResponse data) {
                mostrarCargando(false);
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
        binding.btnLogin.setEnabled(!cargando);
    }
}
