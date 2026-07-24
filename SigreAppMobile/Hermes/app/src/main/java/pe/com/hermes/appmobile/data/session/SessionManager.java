package pe.com.hermes.appmobile.data.session;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Base64;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;

/**
 * Sesión Hermes cifrada (EncryptedSharedPreferences AES-256).
 * <p>
 * Persistido: refresh, datos de usuario/empresa/sucursal y (opcional) credenciales.
 * Access token (temporal o definitivo) solo vive en memoria: se obtiene al llamar APIs;
 * el backend reutiliza el JWT definitivo en {@code tokens_session}.
 */
public class SessionManager {

    private static final String PREFS_NAME = "hermes_session_secure";
    private static final Pattern JWT_EXP = Pattern.compile("\"exp\"\\s*:\\s*(\\d+)");

    private static final String KEY_REFRESH_TOKEN = "refresh_token";
    private static final String KEY_TEMPORAL = "temporal";
    private static final String KEY_USER_ID = "user_id";
    private static final String KEY_EMAIL = "email";
    private static final String KEY_USERNAME = "username";
    private static final String KEY_NOMBRES = "nombres";
    private static final String KEY_APELLIDOS = "apellidos";
    private static final String KEY_NOMBRE = "nombre_completo";
    private static final String KEY_ADMIN_SISTEMA = "admin_sistema";
    private static final String KEY_TIPO_SALES = "tipo_sales";
    private static final String KEY_EMPRESA_ID = "empresa_id";
    private static final String KEY_EMPRESA_CODIGO = "empresa_codigo";
    private static final String KEY_EMPRESA_NOMBRE = "empresa_nombre";
    private static final String KEY_EMPRESA_RUC = "empresa_ruc";
    private static final String KEY_SUCURSAL_ID = "sucursal_id";
    private static final String KEY_SUCURSAL_NOMBRE = "sucursal_nombre";
    private static final String KEY_RECORDAR_SESION = "recordar_sesion";
    private static final String KEY_LOGIN_USUARIO = "login_usuario";
    private static final String KEY_LOGIN_PASSWORD = "login_password";

    private final SharedPreferences prefs;

