package pe.com.hermes.appmobile.data.config

import android.content.Context
import org.json.JSONObject
import java.io.File

/**
 * Configuración de conexión (URL del API Gateway) persistida en un ARCHIVO real dentro
 * del almacenamiento privado de la app (files/appconfig.json) — no en SharedPreferences.
 *
 * Al primer arranque se copia el default embebido en assets/appconfig.json; a partir de ahí
 * toda lectura/escritura (incluido el cambio manual de servidor en Login) opera sobre ese
 * archivo, que persiste entre sesiones y sobrevive un logout.
 */
class AppConfig(private val context: Context) {

    private val configFile: File = File(context.filesDir, "appconfig.json")

    private fun asegurarArchivo(): File {
        if (!configFile.exists()) {
            val defaultJson = context.assets.open("appconfig.json").bufferedReader().use { it.readText() }
            configFile.writeText(defaultJson)
        }
        return configFile
    }

    private fun leerJson(): JSONObject {
        val texto = asegurarArchivo().readText()
        return try {
            JSONObject(texto)
        } catch (_: Exception) {
            JSONObject()
        }
    }

    private fun escribirJson(json: JSONObject) {
        asegurarArchivo().writeText(json.toString(2))
    }

    var apiBaseUrl: String
        get() = leerJson().optString("apiBaseUrl", DEFAULT_API_BASE_URL)
        set(value) {
            val json = leerJson()
            json.put("apiBaseUrl", value)
            escribirJson(json)
        }

    companion object {
        const val DEFAULT_API_BASE_URL = "http://10.0.2.2:9080/api/"
    }
}
