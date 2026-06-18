package pe.restaurant.finanzas.testutil;

import pe.restaurant.finanzas.entity.*;
import pe.restaurant.finanzas.dto.request.*;
import pe.restaurant.finanzas.dto.response.MonedaResponse;
import pe.restaurant.finanzas.dto.response.PlanContableDetResponse;
import pe.restaurant.finanzas.dto.response.EntidadContribuyenteResponse;
import pe.restaurant.finanzas.dto.response.DocTipoResponse;
import pe.restaurant.finanzas.enums.TipoNota;
import pe.restaurant.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Factory para crear datos de prueba para tests de integración.
 * Genera entidades y DTOs con datos realistas para pruebas en base de datos.
 * 
 * @author Equipo de Desarrollo
 */
public class TestDataFactory {

    // Constantes para datos de prueba
    private static final Long DEFAULT_USUARIO_ID = 1L;
    private static final String DEFAULT_ESTADO_ACTIVO = "1";
    
    public static List<DetImpuestoRequest> impuestoDefault() {
        return List.of(new DetImpuestoRequest(1L, BigDecimal.ZERO));
    }

    // ==================== ENTIDADES ====================
    
    /**
     * Crea una entidad CajaBancos para pruebas
     */
    public static CajaBancos crearCajaBancos(Long id, String flagTipoTransaccion) {
        CajaBancos caja = new CajaBancos();
        caja.setId(id);
        caja.setSucursalId(1L);
        caja.setNroRegistro("CB-2026-" + String.format("%06d", id));
        caja.setFechaEmision(LocalDate.now());
        caja.setFechaProgramada(LocalDate.now());
        caja.setFlagTipoTransaccion(flagTipoTransaccion);
        caja.setBancoCntaId(1L);
        caja.setBancoCntaRefId("T".equals(flagTipoTransaccion) ? 2L : null);
        caja.setEntidadContribuyenteId(1L);
        caja.setMonedaId(1L);
        caja.setImpTotal(new BigDecimal("1000.00"));
        caja.setImpAsignado(BigDecimal.ZERO);
        caja.setConceptoFinancieroId(1L);
        caja.setDocTipoId(1L);
        caja.setNroDoc("DOC-" + String.format("%06d", id));
        caja.setObservacion("Movimiento de prueba");
        caja.setTasaCambio(BigDecimal.ONE);
        caja.setMedioPagoId(1L);
        caja.setFlagEstado(DEFAULT_ESTADO_ACTIVO);
        caja.setCreatedBy(DEFAULT_USUARIO_ID);
        caja.setUpdatedBy(DEFAULT_USUARIO_ID);
        return caja;
    }
    
    /**
     * Crea una entidad CajaBancosDet para pruebas
     */
    public static CajaBancosDet crearCajaBancosDet(Long id, CajaBancos cajaBancos) {
        CajaBancosDet detalle = new CajaBancosDet();
        detalle.setId(id);
        detalle.setCajaBancos(cajaBancos);
        detalle.setItem(1);
        detalle.setEntidadContribuyenteId(cajaBancos.getEntidadContribuyenteId() != null ? cajaBancos.getEntidadContribuyenteId() : 1L);
        detalle.setDocTipoId(cajaBancos.getDocTipoId() != null ? cajaBancos.getDocTipoId() : 1L);
        detalle.setNroDoc(String.format("DET-%08d", id));
        detalle.setImporte(new BigDecimal("500.00"));
        detalle.setFlagCxp("0");
        detalle.setSucursalRefId(1L);
        detalle.setFlagEstado(DEFAULT_ESTADO_ACTIVO);
        detalle.setCreatedBy(DEFAULT_USUARIO_ID);
        detalle.setUpdatedBy(DEFAULT_USUARIO_ID);
        return detalle;
    }
    
    /**
     * Crea una lista de entidades CajaBancosDet para pruebas
     */
    public static List<CajaBancosDet> crearListaCajaBancosDet(CajaBancos cajaBancos, int cantidad) {
        List<CajaBancosDet> detalles = new ArrayList<>();
        for (int i = 1; i <= cantidad; i++) {
            detalles.add(crearCajaBancosDet((long) i, cajaBancos));
        }
        return detalles;
    }
    
    // ==================== DTOs REQUEST ====================
    
