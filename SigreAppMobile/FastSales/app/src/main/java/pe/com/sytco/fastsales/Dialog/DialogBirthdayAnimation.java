package pe.com.sytco.fastsales.Dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.annotation.NonNull;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.BirthdayAnimationView;

/**
 * Diálogo para mostrar la animación de cumpleaños con confetti y fuegos artificiales.
 * Se muestra en pantalla completa y se cierra automáticamente después de 2.5 segundos.
 */
public class DialogBirthdayAnimation extends Dialog {
    
    private Context context;
    private String nombreTrabajador;
    private OnAnimationFinishedListener listener;
    private BirthdayAnimationView animationView;
    private TextView tvNombreTrabajador;
    private Handler handler;
    
    /**
     * Interfaz para notificar cuando la animación ha terminado
     */
    public interface OnAnimationFinishedListener {
        void onAnimationFinished();
    }
    
    /**
     * Constructor
     * @param context Contexto de la aplicación
     * @param nombreTrabajador Nombre del trabajador que cumple años
     * @param listener Listener para notificar cuando la animación termine
     */
    public DialogBirthdayAnimation(@NonNull Context context, String nombreTrabajador, OnAnimationFinishedListener listener) {
        super(context, android.R.style.Theme_Black_NoTitleBar_Fullscreen);
        this.context = context;
        this.nombreTrabajador = nombreTrabajador;
        this.listener = listener;
        this.handler = new Handler();
    }
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_birthday_animation);
        
        // Configurar ventana como pantalla completa
        Window window = getWindow();
        if (window != null) {
            window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
            window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            
            // Ocultar la barra de estado y hacer que la ventana se superponga
            window.setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN
            );
        }
        
        // No se puede cancelar con el botón atrás
        setCancelable(false);
        
        // Inicializar vistas
        animationView = findViewById(R.id.birthdayAnimationView);
        tvNombreTrabajador = findViewById(R.id.tvNombreTrabajador);
        
        // Establecer nombre del trabajador
        if (nombreTrabajador != null && !nombreTrabajador.isEmpty()) {
            tvNombreTrabajador.setText(nombreTrabajador.toUpperCase());
        }
    }
    
    @Override
    protected void onStart() {
        super.onStart();
        
        // Iniciar la animación
        if (animationView != null) {
            animationView.startAnimation();
        }
        
        // Auto-cerrar después de 2.5 segundos
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                dismiss();
                if (listener != null) {
                    listener.onAnimationFinished();
                }
            }
        }, 2500); // 2.5 segundos
    }
    
    @Override
    protected void onStop() {
        super.onStop();
        
        // Detener la animación
        if (animationView != null) {
            animationView.stopAnimation();
        }
        
        // Cancelar callbacks pendientes
        if (handler != null) {
            handler.removeCallbacksAndMessages(null);
        }
    }
}
