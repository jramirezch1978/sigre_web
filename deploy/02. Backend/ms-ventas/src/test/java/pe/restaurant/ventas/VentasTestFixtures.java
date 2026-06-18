package pe.restaurant.ventas;

import pe.restaurant.ventas.dto.request.*;
import pe.restaurant.ventas.dto.response.*;
import pe.restaurant.ventas.entity.*;

import java.time.LocalTime;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Fixtures estáticas en RAM (C) para tests unitarios de ms-ventas.
 * NO persiste en BD. Solo para crear objetos de prueba en memoria.
 * 
 * Convención:
 * - Entities: xxxEntity(Long id), xxxEntity(Long id, String flagEstado)
 * - Requests: xxxRequest(), crearXxxRequest()
 * - Responses: xxxResponse(Long id)
 * - Mocks Feign: mockContabilidadResponse(), mockAlmacenResponse()
 */
public final class VentasTestFixtures {

    private VentasTestFixtures() {
        // Utility class
    }

    // ==================== ENTITIES ====================

    /**
     * Crea una Carta con datos mínimos válidos.
     */
    public static Carta cartaEntity(Long id) {
        return cartaEntity(id, "1");
    }

    public static Carta cartaEntity(Long id, String flagEstado) {
        Carta carta = new Carta();
        carta.setId(id);
        carta.setSucursalId(1L);
        carta.setNombre("Carta Test " + id);
        carta.setDescripcion("Descripción de prueba");
        carta.setFlagEstado(flagEstado);
        carta.setDetalles(new ArrayList<>());
        return carta;
    }

    /**
     * Crea un detalle de Carta.
     */
    public static CartaDet cartaDetEntity(Long id, Carta carta, Long articuloId) {
        CartaDet det = new CartaDet();
        det.setId(id);
        det.setCarta(carta);
        CartaDet.Articulo articulo = new CartaDet.Articulo();
        articulo.setId(articuloId);
        det.setArticulo(articulo);
        det.setPrecio(new BigDecimal("10.00"));
        det.setOrden(1);
        det.setFlagEstado("1");
        return det;
    }

    /**
     * Crea una Mesa con datos mínimos válidos.
     */
    public static Mesa mesaEntity(Long id) {
        return mesaEntity(id, "1");
    }

    public static Mesa mesaEntity(Long id, String flagEstado) {
        Mesa mesa = new Mesa();
        mesa.setId(id);
        mesa.setNumero("M-" + id);
        mesa.setCapacidad(4);
        mesa.setFlagEstado(flagEstado);
        
        Mesa.Zona zona = new Mesa.Zona();
        zona.setId(1L);
        zona.setNombre("Zona Test");
        zona.setCapacidad(20);
        zona.setFlagEstado("1");
        mesa.setZona(zona);
        
        return mesa;
    }

    /**
     * Crea una Zona con datos mínimos válidos.
     */
    public static Zona zonaEntity(Long id) {
        return zonaEntity(id, "1");
    }

    public static Zona zonaEntity(Long id, String flagEstado) {
        Zona zona = new Zona();
        zona.setId(id);
        Zona.Sucursal sucursal = new Zona.Sucursal();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Test");
        zona.setSucursal(sucursal);
        zona.setNombre("Zona Test " + id);
        zona.setCapacidad(20);
        zona.setFlagEstado(flagEstado);
        return zona;
    }

    /**
     * Crea un PuntoVenta con datos mínimos válidos.
     */
    public static PuntoVenta puntoVentaEntity(Long id) {
        return puntoVentaEntity(id, "1");
    }

    public static PuntoVenta puntoVentaEntity(Long id, String flagEstado) {
        PuntoVenta pv = new PuntoVenta();
        pv.setId(id);
        pv.setSucursalId(1L);
        pv.setAlmacenId(1L);
        pv.setCodigo("PV-" + id);
        pv.setNombre("Punto Venta Test " + id);
        pv.setSerieBoleta("B001");
        pv.setSerieFactura("F001");
        pv.setTipoImpresora("TICKETERA");
        pv.setFlagEstado(flagEstado);
        return pv;
    }

    /**
     * Crea una OrdenVenta con datos mínimos válidos.
     */
    public static OrdenVenta ordenVentaEntity(Long id) {
        return ordenVentaEntity(id, "1");
    }

