package pe.com.hermes.appmobile.data.remote;

import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.CentroCostoDto;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/** Cliente Retrofit de contabilidad-service (catálogos FK). */
public interface ContabilidadApi {

    @GET("contabilidad/centros-costo")
    Call<ApiResponse<PageData<CentroCostoDto>>> listarCentrosCosto(
            @Query("page") int page,
            @Query("size") int size,
            @Query("flagEstado") String flagEstado);
}
