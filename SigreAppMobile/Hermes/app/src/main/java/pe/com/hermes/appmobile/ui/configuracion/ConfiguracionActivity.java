package pe.com.hermes.appmobile.ui.configuracion;

import android.app.Dialog;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.AuthMeDto;
import pe.com.hermes.appmobile.data.remote.dto.CodigoEmailResponse;
import pe.com.hermes.appmobile.data.remote.dto.PerfilUpdateRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityConfiguracionBinding;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.common.ui.ConfirmDialog;
import pe.com.hermes.common.ui.LoadingDialog;
import pe.com.hermes.common.ui.ValidInputHelper;
import pe.com.hermes.common.validation.InputValidators;

/**
 * Perfil del usuario autenticado.
 * Si el email es nuevo/cambió o no está confirmado, exige código (reuso del flujo recovery).
 */
public class ConfiguracionActivity extends AppCompatActivity {

    private ActivityConfiguracionBinding binding;
    private AuthRepository authRepository;
    private Dialog loadingDialog;

    private String emailOriginal = "";
    private boolean emailConfirmado;
    private boolean codigoEnviado;
    private CountDownTimer timerValidez;
    private CountDownTimer timerReenvio;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityConfiguracionBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        binding.toolbar.setNavigationOnClickListener(v -> finish());
        binding.btnGuardar.setOnClickListener(v -> confirmarYGuardar());
        binding.btnReenviar.setOnClickListener(v -> enviarCodigo(true));
        ValidInputHelper.bindEmail(binding.tilEmail);

