package pe.com.hermes.appmobile.ui.bienvenida;

import android.animation.ObjectAnimator;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.animation.DecelerateInterpolator;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.databinding.ActivityBienvenidaBinding;
import pe.com.hermes.appmobile.ui.menu.MenuActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;

/**
 * Pantalla de bienvenida post-login (paridad FastSales): saludo, usuario, empresa y progreso → menú.
 */
public class BienvenidaActivity extends AppCompatActivity {

    private static final int DURACION_MS = 3500;

    private ActivityBienvenidaBinding binding;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private Runnable relojRunnable;
    private Runnable navegarRunnable;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityBienvenidaBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        cargarDatos();
        binding.tvVersion.setText(AppVersion.etiqueta(this));
        iniciarReloj();
        iniciarProgreso();
    }

    private void cargarDatos() {
        SessionManager session = AppUtils.app(this).getSession();
        binding.tvSaludo.setText(obtenerSaludo());

        String nombre = session.getNombreCompleto();
        if (nombre == null || nombre.isBlank()) {
            nombre = getString(R.string.bienvenida_usuario_default);
        }
        binding.tvNombreUsuario.setText(nombre);

        String empresa = session.getEmpresaNombre();
        binding.tvNombreEmpresa.setText(
                empresa != null && !empresa.isBlank() ? empresa : getString(R.string.brand_name));

        String sucursal = session.getSucursalNombre();
        if (sucursal != null && !sucursal.isBlank()) {
            binding.tvSucursal.setText(sucursal);
            binding.tvSucursal.setVisibility(android.view.View.VISIBLE);
        } else {
            binding.tvSucursal.setVisibility(android.view.View.GONE);
        }
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

    private void iniciarReloj() {
        SimpleDateFormat sdf = new SimpleDateFormat("hh:mm:ss a", Locale.getDefault());
        relojRunnable = new Runnable() {
            @Override
            public void run() {
                binding.tvHoraActual.setText(sdf.format(new Date()));
                handler.postDelayed(this, 1000);
            }
        };
        handler.post(relojRunnable);
    }

    private void iniciarProgreso() {
        ObjectAnimator animator = ObjectAnimator.ofInt(binding.progressBienvenida, "progress", 0, 100);
        animator.setDuration(DURACION_MS);
        animator.setInterpolator(new DecelerateInterpolator());
        animator.start();

        navegarRunnable = () -> {
            startActivity(new Intent(BienvenidaActivity.this, MenuActivity.class));
            finish();
        };
        handler.postDelayed(navegarRunnable, DURACION_MS);
    }

    @Override
    protected void onDestroy() {
        if (relojRunnable != null) {
            handler.removeCallbacks(relojRunnable);
        }
        if (navegarRunnable != null) {
            handler.removeCallbacks(navegarRunnable);
        }
        super.onDestroy();
    }

    @Override
    public void onBackPressed() {
        // Evita salir durante la bienvenida (igual FastSales).
    }
}
