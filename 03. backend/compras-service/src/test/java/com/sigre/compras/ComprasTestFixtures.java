package com.sigre.compras;

import com.sigre.compras.dto.*;
import com.sigre.compras.entity.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.Collections;
import java.util.List;

/**
 * Fábrica centralizada de objetos de prueba para compras-service.
 * Todos los métodos son estáticos y devuelven instancias con datos mínimos válidos.
 * Usar los setters del objeto devuelto para sobreescribir valores según el caso de test.
 */
public final class ComprasTestFixtures {

    private ComprasTestFixtures() {}

    // ══════════════════════════════════════════════════════════════════════
    // Entidades
    // ══════════════════════════════════════════════════════════════════════

    public static OrdenCompra ordenCompra(Long id, String flagEstado) {
        OrdenCompra oc = new OrdenCompra();
        oc.setId(id);
        oc.setSucursalId(1L);
        oc.setProveedorId(1L);
        oc.setMonedaId(1L);
        oc.setFechaEmision(LocalDate.now());
        oc.setNroOrdenCompra("OC-001");
        oc.setFlagEstado(flagEstado);
        oc.setFlagImportacion("0");
        oc.setTotal(BigDecimal.ZERO);
        oc.setSubtotal(BigDecimal.ZERO);
        oc.setDescuentoTotal(BigDecimal.ZERO);
        oc.setIgvTotal(BigDecimal.ZERO);
        oc.setPercepcionTotal(BigDecimal.ZERO);
        return oc;
    }

    public static OrdenCompra ordenCompra(Long id) {
        return ordenCompra(id, "1");
    }

    public static OrdenCompraDet ordenCompraDet(Long id) {
        OrdenCompraDet l = new OrdenCompraDet();
        l.setId(id);
        l.setArticuloId(1L);
        l.setCantProyectada(new BigDecimal("10"));
        l.setCantProcesada(BigDecimal.ZERO);
        l.setCantFacturada(BigDecimal.ZERO);
        l.setValorUnitario(new BigDecimal("100"));
        l.setFlagEstado("1");
        l.setSubtotal(new BigDecimal("1000"));
        return l;
    }

    public static OrdenCompra ordenCompraConDetalle(Long id) {
        return ordenCompraConDetalle(id, "1");
    }

    public static OrdenCompra ordenCompraConDetalle(Long id, String flagEstado) {
        OrdenCompra oc = ordenCompra(id, flagEstado);
        oc.addLinea(ordenCompraDet(100L));
        return oc;
    }

    public static OrdenServicio ordenServicio(Long id, String flagEstado) {
        OrdenServicio os = new OrdenServicio();
        os.setId(id);
        os.setSucursalId(1L);
        os.setProveedorId(1L);
        os.setMonedaId(1L);
        os.setFecRegistro(LocalDate.now());
        os.setNroOs("OS-00000001");
        os.setFlagEstado(flagEstado);
        os.setFormaPagoId(1L);
        os.setCodOrigen("OS");
        os.setMontoTotal(BigDecimal.ZERO);
        return os;
    }

    public static OrdenServicio ordenServicio(Long id) {
        return ordenServicio(id, "1");
    }

    public static OrdenServicioDet ordenServicioDet(Long id) {
        OrdenServicioDet l = new OrdenServicioDet();
        l.setId(id);
        l.setServicioId(1L);
        l.setNroItem(1);
        l.setImporte(new BigDecimal("1000"));
        l.setSubtotal(new BigDecimal("1000"));
        l.setFlagEstado("1");
        l.setFecProyect(LocalDate.now().plusDays(30));
        l.setImpProvisionado(BigDecimal.ZERO);
        return l;
    }

    public static OrdenServicio ordenServicioConDetalle(Long id) {
        return ordenServicioConDetalle(id, "1");
    }

    public static OrdenServicio ordenServicioConDetalle(Long id, String flagEstado) {
        OrdenServicio os = ordenServicio(id, flagEstado);
        os.addLinea(ordenServicioDet(100L));
        return os;
    }