        cargarPerfil();
    }

    @Override
    protected void onDestroy() {
        cancelTimers();
        LoadingDialog.cerrar(this, loadingDialog);
        super.onDestroy();
    }

    private void cargarPerfil() {
        mostrarLoading("Cargando perfil…");
        authRepository.obtenerPerfil(new ResultCallback<AuthMeDto>() {
            @Override
            public void onSuccess(AuthMeDto data) {
                ocultarLoading();
                pintarPerfil(data);
            }

            @Override
            public void onError(String mensaje) {
                ocultarLoading();
                AppUtils.toast(ConfiguracionActivity.this,
                        mensaje != null ? mensaje : getString(R.string.config_error_cargar));
            }
        });
    }

    private void pintarPerfil(AuthMeDto data) {
        emailOriginal = data.email != null ? data.email.trim() : "";
        emailConfirmado = Boolean.TRUE.equals(data.flagConfirmacionEmail);

        binding.etUsername.setText(data.username);
        binding.etNombres.setText(data.nombres);
        binding.etApellidos.setText(data.apellidos);
        binding.etDocumento.setText(data.numeroDocumento);
        binding.etEmail.setText(emailOriginal);
        actualizarEstadoEmailUi();
    }

    private void actualizarEstadoEmailUi() {
        if (emailConfirmado) {
            binding.tvEmailEstado.setText(R.string.config_email_confirmado);
            binding.tvEmailEstado.setTextColor(getColor(R.color.sigre_success));
        } else {
            binding.tvEmailEstado.setText(R.string.config_email_pendiente);
            binding.tvEmailEstado.setTextColor(getColor(R.color.sigre_warning));
        }
    }

    private void confirmarYGuardar() {
        String nombres = texto(binding.etNombres);
        String email = texto(binding.etEmail);
        if (nombres.isEmpty() || email.isEmpty()) {
            AppUtils.toast(this, getString(R.string.config_error_campos));
            return;
        }
        if (!InputValidators.email().isValid(email)) {
            AppUtils.toast(this, "Correo electrónico inválido");
            return;
        }

        ConfirmDialog.mostrar(
                this,
                getString(R.string.config_confirmar_guardar_titulo),
                getString(R.string.config_confirmar_guardar_mensaje),
                true,
                this::procesarGuardado);
    }

    private void procesarGuardado() {
        String email = texto(binding.etEmail);
        boolean requiereCodigo = requiereVerificacionEmail(email);

        if (requiereCodigo && !codigoEnviado) {
            enviarCodigo(false);
            return;
        }
        if (requiereCodigo && texto(binding.etCodigo).isEmpty()) {
            AppUtils.toast(this, "Ingrese el código enviado a su correo");
            mostrarPanelCodigo(true);
            return;
        }
        guardar(email);
    }

    private boolean requiereVerificacionEmail(String email) {
        boolean cambio = !email.equalsIgnoreCase(emailOriginal);
        return cambio || !emailConfirmado;
    }

    private void enviarCodigo(boolean esReenvio) {
        String email = texto(binding.etEmail);
        if (email.isEmpty()) {
            AppUtils.toast(this, getString(R.string.config_error_campos));
            return;
        }
        mostrarLoading(esReenvio ? "Reenviando código…" : "Enviando código…");
        authRepository.enviarCodigoConfirmacionEmail(email, new ResultCallback<CodigoEmailResponse>() {
            @Override
            public void onSuccess(CodigoEmailResponse data) {
                ocultarLoading();
                codigoEnviado = true;
                mostrarPanelCodigo(true);
                iniciarContadores(
                        data.validezSegundos > 0 ? data.validezSegundos : 300,
                        data.reenvioSegundos > 0 ? data.reenvioSegundos : 30);
                AppUtils.toast(ConfiguracionActivity.this, "Código enviado a " + email);
            }

            @Override
            public void onError(String mensaje) {
                ocultarLoading();
                AppUtils.toast(ConfiguracionActivity.this,
                        mensaje != null ? mensaje : "No se pudo enviar el código");
            }
        });
    }

    private void guardar(String email) {
        String codigo = texto(binding.etCodigo);
        PerfilUpdateRequest request = new PerfilUpdateRequest(
                texto(binding.etNombres),
                texto(binding.etApellidos),
                texto(binding.etDocumento),
                email,
                requiereVerificacionEmail(email) ? codigo : null);

        mostrarLoading("Guardando…");
        authRepository.actualizarPerfil(request, new ResultCallback<AuthMeDto>() {
            @Override
            public void onSuccess(AuthMeDto data) {
                ocultarLoading();
                cancelTimers();
                codigoEnviado = false;
                mostrarPanelCodigo(false);
                binding.etCodigo.setText("");
                pintarPerfil(data);
                AppUtils.toast(ConfiguracionActivity.this, getString(R.string.config_guardado_ok));
            }

            @Override
            public void onError(String mensaje) {
                ocultarLoading();
                AppUtils.toast(ConfiguracionActivity.this,
                        mensaje != null ? mensaje : "No se pudo guardar");
            }
        });
    }

    private void mostrarPanelCodigo(boolean visible) {
        binding.panelCodigo.setVisibility(visible ? View.VISIBLE : View.GONE);
    }

    private void iniciarContadores(int validezSegundos, int reenvioSegundos) {
        cancelTimers();
        binding.btnReenviar.setEnabled(false);
        binding.btnReenviar.setAlpha(0.4f);

        timerValidez = new CountDownTimer(validezSegundos * 1000L, 1000L) {
            @Override
            public void onTick(long millisUntilFinished) {
                binding.tvContador.setText(getString(
                        R.string.config_contador_codigo, formatoMmSs(millisUntilFinished)));
            }

            @Override
            public void onFinish() {
                binding.tvContador.setText("El código expiró. Solicite uno nuevo.");
                codigoEnviado = false;
            }
        }.start();

        timerReenvio = new CountDownTimer(reenvioSegundos * 1000L, 1000L) {
            @Override
            public void onTick(long millisUntilFinished) {
                binding.btnReenviar.setText(getString(
                        R.string.config_reenvio_en, formatoMmSs(millisUntilFinished)));
            }

            @Override
            public void onFinish() {
                binding.btnReenviar.setText(R.string.config_reenviar_codigo);
                binding.btnReenviar.setEnabled(true);
                binding.btnReenviar.setAlpha(1f);
            }
        }.start();
    }

    private void cancelTimers() {
        if (timerValidez != null) {
            timerValidez.cancel();
            timerValidez = null;
        }
        if (timerReenvio != null) {
            timerReenvio.cancel();
            timerReenvio = null;
        }
    }

    private void mostrarLoading(String mensaje) {
        LoadingDialog.cerrar(this, loadingDialog);
        loadingDialog = LoadingDialog.mostrar(this, mensaje);
    }

    private void ocultarLoading() {
        LoadingDialog.cerrar(this, loadingDialog);
        loadingDialog = null;
    }

    private static String formatoMmSs(long millis) {
        long totalSeg = Math.max(0, millis / 1000L);
        long min = totalSeg / 60L;
        long seg = totalSeg % 60L;
        return String.format("%d:%02d", min, seg);
    }

    private static String texto(EditText edit) {
        return edit.getText() != null ? edit.getText().toString().trim() : "";
    }
}
