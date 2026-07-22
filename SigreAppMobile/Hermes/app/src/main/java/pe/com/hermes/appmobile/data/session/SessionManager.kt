package pe.com.hermes.appmobile.data.session

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey

/**
 * Sesión (token JWT + datos de usuario/empresa/sucursal), cifrada en EncryptedSharedPreferences.
 * La URL del servidor NO vive aquí — ver AppConfig (archivo appconfig.json en almacenamiento
 * privado de la app), a pedido explícito: "configuración... en un archivo... dentro de la app".
 */
class SessionManager(context: Context) {

    private val masterKey = MasterKey.Builder(context)
        .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
        .build()

    private val prefs: SharedPreferences = EncryptedSharedPreferences.create(
        context,
        "sigre_session",
        masterKey,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
    )

    var accessToken: String?
        get() = prefs.getString(KEY_ACCESS_TOKEN, null)
        set(value) = prefs.edit().putString(KEY_ACCESS_TOKEN, value).apply()

    var refreshToken: String?
        get() = prefs.getString(KEY_REFRESH_TOKEN, null)
        set(value) = prefs.edit().putString(KEY_REFRESH_TOKEN, value).apply()

    var temporal: Boolean
        get() = prefs.getBoolean(KEY_TEMPORAL, false)
        set(value) = prefs.edit().putBoolean(KEY_TEMPORAL, value).apply()

    var userId: Long
        get() = prefs.getLong(KEY_USER_ID, -1)
        set(value) = prefs.edit().putLong(KEY_USER_ID, value).apply()

    var nombreCompleto: String?
        get() = prefs.getString(KEY_NOMBRE, null)
        set(value) = prefs.edit().putString(KEY_NOMBRE, value).apply()

    var email: String?
        get() = prefs.getString(KEY_EMAIL, null)
        set(value) = prefs.edit().putString(KEY_EMAIL, value).apply()

    var empresaId: Long
        get() = prefs.getLong(KEY_EMPRESA_ID, -1)
        set(value) = prefs.edit().putLong(KEY_EMPRESA_ID, value).apply()

    var empresaNombre: String?
        get() = prefs.getString(KEY_EMPRESA_NOMBRE, null)
        set(value) = prefs.edit().putString(KEY_EMPRESA_NOMBRE, value).apply()

    var sucursalId: Long
        get() = prefs.getLong(KEY_SUCURSAL_ID, -1)
        set(value) = prefs.edit().putLong(KEY_SUCURSAL_ID, value).apply()

    var sucursalNombre: String?
        get() = prefs.getString(KEY_SUCURSAL_NOMBRE, null)
        set(value) = prefs.edit().putString(KEY_SUCURSAL_NOMBRE, value).apply()

    /** true = login final completo (empresa+sucursal ya seleccionadas, hay refreshToken). */
    fun sesionCompleta(): Boolean = !accessToken.isNullOrBlank() && !temporal && sucursalId > 0

    fun limpiar() {
        prefs.edit().clear().apply()
    }

    private companion object {
        const val KEY_ACCESS_TOKEN = "access_token"
        const val KEY_REFRESH_TOKEN = "refresh_token"
        const val KEY_TEMPORAL = "temporal"
        const val KEY_USER_ID = "user_id"
        const val KEY_NOMBRE = "nombre_completo"
        const val KEY_EMAIL = "email"
        const val KEY_EMPRESA_ID = "empresa_id"
        const val KEY_EMPRESA_NOMBRE = "empresa_nombre"
        const val KEY_SUCURSAL_ID = "sucursal_id"
        const val KEY_SUCURSAL_NOMBRE = "sucursal_nombre"
    }
}
