package pe.com.hermes.appmobile.data.session;

import android.content.Context;
import android.content.SharedPreferences;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;
import java.io.IOException;
import java.security.GeneralSecurityException;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;

/**
 * Sesión Hermes cifrada (EncryptedSharedPreferences AES-256).
 * <p>
 * Persistido: datos de usuario/empresa/sucursal y (opcional) credenciales.
 * Access (temporal o definitivo) no se persiste: se pide al backend en cada API.
 * No se usa refresh en Hermes.
 */
public class SessionManager {

    private static final String PREFS_NAME = "hermes_session_secure";

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

    /**
     * Credenciales en RAM para pedir token en cada API durante la sesión activa.
     * En disco solo si el usuario activó "Guardar sesión".
     */
    private volatile String loginUsuarioMemoria;
    private volatile String loginPasswordMemoria;

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
            // Por política: no persistir access ni refresh.
            prefs.edit().remove("access_token").remove("refresh_token").apply();
        } catch (GeneralSecurityException | IOException e) {
            throw new RuntimeException("No se pudo inicializar la sesion cifrada", e);
        }
    }

    private void migrarDesdePrefsLegacySiExiste(Context context, MasterKey masterKey) {
        if (prefs.contains(KEY_LOGIN_USUARIO) || prefs.contains(KEY_EMPRESA_ID)) {
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
                if ("access_token".equals(key) || "refresh_token".equals(key)) {
                    continue;
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

    public boolean isTemporal() {
        if (accessTokenMemoria != null) {
            return accessTemporalMemoria;
        }
        return prefs.getBoolean(KEY_TEMPORAL, false);
    }

    public void setTemporal(boolean value) { prefs.edit().putBoolean(KEY_TEMPORAL, value).apply(); }

    /** Access solo en memoria. No se persiste access ni refresh. */
    public void guardarTokens(String accessToken, String refreshToken, boolean temporal) {
        setAccessTokenMemoria(accessToken, temporal);
        prefs.edit()
                .putBoolean(KEY_TEMPORAL, temporal)
                .remove("access_token")
                .remove("refresh_token")
                .apply();
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
                .remove("refresh_token")
                .putBoolean(KEY_TEMPORAL, data.temporal)
                .putLong(KEY_USER_ID, data.userId != null ? data.userId : -1L)
                .putString(KEY_EMAIL, data.email)
                .putString(KEY_USERNAME, data.username)
                .putString(KEY_NOMBRES, data.nombres)
                .putString(KEY_APELLIDOS, data.apellidos)
                .putString(KEY_NOMBRE, data.nombreCompleto)
                .putBoolean(KEY_ADMIN_SISTEMA, Boolean.TRUE.equals(data.adminSistema))
                .putString(KEY_TIPO_SALES, data.tipoSales);

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

    public String getLoginUsuario() {
        if (loginUsuarioMemoria != null && !loginUsuarioMemoria.isBlank()) {
            return loginUsuarioMemoria;
        }
        return prefs.getString(KEY_LOGIN_USUARIO, null);
    }

    public String getLoginPassword() {
        if (loginPasswordMemoria != null && !loginPasswordMemoria.isEmpty()) {
            return loginPasswordMemoria;
        }
        return prefs.getString(KEY_LOGIN_PASSWORD, null);
    }

    /** Credenciales en RAM (obligatorias para pedir token en cada API). */
    public void setCredencialesEnMemoria(String usuario, String password) {
        this.loginUsuarioMemoria = usuario != null ? usuario : null;
        this.loginPasswordMemoria = password != null ? password : null;
    }

    public void guardarCredenciales(String usuario, String password) {
        setCredencialesEnMemoria(usuario, password);
        prefs.edit()
                .putString(KEY_LOGIN_USUARIO, usuario != null ? usuario : "")
                .putString(KEY_LOGIN_PASSWORD, password != null ? password : "")
                .apply();
    }

    public void limpiarCredenciales() {
        loginUsuarioMemoria = null;
        loginPasswordMemoria = null;
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

    /** Contexto listo + credenciales para pedir token en cada API. */
    public boolean sesionCompleta() {
        return getEmpresaId() > 0
                && getSucursalId() > 0
                && !prefs.getBoolean(KEY_TEMPORAL, false)
                && tieneCredencialesGuardadas();
    }

    public boolean isRecordarSesion() {
        return prefs.getBoolean(KEY_RECORDAR_SESION, false);
    }

    public void setRecordarSesion(boolean value) {
        prefs.edit().putBoolean(KEY_RECORDAR_SESION, value).apply();
    }

    /**
     * Siempre deja credenciales en RAM para pedir token.
     * En disco solo si {@code recordar} (próximos arranques).
     */
    public void aplicarPreferenciaGuardarSesion(boolean recordar, String usuario, String password) {
        setRecordarSesion(recordar);
        setCredencialesEnMemoria(usuario, password);
        if (recordar) {
            prefs.edit()
                    .putString(KEY_LOGIN_USUARIO, usuario != null ? usuario : "")
                    .putString(KEY_LOGIN_PASSWORD, password != null ? password : "")
                    .apply();
        } else {
            prefs.edit()
                    .remove(KEY_LOGIN_USUARIO)
                    .remove(KEY_LOGIN_PASSWORD)
                    .apply();
        }
    }

    public boolean puedeReutilizarSesion() {
        return sesionCompleta() && isRecordarSesion();
    }

    public void limpiar() {
        limpiarAccessMemoria();
        loginUsuarioMemoria = null;
        loginPasswordMemoria = null;
        prefs.edit().clear().apply();
    }
}
