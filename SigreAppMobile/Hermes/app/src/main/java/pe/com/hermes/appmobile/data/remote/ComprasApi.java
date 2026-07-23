package pe.com.hermes.appmobile.data.remote;

import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ConvertirBody;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ConvertirResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.MotivoBody;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ObservacionBody;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudRequest;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.TipoEntidadDto;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.TipoEntidadRequest;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;

/** Cliente Retrofit de compras-service. */
public interface ComprasApi {

    @GET("compras/solicitudes-compra")
    Call<ApiResponse<PageData<SolicitudCompraResponse>>> listarSolicitudes(
            @Query("sucursalId") Long sucursalId,
            @Query("flagEstado") String flagEstado,
            @Query("page") int page,
            @Query("size") int size
    );

    @GET("compras/solicitudes-compra/{id}")
    Call<ApiResponse<SolicitudDetalleResponse>> obtenerSolicitud(@Path("id") long id);

    @POST("compras/solicitudes-compra")
    Call<ApiResponse<SolicitudDetalleResponse>> crearSolicitud(@Body SolicitudRequest body);

    @PUT("compras/solicitudes-compra/{id}")
    Call<ApiResponse<SolicitudDetalleResponse>> actualizarSolicitud(
            @Path("id") long id, @Body SolicitudRequest body);

    @POST("compras/solicitudes-compra/{id}/enviar")
    Call<ApiResponse<SolicitudDetalleResponse>> enviarSolicitud(@Path("id") long id);

    @POST("compras/solicitudes-compra/{id}/aprobar")
    Call<ApiResponse<SolicitudDetalleResponse>> aprobarSolicitud(
            @Path("id") long id, @Body ObservacionBody body);

    @POST("compras/solicitudes-compra/{id}/rechazar")
    Call<ApiResponse<SolicitudDetalleResponse>> rechazarSolicitud(
            @Path("id") long id, @Body MotivoBody body);

    @POST("compras/solicitudes-compra/{id}/anular")
    Call<ApiResponse<SolicitudDetalleResponse>> anularSolicitud(
            @Path("id") long id, @Body MotivoBody body);

    @POST("compras/solicitudes-compra/{id}/convertir")
    Call<ApiResponse<ConvertirResponse>> convertirSolicitud(
            @Path("id") long id, @Body ConvertirBody body);

    @GET("compras/maestros/tipos-entidad-contribuyente")
    Call<ApiResponse<PageData<TipoEntidadDto>>> listarTiposProveedor(
            @Query("page") int page, @Query("size") int size);

    @POST("compras/maestros/tipos-entidad-contribuyente")
    Call<ApiResponse<TipoEntidadDto>> crearTipoProveedor(@Body TipoEntidadRequest body);

    @PUT("compras/maestros/tipos-entidad-contribuyente/{id}")
    Call<ApiResponse<TipoEntidadDto>> actualizarTipoProveedor(
            @Path("id") long id, @Body TipoEntidadRequest body);
}
