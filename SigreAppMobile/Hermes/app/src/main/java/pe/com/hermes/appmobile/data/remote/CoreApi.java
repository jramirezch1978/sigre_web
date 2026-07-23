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
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.CatalogoCodigoNombre;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.CatalogoCodigoNombreRequest;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ProveedorDto;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ProveedorRequest;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;

/** Cliente Retrofit de core-service. */
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

    @GET("core/relaciones-comerciales")
    Call<ApiResponse<PageData<ProveedorDto>>> listarProveedores(
            @Query("esProveedor") Boolean esProveedor,
            @Query("page") int page,
            @Query("size") int size);

    @GET("core/relaciones-comerciales/{id}")
    Call<ApiResponse<ProveedorDto>> obtenerProveedor(@Path("id") long id);

    @POST("core/relaciones-comerciales")
    Call<ApiResponse<ProveedorDto>> crearProveedor(@Body ProveedorRequest body);

    @PUT("core/relaciones-comerciales/{id}")
    Call<ApiResponse<ProveedorDto>> actualizarProveedor(@Path("id") long id, @Body ProveedorRequest body);

    @GET("core/marcas")
    Call<ApiResponse<PageData<CatalogoCodigoNombre>>> listarMarcas(
            @Query("page") int page, @Query("size") int size);

    @POST("core/marcas")
    Call<ApiResponse<CatalogoCodigoNombre>> crearMarca(@Body CatalogoCodigoNombreRequest body);

    @PUT("core/marcas/{id}")
    Call<ApiResponse<CatalogoCodigoNombre>> actualizarMarca(
            @Path("id") long id, @Body CatalogoCodigoNombreRequest body);

    @GET("core/colores")
    Call<ApiResponse<PageData<CatalogoCodigoNombre>>> listarColores(
            @Query("page") int page, @Query("size") int size);

    @POST("core/colores")
    Call<ApiResponse<CatalogoCodigoNombre>> crearColor(@Body CatalogoCodigoNombreRequest body);

    @PUT("core/colores/{id}")
    Call<ApiResponse<CatalogoCodigoNombre>> actualizarColor(
            @Path("id") long id, @Body CatalogoCodigoNombreRequest body);

    @GET("core/clases-articulo")
    Call<ApiResponse<PageData<CatalogoCodigoNombre>>> listarClases(
            @Query("page") int page, @Query("size") int size);

    @POST("core/clases-articulo")
    Call<ApiResponse<CatalogoCodigoNombre>> crearClase(@Body CatalogoCodigoNombreRequest body);

    @PUT("core/clases-articulo/{id}")
    Call<ApiResponse<CatalogoCodigoNombre>> actualizarClase(
            @Path("id") long id, @Body CatalogoCodigoNombreRequest body);

    @GET("core/categorias")
    Call<ApiResponse<PageData<CatalogoCodigoNombre>>> listarCategorias(
            @Query("page") int page, @Query("size") int size);

    @POST("core/categorias")
    Call<ApiResponse<CatalogoCodigoNombre>> crearCategoria(@Body CatalogoCodigoNombreRequest body);

    @PUT("core/categorias/{id}")
    Call<ApiResponse<CatalogoCodigoNombre>> actualizarCategoria(
            @Path("id") long id, @Body CatalogoCodigoNombreRequest body);

    @GET("core/sub-categorias")
    Call<ApiResponse<PageData<CatalogoCodigoNombre>>> listarSubCategorias(
            @Query("page") int page, @Query("size") int size);

    @POST("core/sub-categorias")
    Call<ApiResponse<CatalogoCodigoNombre>> crearSubCategoria(@Body CatalogoCodigoNombreRequest body);

    @PUT("core/sub-categorias/{id}")
    Call<ApiResponse<CatalogoCodigoNombre>> actualizarSubCategoria(
            @Path("id") long id, @Body CatalogoCodigoNombreRequest body);

    @GET("core/articulos")
    Call<ApiResponse<PageData<CatalogoCodigoNombre>>> listarArticulos(
            @Query("page") int page, @Query("size") int size);

    @POST("core/articulos")
    Call<ApiResponse<CatalogoCodigoNombre>> crearArticulo(@Body CatalogoCodigoNombreRequest body);

    @PUT("core/articulos/{id}")
    Call<ApiResponse<CatalogoCodigoNombre>> actualizarArticulo(
            @Path("id") long id, @Body CatalogoCodigoNombreRequest body);
}
