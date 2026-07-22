package pe.com.hermes.appmobile.data.remote.dto

/** Espejo de com.sigre.almacen.dto.MovimientoListItemResponse. */
data class MovimientoListItemResponse(
    val id: Long,
    val sucursalId: Long? = null,
    val almacenId: Long? = null,
    val articuloMovTipoId: Long? = null,
    val nroVale: String? = null,
    val tipoReferenciaOrigen: String? = null,
    val ordenCompraId: Long? = null,
    val ordenVentaId: Long? = null,
    val fechaMov: String? = null,
    val fecProduccion: String? = null,
    val flagEstado: String? = null,
)
