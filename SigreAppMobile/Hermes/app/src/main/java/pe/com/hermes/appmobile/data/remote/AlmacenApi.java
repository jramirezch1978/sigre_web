package pe.com.hermes.appmobile.data.remote;

import java.util.List;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenMaestroResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenTipoMovResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenTipoResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.GuiaRemisionListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.IdRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.KardexListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.LotePalletListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MotivoTrasladoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.SolicitudSalidaListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.StockAFechaListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.StockListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.TipoMovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.UbicacionAlmacenResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ValorizacionListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.AlmacenRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.AlmacenTipoMovAsignarRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.AlmacenTipoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.ArticuloMovTipoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.InventarioConteoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.LotePalletRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.MotivoTrasladoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.MovimientoCabeceraRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.OrdenTrasladoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.UbicacionRequest;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;

/** Cliente Retrofit de almacen-service (lectura + escritura). */
public interface AlmacenApi {

    @GET("almacen/movimientos")
    Call<ApiResponse<PageData<MovimientoListItemResponse>>> listarMovimientos(
            @Query("sucursalId") Long sucursalId,
            @Query("estado") String estado,
            @Query("page") int page,
            @Query("size") int size
    );

    @GET("almacen/movimientos/{id}")
    Call<ApiResponse<MovimientoDetalleResponse>> obtenerMovimiento(@Path("id") long id);

    @POST("almacen/movimientos")
    Call<ApiResponse<MovimientoDetalleResponse>> crearMovimiento(@Body MovimientoCabeceraRequest body);

    @PUT("almacen/movimientos/{id}")
    Call<ApiResponse<MovimientoDetalleResponse>> actualizarMovimiento(
            @Path("id") long id, @Body MovimientoCabeceraRequest body);

    @POST("almacen/movimientos/confirmar")
    Call<ApiResponse<MovimientoDetalleResponse>> confirmarMovimiento(@Body IdRequest body);

    @POST("almacen/movimientos/anular")
    Call<ApiResponse<MovimientoDetalleResponse>> anularMovimiento(@Body IdRequest body);

    @GET("almacen/dashboard/logistico")
    Call<ApiResponse<DashboardLogisticoResponse>> dashboardLogistico(@Query("sucursalId") Long sucursalId);

    @GET("almacen/ordenes-traslado")
    Call<ApiResponse<PageData<OrdenTrasladoListItemResponse>>> listarOrdenesTraslado(
            @Query("estado") String estado,
            @Query("page") int page,
            @Query("size") int size);

    @GET("almacen/ordenes-traslado/{id}")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> obtenerOrdenTraslado(@Path("id") long id);

    @POST("almacen/ordenes-traslado")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> crearOrdenTraslado(@Body OrdenTrasladoRequest body);

    @PUT("almacen/ordenes-traslado/{id}")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> actualizarOrdenTraslado(
            @Path("id") long id, @Body OrdenTrasladoRequest body);

    @POST("almacen/ordenes-traslado/{id}/aprobar")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> aprobarOrdenTraslado(@Path("id") long id);

    @POST("almacen/ordenes-traslado/{id}/rechazar")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> rechazarOrdenTraslado(@Path("id") long id);

    @POST("almacen/ordenes-traslado/{id}/cerrar")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> cerrarOrdenTraslado(@Path("id") long id);

    @POST("almacen/ordenes-traslado/{id}/anular")
    Call<ApiResponse<OrdenTrasladoDetalleResponse>> anularOrdenTraslado(@Path("id") long id);

