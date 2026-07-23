package pe.com.hermes.appmobile.data.repository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.appmobile.data.remote.ApiClient;
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
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AlmacenRepository {

    public static final class ListadoResult {
        public final List<SimpleItem> items;
        public final boolean abreDetalleMovimiento;

        public ListadoResult(List<SimpleItem> items, boolean abreDetalleMovimiento) {
            this.items = items;
            this.abreDetalleMovimiento = abreDetalleMovimiento;
        }
    }

    private final ApiClient apiClient;
    private final SessionManager session;

    public AlmacenRepository(ApiClient apiClient, SessionManager session) {
        this.apiClient = apiClient;
        this.session = session;
    }

    public void listarMovimientos(ResultCallback<List<MovimientoListItemResponse>> callback) {
        listarMovimientos(0, callback);
    }

    public void listarMovimientos(int page, ResultCallback<List<MovimientoListItemResponse>> callback) {
        Long sucursalId = session.getSucursalId() > 0 ? session.getSucursalId() : null;
        apiClient.getAlmacenApi().listarMovimientos(sucursalId, page, 50)
                .enqueue(pageCallback(callback, "No se pudieron cargar los movimientos"));
    }

    public void obtenerMovimiento(long id, ResultCallback<MovimientoDetalleResponse> callback) {
        apiClient.getAlmacenApi().obtenerMovimiento(id).enqueue(new Callback<ApiResponse<MovimientoDetalleResponse>>() {
            @Override
            public void onResponse(Call<ApiResponse<MovimientoDetalleResponse>> call,
                                   Response<ApiResponse<MovimientoDetalleResponse>> response) {
                ApiResponse<MovimientoDetalleResponse> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                    callback.onError(body != null && body.message != null ? body.message : "No se pudo cargar el detalle");
                    return;
                }
                callback.onSuccess(body.data);
            }

            @Override
            public void onFailure(Call<ApiResponse<MovimientoDetalleResponse>> call, Throwable t) {
                callback.onError(t.getMessage() != null ? t.getMessage() : "Error de red");
            }
        });
    }

    public void listarPorFuente(AlmacenFuenteDatos fuente, ResultCallback<ListadoResult> callback) {
        switch (fuente) {
            case MOVIMIENTOS -> {
                Long sucursalId = session.getSucursalId() > 0 ? session.getSucursalId() : null;
                apiClient.getAlmacenApi().listarMovimientos(sucursalId, 0, 80)
                        .enqueue(new Callback<ApiResponse<PageData<MovimientoListItemResponse>>>() {
                            @Override
                            public void onResponse(Call<ApiResponse<PageData<MovimientoListItemResponse>>> call,
                                                   Response<ApiResponse<PageData<MovimientoListItemResponse>>> response) {
                                List<MovimientoListItemResponse> data = extractPage(response, callback, "movimientos");
                                if (data == null) return;
                                List<SimpleItem> items = new ArrayList<>();
                                for (MovimientoListItemResponse m : data) {
                                    items.add(new SimpleItem(
                                            m.id,
                                            m.nroVale != null ? m.nroVale : "Movimiento " + m.id,
                                            nz(m.fechaMov) + " · estado " + nz(m.flagEstado)));
                                }
                                callback.onSuccess(new ListadoResult(items, true));
                            }

                            @Override
                            public void onFailure(Call<ApiResponse<PageData<MovimientoListItemResponse>>> call, Throwable t) {
                                callback.onError(msg(t));
                            }
                        });
            }
            case ORDENES_TRASLADO -> apiClient.getAlmacenApi().listarOrdenesTraslado(0, 80)
                    .enqueue(mapPage(callback, false, (OrdenTrasladoListItemResponse o) -> new SimpleItem(
                            o.id,
                            o.numero != null ? o.numero : "OTR " + o.id,
                            nz(o.fecha) + " · " + nz(o.flagEstado) + " · orig " + o.almacenOrigenId + " → dest " + o.almacenDestinoId
                    ), "órdenes de traslado"));
            case TOMAS_INVENTARIO -> apiClient.getAlmacenApi().listarTomasInventario(0, 80)
                    .enqueue(mapPage(callback, false, (InventarioConteoListItemResponse t) -> new SimpleItem(
                            t.id,
                            "Conteo #" + (t.nroConteo != null ? t.nroConteo : t.id),
                            nz(t.fechaConteo) + " · art " + t.articuloId + " · " + nz(t.flagEstado)
                    ), "tomas de inventario"));
            case STOCK -> apiClient.getAlmacenApi().listarStock(0, 80)
                    .enqueue(mapPage(callback, false, (StockListItemResponse s) -> new SimpleItem(
                            s.id,
                            "Art " + s.articuloId + " · Alm " + s.almacenId,
                            "Disp " + s.cantidadDisponible + " · Costo " + s.costoPromedio
                    ), "stock"));
            case KARDEX -> apiClient.getAlmacenApi().listarKardex(0, 80)
                    .enqueue(mapPage(callback, false, (KardexListItemResponse k) -> new SimpleItem(
                            k.id,
                            nz(k.articuloCodigo) + " · " + nz(k.articuloNombre),
                            nz(k.fecha) + " · " + nz(k.tipo) + " · cant " + k.cantidad
                    ), "kardex"));
            case DIAGNOSTICO -> apiClient.getAlmacenApi().diagnostico()
                    .enqueue(new Callback<ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>>>() {
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
                            callback.onSuccess(new ListadoResult(items, false));
                        }

                        @Override
                        public void onFailure(Call<ApiResponse<List<DashboardLogisticoResponse.DiagnosticoAlmacenDto>>> call, Throwable t) {
                            callback.onError(msg(t));
                        }
                    });
            case VALORIZACION -> apiClient.getAlmacenApi().valorizacion(0, 80)
                    .enqueue(mapPage(callback, false, (ValorizacionListItemResponse v) -> new SimpleItem(
                            v.articuloId != null ? v.articuloId : 0L,
                            nz(v.articuloCodigo) + " · " + nz(v.articuloNombre),
                            "Cant " + v.cantidadDisponible + " · Valor " + v.valorTotal
                    ), "valorización"));
            case STOCK_A_FECHA -> apiClient.getAlmacenApi().stockAFecha(0, 80)
                    .enqueue(mapPage(callback, false, (StockAFechaListItemResponse s) -> new SimpleItem(
                            s.articuloId != null ? s.articuloId : 0L,
                            nz(s.articuloCodigo) + " · " + nz(s.articuloNombre),
                            "Alm " + s.almacenId + " · Cant " + s.cantidad
                    ), "stock a la fecha"));
            case ALMACENES -> apiClient.getAlmacenApi().listarAlmacenes(0, 80)
                    .enqueue(mapPage(callback, false, (AlmacenMaestroResponse a) -> new SimpleItem(
                            a.id,
                            nz(a.codigo) + " · " + nz(a.nombre),
                            nz(a.almacenTipoNombre) + " · " + nz(a.sucursalNombre) + " · " + nz(a.flagEstado)
                    ), "almacenes"));
            case TIPOS_MOVIMIENTO -> apiClient.getAlmacenApi().listarTiposMovimiento(0, 80)
                    .enqueue(mapPage(callback, false, (TipoMovimientoListItemResponse t) -> new SimpleItem(
                            t.id,
                            nz(t.tipoMov) + " · " + nz(t.descTipoMov),
                            nz(t.flagEstado)
                    ), "tipos de movimiento"));
            case MOTIVOS_TRASLADO -> apiClient.getAlmacenApi().listarMotivosTraslado(0, 80)
                    .enqueue(mapPage(callback, false, (MotivoTrasladoListItemResponse m) -> new SimpleItem(
                            m.id,
                            nz(m.codigo) + " · " + nz(m.descripcion),
                            nz(m.flagEstado)
                    ), "motivos"));
            case LOTES -> apiClient.getAlmacenApi().listarLotes(0, 80)
                    .enqueue(mapPage(callback, false, (LotePalletListItemResponse l) -> new SimpleItem(
                            l.id,
                            nz(l.codigo) + " · lote " + nz(l.nroLote),
                            "Art " + l.articuloId + " · Alm " + l.almacenId
                    ), "lotes"));
            case GUIAS_REMISION -> apiClient.getAlmacenApi().listarGuias(0, 80)
                    .enqueue(mapPage(callback, false, (GuiaRemisionListItemResponse g) -> new SimpleItem(
                            g.id,
                            g.numero != null ? g.numero : "Guía " + g.id,
                            nz(g.fecha) + " · " + nz(g.flagEstado)
                    ), "guías"));
            case SOLICITUDES_SALIDA -> apiClient.getAlmacenApi().listarSolicitudesSalida(0, 80)
                    .enqueue(mapPage(callback, false, (SolicitudSalidaListItemResponse s) -> new SimpleItem(
                            s.id,
                            s.numero != null ? s.numero : "Solicitud " + s.id,
                            nz(s.fecha) + " · " + nz(s.flagEstado)
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
        call.enqueue(new Callback<ApiResponse<Object>>() {
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

    private interface Mapper<T> {
        SimpleItem map(T row);
    }

    private <T> Callback<ApiResponse<PageData<T>>> mapPage(
            ResultCallback<ListadoResult> callback, boolean detalleMov, Mapper<T> mapper, String label) {
        return new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<PageData<T>>> call, Response<ApiResponse<PageData<T>>> response) {
                List<T> data = extractPage(response, callback, label);
                if (data == null) return;
                List<SimpleItem> items = new ArrayList<>();
                for (T row : data) items.add(mapper.map(row));
                callback.onSuccess(new ListadoResult(items, detalleMov));
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
