package pe.com.hermes.appmobile.util

import pe.com.hermes.appmobile.data.config.ServerProfile
import java.net.InetSocketAddress
import java.net.Socket

/**
 * Prueba de conectividad TCP simple contra un servidor — equivalente moderno de
 * ValidarServerTask de FastSales (que hacía ping al webservice SOAP). No depende de
 * ningún endpoint HTTP concreto, solo abre/cierra un socket con timeout corto: sirve
 * tanto para validar un servidor recién tipeado (aún sin guardar) como el que ya está
 * configurado como default.
 */
object ConnectivityChecker {

    private const val TIMEOUT_MS = 2500

    /** Bloqueante — llamar siempre desde Dispatchers.IO. */
    fun probar(hostIp: String, port: String): Boolean {
        val puerto = port.toIntOrNull() ?: return false
        if (hostIp.isBlank()) return false
        return try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress(hostIp, puerto), TIMEOUT_MS)
                true
            }
        } catch (_: Exception) {
            false
        }
    }

    fun probar(server: ServerProfile): Boolean = probar(server.hostIp, server.port)
}
