package pe.com.hermes.appmobile.ui.splash;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.databinding.ActivitySplashBinding;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.ui.menu.MenuActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.ConnectivityChecker;
import pe.com.hermes.common.util.AsyncRunner;

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
                        navegar();
                    }

                    @Override
                    public void onError(Exception error) {
                        binding.tvEstado.setText("Sin conexión — continuando…");
                        navegar();
                    }
                }
        );
    }

    private void navegar() {
        Class<?> destino = AppUtils.app(this).getSession().sesionCompleta() ? MenuActivity.class : LoginActivity.class;
        startActivity(new Intent(this, destino));
        finish();
    }
}
