package pe.com.hermes.appmobile.data.remote;

import java.util.List;
import java.util.Map;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ConfigClaveResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ConversionUnidadResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.NumeradorDocumentoResponse;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/** Cliente Retrofit de core-service (tablas AL009–AL012). */
public interface CoreApi {

    @GET("core/conversiones-unidad")
    Call<ApiResponse<PageData<ConversionUnidadResponse>>> listarConversiones(
            @Query("page") int page, @Query("size") int size);

    @GET("core/numeradores-documento")
    Call<ApiResponse<PageData<NumeradorDocumentoResponse>>> listarNumeradores(
            @Query("nombreTabla") String nombreTabla,
            @Query("page") int page,
            @Query("size") int size);

    @GET("core/config/claves")
    Call<ApiResponse<List<ConfigClaveResponse>>> listarClavesConfig(
            @Query("modulo") String modulo,
            @Query("nivel") String nivel);

    @GET("core/config/empresa")
    Call<ApiResponse<Map<String, Object>>> configEmpresa(
            @Query("empresaId") long empresaId);
}