    public static SolicitudCompra solicitudCompra(Long id, String flagEstado) {
        SolicitudCompra sc = new SolicitudCompra();
        sc.setId(id);
        sc.setNroSolicitud("SC-001");
        sc.setFecha(LocalDate.now());
        sc.setSucursalId(1L);
        sc.setSolicitanteId(1L);
        sc.setPrioridad("MEDIA");
        sc.setFlagEstado(flagEstado);
        sc.setJustificacion("Test");
        sc.setCreatedBy(1L);
        sc.setFecCreacion(OffsetDateTime.now());

        SolicitudCompraDet det = new SolicitudCompraDet();
        det.setId(1L);
        det.setArticuloId(100L);
        det.setCantidad(new BigDecimal("10"));
        det.setSolicitudCompra(sc);
        sc.getLineas().add(det);
        return sc;
    }

    public static Cotizacion cotizacion(Long id, String flagEstado) {
        Cotizacion c = new Cotizacion();
        c.setId(id);
        c.setSucursalId(1L);
        c.setProveedorId(10L);
        c.setFecha(LocalDate.now());
        c.setMonedaId(1L);
        c.setTotal(new BigDecimal("500"));
        c.setFlagEstado(flagEstado);
        c.setCreatedBy(1L);
        c.setFecCreacion(OffsetDateTime.now());

        CotizacionDet det = new CotizacionDet();
        det.setId(1L);
        det.setArticuloId(100L);
        det.setCantidad(new BigDecimal("5"));
        det.setPrecioUnitario(new BigDecimal("100"));
        det.setDescuento(BigDecimal.ZERO);
        det.setCotizacion(c);
        c.getLineas().add(det);
        return c;
    }

    public static ContratoMarco contratoMarco(Long id, String flagEstado) {
        ContratoMarco cm = new ContratoMarco();
        cm.setId(id);
        cm.setProveedorId(10L);
        cm.setNroContrato("CM-001");
        cm.setFechaInicio(LocalDate.now());
        cm.setFechaFin(LocalDate.now().plusYears(1));
        cm.setCondiciones("Condiciones de prueba");
        cm.setFlagEstado(flagEstado);
        cm.setCreatedBy(1L);
        cm.setFecCreacion(OffsetDateTime.now());
        return cm;
    }

    public static ConformidadServicio conformidadServicio(Long id, boolean aprobado, String flagEstado) {
        ConformidadServicio cs = new ConformidadServicio();
        cs.setId(id);
        cs.setOrdenServicioId(10L);
        cs.setFecha(LocalDate.now());
        cs.setObservacion("Test");
        cs.setAprobado(aprobado);
        cs.setFlagEstado(flagEstado);
        cs.setCreatedBy(1L);
        cs.setFecCreacion(OffsetDateTime.now());

        ConformidadServicioDet det = new ConformidadServicioDet();
        det.setId(1L);
        det.setSecuencia(1);
        det.setDescripcion("Servicio A");
        det.setCantidad(new BigDecimal("1"));
        det.setPrecioUnitario(new BigDecimal("500"));
        det.setSubtotal(new BigDecimal("500"));
        det.setConformidadServicio(cs);
        cs.getLineas().add(det);
        return cs;
    }

    public static ProgramacionCompras programacionCompras(Long id, String flagEstado) {
        ProgramacionCompras p = new ProgramacionCompras();
        p.setId(id);
        p.setSucursalId(1L);
        p.setNroProgramacion("PC-001");
        p.setAnio(2026);
        p.setMes(4);
        p.setFlagEstado(flagEstado);
        p.setCreatedBy(1L);
        p.setFecCreacion(OffsetDateTime.now());

        ProgramacionComprasDet det = new ProgramacionComprasDet();
        det.setId(1L);
        det.setArticuloId(100L);
        det.setCantidad(new BigDecimal("20"));
        det.setProgramacionCompras(p);
        p.getLineas().add(det);
        return p;
    }

    // ── Entidades auxiliares / maestros ──

    public static AprobadorConfigurado aprobadorConfigurado(Long id) {
        AprobadorConfigurado e = new AprobadorConfigurado();
        e.setId(id);
        e.setDocTipoId(1L);
        e.setNivel(1);
        e.setAprobadorId(10L);
        e.setMontoMinimo(BigDecimal.ZERO);
        e.setMontoMaximo(new BigDecimal("100000"));
        e.setFlagEstado("1");
        return e;
    }

