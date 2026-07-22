package pe.com.sigre.logistica.data.remote.dto

/** Espejo de com.sigre.compras.dto.SolicitudCompraResponse (fila de listado). */
data class SolicitudCompraResponse(
    val id: Long,
    val numero: String? = null,
    val fecha: String? = null,
    val prioridad: String? = null,
    val flagEstado: String? = null,
    val totalItems: Int = 0,
    val solicitanteId: Long? = null,
    val sucursalId: Long? = null,
)
