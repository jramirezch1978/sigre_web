package pe.com.hermes.common.ui

import android.app.Activity
import android.app.Application
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.enableEdgeToEdge
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

/**
 * Edge-to-edge seguro (obligatorio desde Android 15/API 35) — equivalente
 * moderno de EdgeToEdgeHelper.java de FastSales.
 */
object EdgeToEdgeHelper {

    fun enable(activity: ComponentActivity) {
        activity.enableEdgeToEdge()
    }

    /** Aplica el padding de las barras del sistema (status/navigation) al contenido. */
    fun aplicarInsetsAlContenido(activity: Activity, rootViewId: Int) {
        val root = activity.findViewById<android.view.View>(rootViewId) ?: return
        ViewCompat.setOnApplyWindowInsetsListener(root) { view, insets ->
            val barras = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.setPadding(barras.left, barras.top, barras.right, barras.bottom)
            insets
        }
    }

    /** Registrar una vez en Application.onCreate() para aplicarlo automáticamente a todas las Activities. */
    fun registrarGlobal(application: Application) {
        application.registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
                if (activity is ComponentActivity) activity.enableEdgeToEdge()
            }
            override fun onActivityStarted(activity: Activity) {}
            override fun onActivityResumed(activity: Activity) {}
            override fun onActivityPaused(activity: Activity) {}
            override fun onActivityStopped(activity: Activity) {}
            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
            override fun onActivityDestroyed(activity: Activity) {}
        })
    }
}