    public static AprobadorConfigurado aprobadorConfigurado(Long aprobadorId, BigDecimal min, BigDecimal max) {
        AprobadorConfigurado a = new AprobadorConfigurado();
        a.setDocTipoId(1L);
        a.setAprobadorId(aprobadorId);
        a.setFlagEstado("1");
        a.setMontoMinimo(min);
        a.setMontoMaximo(max);
        return a;
    }

    public static Comprador comprador(Long id) {
        Comprador c = new Comprador();
        c.setId(id);
        c.setUsuarioId(1L);
        c.setNombre("Comprador Test");
        c.setFlagEstado("1");
        return c;
    }

    public static ArticuloPrecioPactado articuloPrecioPactado(Long id) {
        ArticuloPrecioPactado e = new ArticuloPrecioPactado();
        e.setId(id);
        e.setArticuloId(100L);
        e.setProveedorId(10L);
        e.setPrecio(new BigDecimal("50.00"));
        e.setMonedaId(1L);
        e.setFechaDesde(LocalDate.now());
        e.setFechaHasta(LocalDate.now().plusMonths(6));
        e.setFlagEstado("1");
        return e;
    }

    public static ArticuloEstructura articuloEstructura(Long padreId, Long hijoId) {
        ArticuloEstructura e = new ArticuloEstructura();
        e.setArticuloPadreId(padreId);
        e.setArticuloHijoId(hijoId);
        e.setCantidad(BigDecimal.ONE);
        return e;
    }

    public static TipoEntidadContribuyente tipoEntidadContribuyente(Long id) {
        TipoEntidadContribuyente tec = new TipoEntidadContribuyente();
        tec.setId(id);
        tec.setTipo("PROVEEDOR");
        tec.setDescripcion("Entidad proveedora");
        tec.setFlagEstado("1");
        return tec;
    }

    public static ServicioCatalogo servicioCatalogo(Long id) {
        ServicioCatalogo sc = new ServicioCatalogo();
        sc.setId(id);
        sc.setServicio("SRV001");
        sc.setDescripcion("Servicio de prueba");
        sc.setTarifaEstd(new BigDecimal("100.00"));
        sc.setUnidadMedidaId(1L);
        sc.setFlagEstado("1");
        return sc;
    }

    public static CompraFondo compraFondo(BigDecimal total, BigDecimal usado) {
        CompraFondo f = new CompraFondo();
        f.setMontoTotal(total);
        f.setMontoUsado(usado);
        return f;
    }

    public static Aprobacion aprobacion(Long id, String accion) {
        Aprobacion a = new Aprobacion();
        a.setId(id);
        a.setNivel(1);
        a.setAccion(accion);
        a.setAprobadorId(2L);
        a.setComentario(accion);
        a.setFecha(OffsetDateTime.now());
        return a;
    }

    public static OcImportacion ocImportacion(Long ordenCompraId) {
        OcImportacion imp = new OcImportacion();
        imp.setId(1L);
        imp.setOrdenCompraId(ordenCompraId);
        imp.setIncoterm("FOB");
        imp.setPuertoEmbarque("Shanghai");
        imp.setNroDua("DUA-001");
        return imp;
    }

    public static EntidadBancoCnta entidadBancoCnta(Long bancoId, String nroCuenta) {
        EntidadBancoCnta banco = new EntidadBancoCnta();
        banco.setBancoId(bancoId);
        banco.setNroCuenta(nroCuenta);
        return banco;
    }

    public static CompradorCategoria compradorCategoria(Long id, Long compradorId, Long categId) {
        CompradorCategoria cc = new CompradorCategoria();
        cc.setId(id);
        cc.setCompradorId(compradorId);
        cc.setArticuloCategId(categId);
        return cc;
    }

    public static NumOrdSrv numOrdSrv(Long ultNro) {
        NumOrdSrv num = new NumOrdSrv();
        num.setUltNro(ultNro);
        return num;
    }