    /**
     * Crea un CajaBancosRequest para pruebas de cobro (C)
     */
    public static CajaBancosRequest crearCajaBancosRequestCobro() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setFechaEmision(LocalDate.now());
        request.setEntidadContribuyenteId(1L);
        request.setMonedaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        request.setConceptoFinancieroId(1L);
        request.setAno(2026);
        request.setMes(6);
        request.setCntblLibroId(1L);
        request.setDocTipoId(1L);
        request.setNroDoc("REC-001");
        request.setObservacion("Cobro de prueba");
        request.setTasaCambio(BigDecimal.ONE);
        request.setMedioPagoId(1L);
        request.setDetalles(crearListaCajaBancosDetRequestCobro());
        return request;
    }
    
    /**
     * Crea un CajaBancosRequest para pruebas de pago (P)
     */
    public static CajaBancosRequest crearCajaBancosRequestPago() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("P");
        request.setBancoCntaId(1L);
        request.setFechaEmision(LocalDate.now());
        request.setEntidadContribuyenteId(1L);
        request.setMonedaId(1L);
        request.setImpTotal(new BigDecimal("800.00"));
        request.setConceptoFinancieroId(2L);
        request.setAno(2026);
        request.setMes(6);
        request.setCntblLibroId(1L);
        request.setDocTipoId(2L);
        request.setNroDoc("PAG-001");
        request.setObservacion("Pago de prueba");
        request.setTasaCambio(BigDecimal.ONE);
        request.setMedioPagoId(2L);
        request.setDetalles(crearListaCajaBancosDetRequestPago());
        return request;
    }
    
    /**
     * Crea un CajaBancosRequest para pruebas de transferencia (T)
     */
    public static CajaBancosRequest crearCajaBancosRequestTransferencia() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("T");
        request.setBancoCntaId(1L);
        request.setBancoCntaRefId(2L);
        request.setFechaEmision(LocalDate.now());
        request.setMonedaId(1L);
        request.setImpTotal(new BigDecimal("500.00"));
        request.setConceptoFinancieroId(3L);
        request.setAno(2026);
        request.setMes(6);
        request.setCntblLibroId(1L);
        request.setDocTipoId(3L);
        request.setNroDoc("TRF-001");
        request.setObservacion("Transferencia de prueba");
        request.setTasaCambio(BigDecimal.ONE);
        request.setMedioPagoId(3L);
        request.setDetalles(crearListaCajaBancosDetRequestTransferencia());
        return request;
    }
    
    /**
     * Crea un CajaBancosRequest para pruebas de aplicación (A)
     */
    public static CajaBancosRequest crearCajaBancosRequestAplicacion() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("A");
        request.setBancoCntaId(1L);
        request.setFechaEmision(LocalDate.now());
        request.setEntidadContribuyenteId(1L);
        request.setMonedaId(1L);
        request.setImpTotal(new BigDecimal("1200.00"));
        request.setConceptoFinancieroId(4L);
        request.setAno(2026);
        request.setMes(6);
        request.setCntblLibroId(1L);
        request.setDocTipoId(4L);
        request.setNroDoc("APL-001");
        request.setObservacion("Aplicación de documentos");
        request.setTasaCambio(BigDecimal.ONE);
        request.setMedioPagoId(4L);
        request.setDetalles(crearListaCajaBancosDetRequestAplicacion());
        return request;
    }
    
    /**
     * Crea una lista de CajaBancosDetalleRequest para cobro
     */
    private static List<CajaBancosDetalleRequest> crearListaCajaBancosDetRequestCobro() {
        List<CajaBancosDetalleRequest> detalles = new ArrayList<>();
        
        CajaBancosDetalleRequest det1 = new CajaBancosDetalleRequest();
        det1.setItem(1);
        det1.setEntidadContribuyenteId(1L);
        det1.setDocTipoId(1L);
        det1.setNroDoc("CB-COB-001");
        det1.setImporte(new BigDecimal("600.00"));
        det1.setFlagCxp("0");
        det1.setSucursalRefId(1L);
        detalles.add(det1);
        
        CajaBancosDetalleRequest det2 = new CajaBancosDetalleRequest();
        det2.setItem(2);
        det2.setEntidadContribuyenteId(1L);
        det2.setDocTipoId(1L);
        det2.setNroDoc("CB-COB-002");
        det2.setImporte(new BigDecimal("400.00"));
        det2.setFlagCxp("0");
        det2.setSucursalRefId(1L);
        detalles.add(det2);
        
        return detalles;
    }
    
    /**
     * Crea una lista de CajaBancosDetalleRequest para pago
     */
    private static List<CajaBancosDetalleRequest> crearListaCajaBancosDetRequestPago() {
        List<CajaBancosDetalleRequest> detalles = new ArrayList<>();
        
        CajaBancosDetalleRequest det1 = new CajaBancosDetalleRequest();
        det1.setItem(1);
        det1.setEntidadContribuyenteId(1L);
        det1.setDocTipoId(2L);
        det1.setNroDoc("CB-PAG-001");
        det1.setImporte(new BigDecimal("300.00"));
        det1.setFlagCxp("1");
        det1.setSucursalRefId(1L);
        detalles.add(det1);
        
        CajaBancosDetalleRequest det2 = new CajaBancosDetalleRequest();
        det2.setItem(2);
        det2.setEntidadContribuyenteId(1L);
        det2.setDocTipoId(2L);
        det2.setNroDoc("CB-PAG-002");
        det2.setImporte(new BigDecimal("500.00"));
        det2.setFlagCxp("1");
        det2.setSucursalRefId(1L);
        detalles.add(det2);
        
        return detalles;
    }
    
    /**
     * Crea una lista de CajaBancosDetalleRequest para transferencia
     */
    private static List<CajaBancosDetalleRequest> crearListaCajaBancosDetRequestTransferencia() {
        List<CajaBancosDetalleRequest> detalles = new ArrayList<>();
        
        CajaBancosDetalleRequest det1 = new CajaBancosDetalleRequest();
        det1.setItem(1);
        det1.setEntidadContribuyenteId(1L);
        det1.setDocTipoId(3L);
        det1.setNroDoc("CB-TRF-001");
        det1.setImporte(new BigDecimal("500.00"));
        det1.setFlagCxp("0");
        det1.setSucursalRefId(1L);
        detalles.add(det1);
        
        return detalles;
    }
    
    /**
     * Crea una lista de CajaBancosDetalleRequest para aplicación
     */
    private static List<CajaBancosDetalleRequest> crearListaCajaBancosDetRequestAplicacion() {
        List<CajaBancosDetalleRequest> detalles = new ArrayList<>();
        
        CajaBancosDetalleRequest det1 = new CajaBancosDetalleRequest();
        det1.setItem(1);
        det1.setEntidadContribuyenteId(1L);
        det1.setDocTipoId(4L);
        det1.setNroDoc("CB-APL-001");
        det1.setImporte(new BigDecimal("1200.00"));
        det1.setFlagCxp("1");
        det1.setSucursalRefId(1L);
        detalles.add(det1);
        
        return detalles;
    }
    
    // ==================== DATOS DE PRUEBA PARA OTROS MÓDULOS ====================
    
    /**
     * Crea una entidad CntasPagar para pruebas
     */
    public static CntasPagar crearCntasPagar(Long id) {
        CntasPagar cxp = new CntasPagar();
        cxp.setId(id);
        cxp.setFechaEmision(LocalDate.now().minusDays(30));
        cxp.setFechaVencimiento(LocalDate.now().plusDays(15));
        cxp.setProveedorId(1L);
        cxp.setDocTipoId(1L);
        cxp.setSerie("F001");
        cxp.setNumero("000" + id);
        cxp.setTotal(new BigDecimal("1500.00"));
        cxp.setSaldo(new BigDecimal("1500.00"));
        cxp.setFlagEstado(DEFAULT_ESTADO_ACTIVO);
        cxp.setCreatedBy(DEFAULT_USUARIO_ID);
        cxp.setUpdatedBy(DEFAULT_USUARIO_ID);
        return cxp;
    }
    
    /**
     * Crea una entidad ConceptoFinanciero para pruebas
     */
    public static ConceptoFinanciero crearConceptoFinanciero(Long id) {
        ConceptoFinanciero concepto = new ConceptoFinanciero();
        concepto.setId(id);
        concepto.setCodigo("CF" + String.format("%03d", id));
        concepto.setNombre("Concepto financiero " + id);
        concepto.setFlagEstado(DEFAULT_ESTADO_ACTIVO);
        concepto.setCreatedBy(DEFAULT_USUARIO_ID);
        concepto.setUpdatedBy(DEFAULT_USUARIO_ID);
        return concepto;
    }
    
    /**
     * Crea una lista de entidades ConceptoFinanciero para pruebas
     */
    public static List<ConceptoFinanciero> crearListaConceptoFinanciero() {
        List<ConceptoFinanciero> conceptos = new ArrayList<>();
        conceptos.add(crearConceptoFinanciero(1L));
        conceptos.add(crearConceptoFinanciero(2L));
        conceptos.add(crearConceptoFinanciero(3L));
        conceptos.add(crearConceptoFinanciero(4L));
        conceptos.add(crearConceptoFinanciero(5L));
        conceptos.add(crearConceptoFinanciero(6L));
        return conceptos;
    }
    
    // ==================== DATOS DE PRUEBA PARA PROGRAMACION PAGOS ====================
    
    /**
     * Crea un ProgramacionPagoRequest para pruebas
     */
    public static ProgramacionPagoRequest crearProgramacionPagoRequest() {
        ProgramacionPagoRequest request = new ProgramacionPagoRequest();
        request.setFechaProgramada(LocalDate.now().plusDays(7));
        // No hay método setObservación en ProgramacionPagoRequest
        request.setDetalles(crearListaProgramacionPagoDetalleRequest());
        return request;
    }
    
    /**
     * Crea una lista de ProgramacionPagoDetalleRequest para pruebas
     */
    private static List<ProgramacionPagoDetalleRequest> crearListaProgramacionPagoDetalleRequest() {
        List<ProgramacionPagoDetalleRequest> detalles = new ArrayList<>();
        
        ProgramacionPagoDetalleRequest det1 = new ProgramacionPagoDetalleRequest();
        det1.setCntasPagarId(1L);
        det1.setMontoProgramado(new BigDecimal("500.00"));
        detalles.add(det1);
        
        ProgramacionPagoDetalleRequest det2 = new ProgramacionPagoDetalleRequest();
        det2.setCntasPagarId(2L);
        det2.setMontoProgramado(new BigDecimal("300.00"));
        detalles.add(det2);
        
        return detalles;
    }
    
    // ==================== DATOS DE PRUEBA PARA SOLICITUD GIRO ====================

    public static SolicitudGiroRequest crearSolicitudGiroRequest() {
        SolicitudGiroRequest request = new SolicitudGiroRequest();
        request.setSucursalId(1L);
        request.setSolicitanteId(1L);
        request.setFecha(LocalDate.now());
        request.setMonto(new BigDecimal("5000.00"));
        request.setMotivo("Solicitud de giro de prueba");
        request.setTipoSolicitud("O");
        request.setCentrosCostoId(1L);
        return request;
    }

    // ==================== DATOS DE PRUEBA PARA RETENCION ====================

    private static final java.util.concurrent.atomic.AtomicLong contador = new java.util.concurrent.atomic.AtomicLong(1);

    private static String sufijoUnico() {
        return String.valueOf(contador.getAndIncrement());
    }

    public static RetencionRequest crearRetencionRequest() {
        RetencionRequest request = new RetencionRequest();
        request.setCntasPagarId(1001L);
        request.setNroCertificado("RET-" + sufijoUnico());
        request.setFechaEmision(LocalDate.now());
        request.setProveedorId(1L);
        request.setImporteDoc(new BigDecimal("1000.00"));
        request.setSaldoSol(new BigDecimal("1000.00"));
        request.setSaldoDol(BigDecimal.ZERO);
        request.setNroRegCajaBan(2001L);
        request.setFecPago(LocalDate.now());
        return request;
    }

    public static RetencionRequest crearRetencionRequestParaActualizar() {
        RetencionRequest request = new RetencionRequest();
        request.setCntasPagarId(1001L);
        request.setNroCertificado("RET-UPD-" + sufijoUnico());
        request.setFechaEmision(LocalDate.now());
        request.setProveedorId(1L);
        request.setImporteDoc(new BigDecimal("1500.00"));
        request.setSaldoSol(new BigDecimal("1500.00"));
        request.setSaldoDol(BigDecimal.ZERO);
        request.setNroRegCajaBan(2001L);
        request.setFecPago(LocalDate.now());
        return request;
    }

    // ==================== DATOS DE PRUEBA PARA DETRACCION ====================

    public static DetraccionRequest crearDetraccionRequest() {
        DetraccionRequest request = new DetraccionRequest();
        request.setCntasPagarId(1001L);
        request.setNroDetraccion("DET-" + sufijoUnico());
        request.setFechaRegistro(LocalDate.now());
        request.setNroDeposito("DEP-" + sufijoUnico());
        request.setFechaDeposito(LocalDate.now());
        request.setImporte(new BigDecimal("100.00"));
        request.setFlagTabla("1");
        request.setOrgCajaBanc("CB");
        request.setNroRegCajaBanc(2001L);
        request.setTipoDocCxc("FAC");
        request.setNroDocCxc("F001-00001");
        return request;
    }

    public static DetraccionRequest crearDetraccionRequestParaActualizar() {
        DetraccionRequest request = new DetraccionRequest();
        request.setCntasPagarId(1001L);
        request.setNroDetraccion("DET-UPD-" + sufijoUnico());
        request.setFechaRegistro(LocalDate.now());
        request.setNroDeposito("DEP-UPD-" + sufijoUnico());
        request.setFechaDeposito(LocalDate.now());
        request.setImporte(new BigDecimal("150.00"));
        request.setFlagTabla("1");
        request.setOrgCajaBanc("CB");
        request.setNroRegCajaBanc(2001L);
        request.setTipoDocCxc("FAC");
        request.setNroDocCxc("F001-00002");
        return request;
    }

    // ==================== DATOS DE PRUEBA PARA NOTA DEBITO/CREDITO ====================

    public static NotaRequest crearNotaDebitoRequest() {
        NotaRequest request = new NotaRequest();
        request.setTipoNota(TipoNota.DEBITO);
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("ND" + sufijoUnico());
        request.setNumero("00000001");
        request.setFechaEmision(LocalDate.now());
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("500.00"));
        request.setAno(LocalDate.now().getYear());
        request.setMes(LocalDate.now().getMonthValue());
        request.setCntblLibroId(1L);

        List<NotaDetalleRequest> detalles = new ArrayList<>();
        NotaDetalleRequest det = new NotaDetalleRequest();
        det.setItem(1);
        det.setConceptoFinancieroId(1L);
        det.setDescripcion("Nota debito");
        det.setCantidad(BigDecimal.ONE);
        det.setPrecioUnitario(new BigDecimal("500.00"));
        det.setFechaMov(LocalDate.now());
        det.setTipoMov("NOTA_DEBITO");
        det.setMonto(new BigDecimal("500.00"));
        det.setCentrosCostoId(1L);
        det.setImpuestos(impuestoDefault());
        detalles.add(det);
        request.setDetalles(detalles);

        return request;
    }

    public static NotaRequest crearNotaCreditoRequest() {
        NotaRequest request = new NotaRequest();
        request.setTipoNota(TipoNota.CREDITO);
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("NC" + sufijoUnico());
        request.setNumero("00000001");
        request.setFechaEmision(LocalDate.now());
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("300.00"));
        request.setAno(LocalDate.now().getYear());
        request.setMes(LocalDate.now().getMonthValue());
        request.setCntblLibroId(1L);

        List<NotaDetalleRequest> detalles = new ArrayList<>();
        NotaDetalleRequest det = new NotaDetalleRequest();
        det.setItem(1);
        det.setConceptoFinancieroId(1L);
        det.setDescripcion("Nota credito");
        det.setCantidad(BigDecimal.ONE);
        det.setPrecioUnitario(new BigDecimal("300.00"));
        det.setFechaMov(LocalDate.now());
        det.setTipoMov("NOTA_CREDITO");
        det.setMonto(new BigDecimal("300.00"));
        det.setCentrosCostoId(1L);
        det.setImpuestos(impuestoDefault());
        detalles.add(det);
        request.setDetalles(detalles);

        return request;
    }

    // ==================== DATOS DE PRUEBA PARA LIQUIDACION ====================

    public static LiquidacionRequest crearLiquidacionRequest() {
        LiquidacionRequest request = new LiquidacionRequest();
        request.setSolicitudGiroId(1L);
        request.setNroLiquidacion("LIQ-" + sufijoUnico());
        request.setSucursalId(1L);
        request.setDocTipoId(1L);
        request.setProveedorId(1L);
        request.setFechaLiquidacion(LocalDate.now());
        request.setTipoLiquidacion("G");
        request.setMonedaId(1L);
        request.setConceptoFinancieroId(1L);
        request.setImporteNeto(new BigDecimal("1000.00"));
        request.setTasaCambio(BigDecimal.ONE);
        request.setAnio(2026);
        request.setMes(5);
        request.setObservacion("Liquidacion de prueba");

        List<LiquidacionDetalleRequest> detalles = new ArrayList<>();
        LiquidacionDetalleRequest det = new LiquidacionDetalleRequest();
        det.setItem(1);
        det.setOrigenDocRef("CP");
        det.setMonedaId(1L);
        det.setConceptoFinancieroId(1L);
        det.setCntasPagarId(1001L);
        det.setCentrosCostoId(1L);
        det.setFactorSigno((short) 1);
        det.setImporte(new BigDecimal("1000.00"));
        det.setFlagRetencion("0");
        det.setFlagProvisionado("0");
        detalles.add(det);
        request.setDetalles(detalles);

        return request;
    }

    // ==================== DATOS DE PRUEBA PARA MOCK DE FEIGN CLIENTS ====================

    public static ApiResponse<PlanContableDetResponse> mockPlanContableDetResponse() {
        return ApiResponse.ok(new PlanContableDetResponse(2L, "42120101", "TEST", "D", "D", "1"));
    }

    public static ApiResponse<MonedaResponse> mockMonedaResponse() {
        return ApiResponse.ok(new MonedaResponse(1L, "PEN", "SOLES", "S/", "1"));
    }

    public static ApiResponse<EntidadContribuyenteResponse> mockEntidadResponse() {
        EntidadContribuyenteResponse entidad = new EntidadContribuyenteResponse();
        entidad.setId(1L);
        entidad.setRazonSocial("PROVEEDOR TEST");
        entidad.setNumeroDocumento("20123456789");
        return ApiResponse.ok(entidad);
    }

    public static ApiResponse<DocTipoResponse> mockDocTipoResponse() {
        DocTipoResponse docTipo = new DocTipoResponse();
        docTipo.setId(1L);
        docTipo.setCodigo("01");
        docTipo.setNombre("FACTURA");
        return ApiResponse.ok(docTipo);
    }

    // ==================== DATOS DE PRUEBA PARA CUENTAS POR PAGAR ====================

    public static CntasPagarRequest crearCntasPagarRequest() {
        CntasPagarRequest request = new CntasPagarRequest();
        request.setProveedorId(1L);
        request.setDocTipoId(1L);
        request.setSerie("F001");
        request.setNumero("000" + sufijoUnico());
        request.setFechaEmision(LocalDate.now().minusDays(30));
        request.setFechaVencimiento(LocalDate.now().plusDays(15));
        request.setMonedaId(1L);
        request.setTotal(new BigDecimal("1500.00"));
        request.setAno(LocalDate.now().getYear());
        request.setMes(LocalDate.now().getMonthValue());
        request.setCntblLibroId(1L);

        List<CntasPagarDetRequest> detalles = new ArrayList<>();
        CntasPagarDetRequest det = new CntasPagarDetRequest();
        det.setItem(1);
        det.setConceptoFinancieroId(1L);
        det.setDescripcion("Compra de prueba");
        det.setCantidad(BigDecimal.ONE);
        det.setPrecioUnitario(new BigDecimal("1500.00"));
        det.setMonto(new BigDecimal("1500.00"));
        det.setCentrosCostoId(1L);
        det.setImpuestos(impuestoDefault());
        det.setFechaMov(LocalDate.now());
        det.setTipoMov("COMPRA");
        detalles.add(det);
        request.setDetalles(detalles);

        return request;
    }

    // ==================== MÉTODOS UTILITARIOS ====================
    
    /**
     * Crea un número de documento único para pruebas
     */
    public static String crearNumeroUnico(String prefijo, Long id) {
        return prefijo + "-" + LocalDate.now().getYear() + "-" + String.format("%06d", id);
    }
    
    /**
     * Crea un monto aleatorio para pruebas
     */
    public static BigDecimal crearMontoAleatorio(BigDecimal min, BigDecimal max) {
        double randomValue = min.doubleValue() + (Math.random() * (max.doubleValue() - min.doubleValue()));
        return BigDecimal.valueOf(randomValue).setScale(2, RoundingMode.HALF_UP);
    }
    
    /**
     * Crea una fecha aleatoria en un rango
     */
    public static LocalDate crearFechaAleatoria(LocalDate inicio, LocalDate fin) {
        long dias = inicio.until(fin).getDays();
        long randomDias = (long) (Math.random() * dias);
        return inicio.plusDays(randomDias);
    }
}
