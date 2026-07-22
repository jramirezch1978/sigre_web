package pe.com.hermes.appmobile.data.remote;

import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/** Espejo de com.sigre.compras.controller.SolicitudCompraController (GET /api/compras/solicitudes-compra). */
public interface ComprasApi {

    @GET("compras/solicitudes-compra")
    Call<ApiResponse<PageData<SolicitudCompraResponse>>> listarSolicitudes(
            @Query("flagEstado") String flagEstado,
            @Query("page") int page,
            @Query("size") int size
    );
}