    public static OrdenVenta ordenVentaEntity(Long id, String flagEstado) {
        OrdenVenta ov = new OrdenVenta();
        ov.setId(id);
        ov.setSucursalId(1L);
        ov.setNroOrdenVenta("OV-TEST-" + String.format("%04d", id));
        ov.setClienteId(2L);
        ov.setFechaEmision(LocalDate.now());
        ov.setMonedaId(1L);
        ov.setDocTipoId(1L);
        ov.setMontoTotal(new BigDecimal("100.00"));
        ov.setMontoFacturado(BigDecimal.ZERO);
        ov.setFlagEstado(flagEstado);
        ov.setDetalles(new ArrayList<>());
        return ov;
    }

    /**
     * Crea un detalle de OrdenVenta.
     */
    public static OrdenVentaDet ordenVentaDetEntity(Long id, OrdenVenta ordenVenta, Long articuloId) {
        OrdenVentaDet det = new OrdenVentaDet();
        det.setId(id);
        det.setOrdenVenta(ordenVenta);
        det.setArticuloId(articuloId);
        det.setLineaNro(1);
        det.setCantProyectada(new BigDecimal("5.00"));
        det.setValorUnitario(new BigDecimal("20.00"));
        det.setSubtotal(new BigDecimal("100.00"));
        det.setAlmacenId(1L);
        det.setFlagEstado("1");
        return det;
    }

    /**
     * Crea una Comanda con datos mínimos válidos.
     */
    public static Comanda comandaEntity(Long id) {
        return comandaEntity(id, "1");
    }

    public static Comanda comandaEntity(Long id, String flagEstado) {
        Comanda comanda = new Comanda();
        comanda.setId(id);
        comanda.setSucursalId(1L);
        comanda.setPuntoVentaId(1L);
        comanda.setTurnoId(1L);
        comanda.setClienteId(2L);
        comanda.setMesa("M-TEST-01");
        comanda.setFechaHora(Instant.now());
        comanda.setTotal(BigDecimal.ZERO);
        comanda.setFlagEstado(flagEstado);
        comanda.setDetalles(new ArrayList<>());
        return comanda;
    }

    /**
     * Crea una Proforma con datos mínimos válidos.
     */
    public static Proforma proformaEntity(Long id) {
        return proformaEntity(id, "1");
    }

    public static Proforma proformaEntity(Long id, String flagEstado) {
        Proforma proforma = new Proforma();
        proforma.setId(id);
        proforma.setSucursalId(1L);
        proforma.setClienteId(2L);
        proforma.setNumero("PF-TEST-" + String.format("%04d", id));
        proforma.setFecha(LocalDate.now());
        proforma.setFechaValidez(LocalDate.now().plusDays(30));
        proforma.setMonedaId(1L);
        proforma.setSubtotal(new BigDecimal("100.00"));
        proforma.setIgv(new BigDecimal("18.00"));
        proforma.setTotal(new BigDecimal("118.00"));
        proforma.setFlagEstado(flagEstado);
        proforma.setDetalles(new ArrayList<>());
        return proforma;
    }

    /**
     * Crea un Vendedor con datos mínimos válidos.
     */
    public static Vendedor vendedorEntity(Long id) {
        return vendedorEntity(id, "1");
    }

    public static Vendedor vendedorEntity(Long id, String flagEstado) {
        Vendedor vendedor = new Vendedor();
        vendedor.setId(id);
        vendedor.setUsuarioId(id);
        vendedor.setNombre("Vendedor Test " + id);
        vendedor.setComisionPorcentaje(new BigDecimal("5.00"));
        vendedor.setFlagEstado(flagEstado);
        return vendedor;
    }

    /**
     * Crea un CierreCaja con datos mínimos válidos.
     */
    public static CierreCaja cierreCajaEntity(Long id) {
        return cierreCajaEntity(id, "1");
    }

    public static CierreCaja cierreCajaEntity(Long id, String flagEstado) {
        CierreCaja cierre = new CierreCaja();
        cierre.setId(id);
        cierre.setTurnoId(1L);
        cierre.setVentasEfectivo(new BigDecimal("100.00"));
        cierre.setVentasTarjeta(new BigDecimal("50.00"));
        cierre.setVentasDigital(new BigDecimal("25.00"));
        cierre.setVentasTotal(new BigDecimal("175.00"));
        cierre.setPropinasTotal(new BigDecimal("10.00"));
        cierre.setFondoInicial(new BigDecimal("50.00"));
        cierre.setFlagEstado(flagEstado);
        return cierre;
    }