    /** Access JWT solo en RAM (no se persiste). */
    private volatile String accessTokenMemoria;
    private volatile boolean accessTemporalMemoria;

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
            // Por política: nunca reutilizar access persistido de versiones anteriores.
            prefs.edit().remove("access_token").apply();
        } catch (GeneralSecurityException | IOException e) {
            throw new RuntimeException("No se pudo inicializar la sesion cifrada", e);
        }
    }

    private void migrarDesdePrefsLegacySiExiste(Context context, MasterKey masterKey) {
        if (prefs.contains(KEY_REFRESH_TOKEN) || prefs.contains(KEY_LOGIN_USUARIO) || prefs.contains(KEY_EMPRESA_ID)) {
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
                if ("access_token".equals(key)) {
                    continue; // no migrar access definitivo/temporal
                }
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
            // Sin legacy usable.
        }
    }

    public String getAccessToken() {
        return accessTokenMemoria;
    }

    public void setAccessTokenMemoria(String token, boolean temporal) {
        this.accessTokenMemoria = token;
        this.accessTemporalMemoria = temporal;
    }

    public void limpiarAccessMemoria() {
        this.accessTokenMemoria = null;
        this.accessTemporalMemoria = false;
    }

    /** true si hay access en memoria y no vence en {@code margenSegundos}. */
    public boolean tieneAccessValidoEnMemoria(int margenSegundos) {
        String token = accessTokenMemoria;
        return token != null && !token.isBlank() && !jwtVenceEnSegundos(token, margenSegundos);
    }

    public static boolean jwtVenceEnSegundos(String jwt, int margenSegundos) {
        if (jwt == null || jwt.isBlank()) {
            return true;
        }
        try {
            String[] parts = jwt.split("\\.");
            if (parts.length < 2) {
                return true;
            }
            String payload = parts[1];
            int pad = (4 - payload.length() % 4) % 4;
            if (pad > 0) {
                payload = payload + "====".substring(0, pad);
            }
            String json = new String(
                    Base64.decode(payload, Base64.URL_SAFE | Base64.NO_WRAP),
                    StandardCharsets.UTF_8);
            Matcher m = JWT_EXP.matcher(json);
            if (!m.find()) {
                return true;
            }
            long exp = Long.parseLong(m.group(1));
            long ahora = System.currentTimeMillis() / 1000L;
            return ahora >= (exp - margenSegundos);
        } catch (Exception e) {
            return true;
        }
    }

    public String getRefreshToken() { return prefs.getString(KEY_REFRESH_TOKEN, null); }
    public void setRefreshToken(String value) { prefs.edit().putString(KEY_REFRESH_TOKEN, value).apply(); }

    public boolean isTemporal() {
        if (accessTokenMemoria != null) {
            return accessTemporalMemoria;
        }
        return prefs.getBoolean(KEY_TEMPORAL, false);
    }

    public void setTemporal(boolean value) { prefs.edit().putBoolean(KEY_TEMPORAL, value).apply(); }

    /**
     * Actualiza tokens en memoria; solo el refresh se persiste cifrado.
     * El access definitivo/temporal NO se guarda en disco.
     */
    public void guardarTokens(String accessToken, String refreshToken, boolean temporal) {
        setAccessTokenMemoria(accessToken, temporal);
        SharedPreferences.Editor editor = prefs.edit()
                .putBoolean(KEY_TEMPORAL, temporal)
                .remove("access_token");
        if (refreshToken != null && !refreshToken.isBlank()) {
            editor.putString(KEY_REFRESH_TOKEN, refreshToken);
        }
        editor.apply();
    }

    public long getUserId() { return prefs.getLong(KEY_USER_ID, -1); }
    public void setUserId(long value) { prefs.edit().putLong(KEY_USER_ID, value).apply(); }

    public String getEmail() { return prefs.getString(KEY_EMAIL, null); }
    public void setEmail(String value) { prefs.edit().putString(KEY_EMAIL, value).apply(); }

    public String getUsername() { return prefs.getString(KEY_USERNAME, null); }
    public String getNombres() { return prefs.getString(KEY_NOMBRES, null); }
    public String getApellidos() { return prefs.getString(KEY_APELLIDOS, null); }

    public String getNombreCompleto() { return prefs.getString(KEY_NOMBRE, null); }
    public void setNombreCompleto(String value) { prefs.edit().putString(KEY_NOMBRE, value).apply(); }

    public boolean isAdminSistema() { return prefs.getBoolean(KEY_ADMIN_SISTEMA, false); }
    public String getTipoSales() { return prefs.getString(KEY_TIPO_SALES, null); }

    public long getEmpresaId() { return prefs.getLong(KEY_EMPRESA_ID, -1); }
    public void setEmpresaId(long value) { prefs.edit().putLong(KEY_EMPRESA_ID, value).apply(); }

    public String getEmpresaCodigo() { return prefs.getString(KEY_EMPRESA_CODIGO, null); }
    public String getEmpresaNombre() { return prefs.getString(KEY_EMPRESA_NOMBRE, null); }
    public void setEmpresaNombre(String value) { prefs.edit().putString(KEY_EMPRESA_NOMBRE, value).apply(); }

    public String getEmpresaRuc() { return prefs.getString(KEY_EMPRESA_RUC, null); }

    public long getSucursalId() { return prefs.getLong(KEY_SUCURSAL_ID, -1); }
    public void setSucursalId(long value) { prefs.edit().putLong(KEY_SUCURSAL_ID, value).apply(); }

    public String getSucursalNombre() { return prefs.getString(KEY_SUCURSAL_NOMBRE, null); }
    public void setSucursalNombre(String value) { prefs.edit().putString(KEY_SUCURSAL_NOMBRE, value).apply(); }

    public void guardarDesdeLogin(LoginResponse data) {
        if (data == null) {
            return;
        }
        setAccessTokenMemoria(data.accessToken, data.temporal);

        SharedPreferences.Editor editor = prefs.edit()
                .remove("access_token")
                .putBoolean(KEY_TEMPORAL, data.temporal)
                .putLong(KEY_USER_ID, data.userId != null ? data.userId : -1L)
                .putString(KEY_EMAIL, data.email)
                .putString(KEY_USERNAME, data.username)
                .putString(KEY_NOMBRES, data.nombres)
                .putString(KEY_APELLIDOS, data.apellidos)
                .putString(KEY_NOMBRE, data.nombreCompleto)
                .putBoolean(KEY_ADMIN_SISTEMA, Boolean.TRUE.equals(data.adminSistema))
                .putString(KEY_TIPO_SALES, data.tipoSales);

        if (data.refreshToken != null && !data.refreshToken.isBlank()) {
            editor.putString(KEY_REFRESH_TOKEN, data.refreshToken);
        }

        if (data.temporal) {
            editor.putLong(KEY_EMPRESA_ID, -1L)
                    .remove(KEY_EMPRESA_CODIGO)
                    .remove(KEY_EMPRESA_NOMBRE)
                    .remove(KEY_EMPRESA_RUC)
                    .putLong(KEY_SUCURSAL_ID, -1L)
                    .remove(KEY_SUCURSAL_NOMBRE);
        } else {
            editor.putLong(KEY_EMPRESA_ID, data.empresaId != null ? data.empresaId : -1L)
                    .putString(KEY_EMPRESA_CODIGO, data.empresaCodigo)
                    .putString(KEY_EMPRESA_NOMBRE, data.empresaNombre)
                    .putString(KEY_EMPRESA_RUC, data.empresaRuc)
                    .putLong(KEY_SUCURSAL_ID, data.sucursalId != null ? data.sucursalId : -1L)
                    .putString(KEY_SUCURSAL_NOMBRE, data.sucursalNombre);
        }
        editor.apply();
    }

    public void enriquecerContextoEmpresaSucursal(
            long empresaId,
            String empresaCodigo,
            String empresaNombre,
            String empresaRuc,
            long sucursalId,
            String sucursalNombre) {
        SharedPreferences.Editor editor = prefs.edit();
        if (empresaId > 0) {
            editor.putLong(KEY_EMPRESA_ID, empresaId);
        }
        if (empresaCodigo != null && !empresaCodigo.isBlank()) {
            editor.putString(KEY_EMPRESA_CODIGO, empresaCodigo);
        }
        if (empresaNombre != null && !empresaNombre.isBlank()) {
            editor.putString(KEY_EMPRESA_NOMBRE, empresaNombre);
        }
        if (empresaRuc != null && !empresaRuc.isBlank()) {
            editor.putString(KEY_EMPRESA_RUC, empresaRuc);
        }
        if (sucursalId > 0) {
            editor.putLong(KEY_SUCURSAL_ID, sucursalId);
        }
        if (sucursalNombre != null && !sucursalNombre.isBlank()) {
            editor.putString(KEY_SUCURSAL_NOMBRE, sucursalNombre);
        }
        editor.putBoolean(KEY_TEMPORAL, false);
        editor.apply();
        accessTemporalMemoria = false;
    }

    public String etiquetaEmpresaSucursal() {
        String emp = getEmpresaNombre() != null ? getEmpresaNombre().trim() : "";
        String suc = getSucursalNombre() != null ? getSucursalNombre().trim() : "";
        if (!emp.isEmpty() && !suc.isEmpty()) {
            return emp + " · " + suc;
        }
        if (!emp.isEmpty()) {
            return emp;
        }
        if (!suc.isEmpty()) {
            return suc;
        }
        return "";
    }

    public String getLoginUsuario() { return prefs.getString(KEY_LOGIN_USUARIO, null); }
    public String getLoginPassword() { return prefs.getString(KEY_LOGIN_PASSWORD, null); }

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

    /** Contexto de negocio listo (empresa+sucursal) y forma de recuperar access (credenciales o refresh). */
    public boolean sesionCompleta() {
        return getEmpresaId() > 0
                && getSucursalId() > 0
                && !prefs.getBoolean(KEY_TEMPORAL, false)
                && (tieneCredencialesGuardadas()
                || (getRefreshToken() != null && !getRefreshToken().isBlank()));
    }

    public boolean isRecordarSesion() {
        return prefs.getBoolean(KEY_RECORDAR_SESION, false);
    }

    public void setRecordarSesion(boolean value) {
        prefs.edit().putBoolean(KEY_RECORDAR_SESION, value).apply();
    }

    public void aplicarPreferenciaGuardarSesion(boolean recordar, String usuario, String password) {
        setRecordarSesion(recordar);
        if (recordar) {
            guardarCredenciales(usuario, password);
        } else {
            limpiarCredenciales();
        }
    }

    public boolean puedeReutilizarSesion() {
        return sesionCompleta() && isRecordarSesion();
    }

    public void limpiar() {
        limpiarAccessMemoria();
        prefs.edit().clear().apply();
    }
}
