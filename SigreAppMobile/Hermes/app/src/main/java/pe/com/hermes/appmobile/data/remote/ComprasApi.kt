package pe.com.hermes.appmobile.data.remote

import pe.com.hermes.appmobile.data.remote.dto.ApiResponse
import pe.com.hermes.appmobile.data.remote.dto.PageData
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse
import retrofit2.http.GET
import retrofit2.http.Query

/** Espejo de com.sigre.compras.controller.SolicitudCompraController (GET /api/compras/solicitudes-compra). */
interface ComprasApi {

    @GET("compras/solicitudes-compra")
    suspend fun listarSolicitudes(
        @Query("flagEstado") flagEstado: String? = null,
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 50,
    ): ApiResponse<PageData<SolicitudCompraResponse>>
}