        public static TipoPercepcion tipoPercepcion(Long id) {
        TipoPercepcion tp = new TipoPercepcion();
        tp.setId(id);
        tp.setCodigo("51");
        tp.setDescripcion("Percepcion Venta Interna");
        tp.setTasa(new BigDecimal("2.0000"));
        tp.setFlagEstado("1");
        return tp;
    }

    public static AsignacionOsOc asignacionOsOc(Long id, Long osId, Long ocId) {
        AsignacionOsOc a = new AsignacionOsOc();
        a.setId(id);
        a.setOrdenServicioId(osId);
        a.setOrdenCompraId(ocId);
        a.setFechaAsignacion(OffsetDateTime.now());
        a.setCreatedBy(1L);

        AsignacionOsOcDet det = new AsignacionOsOcDet();
        det.setId(1L);
        det.setAsignacionOsOc(a);
        det.setOrdenServicioDetId(1L);
        det.setOrdenCompraDetId(1L);
        det.setMontoAplicado(new BigDecimal("1000.0000"));
        det.setCreatedBy(1L);
        a.getDetalles().add(det);
        return a;
    }

    public static OsConformidadLog osConformidadLog(Long id, Long osDetId, String accion) {
        OsConformidadLog log = new OsConformidadLog();
        log.setId(id);
        log.setOrdenServicioDetId(osDetId);
        log.setAccion(accion);
        log.setUsuarioId(1L);
        log.setObservacion("Log de prueba");
        return log;
    }

    public static OsAjusteValor osAjusteValor(Long id, Long osDetId) {
        OsAjusteValor ajuste = new OsAjusteValor();
        ajuste.setId(id);
        ajuste.setOrdenServicioDetId(osDetId);
        ajuste.setImporteAnterior(new BigDecimal("1000.0000"));
        ajuste.setImporteNuevo(new BigDecimal("1200.0000"));
        ajuste.setMotivo("Ajuste por variacion de precio");
        ajuste.setCreatedBy(1L);
        return ajuste;
    }

    public static ArticuloMovProy articuloMovProy(Long id, Long articuloId, Long ocDetId) {
        ArticuloMovProy mp = new ArticuloMovProy();
        mp.setId(id);
        mp.setArticuloId(articuloId);
        mp.setOrdenCompraDetId(ocDetId);
        mp.setCantidad(new BigDecimal("10.0000"));
        mp.setFechaProyectada(LocalDate.now().plusDays(15));
        mp.setTipoOrigen("OC");
        mp.setFlagEstado("1");
        mp.setCreatedBy(1L);
        return mp;
    }

    // ══════════════════════════════════════════════════════════════════════
    // Requests (DTOs de entrada)
    // ══════════════════════════════════════════════════════════════════════

    public static OrdenCompraCabeceraRequest ordenCompraRequest() {
        OrdenCompraCabeceraRequest req = new OrdenCompraCabeceraRequest();
        req.setSucursalId(1L);
        req.setProveedorId(1L);
        req.setMonedaId(1L);
        req.setFechaEmision(LocalDate.now());
        req.setFormaPagoId(1L);

        OrdenCompraLineaRequest lr = new OrdenCompraLineaRequest();
        lr.setArticuloId(1L);
        lr.setCantProyectada(new BigDecimal("10"));
        lr.setValorUnitario(new BigDecimal("100"));
        lr.setFechaEntrega(LocalDate.now().plusDays(15));
        req.setLineas(List.of(lr));
        return req;
    }

    public static OrdenServicioCabeceraRequest ordenServicioRequest() {
        OrdenServicioCabeceraRequest req = new OrdenServicioCabeceraRequest();
        req.setSucursalId(1L);
        req.setCodOrigen("OS");
        req.setProveedorId(1L);
        req.setMonedaId(1L);
        req.setFecRegistro(LocalDate.now());
        req.setFormaPagoId(1L);

        OrdenServicioLineaRequest lr = new OrdenServicioLineaRequest();
        lr.setServicioId(1L);
        lr.setImporte(new BigDecimal("1000"));
        lr.setFecProyect(LocalDate.now().plusDays(30));
        req.setLineas(List.of(lr));
        return req;
    }

