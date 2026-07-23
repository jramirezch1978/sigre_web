package pe.com.hermes.appmobile.data.remote;

import java.util.List;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenMaestroResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.GuiaRemisionListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.KardexListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.LotePalletListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MotivoTrasladoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.SolicitudSalidaListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.StockAFechaListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.StockListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.TipoMovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ValorizacionListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

/** Cliente Retrofit de almacen-service. */
public interface AlmacenApi {

    @GET("almacen/movimientos")
    Call<ApiResponse<PageData<MovimientoListItemResponse>>> listarMovimientos(
            @Query("sucursalId") Long sucursalId,
            @Query("page") int page,
            @Query("size") int size
    );

    @GET("almacen/movimientos/{id}")
    Call<ApiResponse<MovimientoDetalleResponse>> obtenerMovimiento(@Path("id") long id);

    @GET("almacen/dashboard/logistico")
    Call<ApiResponse<DashboardLogisticoResponse>> dashboardLogistico(@Query("sucursalId") Long sucursalId);

    @GET("almacen/ordenes-traslado")
    Call<ApiResponse<PageData<OrdenTrasladoListItemResponse>>> listarOrdenesTraslado(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/tomas-inventario")
    Call<ApiResponse<PageData<InventarioConteoListItemResponse>>> listarTomasInventario(
            @Query("page") int page, @Query("size") int size);

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

    @GET("almacen/maestros/tipos-movimiento-catalogo")
    Call<ApiResponse<PageData<TipoMovimientoListItemResponse>>> listarTiposMovimiento(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/maestros/motivos-traslado")
    Call<ApiResponse<PageData<MotivoTrasladoListItemResponse>>> listarMotivosTraslado(
            @Query("page") int page, @Query("size") int size);

    @GET("almacen/lotes-pallets")
    Call<ApiResponse<PageData<LotePalletListItemResponse>>> listarLotes(
            @Query("page") int page, @Query("size") int size);

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
