package pe.com.hermes.appmobile.data.session;

import android.content.Context;
import android.content.SharedPreferences;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;
import java.io.IOException;
import java.security.GeneralSecurityException;

/**
 * Sesion (token JWT + datos de usuario/empresa/sucursal), cifrada en EncryptedSharedPreferences.
 * La URL del servidor NO vive aqui — ver AppConfig (archivo appconfig.json en almacenamiento
 * privado de la app), a pedido explicito: "configuracion... en un archivo... dentro de la app".
 */
public class SessionManager {

    private static final String KEY_ACCESS_TOKEN = "access_token";
    private static final String KEY_REFRESH_TOKEN = "refresh_token";
    private static final String KEY_TEMPORAL = "temporal";
    private static final String KEY_USER_ID = "user_id";
    private static final String KEY_NOMBRE = "nombre_completo";
    private static final String KEY_EMAIL = "email";
    private static final String KEY_EMPRESA_ID = "empresa_id";
    private static final String KEY_EMPRESA_NOMBRE = "empresa_nombre";
    private static final String KEY_SUCURSAL_ID = "sucursal_id";
    private static final String KEY_SUCURSAL_NOMBRE = "sucursal_nombre";

    private final SharedPreferences prefs;

    public SessionManager(Context context) {
        try {
            MasterKey masterKey = new MasterKey.Builder(context)
                    .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                    .build();
            prefs = EncryptedSharedPreferences.create(
                    context,
                    "sigre_session",
                    masterKey,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
        } catch (GeneralSecurityException | IOException e) {
            throw new RuntimeException("No se pudo inicializar la sesion cifrada", e);
        }
    }

    public String getAccessToken() { return prefs.getString(KEY_ACCESS_TOKEN, null); }
    public void setAccessToken(String value) { prefs.edit().putString(KEY_ACCESS_TOKEN, value).apply(); }

    public String getRefreshToken() { return prefs.getString(KEY_REFRESH_TOKEN, null); }
    public void setRefreshToken(String value) { prefs.edit().putString(KEY_REFRESH_TOKEN, value).apply(); }

    public boolean isTemporal() { return prefs.getBoolean(KEY_TEMPORAL, false); }
    public void setTemporal(boolean value) { prefs.edit().putBoolean(KEY_TEMPORAL, value).apply(); }

    public long getUserId() { return prefs.getLong(KEY_USER_ID, -1); }
    public void setUserId(long value) { prefs.edit().putLong(KEY_USER_ID, value).apply(); }

    public String getNombreCompleto() { return prefs.getString(KEY_NOMBRE, null); }
    public void setNombreCompleto(String value) { prefs.edit().putString(KEY_NOMBRE, value).apply(); }

    public String getEmail() { return prefs.getString(KEY_EMAIL, null); }
    public void setEmail(String value) { prefs.edit().putString(KEY_EMAIL, value).apply(); }

    public long getEmpresaId() { return prefs.getLong(KEY_EMPRESA_ID, -1); }
    public void setEmpresaId(long value) { prefs.edit().putLong(KEY_EMPRESA_ID, value).apply(); }

    public String getEmpresaNombre() { return prefs.getString(KEY_EMPRESA_NOMBRE, null); }
    public void setEmpresaNombre(String value) { prefs.edit().putString(KEY_EMPRESA_NOMBRE, value).apply(); }

    public long getSucursalId() { return prefs.getLong(KEY_SUCURSAL_ID, -1); }
    public void setSucursalId(long value) { prefs.edit().putLong(KEY_SUCURSAL_ID, value).apply(); }

    public String getSucursalNombre() { return prefs.getString(KEY_SUCURSAL_NOMBRE, null); }
    public void setSucursalNombre(String value) { prefs.edit().putString(KEY_SUCURSAL_NOMBRE, value).apply(); }

    /** true = login final completo (empresa+sucursal ya seleccionadas, hay refreshToken). */
    public boolean sesionCompleta() {
        String token = getAccessToken();
        return token != null && !token.trim().isEmpty() && !isTemporal() && getSucursalId() > 0;
    }

    public void limpiar() {
        prefs.edit().clear().apply();
    }
}
