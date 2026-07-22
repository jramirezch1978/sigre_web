package pe.com.sytco.fastsales.util;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import androidx.activity.ComponentActivity;
import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

/**
 * Edge-to-edge (Android 15 / targetSdk 35) sin usar
 * {@code Window.setStatusBarColor} / {@code setNavigationBarColor}.
 */
public final class EdgeToEdgeHelper {

    private EdgeToEdgeHelper() {
    }

    /** Llamar antes de {@code setContentView} (p. ej. onActivityPreCreated). */
    public static void enable(@Nullable Activity activity) {
        if (!(activity instanceof ComponentActivity)) {
            return;
        }
        try {
            EdgeToEdge.enable((ComponentActivity) activity);
        } catch (Exception ex) {
            LogHelper.e("EdgeToEdge", "No se pudo activar edge-to-edge", ex);
        }
    }

    /** Aplica padding de system bars al contenedor de contenido. */
    public static void applySystemBarInsets(@Nullable Activity activity) {
        if (activity == null) {
            return;
        }
        final View content = activity.findViewById(android.R.id.content);
        if (content == null) {
            return;
        }
        ViewCompat.setOnApplyWindowInsetsListener(content, (v, windowInsets) -> {
            Insets bars = windowInsets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(bars.left, bars.top, bars.right, bars.bottom);
            return windowInsets;
        });
        ViewCompat.requestApplyInsets(content);
    }

    /**
     * Callbacks de Application para aplicar edge-to-edge a todas las Activity.
     */
    public static final class LifecycleCallbacks implements android.app.Application.ActivityLifecycleCallbacks {

        @Override
        public void onActivityPreCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
            // Antes de Activity.onCreate / setContentView (requisito de EdgeToEdge).
            enable(activity);
        }

        @Override
        public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
            // Tras onCreate/setContentView: insets (también cubre API < 29 sin PostCreated).
            applySystemBarInsets(activity);
        }

        @Override
        public void onActivityStarted(@NonNull Activity activity) {
        }

        @Override
        public void onActivityResumed(@NonNull Activity activity) {
        }

        @Override
        public void onActivityPaused(@NonNull Activity activity) {
        }

        @Override
        public void onActivityStopped(@NonNull Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(@NonNull Activity activity) {
        }
    }
}
