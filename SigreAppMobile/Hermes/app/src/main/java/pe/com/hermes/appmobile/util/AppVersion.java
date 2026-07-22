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
        int code = BuildConfig.VERSION_CODE;
        try {
            android.content.pm.PackageInfo info = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            if (info.versionName != null && !info.versionName.isBlank()) {
                name = info.versionName;
            }
            code = (int) info.getLongVersionCode();
        } catch (PackageManager.NameNotFoundException ignored) {
            // Fallback a BuildConfig.
        }
        if (name == null || name.isBlank()) {
            name = "—";
        }
        // FastSales muestra solo versionName; aquí el code facilita ver cada build.
        return "Version: " + name + " (" + code + ")";
    }
}
