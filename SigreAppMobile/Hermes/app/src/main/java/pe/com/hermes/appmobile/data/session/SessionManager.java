package pe.com.hermes.appmobile.data.session;

import android.content.Context;
import android.content.SharedPreferences;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;
import java.io.IOException;
import java.security.GeneralSecurityException;

/**
 * Sesión Hermes en almacenamiento cifrado del dispositivo
 * ({@link EncryptedSharedPreferences}: AES-256-SIV claves + AES-256-GCM valores).
 * <p>
 * Incluye: token temporal, token definitivo (access), refresh, datos de sesión,
 * y opcionalmente usuario + contraseña cuando el usuario activa "Guardar sesión".
 * La URL del servidor vive en AppConfig (appconfig.json), no aquí.
 */
public class SessionManager {

    private static final String PREFS_NAME = "hermes_session_secure";

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
    private static final String KEY_RECORDAR_SESION = "recordar_sesion";
    private static final String KEY_LOGIN_USUARIO = "login_usuario";
    private static final String KEY_LOGIN_PASSWORD = "login_password";

    private final SharedPreferences prefs;

    public SessionManager(Context context) {
        try {
            MasterKey masterKey = new MasterKey.Builder(context)
                    .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                    .build();
            prefs = EncryptedSharedPreferences.create(
                    context,
                    PREFS_NAME,
                    masterKey,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            migrarDesdePrefsLegacySiExiste(context, masterKey);
        } catch (GeneralSecurityException | IOException e) {
            throw new RuntimeException("No se pudo inicializar la sesion cifrada", e);
        }
    }

    /** Migra una sola vez desde el archivo legacy {@code sigre_session}. */
    private void migrarDesdePrefsLegacySiExiste(Context context, MasterKey masterKey) {
        if (prefs.contains(KEY_ACCESS_TOKEN) || prefs.contains(KEY_LOGIN_USUARIO)) {
            return;
        }
        try {
            SharedPreferences legacy = EncryptedSharedPreferences.create(
                    context,
                    "sigre_session",
                    masterKey,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            if (legacy.getAll().isEmpty()) {
                return;
            }
            SharedPreferences.Editor editor = prefs.edit();
            for (String key : legacy.getAll().keySet()) {
                Object value = legacy.getAll().get(key);
                if (value instanceof String) {
                    editor.putString(key, (String) value);
                } else if (value instanceof Boolean) {
                    editor.putBoolean(key, (Boolean) value);
                } else if (value instanceof Long) {
                    editor.putLong(key, (Long) value);
                } else if (value instanceof Integer) {
                    editor.putInt(key, (Integer) value);
                }
            }
            editor.apply();
            legacy.edit().clear().apply();
        } catch (Exception ignored) {
            // Si no hay legacy o falla la migración, se inicia sesión limpia.
        }
    }

    public String getAccessToken() { return prefs.getString(KEY_ACCESS_TOKEN, null); }
    public void setAccessToken(String value) { prefs.edit().putString(KEY_ACCESS_TOKEN, value).apply(); }

    public String getRefreshToken() { return prefs.getString(KEY_REFRESH_TOKEN, null); }
    public void setRefreshToken(String value) { prefs.edit().putString(KEY_REFRESH_TOKEN, value).apply(); }

    public boolean isTemporal() { return prefs.getBoolean(KEY_TEMPORAL, false); }
    public void setTemporal(boolean value) { prefs.edit().putBoolean(KEY_TEMPORAL, value).apply(); }

    /**
     * Guarda token de acceso (temporal o definitivo) + refresh de forma cifrada.
     * {@code temporal=true} = post-login previo a empresa/sucursal; {@code false} = sesión definitiva.
     */
    public void guardarTokens(String accessToken, String refreshToken, boolean temporal) {
        SharedPreferences.Editor editor = prefs.edit()
                .putString(KEY_ACCESS_TOKEN, accessToken)
                .putBoolean(KEY_TEMPORAL, temporal);
        if (refreshToken != null) {
            editor.putString(KEY_REFRESH_TOKEN, refreshToken);
        }
        editor.apply();
    }

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

    public String getLoginUsuario() { return prefs.getString(KEY_LOGIN_USUARIO, null); }
    public String getLoginPassword() { return prefs.getString(KEY_LOGIN_PASSWORD, null); }

    /** Usuario y contraseña cifrados en el almacén seguro del dispositivo. */
    public void guardarCredenciales(String usuario, String password) {
        prefs.edit()
                .putString(KEY_LOGIN_USUARIO, usuario != null ? usuario : "")
                .putString(KEY_LOGIN_PASSWORD, password != null ? password : "")
                .apply();
    }

    public void limpiarCredenciales() {
        prefs.edit()
                .remove(KEY_LOGIN_USUARIO)
                .remove(KEY_LOGIN_PASSWORD)
                .apply();
    }

    public boolean tieneCredencialesGuardadas() {
        String usuario = getLoginUsuario();
        String password = getLoginPassword();
        return usuario != null && !usuario.isBlank()
                && password != null && !password.isEmpty();
    }

    /** true = login final completo (empresa+sucursal ya seleccionadas, hay access token). */
    public boolean sesionCompleta() {
        String token = getAccessToken();
        return token != null && !token.trim().isEmpty() && !isTemporal() && getSucursalId() > 0;
    }

    public boolean isRecordarSesion() {
        return prefs.getBoolean(KEY_RECORDAR_SESION, false);
    }

    public void setRecordarSesion(boolean value) {
        prefs.edit().putBoolean(KEY_RECORDAR_SESION, value).apply();
    }

    /**
     * Aplica la preferencia "Guardar sesión": tokens/datos ya están cifrados;
     * si recordar=true también persiste usuario/contraseña cifrados.
     */
    public void aplicarPreferenciaGuardarSesion(boolean recordar, String usuario, String password) {
        setRecordarSesion(recordar);
        if (recordar) {
            guardarCredenciales(usuario, password);
        } else {
            limpiarCredenciales();
        }
    }

    /** Sesión completa + el usuario pidió guardarla. */
    public boolean puedeReutilizarSesion() {
        return sesionCompleta() && isRecordarSesion();
    }

    public void limpiar() {
        prefs.edit().clear().apply();
    }
}
