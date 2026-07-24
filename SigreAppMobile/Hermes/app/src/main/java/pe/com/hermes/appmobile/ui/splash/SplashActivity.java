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
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;
import pe.com.hermes.appmobile.util.ConnectivityChecker;
import pe.com.hermes.appmobile.util.PlayAppUpdateHelper;
import pe.com.hermes.common.util.AsyncRunner;

/**
 * Pantalla de inicio: permisos → Google Play Update → servidor → registro dispositivo → login.
 * <p>
 * Actualización Play: aviso si hay 1–3 revisiones de atraso; si hay 4+ (ej. 268→276),
 * diálogo obligatorio con Aceptar y descarga/instalación inmediata.
 */
public class SplashActivity extends AppCompatActivity {

    private ActivitySplashBinding binding;
    private PlayAppUpdateHelper playAppUpdateHelper;
    private boolean registrando;
    private boolean permisosSolicitados;
    private boolean updateCheckHecho;

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
            verificarActualizacionPlay();
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
            verificarActualizacionPlay();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (playAppUpdateHelper != null) {
            playAppUpdateHelper.resumeIfNeeded();
        }
        if (updateCheckHecho
                && binding.grupoAcciones.getVisibility() == View.VISIBLE
                && binding.btnConfigurarServidor.getVisibility() == View.VISIBLE
                && !registrando
                && !permisosSolicitados) {
            iniciarValidacion();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (playAppUpdateHelper != null) {
            playAppUpdateHelper.onActivityResult(requestCode, resultCode);
        }
    }

    @Override
    protected void onDestroy() {
        if (playAppUpdateHelper != null) {
            playAppUpdateHelper.unregister();
            playAppUpdateHelper = null;
        }
        super.onDestroy();
    }

    /** Primero Play Update; si no hay bloqueo, sigue con servidor/dispositivo. */
    private void verificarActualizacionPlay() {
        binding.tvEstado.setText(R.string.splash_verificando_actualizacion);
        ocultarAcciones();
        playAppUpdateHelper = new PlayAppUpdateHelper(this, () -> {
            updateCheckHecho = true;
            iniciarValidacion();
        });
        playAppUpdateHelper.checkOnStartup();
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
        // Siempre pedir credenciales: no saltar al dashboard por sesión residual.
        startActivity(new Intent(this, LoginActivity.class));
        finish();
    }
}