    /**
     * Crea un DescuentoPromocion con datos mínimos válidos.
     */
    public static DescuentoPromocion descuentoPromocionEntity(Long id) {
        return descuentoPromocionEntity(id, "1");
    }

    public static DescuentoPromocion descuentoPromocionEntity(Long id, String flagEstado) {
        DescuentoPromocion desc = new DescuentoPromocion();
        desc.setId(id);
        desc.setNombre("PROMO-TEST-" + id);
        desc.setTipo("PCT");
        desc.setValor(new BigDecimal("10.00"));
        desc.setFechaInicio(LocalDate.now());
        desc.setFechaFin(LocalDate.now().plusDays(30));
        desc.setFlagEstado(flagEstado);
        return desc;
    }

    /**
     * Crea una ZonaVenta con datos mínimos válidos.
     */
    public static ZonaVenta zonaVentaEntity(Long id) {
        return zonaVentaEntity(id, "1");
    }

    public static ZonaVenta zonaVentaEntity(Long id, String flagEstado) {
        ZonaVenta zv = new ZonaVenta();
        zv.setId(id);
        zv.setZonaVenta("ZV-" + id);
        zv.setDescZonaVenta("Zona Venta Test " + id);
        zv.setUbigeo("150101");
        zv.setFlagEstado(flagEstado);
        return zv;
    }

    // ==================== REQUESTS ====================

    /**
     * Crea un CartaRequest con datos mínimos válidos.
     */
    public static CartaRequest cartaRequest() {
        CartaRequest req = new CartaRequest();
        req.setNombre("Carta Test Request");
        req.setDescripcion("Descripción de prueba");
        return req;
    }

    public static CartaRequest cartaRequestConDetalles() {
        CartaRequest req = cartaRequest();
        CartaRequest.CartaDetRequest det = new CartaRequest.CartaDetRequest();
        det.setArticuloId(100L);
        det.setPrecio(new BigDecimal("15.00"));
        det.setOrden(1);
        req.setDetalles(List.of(det));
        return req;
    }

    /**
     * Crea un MesaRequest con datos mínimos válidos.
     */
    public static MesaRequest mesaRequest() {
        MesaRequest req = new MesaRequest();
        req.setZonaId(1L);
        req.setNumero("M-TEST-REQ");
        req.setCapacidad(4);
        return req;
    }

    /**
     * Crea un ZonaRequest con datos mínimos válidos.
     */
    public static ZonaRequest zonaRequest() {
        ZonaRequest req = new ZonaRequest();
        req.setNombre("Zona Test Request");
        req.setCapacidad(20);
        return req;
    }

    /**
     * Crea un PuntoVentaRequest con datos mínimos válidos.
     */
    public static PuntoVentaRequest puntoVentaRequest() {
        PuntoVentaRequest req = new PuntoVentaRequest();
        req.setAlmacenId(1L);
        req.setCodigo("PV-TEST-REQ");
        req.setNombre("Punto Venta Test Request");
        req.setSerieBoleta("B001");
        req.setSerieFactura("F001");
        req.setTipoImpresora("TICKETERA");
        return req;
    }

    /**
     * Crea un OrdenVentaRequest con datos mínimos válidos.
     */
    public static OrdenVentaRequest ordenVentaRequest() {
        OrdenVentaRequest req = new OrdenVentaRequest();
        req.setClienteId(2L);
        req.setFechaEmision(LocalDate.now());
        req.setMonedaId(1L);
        req.setDocTipoId(1L);
        return req;
    }

    /**
     * Crea un ProformaRequest con datos mínimos válidos.
     */
    public static ProformaRequest proformaRequest() {
        ProformaRequest req = new ProformaRequest();
        req.setClienteId(2L);
        req.setFecha(LocalDate.now());
        req.setFechaValidez(LocalDate.now().plusDays(30));
        req.setMonedaId(1L);
        return req;
    }

    /**
     * Crea un VendedorRequest con datos mínimos válidos.
     */
    public static VendedorRequest vendedorRequest() {
        VendedorRequest req = new VendedorRequest();
        req.setUsuarioId(1L);
        req.setNombre("Vendedor Test Request");
        req.setComisionPorcentaje(new BigDecimal("5.00"));
        return req;
    }

