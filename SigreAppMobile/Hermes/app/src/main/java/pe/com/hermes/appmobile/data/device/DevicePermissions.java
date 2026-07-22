package pe.com.hermes.appmobile.data.device;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.util.ArrayList;
import java.util.List;

/**
 * Permisos peligrosos para registrar dispositivo (IMEI / WiFi en Android 10+).
 * INTERNET, ACCESS_NETWORK_STATE y ACCESS_WIFI_STATE son normales (solo Manifest).
 */
public final class DevicePermissions {

    public static final int REQUEST_CODE = 4101;

    private DevicePermissions() {}

    /** Solo permisos que requieren diálogo en runtime. */
    public static String[] peligrosos() {
        List<String> perms = new ArrayList<>();
        perms.add(Manifest.permission.READ_PHONE_STATE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            perms.add(Manifest.permission.ACCESS_FINE_LOCATION);
            perms.add(Manifest.permission.ACCESS_COARSE_LOCATION);
        }
        return perms.toArray(new String[0]);
    }

    /** @return true si ya estaban concedidos o no aplican; false si se mostró el diálogo. */
    public static boolean solicitarSiFalta(Activity activity) {
        List<String> faltantes = new ArrayList<>();
        for (String p : peligrosos()) {
            if (ContextCompat.checkSelfPermission(activity, p) != PackageManager.PERMISSION_GRANTED) {
                faltantes.add(p);
            }
        }
        if (faltantes.isEmpty()) {
            return true;
        }
        ActivityCompat.requestPermissions(
                activity,
                faltantes.toArray(new String[0]),
                REQUEST_CODE);
        return false;
    }
}
