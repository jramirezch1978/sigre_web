package pe.com.hermes.appmobile.util;

import android.content.Context;
import android.content.pm.PackageManager;
import pe.com.hermes.appmobile.BuildConfig;

/**
 * Texto de versión compilada — igual que FastSales
 * ({@code "Version: " + getPackageInfo(...).versionName}).
 */
public final class AppVersion {

    private AppVersion() {
    }

    public static String etiqueta(Context context) {
        String name = BuildConfig.VERSION_NAME;
        try {
            name = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0)
                    .versionName;
        } catch (PackageManager.NameNotFoundException ignored) {
            // Fallback a BuildConfig.
        }
        if (name == null || name.isBlank()) {
            name = "—";
        }
        return "Version: " + name;
    }
}
