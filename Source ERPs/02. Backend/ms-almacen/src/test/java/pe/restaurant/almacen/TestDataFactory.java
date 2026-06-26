package pe.restaurant.almacen;

import pe.restaurant.almacen.dto.*;
import pe.restaurant.almacen.entity.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Fábrica centralizada de objetos de prueba para ms-almacén (patrón ms-compras).
 * Métodos estáticos; datos en memoria para tests unitarios con Mockito.
 * Para persistencia JDBC idempotente ver {@link pe.restaurant.almacen.testdata.AlmacenTestDataFactory}.
 * Cuerpos HTTP en IT: {@link pe.restaurant.almacen.support.AlmacenTestFixtures}.
 */
public final class TestDataFactory {

    public static final String NRO_VALE_FACTORY = "LM-TEST-0001";
    public static final String CODIGO_ALMACEN = "AL-TEST-01";

    private TestDataFactory() {}

    // ── Entidades maestras ──

    public static Almacen almacen(Long id) {
        return almacen(id, 10L, CODIGO_ALMACEN);
    }

    public static Almacen almacen(Long id, Long sucursalId, String codigo) {
        Almacen a = new Almacen();
        a.setId(id);
        a.setSucursalId(sucursalId);
        a.setAlmacenTipoId(1L);
        a.setCodigo(codigo);
        a.setNombre("Almacén test " + codigo);
        a.setFlagEstado("1");
        return a;
    }

    public static ArticuloMovTipo articuloMovTipo(Long id) {
        return articuloMovTipoIngreso(id);
    }

    public static ArticuloMovTipo articuloMovTipoIngreso(Long id) {
        ArticuloMovTipo t = new ArticuloMovTipo();
        t.setId(id);
        t.setTipoMov("I01");
        t.setDescTipoMov("Ingreso test");
        t.setFlagEstado("1");
        t.setFlagContabiliza("0");
        t.setFlagSolicitaRef("1");
        t.setFlagSolicitaProv("0");
        t.setFlagSolicitaDocExt("0");
        t.setFlagSolicitaDocInt("0");
        t.setFlagSolicitaLote("0");
        t.setFlagSolicitaCenbef("0");
        t.setFlagMovEntreAlm("0");
        t.setFlagSolicitaPrecio("0");
        t.setFlagClaseMov("I");
        t.setFactorSldoTotal(BigDecimal.ONE);
        return t;
    }

    public static ArticuloMovTipo articuloMovTipoTraslado(Long id) {
        return articuloMovTipoTrasladoSalida(id, true);
    }

    /** Tipo clase T para integración traslado-ejecutar (requiere flag solicita ref). */
    public static ArticuloMovTipo articuloMovTipoTrasladoSalida(Long id, boolean movEntreAlm) {
        ArticuloMovTipo t = articuloMovTipoIngreso(id);
        t.setFlagClaseMov("T");
        t.setFlagMovEntreAlm(movEntreAlm ? "1" : "0");
        t.setFlagSolicitaRef("1");
        return t;
    }

    /** Tipo clase V para integración despacho OV. */
    public static ArticuloMovTipo articuloMovTipoSalidaOv(Long id) {
        ArticuloMovTipo t = articuloMovTipoIngreso(id);
        t.setFlagClaseMov("V");
        t.setFlagSolicitaRef("1");
        t.setFactorSldoTotal(new BigDecimal("-1"));
        return t;
    }

    /** Tipo origen con devolución configurada (tipoMovDev). */
    public static ArticuloMovTipo articuloMovTipoConDevolucion(Long id, String tipoMovDev) {
        ArticuloMovTipo t = articuloMovTipoIngreso(id);
        t.setTipoMov("ING01");
        t.setTipoMovDev(tipoMovDev);
        return t;
    }

    public static ArticuloMovTipo articuloMovTipoDevolucion(String tipoMov) {
        ArticuloMovTipo t = articuloMovTipoIngreso(99L);
        t.setTipoMov(tipoMov);
        t.setDescTipoMov("Devolución test");
        t.setFactorSldoTotal(new BigDecimal("1"));
        return t;
    }

