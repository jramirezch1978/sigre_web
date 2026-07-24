package pe.com.hermes.appmobile.data.repository;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenMaestroResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.AlmacenRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.AlmacenTipoMovAsignarRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.AlmacenTipoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.ArticuloMovTipoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.ConfigEmpresaSaveRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.ConversionUnidadRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.InventarioConteoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.LotePalletRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.MotivoTrasladoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.MovimientoCabeceraRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.NumeradorDocumentoUpsertRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.OrdenTrasladoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.UbicacionRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenTipoMovResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.AlmacenTipoResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ConfigClaveResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ConversionUnidadResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.GuiaRemisionListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.IdRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.KardexListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.LotePalletListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MotivoTrasladoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.NumeradorDocumentoResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.SolicitudSalidaListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.StockAFechaListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.StockListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.TipoMovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.UbicacionAlmacenResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.ValorizacionListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.util.FlagEstadoLabels;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AlmacenRepository {

    public enum DetalleTipo {
        NINGUNO,
        MOVIMIENTO,
        ORDEN_TRASLADO,
        TOMA_INVENTARIO
    }

    public static final class ListadoResult {
        public final List<SimpleItem> items;
        public final DetalleTipo detalleTipo;

        public ListadoResult(List<SimpleItem> items, DetalleTipo detalleTipo) {
            this.items = items;
            this.detalleTipo = detalleTipo != null ? detalleTipo : DetalleTipo.NINGUNO;
        }

        public boolean abreDetalle() {
            return detalleTipo != DetalleTipo.NINGUNO;
        }
    }

    private final ApiClient apiClient;
    private final SessionManager session;

    public AlmacenRepository(ApiClient apiClient, SessionManager session) {
        this.apiClient = apiClient;
        this.session = session;
    }

    public void listarMovimientos(ResultCallback<List<MovimientoListItemResponse>> callback) {
        Long sucursalId = session.getSucursalId() > 0 ? session.getSucursalId() : null;
        apiClient.getAlmacenApi().listarMovimientos(sucursalId, null, 0, 50)
                .enqueue(pageCallback(callback, "No se pudieron cargar los movimientos"));
    }

    public void listarPorVista(String codigoVentana, AlmacenFuenteDatos fuente,
                               ResultCallback<ListadoResult> callback) {
        String estado = null;
        if ("AL016".equalsIgnoreCase(codigoVentana)) {
            estado = "P"; // pendientes aprobación
        }
        if (fuente == AlmacenFuenteDatos.MOVIMIENTOS) {
            Long sucursalId = session.getSucursalId() > 0 ? session.getSucursalId() : null;
            apiClient.getAlmacenApi().listarMovimientos(sucursalId, estado, 0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.MOVIMIENTO, (MovimientoListItemResponse m) -> new SimpleItem(
                            m.id,
                            m.nroVale != null ? m.nroVale : "Movimiento " + m.id,
                            nz(m.fechaMov) + " · " + FlagEstadoLabels.campoListado(m.flagEstado)
                    ), "movimientos"));
            return;
        }
        if (fuente == AlmacenFuenteDatos.ORDENES_TRASLADO) {
            apiClient.getAlmacenApi().listarOrdenesTraslado(estado, 0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.ORDEN_TRASLADO, (OrdenTrasladoListItemResponse o) -> new SimpleItem(
                            o.id,
                            o.numero != null ? o.numero : "OTR " + o.id,
                            nz(o.fecha) + " · " + FlagEstadoLabels.campoListado(o.flagEstado)
                                    + " · " + o.almacenOrigenId + " → " + o.almacenDestinoId
                    ), "órdenes de traslado"));
            return;
        }
        listarPorFuente(fuente, callback);
    }

    public void crearMovimiento(MovimientoCabeceraRequest body, ResultCallback<MovimientoDetalleResponse> callback) {
        apiClient.getAlmacenApi().crearMovimiento(body).enqueue(entityCallback(callback, "crear movimiento"));
    }

    public void actualizarMovimiento(long id, MovimientoCabeceraRequest body,
                                     ResultCallback<MovimientoDetalleResponse> callback) {
        apiClient.getAlmacenApi().actualizarMovimiento(id, body).enqueue(entityCallback(callback, "actualizar movimiento"));
    }

    public void crearOrdenTraslado(OrdenTrasladoRequest body, ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().crearOrdenTraslado(body).enqueue(entityCallback(callback, "crear OTR"));
    }

    public void actualizarOrdenTraslado(long id, OrdenTrasladoRequest body,
                                        ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().actualizarOrdenTraslado(id, body).enqueue(entityCallback(callback, "actualizar OTR"));
    }

    public void crearTomaInventario(InventarioConteoRequest body,
                                    ResultCallback<InventarioConteoDetalleResponse> callback) {
        apiClient.getAlmacenApi().crearTomaInventario(body).enqueue(entityCallback(callback, "crear conteo"));
    }

    public void actualizarTomaInventario(long id, InventarioConteoRequest body,
                                         ResultCallback<InventarioConteoDetalleResponse> callback) {
        apiClient.getAlmacenApi().actualizarTomaInventario(id, body).enqueue(entityCallback(callback, "actualizar conteo"));
    }

    public void guardarTabla(AlmacenFuenteDatos fuente, long id, Map<String, String> campos,
                             ResultCallback<String> callback) {
        try {
            Call<?> call = buildTablaCall(fuente, id, campos);
            if (call == null) {
                callback.onError("Esta tabla no admite alta/edición en móvil");
                return;
            }
            //noinspection unchecked
            ((Call<ApiResponse<?>>) call).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<ApiResponse<?>> c, Response<ApiResponse<?>> response) {
                    ApiResponse<?> body = response.body();
                    if (!response.isSuccessful() || body == null || !body.success) {
                        callback.onError(body != null && body.message != null ? body.message : "No se pudo guardar");
                        return;
                    }
                    callback.onSuccess(body.message != null ? body.message : "Guardado");
                }

                @Override
                public void onFailure(Call<ApiResponse<?>> c, Throwable t) {
                    callback.onError(msg(t));
                }
            });
        } catch (Exception e) {
            callback.onError(e.getMessage() != null ? e.getMessage() : "Datos inválidos");
        }
    }

    private Call<?> buildTablaCall(AlmacenFuenteDatos fuente, long id, Map<String, String> campos) {
        boolean crear = id <= 0;
        return switch (fuente) {
            case ALMACENES -> {
                AlmacenRequest r = new AlmacenRequest();
                r.sucursalId = longOr(campos.get("sucursalId"), session.getSucursalId());
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                r.almacenTipoId = longOrNull(campos.get("almacenTipoId"));
                r.flagEstado = orDefault(campos.get("flagEstado"), "1");
                yield crear ? apiClient.getAlmacenApi().crearAlmacen(r)
                        : apiClient.getAlmacenApi().actualizarAlmacen(id, r);
            }
            case TIPOS_MOVIMIENTO -> {
                ArticuloMovTipoRequest r = new ArticuloMovTipoRequest();
                r.tipoMov = req(campos, "tipoMov");
                r.descTipoMov = req(campos, "descTipoMov");
                r.flagEstado = orDefault(campos.get("flagEstado"), "1");
                r.factorSldoTotal = decimalOrNull(campos.get("factorSldoTotal"));
                yield crear ? apiClient.getAlmacenApi().crearTipoMovimiento(r)
                        : apiClient.getAlmacenApi().actualizarTipoMovimiento(id, r);
            }
            case TIPOS_ALMACEN -> {
                AlmacenTipoRequest r = new AlmacenTipoRequest();
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                r.cntblLibroId = longOrNull(campos.get("cntblLibroId"));
                r.flagEstado = orDefault(campos.get("flagEstado"), "1");
                yield crear ? apiClient.getAlmacenApi().crearTipoAlmacen(r)
                        : apiClient.getAlmacenApi().actualizarTipoAlmacen(id, r);
            }
            case UBICACIONES -> {
                UbicacionRequest r = new UbicacionRequest();
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                r.pasillo = campos.get("pasillo");
                r.estante = campos.get("estante");
                r.nivel = campos.get("nivel");
                long almId = longOr(campos.get("almacenId"), 0);
                if (crear) {
                    if (almId <= 0) throw new IllegalArgumentException("almacenId requerido");
                    yield apiClient.getAlmacenApi().crearUbicacion(almId, r);
                }
                yield apiClient.getAlmacenApi().actualizarUbicacion(id, r);
            }
            case TIPOS_MOV_ALMACEN -> {
                AlmacenTipoMovAsignarRequest r = new AlmacenTipoMovAsignarRequest();
                r.articuloMovTipoId = longOr(campos.get("articuloMovTipoId"), 0);
                long almId = longOr(campos.get("almacenId"), 0);
                if (almId <= 0 || r.articuloMovTipoId <= 0) {
                    throw new IllegalArgumentException("almacenId y articuloMovTipoId requeridos");
                }
                yield apiClient.getAlmacenApi().asignarTipoMov(almId, r);
            }
            case MOTIVOS_TRASLADO -> {
                MotivoTrasladoRequest r = new MotivoTrasladoRequest();
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                r.flagEstado = orDefault(campos.get("flagEstado"), "1");
                yield crear ? apiClient.getAlmacenApi().crearMotivoTraslado(r)
                        : apiClient.getAlmacenApi().actualizarMotivoTraslado(id, r);
            }
            case LOTES -> {
                LotePalletRequest r = new LotePalletRequest();
                r.articuloId = longOr(campos.get("articuloId"), 0);
                r.nroLote = req(campos, "nroLote");
                r.fechaProduccion = emptyToNull(campos.get("fechaProduccion"));
                r.fechaVencimiento = emptyToNull(campos.get("fechaVencimiento"));
                r.observacion = emptyToNull(campos.get("observacion"));
                r.flagEstado = orDefault(campos.get("flagEstado"), "1");
                if (r.articuloId <= 0) throw new IllegalArgumentException("articuloId requerido");
                yield crear ? apiClient.getAlmacenApi().crearLote(r)
                        : apiClient.getAlmacenApi().actualizarLote(id, r);
            }
            case CONVERSIONES -> {
                ConversionUnidadRequest r = new ConversionUnidadRequest();
                r.umOrigenId = longOr(campos.get("umOrigenId"), 0);
                r.umDestinoId = longOr(campos.get("umDestinoId"), 0);
                r.factorConversion = decimalOrNull(campos.get("factorConversion"));
                if (r.umOrigenId <= 0 || r.umDestinoId <= 0 || r.factorConversion == null) {
                    throw new IllegalArgumentException("UM origen/destino y factor requeridos");
                }
                yield crear ? apiClient.getCoreApi().crearConversion(r)
                        : apiClient.getCoreApi().actualizarConversion(id, r);
            }
            case NUMERACION_VALES, NUMERACION_OTR -> {
                NumeradorDocumentoUpsertRequest r = new NumeradorDocumentoUpsertRequest();
                r.nombreTabla = fuente == AlmacenFuenteDatos.NUMERACION_VALES
                        ? "almacen.vale_mov" : "almacen.orden_traslado";
                r.sucursalId = longOr(campos.get("sucursalId"), session.getSucursalId());
                r.ano = intOr(campos.get("ano"), java.time.Year.now().getValue());
                r.ultNro = longOr(campos.get("ultNro"), 1);
                r.flagEstado = orDefault(campos.get("flagEstado"), "1");
                yield apiClient.getCoreApi().upsertNumerador(r);
            }
            case PARAMETROS -> {
                ConfigEmpresaSaveRequest r = new ConfigEmpresaSaveRequest();
                r.empresaId = session.getEmpresaId();
                String clave = req(campos, "clave");
                r.valores = Map.of(clave, campos.get("valor") != null ? campos.get("valor") : "");
                yield apiClient.getCoreApi().guardarConfigEmpresa(r);
            }
            default -> null;
        };
    }

    private static String req(Map<String, String> m, String k) {
        String v = m.get(k);
        if (v == null || v.isBlank()) throw new IllegalArgumentException(k + " requerido");
        return v.trim();
    }

    private static String orDefault(String v, String d) {
        return v != null && !v.isBlank() ? v.trim() : d;
    }

    private static String emptyToNull(String v) {
        return v != null && !v.isBlank() ? v.trim() : null;
    }

    private static long longOr(String v, long d) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v.trim()) : d; }
        catch (Exception e) { return d; }
    }

    private static Long longOrNull(String v) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v.trim()) : null; }
        catch (Exception e) { return null; }
    }

    private static int intOr(String v, int d) {
        try { return v != null && !v.isBlank() ? Integer.parseInt(v.trim()) : d; }
        catch (Exception e) { return d; }
    }

    private static BigDecimal decimalOrNull(String v) {
        try { return v != null && !v.isBlank() ? new BigDecimal(v.trim()) : null; }
        catch (Exception e) { return null; }
    }

    public void obtenerMovimiento(long id, ResultCallback<MovimientoDetalleResponse> callback) {
        apiClient.getAlmacenApi().obtenerMovimiento(id).enqueue(entityCallback(callback, "detalle"));
    }

    public void confirmarMovimiento(long id, ResultCallback<MovimientoDetalleResponse> callback) {
        apiClient.getAlmacenApi().confirmarMovimiento(IdRequest.confirmar(id))
                .enqueue(entityCallback(callback, "confirmar movimiento"));
    }

    public void anularMovimiento(long id, String motivo, ResultCallback<MovimientoDetalleResponse> callback) {
        apiClient.getAlmacenApi().anularMovimiento(IdRequest.anular(id, motivo))
                .enqueue(entityCallback(callback, "anular movimiento"));
    }

    public void obtenerOrdenTraslado(long id, ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().obtenerOrdenTraslado(id).enqueue(entityCallback(callback, "OTR"));
    }

    public void aprobarOrdenTraslado(long id, ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().aprobarOrdenTraslado(id).enqueue(entityCallback(callback, "aprobar OTR"));
    }

    public void rechazarOrdenTraslado(long id, ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().rechazarOrdenTraslado(id).enqueue(entityCallback(callback, "rechazar OTR"));
    }

    public void cerrarOrdenTraslado(long id, ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().cerrarOrdenTraslado(id).enqueue(entityCallback(callback, "cerrar OTR"));
    }

    public void anularOrdenTraslado(long id, ResultCallback<OrdenTrasladoDetalleResponse> callback) {
        apiClient.getAlmacenApi().anularOrdenTraslado(id).enqueue(entityCallback(callback, "anular OTR"));
    }

    public void obtenerTomaInventario(long id, ResultCallback<InventarioConteoDetalleResponse> callback) {
        apiClient.getAlmacenApi().obtenerTomaInventario(id).enqueue(entityCallback(callback, "toma inventario"));
    }

    public void compararTomaInventario(long id, ResultCallback<InventarioConteoDetalleResponse> callback) {
        apiClient.getAlmacenApi().compararTomaInventario(id).enqueue(entityCallback(callback, "comparar conteo"));
    }

    public void cerrarTomaInventario(long id, ResultCallback<InventarioConteoDetalleResponse> callback) {
        apiClient.getAlmacenApi().cerrarTomaInventario(id).enqueue(entityCallback(callback, "cerrar conteo"));
    }

    public void anularTomaInventario(long id, ResultCallback<InventarioConteoDetalleResponse> callback) {
        apiClient.getAlmacenApi().anularTomaInventario(id).enqueue(entityCallback(callback, "anular conteo"));
    }

    public void listarPorFuente(AlmacenFuenteDatos fuente, ResultCallback<ListadoResult> callback) {
        switch (fuente) {
            case MOVIMIENTOS -> listarPorVista(null, AlmacenFuenteDatos.MOVIMIENTOS, callback);
            case ORDENES_TRASLADO -> listarPorVista(null, AlmacenFuenteDatos.ORDENES_TRASLADO, callback);
            case TOMAS_INVENTARIO -> apiClient.getAlmacenApi().listarTomasInventario(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.TOMA_INVENTARIO, (InventarioConteoListItemResponse t) -> new SimpleItem(
                            t.id,
                            "Conteo #" + (t.nroConteo != null ? t.nroConteo : t.id),
                            nz(t.fechaConteo) + " · art " + t.articuloId + " · "
                                    + FlagEstadoLabels.campoListado(t.flagEstado)
                    ), "tomas de inventario"));
            case STOCK -> apiClient.getAlmacenApi().listarStock(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (StockListItemResponse s) -> new SimpleItem(
                            s.id,
                            "Art " + s.articuloId + " · Alm " + s.almacenId,
                            "Disp " + s.cantidadDisponible + " · Costo " + s.costoPromedio
                    ), "stock"));
            case KARDEX -> apiClient.getAlmacenApi().listarKardex(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (KardexListItemResponse k) -> new SimpleItem(
                            k.id,
                            nz(k.articuloCodigo) + " · " + nz(k.articuloNombre),
                            nz(k.fecha) + " · " + nz(k.tipo) + " · cant " + k.cantidad
                    ), "kardex"));
            case DIAGNOSTICO -> apiClient.getAlmacenApi().diagnostico()
                    .enqueue(new Callback<>() {
                        @Override
                        public void onResponse(Call<ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>>> call,
                                               Response<ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>>> response) {
                            ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>> body = response.body();
                            if (!response.isSuccessful() || body == null || !body.success) {
                                callback.onError(body != null && body.message != null ? body.message : "Error diagnóstico");
                                return;
                            }
                            List<SimpleItem> items = new ArrayList<>();
                            List<DashboardLogisticoResponse.DiagnosticoAlmacenDto> data =
                                    body.data != null ? body.data : Collections.emptyList();
                            for (DashboardLogisticoResponse.DiagnosticoAlmacenDto d : data) {
                                items.add(new SimpleItem(
                                        d.almacenId,
                                        nz(d.almacenCodigo) + " · " + nz(d.almacenNombre),
                                        "Arts " + d.totalArticulos + " · Valor " + d.valorInventario));
                            }
                            callback.onSuccess(new ListadoResult(items, DetalleTipo.NINGUNO));
                        }

                        @Override
                        public void onFailure(Call<ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>>> call, Throwable t) {
                            callback.onError(msg(t));
                        }
                    });
            case VALORIZACION -> apiClient.getAlmacenApi().valorizacion(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (ValorizacionListItemResponse v) -> new SimpleItem(
                            v.articuloId != null ? v.articuloId : 0L,
                            nz(v.articuloCodigo) + " · " + nz(v.articuloNombre),
                            "Cant " + v.cantidadDisponible + " · Valor " + v.valorTotal
                    ), "valorización"));
            case STOCK_A_FECHA -> apiClient.getAlmacenApi().stockAFecha(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (StockAFechaListItemResponse s) -> new SimpleItem(
                            s.articuloId != null ? s.articuloId : 0L,
                            nz(s.articuloCodigo) + " · " + nz(s.articuloNombre),
                            "Alm " + s.almacenId + " · Cant " + s.cantidad
                    ), "stock a la fecha"));
            case ALMACENES -> apiClient.getAlmacenApi().listarAlmacenes(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (AlmacenMaestroResponse a) -> new SimpleItem(
                            a.id,
                            nz(a.codigo) + " · " + nz(a.nombre),
                            subtituloAlmacen(a)
                    ), "almacenes"));
            case TIPOS_MOVIMIENTO -> apiClient.getAlmacenApi().listarTiposMovimiento(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (TipoMovimientoListItemResponse t) -> new SimpleItem(
                            t.id,
                            nz(t.tipoMov) + " · " + nz(t.descTipoMov),
                            FlagEstadoLabels.campoListado(t.flagEstado)
                    ), "tipos de movimiento"));
            case TIPOS_ALMACEN -> apiClient.getAlmacenApi().listarTiposAlmacen(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (AlmacenTipoResponse t) -> new SimpleItem(
                            t.id,
                            nz(t.codigo) + " · " + nz(t.nombre),
                            "Libro: " + nz(t.libroNombre) + " · " + FlagEstadoLabels.campoListado(t.flagEstado)
                    ), "tipos de almacén"));
            case UBICACIONES -> listarUbicacionesTodas(callback);
            case TIPOS_MOV_ALMACEN -> listarTiposMovAlmacenTodas(callback);
            case MOTIVOS_TRASLADO -> apiClient.getAlmacenApi().listarMotivosTraslado(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (MotivoTrasladoListItemResponse m) -> new SimpleItem(
                            m.id,
                            nz(m.codigo) + " · " + nz(m.nombre != null ? m.nombre : m.descripcion),
                            subtituloMotivo(m)
                    ), "motivos"));
            case LOTES -> apiClient.getAlmacenApi().listarLotes(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (LotePalletListItemResponse l) -> new SimpleItem(
                            l.id,
                            nz(l.codigo) + " · lote " + nz(l.nroLote),
                            "Art " + l.articuloId + " · Alm " + l.almacenId
                    ), "lotes"));
            case CONVERSIONES -> apiClient.getCoreApi().listarConversiones(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (ConversionUnidadResponse c) -> new SimpleItem(
                            c.id,
                            nz(c.umOrigenCodigo) + " → " + nz(c.umDestinoCodigo),
                            nz(c.umOrigenNombre) + " / " + nz(c.umDestinoNombre) + " · factor " + c.factorConversion
                    ), "conversiones"));
            case NUMERACION_VALES -> apiClient.getCoreApi()
                    .listarNumeradores("almacen.vale_mov", 0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, this::mapNumerador, "numeración vales"));
            case NUMERACION_OTR -> apiClient.getCoreApi()
                    .listarNumeradores("almacen.orden_traslado", 0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, this::mapNumerador, "numeración OTR"));
            case PARAMETROS -> listarParametros(callback);
            case GUIAS_REMISION -> apiClient.getAlmacenApi().listarGuias(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (GuiaRemisionListItemResponse g) -> new SimpleItem(
                            g.id,
                            g.numero != null ? g.numero : "Guía " + g.id,
                            nz(g.fecha) + " · " + FlagEstadoLabels.campoListado(g.flagEstado)
                    ), "guías"));
            case SOLICITUDES_SALIDA -> apiClient.getAlmacenApi().listarSolicitudesSalida(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (SolicitudSalidaListItemResponse s) -> new SimpleItem(
                            s.id,
                            s.numero != null ? s.numero : "Solicitud " + s.id,
                            nz(s.fecha) + " · " + FlagEstadoLabels.campoListado(s.flagEstado)
                    ), "solicitudes"));
            default -> callback.onError("Fuente no soportada en móvil");
        }
    }

    public void ejecutarProceso(String procesoPath, ResultCallback<String> callback) {
        Call<ApiResponse<Object>> call;
        if ("/procesos/recalculo-precios-promedio".equals(procesoPath)) {
            call = apiClient.getAlmacenApi().procesoRecalculo();
        } else if ("/procesos/cuadre-stock".equals(procesoPath)) {
            call = apiClient.getAlmacenApi().procesoCuadreStock();
        } else if ("/procesos/actualizacion-automatica".equals(procesoPath)) {
            call = apiClient.getAlmacenApi().procesoActualizacion();
        } else {
            callback.onError("Proceso no soportado");
            return;
        }
        call.enqueue(new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<Object>> call, Response<ApiResponse<Object>> response) {
                ApiResponse<Object> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success) {
                    callback.onError(body != null && body.message != null ? body.message : "El proceso falló");
                    return;
                }
                callback.onSuccess(body.message != null ? body.message : "Proceso ejecutado correctamente");
            }

            @Override
            public void onFailure(Call<ApiResponse<Object>> call, Throwable t) {
                callback.onError(msg(t));
            }
        });
    }

    private void listarUbicacionesTodas(ResultCallback<ListadoResult> callback) {
        apiClient.getAlmacenApi().listarAlmacenes(0, 200).enqueue(new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<PageData<AlmacenMaestroResponse>>> call,
                                   Response<ApiResponse<PageData<AlmacenMaestroResponse>>> response) {
                List<AlmacenMaestroResponse> almacenes = extractPage(response, callback, "almacenes");
                if (almacenes == null) return;
                if (almacenes.isEmpty()) {
                    callback.onSuccess(new ListadoResult(List.of(), DetalleTipo.NINGUNO));
                    return;
                }
                List<SimpleItem> acc = Collections.synchronizedList(new ArrayList<>());
                AtomicInteger pending = new AtomicInteger(almacenes.size());
                AtomicInteger errors = new AtomicInteger(0);
                for (AlmacenMaestroResponse a : almacenes) {
                    apiClient.getAlmacenApi().listarUbicaciones(a.id).enqueue(new Callback<>() {
                        @Override
                        public void onResponse(Call<ApiResponse<List<UbicacionAlmacenResponse>>> call,
                                               Response<ApiResponse<List<UbicacionAlmacenResponse>>> response) {
                            ApiResponse<List<UbicacionAlmacenResponse>> body = response.body();
                            if (response.isSuccessful() && body != null && body.success && body.data != null) {
                                for (UbicacionAlmacenResponse u : body.data) {
                                    acc.add(new SimpleItem(
                                            u.id,
                                            nz(a.codigo) + " · " + nz(u.codigo) + " · " + nz(u.nombre),
                                            "Pasillo " + nz(u.pasillo) + " / Est " + nz(u.estante) + " / Niv " + nz(u.nivel)
                                    ));
                                }
                            } else {
                                errors.incrementAndGet();
                            }
                            if (pending.decrementAndGet() == 0) {
                                if (acc.isEmpty() && errors.get() > 0) {
                                    callback.onError("No se pudieron cargar ubicaciones");
                                } else {
                                    callback.onSuccess(new ListadoResult(new ArrayList<>(acc), DetalleTipo.NINGUNO));
                                }
                            }
                        }

                        @Override
                        public void onFailure(Call<ApiResponse<List<UbicacionAlmacenResponse>>> call, Throwable t) {
                            errors.incrementAndGet();
                            if (pending.decrementAndGet() == 0) {
                                if (acc.isEmpty()) callback.onError(msg(t));
                                else callback.onSuccess(new ListadoResult(new ArrayList<>(acc), DetalleTipo.NINGUNO));
                            }
                        }
                    });
                }
            }

            @Override
            public void onFailure(Call<ApiResponse<PageData<AlmacenMaestroResponse>>> call, Throwable t) {
                callback.onError(msg(t));
            }
        });
    }

    private void listarTiposMovAlmacenTodas(ResultCallback<ListadoResult> callback) {
        apiClient.getAlmacenApi().listarAlmacenes(0, 200).enqueue(new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<PageData<AlmacenMaestroResponse>>> call,
                                   Response<ApiResponse<PageData<AlmacenMaestroResponse>>> response) {
                List<AlmacenMaestroResponse> almacenes = extractPage(response, callback, "almacenes");
                if (almacenes == null) return;
                if (almacenes.isEmpty()) {
                    callback.onSuccess(new ListadoResult(List.of(), DetalleTipo.NINGUNO));
                    return;
                }
                List<SimpleItem> acc = Collections.synchronizedList(new ArrayList<>());
                AtomicInteger pending = new AtomicInteger(almacenes.size());
                for (AlmacenMaestroResponse a : almacenes) {
                    apiClient.getAlmacenApi().listarTiposMovPorAlmacen(a.id, 0, 200).enqueue(new Callback<>() {
                        @Override
                        public void onResponse(Call<ApiResponse<PageData<AlmacenTipoMovResponse>>> call,
                                               Response<ApiResponse<PageData<AlmacenTipoMovResponse>>> response) {
                            List<AlmacenTipoMovResponse> rows = extractPageQuiet(response);
                            for (AlmacenTipoMovResponse t : rows) {
                                acc.add(new SimpleItem(
                                        t.id,
                                        nz(a.codigo) + " · " + nz(t.tipoMov),
                                        nz(t.descTipoMov) + " · " + FlagEstadoLabels.campoListado(t.flagEstado)
                                ));
                            }
                            if (pending.decrementAndGet() == 0) {
                                callback.onSuccess(new ListadoResult(new ArrayList<>(acc), DetalleTipo.NINGUNO));
                            }
                        }

                        @Override
                        public void onFailure(Call<ApiResponse<PageData<AlmacenTipoMovResponse>>> call, Throwable t) {
                            if (pending.decrementAndGet() == 0) {
                                callback.onSuccess(new ListadoResult(new ArrayList<>(acc), DetalleTipo.NINGUNO));
                            }
                        }
                    });
                }
            }

            @Override
            public void onFailure(Call<ApiResponse<PageData<AlmacenMaestroResponse>>> call, Throwable t) {
                callback.onError(msg(t));
            }
        });
    }

    private void listarParametros(ResultCallback<ListadoResult> callback) {
        apiClient.getCoreApi().listarClavesConfig("ALMACEN", null).enqueue(new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<List<ConfigClaveResponse>>> call,
                                   Response<ApiResponse<List<ConfigClaveResponse>>> response) {
                ApiResponse<List<ConfigClaveResponse>> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success) {
                    callback.onError(body != null && body.message != null ? body.message : "No se pudieron cargar parámetros");
                    return;
                }
                List<ConfigClaveResponse> claves = body.data != null ? body.data : List.of();
                long empresaId = session.getEmpresaId();
                if (empresaId <= 0 || claves.isEmpty()) {
                    callback.onSuccess(new ListadoResult(mapClaves(claves, Map.of()), DetalleTipo.NINGUNO));
                    return;
                }
                apiClient.getCoreApi().configEmpresa(empresaId).enqueue(new Callback<>() {
                    @Override
                    public void onResponse(Call<ApiResponse<Map<String, Object>>> call,
                                           Response<ApiResponse<Map<String, Object>>> response) {
                        Map<String, Object> valores = Map.of();
                        ApiResponse<Map<String, Object>> b = response.body();
                        if (response.isSuccessful() && b != null && b.success && b.data != null) {
                            valores = b.data;
                        }
                        callback.onSuccess(new ListadoResult(mapClaves(claves, valores), DetalleTipo.NINGUNO));
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<Map<String, Object>>> call, Throwable t) {
                        callback.onSuccess(new ListadoResult(mapClaves(claves, Map.of()), DetalleTipo.NINGUNO));
                    }
                });
            }

            @Override
            public void onFailure(Call<ApiResponse<List<ConfigClaveResponse>>> call, Throwable t) {
                callback.onError(msg(t));
            }
        });
    }

    private static List<SimpleItem> mapClaves(List<ConfigClaveResponse> claves, Map<String, Object> valores) {
        List<SimpleItem> items = new ArrayList<>();
        long i = 1;
        for (ConfigClaveResponse c : claves) {
            Object val = valores.get(c.clave);
            items.add(new SimpleItem(
                    i++,
                    nz(c.clave),
                    nz(c.descripcion) + " · " + (val != null ? String.valueOf(val) : "—")
            ));
        }
        return items;
    }

    private SimpleItem mapNumerador(NumeradorDocumentoResponse n) {
        return new SimpleItem(
                n.sucursalId != null ? n.sucursalId : 0L,
                nz(n.sucursalCodigo) + " · " + nz(n.sucursalNombre),
                "Año " + n.ano + " · próximo " + n.ultNro + " · " + FlagEstadoLabels.campoListado(n.flagEstado)
        );
    }

    /** Subtítulo de maestro almacenes (paridad columnas web). */
    private static String subtituloAlmacen(AlmacenMaestroResponse a) {
        return "Tipo: " + nz(a.almacenTipoNombre)
                + "\nSucursal: " + nz(a.sucursalNombre)
                + "\nCentro de costos: " + centrosCostoLabel(a.centrosCostoCodigo, a.centrosCostoNombre)
                + "\n" + FlagEstadoLabels.campoListado(a.flagEstado);
    }

    private static String subtituloMotivo(MotivoTrasladoListItemResponse m) {
        String desc = m.descripcion != null && !m.descripcion.isBlank() ? m.descripcion.trim() : null;
        if (desc != null && m.nombre != null && !desc.equalsIgnoreCase(m.nombre.trim())) {
            return "Descripción: " + desc + "\n" + FlagEstadoLabels.campoListado(m.flagEstado);
        }
        return FlagEstadoLabels.campoListado(m.flagEstado);
    }

    private static String centrosCostoLabel(String codigo, String nombre) {
        String c = codigo != null ? codigo.trim() : "";
        String n = nombre != null ? nombre.trim() : "";
        if (!c.isEmpty() && !n.isEmpty()) {
            return c + " — " + n;
        }
        if (!n.isEmpty()) {
            return n;
        }
        if (!c.isEmpty()) {
            return c;
        }
        return "—";
    }

    private interface Mapper<T> {
        SimpleItem map(T row);
    }

    private <T> Callback<ApiResponse<PageData<T>>> mapPage(
            ResultCallback<ListadoResult> callback, DetalleTipo tipo, Mapper<T> mapper, String label) {
        return new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<PageData<T>>> call, Response<ApiResponse<PageData<T>>> response) {
                List<T> data = extractPage(response, callback, label);
                if (data == null) return;
                List<SimpleItem> items = new ArrayList<>();
                for (T row : data) items.add(mapper.map(row));
                callback.onSuccess(new ListadoResult(items, tipo));
            }

            @Override
            public void onFailure(Call<ApiResponse<PageData<T>>> call, Throwable t) {
                callback.onError(msg(t));
            }
        };
    }

    private <T> List<T> extractPage(Response<ApiResponse<PageData<T>>> response,
                                    ResultCallback<?> callback, String label) {
        ApiResponse<PageData<T>> body = response.body();
        if (!response.isSuccessful() || body == null || !body.success) {
            callback.onError(body != null && body.message != null ? body.message : "No se pudo cargar " + label);
            return null;
        }
        return body.data != null && body.data.content != null ? body.data.content : Collections.emptyList();
    }

    private <T> List<T> extractPageQuiet(Response<ApiResponse<PageData<T>>> response) {
        ApiResponse<PageData<T>> body = response.body();
        if (!response.isSuccessful() || body == null || !body.success || body.data == null || body.data.content == null) {
            return Collections.emptyList();
        }
        return body.data.content;
    }

    private <T> Callback<ApiResponse<T>> entityCallback(ResultCallback<T> callback, String label) {
        return new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<T>> call, Response<ApiResponse<T>> response) {
                ApiResponse<T> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                    callback.onError(body != null && body.message != null ? body.message : "No se pudo " + label);
                    return;
                }
                callback.onSuccess(body.data);
            }

            @Override
            public void onFailure(Call<ApiResponse<T>> call, Throwable t) {
                callback.onError(msg(t));
            }
        };
    }

    private <T> Callback<ApiResponse<PageData<T>>> pageCallback(ResultCallback<List<T>> callback, String err) {
        return new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<PageData<T>>> call, Response<ApiResponse<PageData<T>>> response) {
                ApiResponse<PageData<T>> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success) {
                    callback.onError(body != null && body.message != null ? body.message : err);
                    return;
                }
                callback.onSuccess(body.data != null ? body.data.content : Collections.emptyList());
            }

            @Override
            public void onFailure(Call<ApiResponse<PageData<T>>> call, Throwable t) {
                callback.onError(msg(t));
            }
        };
    }

    private static String nz(String v) {
        return v != null && !v.isBlank() ? v : "—";
    }

    private static String msg(Throwable t) {
        return t.getMessage() != null ? t.getMessage() : "Error de red";
    }
}