    /**
     * Crea un DescuentoPromocionRequest con datos mínimos válidos.
     */
    public static DescuentoPromocionRequest descuentoPromocionRequest() {
        DescuentoPromocionRequest req = new DescuentoPromocionRequest();
        req.setNombre("PROMO-TEST-REQ");
        req.setTipo("PCT");
        req.setValor(new BigDecimal("10.00"));
        req.setFechaInicio(LocalDate.now());
        req.setFechaFin(LocalDate.now().plusDays(30));
        return req;
    }

    /**
     * Crea un ZonaVentaRequest con datos mínimos válidos.
     */
    public static ZonaVentaRequest zonaVentaRequest() {
        ZonaVentaRequest req = new ZonaVentaRequest();
        req.setZonaVenta("ZV-TEST-REQ");
        req.setDescZonaVenta("Zona Venta Test Request");
        req.setUbigeo("150101");
        return req;
    }

    // ==================== RESPONSES ====================

    /**
     * Crea un CartaResponse con datos mínimos válidos.
     */
    public static CartaResponse cartaResponse(Long id) {
        CartaResponse resp = new CartaResponse();
        resp.setId(id);
        resp.setSucursalId(1L);
        resp.setNombre("Carta Test " + id);
        resp.setDescripcion("Descripción de prueba");
        resp.setFlagEstado("1");
        return resp;
    }

    /**
     * Crea un MesaResponse con datos mínimos válidos.
     */
    public static MesaResponse mesaResponse(Long id) {
        MesaResponse resp = new MesaResponse();
        resp.setId(id);
        resp.setNumero("M-" + id);
        resp.setCapacidad(4);
        resp.setFlagEstado("1");
        return resp;
    }

    /**
     * Crea un OrdenVentaResponse con datos mínimos válidos.
     */
    public static OrdenVentaResponse ordenVentaResponse(Long id) {
        OrdenVentaResponse resp = new OrdenVentaResponse();
        resp.setId(id);
        resp.setNroOrdenVenta("OV-TEST-" + String.format("%04d", id));
        resp.setFechaEmision(LocalDate.now());
        resp.setMontoTotal(new BigDecimal("100.00"));
        resp.setFlagEstado("1");
        return resp;
    }

    // ==================== MOCKS FEIGN ====================

    /**
     * Mock de respuesta del servicio de Contabilidad para generación de asiento.
     */
    public static Object mockContabilidadGenerarAsientoResponse() {
        // Retornar un objeto genérico que simule la respuesta
        return new Object() {
            public Long getId() { return 1L; }
            public String getNumero() { return "ASI-001"; }
            public String getEstado() { return "REGISTRADO"; }
        };
    }

    /**
     * Mock de respuesta del servicio de Almacén para movimiento.
     */
    public static Object mockAlmacenMovimientoResponse() {
        return new Object() {
            public Long getId() { return 1L; }
            public String getNumero() { return "MOV-001"; }
            public String getTipo() { return "SALIDA"; }
        };
    }

    /**
     * Mock de respuesta genérica de entidad contribuyente.
     */
    public static Object mockEntidadContribuyenteResponse() {
        return new Object() {
            public Long getId() { return 2L; }
            public String getRazonSocial() { return "CLIENTE DEMO E.I.R.L."; }
            public String getNroDocumento() { return "20987654321"; }
        };
    }
    
    // ==================== CUENTAS POR COBRAR ====================
    
    /**
     * Crea una entidad CuentaCobrar para pruebas
     */
    public static CuentaCobrar cuentaCobrarEntity(Long id, String flagEstado) {
        CuentaCobrar entity = new CuentaCobrar();
        entity.setId(id);
        entity.setSucursalId(1L);
        entity.setClienteId(1L);
        entity.setDocTipoId(1L);
        entity.setSerie("CXB");
        entity.setNumero("00001");
        entity.setMonedaId(1L);
        entity.setTotal(new BigDecimal("1000.00"));
        entity.setSaldo(new BigDecimal("1000.00"));
        entity.setAno(2026);
        entity.setMes(5);
        entity.setCntblLibroId(4L);
        entity.setFlagEstado(flagEstado);
        return entity;
    }
    
