package pe.com.hermes.appmobile.data.remote;

import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/** Espejo de controladores almacen-service (movimientos + dashboard). */
public interface AlmacenApi {

    @GET("almacen/movimientos")
    Call<ApiResponse<PageData<MovimientoListItemResponse>>> listarMovimientos(
            @Query("sucursalId") Long sucursalId,
            @Query("page") int page,
            @Query("size") int size
    );

    @GET("almacen/dashboard/logistico")
    Call<ApiResponse<DashboardLogisticoResponse>> dashboardLogistico(
            @Query("sucursalId") Long sucursalId
    );
}