    @GET("almacen/tomas-inventario")
    Call<ApiResponse<PageData<InventarioConteoListItemResponse>>> listarTomasInventario(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/tomas-inventario/{id}")
    Call<ApiResponse<InventarioConteoDetalleResponse>> obtenerTomaInventario(@Path("id") long id);

    @POST("almacen/tomas-inventario")
    Call<ApiResponse<InventarioConteoDetalleResponse>> crearTomaInventario(@Body InventarioConteoRequest body);

    @PUT("almacen/tomas-inventario/{id}")
    Call<ApiResponse<InventarioConteoDetalleResponse>> actualizarTomaInventario(
            @Path("id") long id, @Body InventarioConteoRequest body);

    @POST("almacen/tomas-inventario/{id}/comparar")
    Call<ApiResponse<InventarioConteoDetalleResponse>> compararTomaInventario(@Path("id") long id);

    @POST("almacen/tomas-inventario/{id}/cerrar")
    Call<ApiResponse<InventarioConteoDetalleResponse>> cerrarTomaInventario(@Path("id") long id);

    @POST("almacen/tomas-inventario/{id}/anular")
    Call<ApiResponse<InventarioConteoDetalleResponse>> anularTomaInventario(@Path("id") long id);

    @GET("almacen/stock")
    Call<ApiResponse<PageData<StockListItemResponse>>> listarStock(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/kardex")
    Call<ApiResponse<PageData<KardexListItemResponse>>> listarKardex(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/reportes/diagnostico")
    Call<ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>>> diagnostico();

    @GET("almacen/reportes/valorizacion")
    Call<ApiResponse<PageData<ValorizacionListItemResponse>>> valorizacion(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/reportes/stock-a-fecha")
    Call<ApiResponse<PageData<StockAFechaListItemResponse>>> stockAFecha(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/almacenes")
    Call<ApiResponse<PageData<AlmacenMaestroResponse>>> listarAlmacenes(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/almacenes/{id}")
    Call<ApiResponse<AlmacenMaestroResponse>> obtenerAlmacen(@Path("id") long id);

    @POST("almacen/almacenes")
    Call<ApiResponse<AlmacenMaestroResponse>> crearAlmacen(@Body AlmacenRequest body);

    @PUT("almacen/almacenes/{id}")
    Call<ApiResponse<AlmacenMaestroResponse>> actualizarAlmacen(@Path("id") long id, @Body AlmacenRequest body);

    @GET("almacen/almacenes/{almacenId}/ubicaciones")
    Call<ApiResponse<List<UbicacionAlmacenResponse>>> listarUbicaciones(@Path("almacenId") long almacenId);

    @POST("almacen/almacenes/{almacenId}/ubicaciones")
    Call<ApiResponse<UbicacionAlmacenResponse>> crearUbicacion(
            @Path("almacenId") long almacenId, @Body UbicacionRequest body);

    @PUT("almacen/ubicaciones/{id}")
    Call<ApiResponse<UbicacionAlmacenResponse>> actualizarUbicacion(
            @Path("id") long id, @Body UbicacionRequest body);

    @GET("almacen/almacenes/{almacenId}/tipos-movimiento")
    Call<ApiResponse<PageData<AlmacenTipoMovResponse>>> listarTiposMovPorAlmacen(
            @Path("almacenId") long almacenId,
            @Query("page") int page,
            @Query("size") int size);

    @POST("almacen/almacenes/{almacenId}/tipos-movimiento")
    Call<ApiResponse<AlmacenTipoMovResponse>> asignarTipoMov(
            @Path("almacenId") long almacenId, @Body AlmacenTipoMovAsignarRequest body);

    @GET("almacen/almacen-tipos")
    Call<ApiResponse<PageData<AlmacenTipoResponse>>> listarTiposAlmacen(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/almacen-tipos/{id}")
    Call<ApiResponse<AlmacenTipoResponse>> obtenerTipoAlmacen(@Path("id") long id);

    @POST("almacen/almacen-tipos")
    Call<ApiResponse<AlmacenTipoResponse>> crearTipoAlmacen(@Body AlmacenTipoRequest body);

    @PUT("almacen/almacen-tipos/{id}")
    Call<ApiResponse<AlmacenTipoResponse>> actualizarTipoAlmacen(
            @Path("id") long id, @Body AlmacenTipoRequest body);

    @GET("almacen/maestros/tipos-movimiento-catalogo")
    Call<ApiResponse<PageData<TipoMovimientoListItemResponse>>> listarTiposMovimiento(
            @Query("page") int page, @Query("size") int size, @Query("sort") String sort);

    @GET("almacen/maestros/tipos-movimiento-catalogo/{id}")
    Call<ApiResponse<TipoMovimientoListItemResponse>> obtenerTipoMovimiento(@Path("id") long id);

    @POST("almacen/maestros/tipos-movimiento-catalogo")
    Call<ApiResponse<TipoMovimientoListItemResponse>> crearTipoMovimiento(@Body ArticuloMovTipoRequest body);

    @PUT("almacen/maestros/tipos-movimiento-catalogo/{id}")
    Call<ApiResponse<TipoMovimientoListItemResponse>> actualizarTipoMovimiento(
            @Path("id") long id, @Body ArticuloMovTipoRequest body);

    @GET("almacen/maestros/motivos-traslado")
    Call<ApiResponse<PageData<MotivoTrasladoListItemResponse>>> listarMotivosTraslado(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/maestros/motivos-traslado/{id}")
    Call<ApiResponse<MotivoTrasladoListItemResponse>> obtenerMotivoTraslado(@Path("id") long id);

    @POST("almacen/maestros/motivos-traslado")
    Call<ApiResponse<MotivoTrasladoListItemResponse>> crearMotivoTraslado(@Body MotivoTrasladoRequest body);

    @PUT("almacen/maestros/motivos-traslado/{id}")
    Call<ApiResponse<MotivoTrasladoListItemResponse>> actualizarMotivoTraslado(
            @Path("id") long id, @Body MotivoTrasladoRequest body);

    @GET("almacen/lotes-pallets")
    Call<ApiResponse<PageData<LotePalletListItemResponse>>> listarLotes(
            @Query("page") int page, @Query("size") int size);

    @POST("almacen/lotes-pallets")
    Call<ApiResponse<LotePalletListItemResponse>> crearLote(@Body LotePalletRequest body);

    @PUT("almacen/lotes-pallets/{id}")
    Call<ApiResponse<LotePalletListItemResponse>> actualizarLote(
            @Path("id") long id, @Body LotePalletRequest body);

    @GET("almacen/guias-remision")
    Call<ApiResponse<PageData<GuiaRemisionListItemResponse>>> listarGuias(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/solicitudes-salida")
    Call<ApiResponse<PageData<SolicitudSalidaListItemResponse>>> listarSolicitudesSalida(
            @Query("page") int page, @Query("size") int size);

    @POST("almacen/procesos/recalculo-precios-promedio")
    Call<ApiResponse<Object>> procesoRecalculo();

    @POST("almacen/procesos/cuadre-stock")
    Call<ApiResponse<Object>> procesoCuadreStock();

    @POST("almacen/procesos/actualizacion-automatica")
    Call<ApiResponse<Object>> procesoActualizacion();
}