    public static ArticuloAlmacen articuloAlmacen(Long almacenId, Long articuloId, BigDecimal cantidad, BigDecimal costo) {
        ArticuloAlmacen aa = new ArticuloAlmacen();
        aa.setAlmacenId(almacenId);
        aa.setArticuloId(articuloId);
        aa.setCantidadDisponible(cantidad);
        aa.setCostoPromedio(costo);
        return aa;
    }

    public static ArticuloAlmacen articuloAlmacenDefault() {
        return articuloAlmacen(10L, 100L, new BigDecimal("100"), new BigDecimal("5.00"));
    }

    // ── Vale movimiento ──

    public static ValeMov valeMov(Long id) {
        return valeMov(id, NRO_VALE_FACTORY);
    }

    public static ValeMov valeMov(Long id, String nroVale) {
        ValeMov v = new ValeMov();
        v.setId(id);
        v.setSucursalId(1L);
        v.setAlmacenId(10L);
        v.setArticuloMovTipoId(1L);
        v.setFechaMov(LocalDate.of(2026, 4, 17));
        v.setNroVale(nroVale);
        v.setFlagEstado("1");
        return v;
    }

    public static ValeMov valeMovConLinea(Long id, Long articuloId) {
        ValeMov v = valeMov(id);
        ValeMovDet det = valeMovDet(articuloId, new BigDecimal("10"), new BigDecimal("5.00"));
        v.addLinea(det);
        return v;
    }

    public static ValeMovDet valeMovDet(Long articuloId, BigDecimal cantidad, BigDecimal costo) {
        ValeMovDet d = new ValeMovDet();
        d.setArticuloId(articuloId);
        d.setCantProcesada(cantidad);
        d.setCostoUnitario(costo);
        d.setMonedaId(1L);
        d.setFlagEstado("1");
        return d;
    }

    // ── Orden traslado ──

    public static OrdenTraslado ordenTraslado(Long id) {
        OrdenTraslado ot = new OrdenTraslado();
        ot.setId(id);
        ot.setAlmacenOrigenId(10L);
        ot.setAlmacenDestinoId(20L);
        ot.setNumero("OT-TEST-001");
        ot.setFecha(LocalDate.of(2026, 5, 2));
        ot.setFlagEstado("1");
        ot.setObservacion("Traslado test");
        return ot;
    }

    public static OrdenTrasladoDet ordenTrasladoDet(Long id, Long articuloId, BigDecimal cantidad) {
        OrdenTrasladoDet d = new OrdenTrasladoDet();
        d.setId(id);
        d.setArticuloId(articuloId);
        d.setCantidad(cantidad);
        d.setCantidadDespachada(BigDecimal.ZERO);
        d.setCantidadRecibida(BigDecimal.ZERO);
        return d;
    }

    // ── DTOs request / response ──

    public static MovimientoLineaRequest movimientoLineaRequest(Long articuloId, BigDecimal cant, BigDecimal costo) {
        MovimientoLineaRequest l = new MovimientoLineaRequest();
        l.setArticuloId(articuloId);
        l.setCantProcesada(cant);
        l.setCostoUnitario(costo);
        return l;
    }

    public static MovimientoCabeceraRequest movimientoCabeceraRequest() {
        MovimientoCabeceraRequest req = new MovimientoCabeceraRequest();
        req.setSucursalId(1L);
        req.setAlmacenId(10L);
        req.setArticuloMovTipoId(1L);
        req.setFechaMov(LocalDate.of(2026, 4, 17));
        req.setLineas(List.of(movimientoLineaRequest(100L, new BigDecimal("10"), new BigDecimal("5.00"))));
        return req;
    }

    public static MovimientoCabeceraRequest movimientoCabeceraRecepcionOc(Long ordenCompraId, Long almacenId) {
        MovimientoCabeceraRequest req = movimientoCabeceraRequest();
        req.setAlmacenId(almacenId);
        req.setOrdenCompraId(ordenCompraId);
        req.setTipoReferenciaOrigen("C");
        req.setProveedorId(99L);
        req.setObservaciones("Recepción OC test");
        return req;
    }

