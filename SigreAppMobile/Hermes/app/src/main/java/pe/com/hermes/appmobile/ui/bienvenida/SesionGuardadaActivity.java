package pe.com.hermes.appmobile.ui.bienvenida;

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Calendar;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.databinding.ActivitySesionGuardadaBinding;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;

/**
 * Arranque con sesión cifrada guardada: continuar o cambiar de cuenta.
 */
public class SesionGuardadaActivity extends AppCompatActivity {

    private ActivitySesionGuardadaBinding binding;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivitySesionGuardadaBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SessionManager session = AppUtils.app(this).getSession();
        if (!session.puedeReutilizarSesion()) {
            irALoginLimpiando(session);
            return;
        }

        binding.tvSaludo.setText(obtenerSaludo());
        String nombre = session.getNombreCompleto();
        binding.tvNombreUsuario.setText(
                nombre != null && !nombre.isBlank() ? nombre : getString(R.string.bienvenida_usuario_default));

        String empresa = session.getEmpresaNombre() != null ? session.getEmpresaNombre() : "—";
        String sucursal = session.getSucursalNombre() != null ? session.getSucursalNombre() : "—";
        binding.tvEmpresaSucursal.setText(
                getString(R.string.sesion_guardada_empresa_sucursal, empresa, sucursal));
        binding.tvVersion.setText(AppVersion.etiqueta(this));

        binding.btnContinuar.setOnClickListener(v -> continuarConSesionGuardada());
        binding.btnCambiarCuenta.setOnClickListener(v -> irALoginLimpiando(session));
    }

    /** Pide access definitivo al backend y entra a bienvenida. */
    private void continuarConSesionGuardada() {
        binding.btnContinuar.setEnabled(false);
        binding.btnCambiarCuenta.setEnabled(false);
        new Thread(() -> {
            String token = AppUtils.app(this).getApiClient().asegurarAccessToken();
            runOnUiThread(() -> {
                if (token == null || token.isBlank()) {
                    binding.btnContinuar.setEnabled(true);
                    binding.btnCambiarCuenta.setEnabled(true);
                    irALoginLimpiando(AppUtils.app(this).getSession());
                    return;
                }
                startActivity(new Intent(this, BienvenidaActivity.class));
                finish();
            });
        }).start();
    }

    private void irALoginLimpiando(SessionManager session) {
        session.limpiar();
        startActivity(new Intent(this, LoginActivity.class));
        finish();
    }

    private String obtenerSaludo() {
        int hora = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
        if (hora < 12) {
            return "¡Buenos días!";
        }
        if (hora < 19) {
            return "¡Buenas tardes!";
        }
        return "¡Buenas noches!";
    }
}
