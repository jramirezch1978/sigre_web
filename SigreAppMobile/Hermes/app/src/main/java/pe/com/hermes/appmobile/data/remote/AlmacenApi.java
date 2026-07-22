package pe.com.hermes.appmobile.data.remote;

import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/** Espejo de com.sigre.almacen.controller.ValeMovController (GET /api/almacen/movimientos). */
public interface AlmacenApi {

    @GET("almacen/movimientos")
    Call<ApiResponse<PageData<MovimientoListItemResponse>>> listarMovimientos(
            @Query("sucursalId") Long sucursalId,
            @Query("page") int page,
            @Query("size") int size
    );
}