    /**
     * Crea una entidad CuentaCobrarDet para pruebas
     */
    public static CuentaCobrarDet cuentaCobrarDetEntity(Long id, CuentaCobrar cuentaCobrar, Long conceptoFinancieroId) {
        CuentaCobrarDet entity = new CuentaCobrarDet();
        entity.setId(id);
        entity.setCuentaCobrar(cuentaCobrar);
        entity.setCntasCobrarId(cuentaCobrar.getId());
        entity.setConceptoFinancieroId(conceptoFinancieroId);
        entity.setTipoMov(CuentaCobrarDet.TipoMovimiento.CARGO);
        entity.setMonto(new BigDecimal("100.00"));
        entity.setFlagEstado("1");
        return entity;
    }
    
    // ==================== VENTAS FASE 4 DTO (UTILIZAR MÉTODOS EXISTENTES) ====================
    
    // ==================== CARTA MENU (UTILIZAR MÉTODOS EXISTENTES) ====================
    
    // ==================== SERVICIOS CxC ====================
    
    /**
     * Crea una entidad ServiciosCxC para pruebas
     */
    public static ServiciosCxC serviciosCxCEntity(Long id, String flagEstado) {
        ServiciosCxC entity = new ServiciosCxC();
        entity.setId(id);
        entity.setCodServicio("S01");
        entity.setDescServicio("Servicio Test");
        entity.setTarifa(new BigDecimal("100.00"));
        entity.setCodMoneda("PEN");
        entity.setFlagAfectoIgv("1");
        entity.setFlagEstado(flagEstado);
        return entity;
    }
    
    /**
     * Crea un request ServiciosCxC para pruebas
     */
    public static ServiciosCxCRequest serviciosCxCRequest() {
        return new ServiciosCxCRequest(
                "S01",
                "Servicio Test",
                new BigDecimal("100.00"),
                "1",
                "PEN"
        );
    }

    /**
     * Crea una Propina con datos mínimos válidos.
     */
    public static Propina propinaEntity(Long id) {
        return propinaEntity(id, "1");
    }

    public static Propina propinaEntity(Long id, String flagEstado) {
        Propina propina = new Propina();
        propina.setId(id);
        propina.setFsFacturaSimplId(1L);
        propina.setTrabajadorId(1L);
        propina.setMonto(new BigDecimal("10.00"));
        propina.setFecha(LocalDate.now());
        propina.setFlagEstado(flagEstado);
        return propina;
    }

    /**
     * Crea una Reservacion con datos mínimos válidos.
     */
    public static Reservacion reservacionEntity(Long id) {
        return reservacionEntity(id, "1");
    }

    public static Reservacion reservacionEntity(Long id, String flagEstado) {
        Reservacion reservacion = new Reservacion();
        reservacion.setId(id);
        reservacion.setSucursalId(1L);
        reservacion.setClienteId(1L);
        reservacion.setMesaId(1L);
        reservacion.setFecha(LocalDate.now());
        reservacion.setHora(LocalTime.of(19, 0));
        reservacion.setComensales(4);
        reservacion.setEstado("CONFIRMADA");
        reservacion.setObservaciones("Reserva de prueba");
        reservacion.setFlagEstado(flagEstado);
        reservacion.setItems(new ArrayList<>());
        return reservacion;
    }

    /**
     * Crea un detalle de Reservacion.
     */
    public static ReservacionDet reservacionDetEntity(Long id, Reservacion reservacion, Long articuloId) {
        ReservacionDet det = new ReservacionDet();
        det.setId(id);
        det.setReservacion(reservacion);
        det.setArticuloId(articuloId);
        det.setCantidad(new BigDecimal("2"));
        det.setObservacion("Sin cebolla");
        return det;
    }

    /**
     * Crea una EntidadCreditosCxc con datos mínimos válidos.
     */
    public static EntidadCreditosCxc entidadCreditosCxcEntity(Long id) {
        return entidadCreditosCxcEntity(id, "1");
    }

    public static EntidadCreditosCxc entidadCreditosCxcEntity(Long id, String flagEstado) {
        EntidadCreditosCxc credito = new EntidadCreditosCxc();
        credito.setId(id);
        credito.setEntidadContribuyenteId(1L);
        credito.setMonedaId(1L);
        credito.setLimiteCredito(new BigDecimal("5000.00"));
        credito.setDiasCredito(30);
        credito.setFlagEstado(flagEstado);
        return credito;
    }
}
