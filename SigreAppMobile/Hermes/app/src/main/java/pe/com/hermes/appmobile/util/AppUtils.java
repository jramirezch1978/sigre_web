package pe.com.hermes.appmobile.util;

import android.app.Activity;
import android.widget.Toast;
import pe.com.hermes.appmobile.SigreApplication;

/** Reemplazo en Java puro de las extension functions Activity.app / Activity.toast() de Kotlin. */
public final class AppUtils {

    private AppUtils() {
    }

    public static SigreApplication app(Activity activity) {
        return (SigreApplication) activity.getApplication();
    }

    public static void toast(Activity activity, String mensaje) {
        Toast.makeText(activity, mensaje, Toast.LENGTH_LONG).show();
    }
}
