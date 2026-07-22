package pe.com.hermes.appmobile.data.config

/**
 * Perfil de servidor remoto — mismos 5 campos que BeanServerRemote de FastSales
 * (nombre, hostIP, port, protocolo, flagDefault), en vez de una única URL suelta.
 */
data class ServerProfile(
    var nombre: String = "",
    var hostIp: String = "",
    var port: String = "",
    var protocolo: String = "http",
    var flagDefault: Boolean = false,
) {
    /** protocolo://hostIp:port/api/ — la URL base real que consume Retrofit. */
    fun apiBaseUrl(): String {
        val host = hostIp.trim()
        val p = port.trim()
        val sufijo = if (p.isNotEmpty()) ":$p" else ""
        return "$protocolo://$host$sufijo/api/"
    }
}
