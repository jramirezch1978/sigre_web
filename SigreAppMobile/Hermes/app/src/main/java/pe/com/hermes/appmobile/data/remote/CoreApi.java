package pe.com.hermes.appmobile.data.remote;

import java.util.List;
import java.util.Map;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ConfigClaveResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ConversionUnidadResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.NumeradorDocumentoResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.ConfigEmpresaSaveRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.ConversionUnidadRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.NumeradorDocumentoUpsertRequest;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;

/** Cliente Retrofit de core-service (tablas AL009–AL012). */
public interface CoreApi {

    @GET("core/conversiones-unidad")
    Call<ApiResponse<PageData<ConversionUnidadResponse>>> listarConversiones(
            @Query("page") int page, @Query("size") int size);

    @POST("core/conversiones-unidad")
    Call<ApiResponse<ConversionUnidadResponse>> crearConversion(@Body ConversionUnidadRequest body);

    @PUT("core/conversiones-unidad/{id}")
    Call<ApiResponse<ConversionUnidadResponse>> actualizarConversion(
            @Path("id") long id, @Body ConversionUnidadRequest body);

    @GET("core/numeradores-documento")
    Call<ApiResponse<PageData<NumeradorDocumentoResponse>>> listarNumeradores(
            @Query("nombreTabla") String nombreTabla,
            @Query("page") int page,
            @Query("size") int size);

    @POST("core/numeradores-documento")
    Call<ApiResponse<NumeradorDocumentoResponse>> upsertNumerador(@Body NumeradorDocumentoUpsertRequest body);

    @PUT("core/numeradores-documento")
    Call<ApiResponse<NumeradorDocumentoResponse>> actualizarNumerador(@Body NumeradorDocumentoUpsertRequest body);

    @GET("core/config/claves")
    Call<ApiResponse<List<ConfigClaveResponse>>> listarClavesConfig(
            @Query("modulo") String modulo,
            @Query("nivel") String nivel);

    @GET("core/config/empresa")
    Call<ApiResponse<Map<String, Object>>> configEmpresa(
            @Query("empresaId") long empresaId);

    @PUT("core/config/empresa")
    Call<ApiResponse<Map<String, Object>>> guardarConfigEmpresa(@Body ConfigEmpresaSaveRequest body);
}
