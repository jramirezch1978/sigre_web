package pe.com.hermes.appmobile.data.device;

import android.content.Context;
import android.content.SharedPreferences;
import android.provider.Settings;

/**
 * Identidad local del dispositivo — equivalente moderno del BeanAndroidDevice/deviceID
 * (Settings.Secure.ANDROID_ID) de FastSales. Se guarda en SharedPreferences simples (no
 * cifradas: no es un secreto, es solo el nro de registro que el backend ya conoce) y
 * SOBREVIVE el logout (SessionManager.limpiar() no la toca) — el equipo no debe volver
 * a pedir autorización cada vez que alguien cierra sesión en él.
 */
public class DeviceRegistry {

    private static final String PREFS = "hermes_device";
    private static final String KEY_NRO_REGISTRO = "nro_registro";
    private static final String KEY_AUTORIZADO = "autorizado";

    private final SharedPreferences prefs;

    public DeviceRegistry(Context context) {
        this.prefs = context.getApplicationContext().getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    /** Identificador estable del equipo (por app+firma+usuario del dispositivo). */
    public String obtenerDeviceId(Context context) {
        return Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
    }

    public String getNroRegistro() {
        return prefs.getString(KEY_NRO_REGISTRO, null);
    }

    public boolean isAutorizado() {
        if (getNroRegistro() == null) {
            return false;
        }
        return prefs.getBoolean(KEY_AUTORIZADO, false);
    }

    /** Registrado en backend y con flag_autorizado activo. */
    public boolean isDispositivoListo() {
        return getNroRegistro() != null && isAutorizado();
    }

    public void guardar(String nroRegistro, boolean autorizado) {
        prefs.edit().putString(KEY_NRO_REGISTRO, nroRegistro).putBoolean(KEY_AUTORIZADO, autorizado).apply();
    }
}