    public static MovimientoDetalleResponse movimientoDetalleResponse(Long id) {
        return MovimientoDetalleResponse.builder()
                .id(id)
                .sucursalId(1L)
                .almacenId(10L)
                .nroVale(NRO_VALE_FACTORY)
                .flagEstado("1")
                .lineas(List.of())
                .build();
    }

    public static MovimientoAnularRequest movimientoAnularRequest(Long valeId) {
        MovimientoAnularRequest req = new MovimientoAnularRequest();
        req.setId(valeId);
        req.setMotivo("Anulación test");
        return req;
    }

    public static IntegracionRecepcionOcRequest integracionRecepcionOcRequest() {
        IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
        req.setOrdenCompraId(1L);
        req.setArticuloMovTipoId(5L);
        req.setAlmacenId(20L);
        req.setFechaMov(LocalDate.of(2026, 5, 9));
        req.setObservaciones("Recepción demo");
        req.setValidarTresVias(true);
        req.setToleranciaTresVias(new BigDecimal("0.0001"));
        return req;
    }

    public static IntegracionRecepcionOcRequest integracionRecepcionOcRequestSinTresVias() {
        IntegracionRecepcionOcRequest req = integracionRecepcionOcRequest();
        req.setValidarTresVias(false);
        return req;
    }

    public static IntegracionSalidaOvRequest integracionSalidaOvRequest() {
        IntegracionSalidaOvRequest req = new IntegracionSalidaOvRequest();
        req.setOrdenVentaId(201L);
        req.setArticuloMovTipoId(2L);
        req.setAlmacenId(10L);
        req.setFechaMov(LocalDate.of(2026, 5, 9));
        req.setObservaciones("Salida OV test");
        return req;
    }

    public static IntegracionTrasladoEjecutarRequest integracionTrasladoEjecutarRequest() {
        IntegracionTrasladoEjecutarRequest req = new IntegracionTrasladoEjecutarRequest();
        req.setOrdenTrasladoId(1L);
        req.setArticuloMovTipoId(3L);
        req.setFechaMov(LocalDate.of(2026, 5, 9));
        req.setObservaciones("Ejecutar traslado test");
        return req;
    }

    public static OrdenTrasladoRequest ordenTrasladoRequest() {
        OrdenTrasladoRequest req = new OrdenTrasladoRequest();
        req.setAlmacenOrigenId(10L);
        req.setAlmacenDestinoId(20L);
        req.setFecha(LocalDate.of(2026, 5, 2));
        req.setObservacion("OT test");
        OrdenTrasladoLineaRequest linea = new OrdenTrasladoLineaRequest();
        linea.setArticuloId(100L);
        linea.setCantidad(new BigDecimal("5"));
        req.setLineas(List.of(linea));
        return req;
    }

    // ── Filas JDBC simuladas (integración compras) ──

    public static Map<String, Object> filaOrdenCompraJdbc(Long sucursalId, Long proveedorId) {
        Map<String, Object> row = new HashMap<>();
        row.put("sucursal_id", sucursalId);
        row.put("proveedor_id", proveedorId);
        return row;
    }

    public static Map<String, Object> filaOrdenCompraDetJdbc(Long detId, Long articuloId, Long almacenId,
                                                             BigDecimal cantProyectada, BigDecimal valorUnitario) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", detId);
        row.put("articulo_id", articuloId);
        row.put("cant_proyectada", cantProyectada);
        row.put("cant_procesada", BigDecimal.ZERO);
        row.put("valor_unitario", valorUnitario);
        row.put("almacen_id", almacenId);
        row.put("centros_costo_id", null);
        return row;
    }

    public static Map<String, Object> filaOrdenVentaJdbc(Long sucursalId) {
        Map<String, Object> row = new HashMap<>();
        row.put("sucursal_id", sucursalId);
        return row;
    }

    public static Map<String, Object> filaOrdenVentaDetJdbc(Long detId, Long articuloId, Long almacenId,
                                                            BigDecimal cantProyectada, BigDecimal valorUnitario) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", detId);
        row.put("articulo_id", articuloId);
        row.put("cant_proyectada", cantProyectada);
        row.put("cant_procesada", BigDecimal.ZERO);
        row.put("valor_unitario", valorUnitario);
        row.put("almacen_id", almacenId);
        row.put("centros_costo_id", null);
        return row;
    }
}