    public static SolicitudCompraRequest solicitudCompraRequest() {
        SolicitudCompraRequest req = new SolicitudCompraRequest();
        req.setSucursalId(1L);
        req.setFecha(LocalDate.now());
        req.setSolicitanteId(1L);
        req.setPrioridad("MEDIA");
        req.setJustificacion("Necesario para operación");

        SolicitudCompraDetRequest lr = new SolicitudCompraDetRequest();
        lr.setArticuloId(100L);
        lr.setCantidad(new BigDecimal("10"));
        lr.setEspecificaciones("Especificación de prueba");
        req.setLineas(List.of(lr));
        return req;
    }

    public static CotizacionRequest cotizacionRequest() {
        CotizacionRequest req = new CotizacionRequest();
        req.setProveedorId(10L);
        req.setFecha(LocalDate.now());
        req.setMonedaId(1L);

        CotizacionDetRequest lr = new CotizacionDetRequest();
        lr.setArticuloId(100L);
        lr.setCantidad(new BigDecimal("5"));
        lr.setPrecioUnitario(new BigDecimal("100"));
        req.setLineas(List.of(lr));
        return req;
    }

    public static ContratoMarcoRequest contratoMarcoRequest() {
        ContratoMarcoRequest req = new ContratoMarcoRequest();
        req.setProveedorId(10L);
        req.setFechaInicio(LocalDate.now());
        req.setFechaFin(LocalDate.now().plusYears(1));
        req.setCondiciones("Condiciones de prueba");
        return req;
    }

    public static ConformidadServicioRequest conformidadServicioRequest() {
        ConformidadServicioRequest req = new ConformidadServicioRequest();
        req.setOrdenServicioId(10L);
        req.setFecha(LocalDate.now());
        req.setObservacion("Test");

        ConformidadServicioDetRequest det = new ConformidadServicioDetRequest();
        det.setSecuencia(1);
        det.setDescripcion("Servicio A");
        det.setCantidad(new BigDecimal("1"));
        det.setPrecioUnitario(new BigDecimal("500"));
        req.setLineas(List.of(det));
        return req;
    }

    public static ProgramacionComprasRequest programacionComprasRequest() {
        ProgramacionComprasRequest req = new ProgramacionComprasRequest();
        req.setAnio(2026);
        req.setMes(4);

        ProgramacionComprasDetRequest det = new ProgramacionComprasDetRequest();
        det.setArticuloId(100L);
        det.setCantidad(new BigDecimal("20"));
        req.setLineas(List.of(det));
        return req;
    }

    // ══════════════════════════════════════════════════════════════════════
    // Responses (DTOs de salida) — para tests de controllers
    // ══════════════════════════════════════════════════════════════════════

    public static OrdenCompraDetalleResponse ordenCompraDetalleResponse() {
        return OrdenCompraDetalleResponse.builder()
                .id(1L)
                .sucursalId(1L)
                .proveedorId(1L)
                .nroOrdenCompra("OC-001")
                .fechaEmision(LocalDate.now())
                .monedaId(1L)
                .flagEstado("1")
                .total(new BigDecimal("1000"))
                .lineas(Collections.emptyList())
                .build();
    }

    public static OrdenCompraResumenResponse ordenCompraResumenResponse() {
        return OrdenCompraResumenResponse.builder()
                .id(1L)
                .nroOrdenCompra("OC-001")
                .flagEstado("1")
                .total(new BigDecimal("1000"))
                .build();
    }

    public static OrdenServicioDetalleResponse ordenServicioDetalleResponse() {
        return OrdenServicioDetalleResponse.builder()
                .id(1L)
                .sucursalId(1L)
                .proveedorId(1L)
                .nroOs("OS-00000001")
                .flagEstado("1")
                .montoTotal(BigDecimal.ZERO)
                .lineas(Collections.emptyList())
                .build();
    }

    public static OrdenServicioResumenResponse ordenServicioResumenResponse() {
        return OrdenServicioResumenResponse.builder()
                .id(1L)
                .nroOs("OS-00000001")
                .flagEstado("1")
                .montoTotal(BigDecimal.ZERO)
                .build();
    }
}
