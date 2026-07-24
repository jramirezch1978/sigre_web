package pe.com.hermes.appmobile.data.repository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import pe.com.hermes.appmobile.data.compras.ComprasFuenteDatos;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.CatalogoCodigoNombreRequest;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ConvertirBody;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ConvertirResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.MotivoBody;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ObservacionBody;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ProveedorDto;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ProveedorRequest;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudRequest;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.TipoEntidadDto;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.TipoEntidadRequest;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.util.FlagEstadoLabels;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ComprasRepository {

    public enum DetalleTipo { NINGUNO, SOLICITUD }

    public static final class ListadoResult {
        public final List<SimpleItem> items;
        public final DetalleTipo detalleTipo;

        public ListadoResult(List<SimpleItem> items, DetalleTipo detalleTipo) {
            this.items = items;
            this.detalleTipo = detalleTipo != null ? detalleTipo : DetalleTipo.NINGUNO;
        }
    }

    private final ApiClient apiClient;
    private final SessionManager session;

    public ComprasRepository(ApiClient apiClient, SessionManager session) {
        this.apiClient = apiClient;
        this.session = session;
    }

    public void listarSolicitudes(ResultCallback<List<SolicitudCompraResponse>> callback) {
        Long suc = session.getSucursalId() > 0 ? session.getSucursalId() : null;
        apiClient.getComprasApi().listarSolicitudes(suc, null, 0, 80)
                .enqueue(pageCallback(callback, "No se pudieron cargar las solicitudes"));
    }

    public void listarPorFuente(ComprasFuenteDatos fuente, ResultCallback<ListadoResult> callback) {
        switch (fuente) {
            case SOLICITUDES -> {
                Long suc = session.getSucursalId() > 0 ? session.getSucursalId() : null;
                apiClient.getComprasApi().listarSolicitudes(suc, null, 0, 80)
                        .enqueue(mapPage(callback, DetalleTipo.SOLICITUD, (SolicitudCompraResponse s) -> new SimpleItem(
                                s.id,
                                s.numero != null ? s.numero : "Solicitud " + s.id,
                                nz(s.fecha) + " · " + nz(s.prioridad) + " · "
                                        + FlagEstadoLabels.campoListado(s.flagEstado)
                                        + " · ítems " + s.totalItems
                        ), "solicitudes"));
            }
            case PROVEEDORES -> apiClient.getCoreApi().listarProveedores(true, 0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (ProveedorDto p) -> new SimpleItem(
                            p.id,
                            nz(p.nroDocumento) + " · " + nz(p.razonSocial),
                            nz(p.telefono) + " · " + FlagEstadoLabels.campoListado(p.flagEstado)
                    ), "proveedores"));
            case TIPOS_PROVEEDOR -> apiClient.getComprasApi().listarTiposProveedor(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, (TipoEntidadDto t) -> new SimpleItem(
                            t.id,
                            nz(t.tipo) + " · " + nz(t.descripcion),
                            FlagEstadoLabels.campoListado(t.flagEstado)
                    ), "tipos proveedor"));
            case MARCAS -> apiClient.getCoreApi().listarMarcas(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, c -> new SimpleItem(
                            c.id, nz(c.codigo) + " · " + nz(c.nombre),
                            FlagEstadoLabels.campoListado(c.flagEstado)
                    ), "marcas"));
            case COLORES -> apiClient.getCoreApi().listarColores(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, c -> new SimpleItem(
                            c.id, nz(c.codigo) + " · " + nz(c.nombre),
                            FlagEstadoLabels.campoListado(c.flagEstado)
                    ), "colores"));
            case CLASES_ARTICULO -> apiClient.getCoreApi().listarClases(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, c -> new SimpleItem(
                            c.id,
                            nz(c.codClase != null ? c.codClase : c.codigo) + " · "
                                    + nz(c.descClase != null ? c.descClase : c.nombre),
                            FlagEstadoLabels.campoListado(c.flagEstado)
                    ), "clases"));
            case CATEGORIAS -> apiClient.getCoreApi().listarCategorias(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, c -> new SimpleItem(
                            c.id,
                            nz(c.catArt != null ? c.catArt : c.codigo) + " · "
                                    + nz(c.descCateg != null ? c.descCateg : c.nombre),
                            FlagEstadoLabels.campoListado(c.flagEstado)
                    ), "categorías"));
            case SUB_CATEGORIAS -> apiClient.getCoreApi().listarSubCategorias(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, c -> new SimpleItem(
                            c.id,
                            nz(c.codSubCat != null ? c.codSubCat : c.codigo) + " · "
                                    + nz(c.descSubcateg != null ? c.descSubcateg : c.nombre),
                            "Cat " + c.articuloCategId + " · " + FlagEstadoLabels.campoListado(c.flagEstado)
                    ), "subcategorías"));
            case ARTICULOS -> apiClient.getCoreApi().listarArticulos(0, 80)
                    .enqueue(mapPage(callback, DetalleTipo.NINGUNO, c -> new SimpleItem(
                            c.id,
                            nz(c.codigo) + " · " + nz(c.nombre),
                            "Tipo: " + nz(c.tipo) + " · " + FlagEstadoLabels.campoListado(c.flagEstado)
                    ), "artículos"));
            default -> callback.onError("Fuente Compras no soportada");
        }
    }

    public void obtenerSolicitud(long id, ResultCallback<SolicitudDetalleResponse> callback) {
        apiClient.getComprasApi().obtenerSolicitud(id).enqueue(entity(callback, "detalle solicitud"));
    }

    public void guardarSolicitud(long id, SolicitudRequest body, ResultCallback<SolicitudDetalleResponse> callback) {
        if (id > 0) apiClient.getComprasApi().actualizarSolicitud(id, body).enqueue(entity(callback, "actualizar"));
        else apiClient.getComprasApi().crearSolicitud(body).enqueue(entity(callback, "crear"));
    }

    public void enviar(long id, ResultCallback<SolicitudDetalleResponse> callback) {
        apiClient.getComprasApi().enviarSolicitud(id).enqueue(entity(callback, "enviar"));
    }

    public void aprobar(long id, String obs, ResultCallback<SolicitudDetalleResponse> callback) {
        apiClient.getComprasApi().aprobarSolicitud(id, ObservacionBody.of(obs)).enqueue(entity(callback, "aprobar"));
    }

    public void rechazar(long id, String motivo, ResultCallback<SolicitudDetalleResponse> callback) {
        apiClient.getComprasApi().rechazarSolicitud(id, MotivoBody.of(motivo)).enqueue(entity(callback, "rechazar"));
    }

    public void anular(long id, String motivo, ResultCallback<SolicitudDetalleResponse> callback) {
        apiClient.getComprasApi().anularSolicitud(id, MotivoBody.of(motivo)).enqueue(entity(callback, "anular"));
    }

    public void convertir(long id, String destino, long proveedorId, ResultCallback<ConvertirResponse> callback) {
        ConvertirBody b = new ConvertirBody();
        b.destino = destino;
        b.proveedorIds = List.of(proveedorId);
        apiClient.getComprasApi().convertirSolicitud(id, b).enqueue(entity(callback, "convertir"));
    }

    public void guardarTabla(ComprasFuenteDatos fuente, long id, Map<String, String> campos,
                             ResultCallback<String> callback) {
        try {
            Call<?> call = buildTablaCall(fuente, id, campos);
            if (call == null) {
                callback.onError("Tabla no editable");
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

    private Call<?> buildTablaCall(ComprasFuenteDatos fuente, long id, Map<String, String> campos) {
        boolean crear = id <= 0;
        return switch (fuente) {
            case TIPOS_PROVEEDOR -> {
                TipoEntidadRequest r = new TipoEntidadRequest();
                r.tipo = req(campos, "tipo");
                r.descripcion = req(campos, "descripcion");
                r.flagEstado = or(campos.get("flagEstado"), "1");
                yield crear ? apiClient.getComprasApi().crearTipoProveedor(r)
                        : apiClient.getComprasApi().actualizarTipoProveedor(id, r);
            }
            case PROVEEDORES -> {
                ProveedorRequest r = new ProveedorRequest();
                r.razonSocial = req(campos, "razonSocial");
                r.nombreComercial = emptyToNull(campos.get("nombreComercial"));
                r.tipoDocIdentidadId = longOr(campos.get("tipoDocIdentidadId"), 1);
                r.nroDocumento = req(campos, "nroDocumento");
                r.direccion = emptyToNull(campos.get("direccion"));
                r.telefono = emptyToNull(campos.get("telefono"));
                r.email = emptyToNull(campos.get("email"));
                r.esProveedor = true;
                r.esCliente = "1".equals(campos.get("esCliente")) || "true".equalsIgnoreCase(campos.get("esCliente"));
                r.tipoEntidadContribuyenteId = longOrNull(campos.get("tipoEntidadContribuyenteId"));
                r.flagEstado = or(campos.get("flagEstado"), "1");
                yield crear ? apiClient.getCoreApi().crearProveedor(r)
                        : apiClient.getCoreApi().actualizarProveedor(id, r);
            }
            case MARCAS -> {
                CatalogoCodigoNombreRequest r = new CatalogoCodigoNombreRequest();
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                yield crear ? apiClient.getCoreApi().crearMarca(r) : apiClient.getCoreApi().actualizarMarca(id, r);
            }
            case COLORES -> {
                CatalogoCodigoNombreRequest r = new CatalogoCodigoNombreRequest();
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                yield crear ? apiClient.getCoreApi().crearColor(r) : apiClient.getCoreApi().actualizarColor(id, r);
            }
            case CLASES_ARTICULO -> {
                CatalogoCodigoNombreRequest r = new CatalogoCodigoNombreRequest();
                r.codClase = req(campos, "codClase");
                r.descClase = req(campos, "descClase");
                yield crear ? apiClient.getCoreApi().crearClase(r) : apiClient.getCoreApi().actualizarClase(id, r);
            }
            case CATEGORIAS -> {
                CatalogoCodigoNombreRequest r = new CatalogoCodigoNombreRequest();
                r.catArt = req(campos, "catArt");
                r.descCateg = req(campos, "descCateg");
                yield crear ? apiClient.getCoreApi().crearCategoria(r)
                        : apiClient.getCoreApi().actualizarCategoria(id, r);
            }
            case SUB_CATEGORIAS -> {
                CatalogoCodigoNombreRequest r = new CatalogoCodigoNombreRequest();
                r.codSubCat = req(campos, "codSubCat");
                r.descSubcateg = req(campos, "descSubcateg");
                r.articuloCategId = longOr(campos.get("articuloCategId"), 0);
                if (r.articuloCategId <= 0) throw new IllegalArgumentException("articuloCategId requerido");
                yield crear ? apiClient.getCoreApi().crearSubCategoria(r)
                        : apiClient.getCoreApi().actualizarSubCategoria(id, r);
            }
            case ARTICULOS -> {
                CatalogoCodigoNombreRequest r = new CatalogoCodigoNombreRequest();
                r.codigo = req(campos, "codigo");
                r.nombre = req(campos, "nombre");
                r.tipo = or(campos.get("tipo"), "B");
                r.descripcion = emptyToNull(campos.get("descripcion"));
                r.unidadMedidaId = longOr(campos.get("unidadMedidaId"), 0);
                if (r.unidadMedidaId <= 0) throw new IllegalArgumentException("unidadMedidaId requerido");
                r.articuloCategId = longOrNull(campos.get("articuloCategId"));
                r.articuloSubCategId = longOrNull(campos.get("articuloSubCategId"));
                r.articuloClaseId = longOrNull(campos.get("articuloClaseId"));
                r.marcaId = longOrNull(campos.get("marcaId"));
                r.colorId = longOrNull(campos.get("colorId"));
                r.flagEstado = or(campos.get("flagEstado"), "1");
                yield crear ? apiClient.getCoreApi().crearArticulo(r)
                        : apiClient.getCoreApi().actualizarArticulo(id, r);
            }
            default -> null;
        };
    }

    private interface Mapper<T> { SimpleItem map(T row); }

    private <T> Callback<ApiResponse<PageData<T>>> mapPage(
            ResultCallback<ListadoResult> callback, DetalleTipo tipo, Mapper<T> mapper, String label) {
        return new Callback<>() {
            @Override
            public void onResponse(Call<ApiResponse<PageData<T>>> call, Response<ApiResponse<PageData<T>>> response) {
                ApiResponse<PageData<T>> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success) {
                    callback.onError(body != null && body.message != null ? body.message : "No se pudo cargar " + label);
                    return;
                }
                List<T> data = body.data != null && body.data.content != null ? body.data.content : Collections.emptyList();
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

    private <T> Callback<ApiResponse<T>> entity(ResultCallback<T> callback, String label) {
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

    private static String req(Map<String, String> m, String k) {
        String v = m.get(k);
        if (v == null || v.isBlank()) throw new IllegalArgumentException(k + " requerido");
        return v.trim();
    }

    private static String or(String v, String d) { return v != null && !v.isBlank() ? v.trim() : d; }
    private static String emptyToNull(String v) { return v != null && !v.isBlank() ? v.trim() : null; }
    private static long longOr(String v, long d) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v.trim()) : d; } catch (Exception e) { return d; }
    }
    private static Long longOrNull(String v) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v.trim()) : null; } catch (Exception e) { return null; }
    }
    private static String nz(String v) { return v != null && !v.isBlank() ? v : "—"; }
    private static String msg(Throwable t) { return t.getMessage() != null ? t.getMessage() : "Error de red"; }
}
