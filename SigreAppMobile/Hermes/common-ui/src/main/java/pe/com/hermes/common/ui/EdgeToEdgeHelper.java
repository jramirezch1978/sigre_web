package pe.com.hermes.common.ui;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.view.View;
import androidx.activity.ComponentActivity;
import androidx.activity.EdgeToEdge;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

/**
 * Edge-to-edge seguro (obligatorio desde Android 15/API 35) — equivalente
 * moderno de EdgeToEdgeHelper.java de FastSales.
 */
public final class EdgeToEdgeHelper {

    private EdgeToEdgeHelper() {
    }

    public static void enable(ComponentActivity activity) {
        EdgeToEdge.enable(activity);
    }

    /** Aplica el padding de las barras del sistema (status/navigation) al contenido. */
    public static void aplicarInsetsAlContenido(Activity activity, int rootViewId) {
        View root = activity.findViewById(rootViewId);
        if (root == null) return;
        ViewCompat.setOnApplyWindowInsetsListener(root, (view, insets) -> {
            Insets barras = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            view.setPadding(barras.left, barras.top, barras.right, barras.bottom);
            return insets;
        });
    }

    /** Registrar una vez en Application.onCreate() para aplicarlo automaticamente a todas las Activities. */
    public static void registrarGlobal(Application application) {
        application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                if (activity instanceof ComponentActivity) {
                    EdgeToEdge.enable((ComponentActivity) activity);
                }
            }

            @Override public void onActivityStarted(Activity activity) {}
            @Override public void onActivityResumed(Activity activity) {}
            @Override public void onActivityPaused(Activity activity) {}
            @Override public void onActivityStopped(Activity activity) {}
            @Override public void onActivitySaveInstanceState(Activity activity, Bundle outState) {}
            @Override public void onActivityDestroyed(Activity activity) {}
        });
    }
}
