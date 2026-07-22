package pe.com.hermes.appmobile.ui.splash;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.data.device.DevicePermissions;
import pe.com.hermes.appmobile.data.device.DeviceRegistrationFactory;
import pe.com.hermes.appmobile.data.device.DeviceRegistry;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivitySplashBinding;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.ui.menu.MenuActivity;
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;
import pe.com.hermes.appmobile.util.ConnectivityChecker;
import pe.com.hermes.common.util.AsyncRunner;

/**
 * Pantalla de inicio — equivalente al bloque previo al login de FastSales
 * (permisos + validar servidor + registrar dispositivo antes de credenciales).
 */
public class SplashActivity extends AppCompatActivity {

    private ActivitySplashBinding binding;
    private boolean registrando;
    private boolean permisosSolicitados;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivitySplashBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.tvVersion.setText(AppVersion.etiqueta(this));
        binding.btnReintentar.setOnClickListener(v -> iniciarValidacion());
        binding.btnConfigurarServidor.setOnClickListener(v ->
                startActivity(new Intent(this, ServidorListActivity.class)));

        binding.tvEstado.setText(R.string.splash_solicitando_permisos);
        if (DevicePermissions.solicitarSiFalta(this)) {
            iniciarValidacion();
        } else {
            permisosSolicitados = true;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == DevicePermissions.REQUEST_CODE && permisosSolicitados) {
            permisosSolicitados = false;
            iniciarValidacion();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (binding.grupoAcciones.getVisibility() == View.VISIBLE
                && binding.btnConfigurarServidor.getVisibility() == View.VISIBLE
                && !registrando
                && !permisosSolicitados) {
            iniciarValidacion();
        }
    }

    private void iniciarValidacion() {
        ocultarAcciones();
        binding.tvEstado.setText(R.string.splash_registrando_dispositivo);

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
            mostrarError(getString(R.string.splash_sin_servidor), true);
            return;
        }

        binding.tvEstado.setText(getString(R.string.login_servidor_titulo) + ": " + def.getNombre() + "…");
        AsyncRunner.ejecutar(
                () -> ConnectivityChecker.probar(def),
                new AsyncRunner.OnResultado<ConnectivityChecker.Resultado>() {
                    @Override
                    public void onExito(ConnectivityChecker.Resultado resultado) {
                        if (!resultado.conectado) {
                            mostrarError(getString(R.string.splash_sin_conexion), false);
                            return;
                        }
                        registrarDispositivo();
                    }

                    @Override
                    public void onError(Exception error) {
                        mostrarError(getString(R.string.splash_sin_conexion), false);
                    }
                }
        );
    }

    /** Recolecta IPs/IMEI en background y registra/revalida el dispositivo. */
    private void registrarDispositivo() {
        registrando = true;
        binding.tvEstado.setText(R.string.splash_registrando_dispositivo);

        AsyncRunner.ejecutar(
                () -> DeviceRegistrationFactory.crear(this),
                new AsyncRunner.OnResultado<RegistrarDispositivoRequest>() {
                    @Override
                    public void onExito(RegistrarDispositivoRequest request) {
                        enviarRegistro(request);
                    }

                    @Override
                    public void onError(Exception error) {
                        enviarRegistro(DeviceRegistrationFactory.crear(SplashActivity.this));
                    }
                }
        );
    }

    private void enviarRegistro(RegistrarDispositivoRequest request) {
        DeviceRegistry registry = AppUtils.app(this).getDeviceRegistry();
        AuthRepository authRepository = new AuthRepository(
                AppUtils.app(this).getApiClient(),
                AppUtils.app(this).getSession());

        authRepository.registrarDispositivo(request, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                registrando = false;
                registry.guardar(data.nroRegistro, data.autorizado);
                if (!data.autorizado) {
                    mostrarError(getString(R.string.splash_dispositivo_no_autorizado), false);
                    return;
                }
                String nro = data.nroRegistro != null ? data.nroRegistro : "";
                binding.tvEstado.setText(getString(R.string.splash_dispositivo_ok_nro, nro));
                Toast.makeText(
                        SplashActivity.this,
                        getString(R.string.splash_dispositivo_ok_nro, nro),
                        Toast.LENGTH_LONG).show();
                navegar();
            }

            @Override
            public void onError(String mensaje) {
                registrando = false;
                String detalle = mensaje != null && !mensaje.isBlank()
                        ? mensaje
                        : getString(R.string.splash_error_registro);
                mostrarError(detalle, false);
            }
        });
    }

    private void mostrarError(String mensaje, boolean mostrarConfigServidor) {
        binding.tvEstado.setText(mensaje);
        binding.grupoAcciones.setVisibility(View.VISIBLE);
        binding.btnConfigurarServidor.setVisibility(mostrarConfigServidor ? View.VISIBLE : View.GONE);
    }

    private void ocultarAcciones() {
        binding.grupoAcciones.setVisibility(View.GONE);
        binding.btnConfigurarServidor.setVisibility(View.GONE);
    }

    private void navegar() {
        Class<?> destino = AppUtils.app(this).getSession().sesionCompleta()
                ? MenuActivity.class
                : LoginActivity.class;
        startActivity(new Intent(this, destino));
        finish();
    }
}
