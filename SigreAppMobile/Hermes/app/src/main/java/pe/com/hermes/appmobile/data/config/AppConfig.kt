package pe.com.hermes.appmobile.data.config

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * Configuración de conexión — lista de perfiles de SERVIDOR REMOTO (nombre, host, puerto,
 * protocolo, si es el default), igual que ImplServerRemote/BeanServerRemote de FastSales,
 * pero persistida en un ARCHIVO real dentro del almacenamiento privado de la app
 * (files/appconfig.json), no en SharedPreferences.
 *
 * Al primer arranque se copia el default embebido en assets/appconfig.json; a partir de ahí
 * toda lectura/escritura (alta/edición/borrado de servidores desde la UI) opera sobre ese
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

    fun listarServidores(): List<ServerProfile> {
        val arr = leerJson().optJSONArray("servers") ?: JSONArray()
        return (0 until arr.length()).map { i ->
            val o = arr.getJSONObject(i)
            ServerProfile(
                nombre = o.optString("nombre"),
                hostIp = o.optString("hostIp"),
                port = o.optString("port"),
                protocolo = o.optString("protocolo", "http"),
                flagDefault = o.optBoolean("flagDefault", false),
            )
        }
    }

    fun guardarServidores(servidores: List<ServerProfile>) {
        val arr = JSONArray()
        servidores.forEach { s ->
            arr.put(
                JSONObject()
                    .put("nombre", s.nombre)
                    .put("hostIp", s.hostIp)
                    .put("port", s.port)
                    .put("protocolo", s.protocolo)
                    .put("flagDefault", s.flagDefault)
            )
        }
        val json = leerJson()
        json.put("servers", arr)
        escribirJson(json)
    }

    /** Añade un servidor; si viene marcado como default, desmarca a los demás. */
    fun agregarServidor(nuevo: ServerProfile) {
        val actuales = listarServidores().toMutableList()
        if (nuevo.flagDefault) actuales.replaceAll { it.copy(flagDefault = false) }
        actuales.add(nuevo)
        guardarServidores(actuales)
    }

    /** Reemplaza el servidor en [indice]; si viene marcado como default, desmarca a los demás. */
    fun actualizarServidor(indice: Int, editado: ServerProfile) {
        val actuales = listarServidores().toMutableList()
        if (indice !in actuales.indices) return
        if (editado.flagDefault) actuales.replaceAll { it.copy(flagDefault = false) }
        actuales[indice] = editado
        guardarServidores(actuales)
    }

    fun eliminarServidor(indice: Int) {
        val actuales = listarServidores().toMutableList()
        if (indice !in actuales.indices) return
        actuales.removeAt(indice)
        guardarServidores(actuales)
    }

    fun obtenerDefault(): ServerProfile? = listarServidores().firstOrNull { it.flagDefault }

    /** URL base real que consume Retrofit — la del servidor marcado como default. */
    val apiBaseUrl: String
        get() = obtenerDefault()?.apiBaseUrl() ?: DEFAULT_API_BASE_URL

    companion object {
        const val DEFAULT_API_BASE_URL = "http://10.0.2.2:9080/api/"
    }
}
