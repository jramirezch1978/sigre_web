package pe.com.sigre.logistica.data.remote

import pe.com.sigre.logistica.data.remote.dto.ApiResponse
import pe.com.sigre.logistica.data.remote.dto.MovimientoListItemResponse
import pe.com.sigre.logistica.data.remote.dto.PageData
import retrofit2.http.GET
import retrofit2.http.Query

/** Espejo de com.sigre.almacen.controller.ValeMovController (GET /api/almacen/movimientos). */
interface AlmacenApi {

    @GET("almacen/movimientos")
    suspend fun listarMovimientos(
        @Query("sucursalId") sucursalId: Long? = null,
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 50,
    ): ApiResponse<PageData<MovimientoListItemResponse>>
}
