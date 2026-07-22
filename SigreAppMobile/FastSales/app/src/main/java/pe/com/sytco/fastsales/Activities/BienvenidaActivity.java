package pe.com.sytco.fastsales.Activities;

import android.animation.ObjectAnimator;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.util.Base64;
import android.view.animation.DecelerateInterpolator;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanEmpresa;

public class BienvenidaActivity extends AppCompatActivity {

    private TextView tvSaludo;
    private TextView tvNombreUsuario;
    private TextView tvNombreEmpresaBienvenida;
    private TextView tvHoraActual;
    private TextView tvVersionBienvenida;
    private ImageView ivLogoEmpresaBienvenida;
    private ProgressBar progressBarBienvenida;

    private Handler handler;
    private Runnable updateTimeRunnable;
    private static final int DURACION_PANTALLA = 3500; // 3.5 segundos

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bienvenida);

        initControllers();
        cargarDatos();
        iniciarReloj();
        iniciarProgreso();
    }

    private void initControllers() {
        tvSaludo = findViewById(R.id.tvSaludo);
        tvNombreUsuario = findViewById(R.id.tvNombreUsuario);
        tvNombreEmpresaBienvenida = findViewById(R.id.tvNombreEmpresaBienvenida);
        tvHoraActual = findViewById(R.id.tvHoraActual);
        tvVersionBienvenida = findViewById(R.id.tvVersionBienvenida);
        ivLogoEmpresaBienvenida = findViewById(R.id.ivLogoEmpresaBienvenida);
        progressBarBienvenida = findViewById(R.id.progressBarBienvenida);

        // Obtener versión de la app
        try {
            String versionName = getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
            tvVersionBienvenida.setText("v" + versionName);
        } catch (PackageManager.NameNotFoundException e) {
            tvVersionBienvenida.setText("");
        }
    }

    private void cargarDatos() {
        // Obtener datos del Intent
        Intent intent = getIntent();
        String nombreUsuario = intent.getStringExtra("NOMBRE_USUARIO");
        
        // Cargar información de la empresa
        BeanEmpresa empresa = ImplEmpresa.empresaDefault;
        
        if (empresa != null) {
            // Nombre de la empresa
            tvNombreEmpresaBienvenida.setText(empresa.getRazonSocial());
            
            // Cargar logo desde Base64
            cargarLogoEmpresa(empresa);
        }

        // Nombre del usuario
        if (nombreUsuario != null && !nombreUsuario.isEmpty()) {
            tvNombreUsuario.setText(nombreUsuario);
        } else {
            tvNombreUsuario.setText("Usuario");
        }

        // Saludo según la hora
        tvSaludo.setText(obtenerSaludo());
    }

    /**
     * Obtiene el saludo apropiado según la hora del día
     */
    private String obtenerSaludo() {
        Calendar calendario = Calendar.getInstance();
        int hora = calendario.get(Calendar.HOUR_OF_DAY);

        if (hora >= 0 && hora < 12) {
            return "¡Buenos días!";
        } else if (hora >= 12 && hora < 19) {
            return "¡Buenas tardes!";
        } else {
            return "¡Buenas noches!";
        }
    }

    /**
     * Carga el logo de la empresa desde Base64
     */
    private void cargarLogoEmpresa(BeanEmpresa empresa) {
        try {
            String logoBase64 = empresa.getLogoBase64();
            
            if (logoBase64 != null && !logoBase64.isEmpty()) {
                // Decodificar Base64 a Bitmap
                byte[] decodedBytes = Base64.decode(logoBase64, Base64.DEFAULT);
                Bitmap bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
                
                if (bitmap != null) {
                    ivLogoEmpresaBienvenida.setImageBitmap(bitmap);
                } else {
                    // Error al decodificar
                    mostrarErrorLogo("Error al decodificar la imagen del logo de la empresa");
                }
            } else {
                // No hay logo disponible
                String logoFile = empresa.getLogoFile();
                if (logoFile != null && !logoFile.isEmpty()) {
                    mostrarErrorLogo("No se pudo cargar el logo de la empresa (" + logoFile + ").\n\nPor favor, coordine con el administrador del sistema para verificar que el archivo exista en el servidor.");
                } else {
                    // Usar logo por defecto sin mostrar error (no hay logo configurado)
                    ivLogoEmpresaBienvenida.setImageResource(R.drawable.icono_empresa);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            mostrarErrorLogo("Excepción al cargar el logo: " + e.getMessage() + "\n\nPor favor, coordine con el administrador del sistema.");
        }
    }
    
    /**
     * Muestra un mensaje de error sobre el logo pero continúa con la ejecución
     */
    private void mostrarErrorLogo(String mensaje) {
        // Usar logo por defecto
        ivLogoEmpresaBienvenida.setImageResource(R.drawable.icono_empresa);
        
        // Mostrar Toast con el mensaje de error
        Toast.makeText(this, mensaje, Toast.LENGTH_LONG).show();
    }

    /**
     * Inicia el reloj que se actualiza cada segundo
     */
    private void iniciarReloj() {
        handler = new Handler();
        updateTimeRunnable = new Runnable() {
            @Override
            public void run() {
                // Actualizar hora actual en formato 12 horas con AM/PM
                SimpleDateFormat sdf = new SimpleDateFormat("hh:mm:ss a", Locale.getDefault());
                String horaActual = sdf.format(new Date());
                tvHoraActual.setText(horaActual);

                // Ejecutar cada 1 segundo
                handler.postDelayed(this, 1000);
            }
        };
        handler.post(updateTimeRunnable);
    }

    /**
     * Inicia la barra de progreso y cierra la pantalla automáticamente
     */
    private void iniciarProgreso() {
        // Animar la barra de progreso
        ObjectAnimator progressAnimator = ObjectAnimator.ofInt(progressBarBienvenida, "progress", 0, 100);
        progressAnimator.setDuration(DURACION_PANTALLA);
        progressAnimator.setInterpolator(new DecelerateInterpolator());
        progressAnimator.start();

        // Cerrar la pantalla después de DURACION_PANTALLA milisegundos
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                navegarAHome();
            }
        }, DURACION_PANTALLA);
    }

    /**
     * Navega al HomeActivity
     */
    private void navegarAHome() {
        Intent intent = new Intent(BienvenidaActivity.this, HomeActivity.class);
        startActivity(intent);
        finish(); // Cerrar esta actividad para que no quede en el back stack
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Detener el handler del reloj
        if (handler != null && updateTimeRunnable != null) {
            handler.removeCallbacks(updateTimeRunnable);
        }
    }

    @Override
    public void onBackPressed() {
        // Deshabilitar el botón back para evitar que el usuario salga accidentalmente
        // No hacer nada
    }
}

