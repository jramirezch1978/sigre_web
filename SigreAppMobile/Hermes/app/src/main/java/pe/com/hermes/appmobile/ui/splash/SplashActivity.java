package pe.com.hermes.appmobile.ui.splash;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivitySplashBinding;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.ui.menu.MenuActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.ConnectivityChecker;
import pe.com.hermes.common.util.AsyncRunner;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;

/**
 * Pantalla de inicio (logo Hermes) — hace la carga real en segundo plano antes de decidir
 * a donde navegar (a diferencia de FastSales, donde este trabajo vivia embebido al inicio
 * de LoginActivity.onCreate/continueAfterUpdateCheck):
 *   1) Asegura/lee el archivo de configuracion (siembra el default de assets si es la 1ra vez).
 *   2) Si hay un servidor por defecto, hace un ping TCP corto (no bloqueante para la navegacion).
 *   3) Decide destino: Menu (sesion completa) o Login.
 */
public class SplashActivity extends AppCompatActivity {

    private ActivitySplashBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivitySplashBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.tvEstado.setText("Cargando configuración…");

        AsyncRunner.ejecutar(
                () -> AppUtils.app(this).getConfig().obtenerDefault(),
                new AsyncRunner.OnResultado<ServerProfile>() {
                    @Override
                    public void onExito(ServerProfile def) {
                        continuarConDefault(def);
                    }

                    @Override
                    public void onError(Exception error) {
                        continuarConDefault(null);
                    }
                }
        );
    }

    private void continuarConDefault(ServerProfile def) {
        if (def == null) {
            binding.tvEstado.setText("Sin servidor configurado");
            navegar();
            return;
        }
        binding.tvEstado.setText("Verificando conexión con " + def.getNombre() + "…");
        AsyncRunner.ejecutar(
                () -> ConnectivityChecker.probar(def),
                new AsyncRunner.OnResultado<ConnectivityChecker.Resultado>() {
                    @Override
                    public void onExito(ConnectivityChecker.Resultado resultado) {
                        binding.tvEstado.setText(resultado.conectado
                                ? "Conectado (" + resultado.latenciaMs + " ms)"
                                : "Sin conexión — continuando…");
                        registrarDispositivoYNavegar();
                    }

                    @Override
                    public void onError(Exception error) {
                        binding.tvEstado.setText("Sin conexión — continuando…");
                        registrarDispositivoYNavegar();
                    }
                }
        );
    }

    /** Alta idempotente del equipo (equivalente a registraDevice() de FastSales) — best-effort:
     * si falla por falta de red, se reintenta mas tarde desde LoginActivity al intentar ingresar. */
    private void registrarDispositivoYNavegar() {
        if (AppUtils.app(this).getDeviceRegistry().getNroRegistro() != null) {
            navegar();
            return;
        }
        String deviceId = AppUtils.app(this).getDeviceRegistry().obtenerDeviceId(this);
        RegistrarDispositivoRequest request = new RegistrarDispositivoRequest(
                deviceId, Build.MANUFACTURER, Build.MODEL, Build.MANUFACTURER + " " + Build.MODEL,
                "Android " + Build.VERSION.RELEASE);
        AuthRepository authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        authRepository.registrarDispositivo(request, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                AppUtils.app(SplashActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                navegar();
            }

            @Override
            public void onError(String mensaje) {
                navegar();
            }
        });
    }

    private void navegar() {
        Class<?> destino = AppUtils.app(this).getSession().sesionCompleta() ? MenuActivity.class : LoginActivity.class;
        startActivity(new Intent(this, destino));
        finish();
    }
}
