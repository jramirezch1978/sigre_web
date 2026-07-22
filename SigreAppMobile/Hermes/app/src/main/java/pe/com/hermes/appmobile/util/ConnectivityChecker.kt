package pe.com.hermes.appmobile.util

import pe.com.hermes.appmobile.data.config.ServerProfile
import java.net.InetSocketAddress
import java.net.Socket

/**
 * Prueba de conectividad TCP simple contra un servidor — equivalente moderno de
 * ValidarServerTask de FastSales (que hacía ping al webservice SOAP). No depende de
 * ningún endpoint HTTP concreto, solo abre/cierra un socket con timeout corto: sirve
 * tanto para validar un servidor recién tipeado (aún sin guardar) como el que ya está
 * configurado como default, y para el badge de latencia en tiempo real del Login.
 */
object ConnectivityChecker {

    private const val TIMEOUT_MS = 2500

    data class Resultado(val conectado: Boolean, val latenciaMs: Long?)

    /** Bloqueante — llamar siempre desde Dispatchers.IO. */
    fun probar(hostIp: String, port: String): Resultado {
        val puerto = port.toIntOrNull() ?: return Resultado(false, null)
        if (hostIp.isBlank()) return Resultado(false, null)
        val inicio = System.currentTimeMillis()
        return try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress(hostIp, puerto), TIMEOUT_MS)
                Resultado(true, System.currentTimeMillis() - inicio)
            }
        } catch (_: Exception) {
            Resultado(false, null)
        }
    }

    fun probar(server: ServerProfile): Resultado = probar(server.hostIp, server.port)
}
