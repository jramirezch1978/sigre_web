package pe.restaurant.contabilidad.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.contabilidad.dto.request.*;
import pe.restaurant.contabilidad.dto.response.AsientoResponse;
import pe.restaurant.contabilidad.dto.response.GenerarAsientoResponse;
import pe.restaurant.contabilidad.entity.CntblAsiento;
import pe.restaurant.contabilidad.entity.CntblAsientoDet;
import pe.restaurant.contabilidad.entity.ConceptoFinanciero;
import pe.restaurant.contabilidad.entity.MatrizContable;
import pe.restaurant.contabilidad.entity.MatrizContableDet;
import pe.restaurant.contabilidad.enums.TipoOperacionContable;
import pe.restaurant.contabilidad.mapper.AsientoMapper;
import pe.restaurant.contabilidad.repository.CntblAsientoDetRepository;
import pe.restaurant.contabilidad.repository.CntblAsientoRepository;
import pe.restaurant.contabilidad.repository.ConceptoFinancieroRepository;
import pe.restaurant.contabilidad.repository.MatrizContableRepository;
import pe.restaurant.contabilidad.service.ContabilidadErrorCodes;
import pe.restaurant.contabilidad.service.GenerarAsientoService;
import pe.restaurant.contabilidad.support.AsientoPeriodoLibroValidator;
import pe.restaurant.contabilidad.support.AsientoPeriodoLibroValidator.PeriodoLibro;
import pe.restaurant.contabilidad.support.SucursalVoucherValidator;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class GenerarAsientoServiceImpl implements GenerarAsientoService {

    private static final String FLAG_DEBE = "D";

    private final CntblAsientoRepository asientoRepository;
    private final CntblAsientoDetRepository detalleRepository;
    private final MatrizContableRepository matrizContableRepository;
    private final ConceptoFinancieroRepository conceptoFinancieroRepository;
    private final AsientoMapper asientoMapper;
    private final AsientoPeriodoLibroValidator periodoLibroValidator;
    private final SucursalVoucherValidator sucursalVoucherValidator;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    @Timed(value = "app.contabilidad.generar_asiento", extraTags = {"operation", "caja_bancos"})
    public GenerarAsientoResponse generarAsientoCajaBancos(TipoOperacionContable tipoOperacion,
                                                            CajaBancosAsientoRequest request) {
        log.info("Generando asiento {} desde caja_bancos id={}", tipoOperacion.name(), request.getId());

        PeriodoLibro periodoLibro = periodoLibroValidator.validar(
                request.getAno(), request.getMes(), request.getCntblLibroId());
        CntblAsiento asiento = buildCabecera(tipoOperacion, request.getFechaEmision(),
                request.getSucursalId(), request.getMonedaId(), request.getTasaCambio(),
                request.getObservacion(), periodoLibro);
        CntblAsiento savedAsiento = asientoRepository.save(asiento);

        Map<Long, MatrizContable> cache = new HashMap<>();
        int lineas = 0;

        for (CajaBancosDetAsientoRequest det : request.getDetalles()) {
            lineas += generarLineasDesdeConcepto(savedAsiento, det.getConceptoFinancieroId(),
                    det.getImporte(), det.getCentrosCostoId(), det.getEntidadContribuyenteId(),
                    det.getGlosa(), request.getTasaCambio(), cache);
        }

        return finalizarAsiento(savedAsiento, tipoOperacion, request.getId(), lineas);
    }

    @Override
    @Transactional
    @Timed(value = "app.contabilidad.generar_asiento", extraTags = {"operation", "cntas_pagar"})
    public GenerarAsientoResponse generarAsientoCntasPagar(TipoOperacionContable tipoOperacion,
                                                            CntasPagarAsientoRequest request) {
        log.info("Generando asiento {} desde cntas_pagar id={}", tipoOperacion.name(), request.getId());

        PeriodoLibro periodoLibro = periodoLibroValidator.validar(
                request.getAno(), request.getMes(), request.getCntblLibroId());
        CntblAsiento asiento = buildCabecera(tipoOperacion, request.getFechaEmision(),
                request.getSucursalId(), request.getMonedaId(), request.getTasaCambio(),
                request.getGlosa(), periodoLibro);
        CntblAsiento savedAsiento = asientoRepository.save(asiento);

        Map<Long, MatrizContable> cache = new HashMap<>();
        int lineas = 0;

        for (CntasPagarDetAsientoRequest det : request.getDetalles()) {
            lineas += generarLineasDesdeConcepto(savedAsiento, det.getConceptoFinancieroId(),
                    det.getMonto(), det.getCentrosCostoId(), request.getProveedorId(),
                    det.getGlosa(), request.getTasaCambio(), cache);
            lineas += generarLineasDesdeImpuestos(savedAsiento, det.getImpuestos(),
                    det.getCentrosCostoId(), request.getProveedorId(), det.getGlosa(),
                    request.getTasaCambio());
        }

        return finalizarAsiento(savedAsiento, tipoOperacion, request.getId(), lineas);
    }

    @Override
    @Transactional
    @Timed(value = "app.contabilidad.generar_asiento", extraTags = {"operation", "cntas_cobrar"})
    public GenerarAsientoResponse generarAsientoCntasCobrar(TipoOperacionContable tipoOperacion,
                                                             CntasCobrarAsientoRequest request) {
        log.info("Generando asiento {} desde cntas_cobrar id={}", tipoOperacion.name(), request.getId());

        PeriodoLibro periodoLibro = periodoLibroValidator.validar(
                request.getAno(), request.getMes(), request.getCntblLibroId());
        CntblAsiento asiento = buildCabecera(tipoOperacion, request.getFechaEmision(),
                request.getSucursalId(), request.getMonedaId(), request.getTasaCambio(),
                request.getGlosa(), periodoLibro);
        CntblAsiento savedAsiento = asientoRepository.save(asiento);

        Map<Long, MatrizContable> cache = new HashMap<>();
        int lineas = 0;

        for (CntasCobrarDetAsientoRequest det : request.getDetalles()) {
            lineas += generarLineasDesdeConcepto(savedAsiento, det.getConceptoFinancieroId(),
                    det.getMonto(), null, request.getClienteId(),
                    det.getGlosa(), request.getTasaCambio(), cache);
            lineas += generarLineasDesdeImpuestos(savedAsiento, det.getImpuestos(),
                    null, request.getClienteId(), det.getGlosa(), request.getTasaCambio());
        }

        return finalizarAsiento(savedAsiento, tipoOperacion, request.getId(), lineas);
    }

    @Override
    @Transactional
    @Timed(value = "app.contabilidad.generar_asiento", extraTags = {"operation", "liquidacion"})
    public GenerarAsientoResponse generarAsientoLiquidacion(TipoOperacionContable tipoOperacion,
                                                             LiquidacionAsientoRequest request) {
        log.info("Generando asiento {} desde liquidacion id={}", tipoOperacion.name(), request.getId());

        PeriodoLibro periodoLibro = periodoLibroValidator.validar(
                request.getAno(), request.getMes(), request.getCntblLibroId());
        CntblAsiento asiento = buildCabecera(tipoOperacion, request.getFechaRegistro(),
                request.getSucursalId(), request.getMonedaId(), request.getTasaCambio(),
                request.getObservacion(), periodoLibro);
        CntblAsiento savedAsiento = asientoRepository.save(asiento);

        Map<Long, MatrizContable> cache = new HashMap<>();
        int lineas = 0;

        for (LiquidacionDetAsientoRequest det : request.getDetalles()) {
            lineas += generarLineasDesdeConcepto(savedAsiento, det.getConceptoFinancieroId(),
                    det.getImporte(), det.getCentrosCostoId(), request.getProveedorId(),
                    det.getGlosa(), request.getTasaCambio(), cache);
        }

        return finalizarAsiento(savedAsiento, tipoOperacion, request.getId(), lineas);
    }

    private CntblAsiento buildCabecera(TipoOperacionContable tipoOperacion,
                                        LocalDate fecha, Long sucursalId, Long monedaId,
                                        BigDecimal tasaCambio, String glosa, PeriodoLibro periodoLibro) {
        Long sucursal = sucursalVoucherValidator.validar(
                sucursalId != null ? sucursalId : TenantContext.getSucursalId());

        LocalDate fechaAsiento = fecha != null ? fecha : LocalDate.now();
        String voucher = asientoRepository.getVoucherNumber(
                sucursal, periodoLibro.ano(), periodoLibro.mes(), periodoLibro.cntblLibroId());

        CntblAsiento asiento = new CntblAsiento();
        asiento.setVoucher(voucher);
        asiento.setLibroId(periodoLibro.cntblLibroId());
        asiento.setFecha(fechaAsiento);
        asiento.setGlosa(glosa != null && !glosa.isBlank() ? glosa
                : String.format("Asiento automático - %s", tipoOperacion.name()));
        asiento.setNaturalezaAsiento(tipoOperacion.getTipoOperacion());
        asiento.setModuloOrigen(tipoOperacion.getModulo());
        asiento.setMonedaId(monedaId);
        asiento.setTasaCambio(tasaCambio);
        asiento.setCreatedBy(TenantContext.getUsuarioId());
        return asiento;
    }

    private int generarLineasDesdeConcepto(CntblAsiento asiento, Long conceptoFinancieroId,
                                           BigDecimal monto, Long centrosCostoId,
                                           Long entidadContribuyenteId, String glosa,
                                           BigDecimal tasaCambio, Map<Long, MatrizContable> cache) {
        if (monto == null || monto.compareTo(BigDecimal.ZERO) == 0) {
            return 0;
        }

        MatrizContable matriz = resolverMatrizPorConcepto(conceptoFinancieroId, cache);
        int lineasGeneradas = 0;

        for (MatrizContableDet lineaMatriz : matriz.getDetalles()) {
            BigDecimal importeSol = monto;
            BigDecimal importeDol = BigDecimal.ZERO;
            if (tasaCambio != null && tasaCambio.compareTo(BigDecimal.ZERO) > 0) {
                importeDol = monto.divide(tasaCambio, 4, RoundingMode.HALF_UP);
            }

            CntblAsientoDet det = new CntblAsientoDet();
            det.setCntblAsiento(asiento);
            det.setPlanContableDetId(resolverCuenta(lineaMatriz));
            det.setCentrosCostoId(centrosCostoId);
            det.setEntidadContribuyenteId(entidadContribuyenteId);
            det.setGlosaDetalle(glosa != null ? glosa : asiento.getGlosa());
            det.setFlagDebeHaber(lineaMatriz.getFlagDebHab());
            det.setImporteSol(importeSol);
            det.setImporteDol(importeDol);
            det.setCreatedBy(TenantContext.getUsuarioId());
            det.setFecCreacion(Instant.now());
            detalleRepository.save(det);
            lineasGeneradas++;
        }
        return lineasGeneradas;
    }

    private int generarLineasDesdeImpuestos(CntblAsiento asiento,
                                            List<DetImpuestoAsientoRequest> impuestos,
                                            Long centrosCostoId,
                                            Long entidadContribuyenteId,
                                            String glosa,
                                            BigDecimal tasaCambio) {
        if (impuestos == null || impuestos.isEmpty()) {
            return 0;
        }
        int lineasGeneradas = 0;
        for (DetImpuestoAsientoRequest impuesto : impuestos) {
            lineasGeneradas += generarLineaDesdeImpuesto(asiento, impuesto, centrosCostoId,
                    entidadContribuyenteId, glosa, tasaCambio);
        }
        return lineasGeneradas;
    }

    private int generarLineaDesdeImpuesto(CntblAsiento asiento,
                                          DetImpuestoAsientoRequest impuesto,
                                          Long centrosCostoId,
                                          Long entidadContribuyenteId,
                                          String glosa,
                                          BigDecimal tasaCambio) {
        BigDecimal monto = impuesto.getImporte();
        if (monto == null || monto.compareTo(BigDecimal.ZERO) == 0) {
            return 0;
        }
        Long tiposImpuestoId = impuesto.getTiposImpuestoId();
        if (tiposImpuestoId == null) {
            return 0;
        }

        try {
            Object[] row = (Object[]) entityManager.createNativeQuery(
                            "SELECT plan_contable_det_id, flag_dh_cxp FROM core.tipos_impuesto WHERE id = :id")
                    .setParameter("id", tiposImpuestoId)
                    .getSingleResult();

            Long planContableDetId = row[0] != null ? ((Number) row[0]).longValue() : null;
            if (planContableDetId == null) {
                return 0;
            }

            String flagDebHab = row[1] != null ? row[1].toString().trim() : FLAG_DEBE;
            if (flagDebHab.isEmpty()) {
                flagDebHab = FLAG_DEBE;
            }

            BigDecimal importeSol = monto;
            BigDecimal importeDol = BigDecimal.ZERO;
            if (tasaCambio != null && tasaCambio.compareTo(BigDecimal.ZERO) > 0) {
                importeDol = monto.divide(tasaCambio, 4, RoundingMode.HALF_UP);
            }

            CntblAsientoDet det = new CntblAsientoDet();
            det.setCntblAsiento(asiento);
            det.setPlanContableDetId(planContableDetId);
            det.setCentrosCostoId(centrosCostoId);
            det.setEntidadContribuyenteId(entidadContribuyenteId);
            det.setGlosaDetalle(glosa != null ? glosa : asiento.getGlosa());
            det.setFlagDebeHaber(flagDebHab);
            det.setImporteSol(importeSol);
            det.setImporteDol(importeDol);
            det.setCreatedBy(TenantContext.getUsuarioId());
            det.setFecCreacion(Instant.now());
            detalleRepository.save(det);
            return 1;
        } catch (NoResultException ex) {
            log.warn("Tipo de impuesto id={} no encontrado al generar línea contable", tiposImpuestoId);
            return 0;
        }
    }

    private MatrizContable resolverMatrizPorConcepto(Long conceptoFinancieroId,
                                                     Map<Long, MatrizContable> cache) {
        ConceptoFinanciero concepto = conceptoFinancieroRepository
                .findById(conceptoFinancieroId)
                .orElseThrow(() -> new BusinessException(
                        String.format("Concepto financiero con ID %d no encontrado", conceptoFinancieroId),
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        ContabilidadErrorCodes.CONCEPTO_FINANCIERO_NO_ENCONTRADO));

        if (!"1".equals(concepto.getFlagEstado())) {
            throw new BusinessException(
                    String.format("Concepto financiero '%s' está inactivo", concepto.getCodigo()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CONCEPTO_FINANCIERO_INACTIVO);
        }

        Long matrizId = concepto.getMatrizContableId();
        return cache.computeIfAbsent(matrizId, id ->
                matrizContableRepository.findByIdWithDetalles(id)
                        .orElseThrow(() -> new BusinessException(
                                String.format("Matriz contable ID %d (concepto '%s') no encontrada o inactiva",
                                        id, concepto.getCodigo()),
                                HttpStatus.UNPROCESSABLE_ENTITY,
                                ContabilidadErrorCodes.MATRIZ_CONTABLE_NO_ENCONTRADA))
        );
    }

    private Long resolverCuenta(MatrizContableDet lineaMatriz) {
        if (lineaMatriz.getPlanContableDetId() != null) {
            return lineaMatriz.getPlanContableDetId();
        }
        throw new BusinessException(
                "Matriz contable incompleta: falta cuenta para secuencia " + lineaMatriz.getSecuencia(),
                HttpStatus.UNPROCESSABLE_ENTITY,
                ContabilidadErrorCodes.PLAN_CONTABLE_NO_ENCONTRADO);
    }

    private GenerarAsientoResponse finalizarAsiento(CntblAsiento savedAsiento,
                                                     TipoOperacionContable tipoOperacion,
                                                     Long documentoOrigenId, int lineas) {
        CntblAsiento asientoCompleto = asientoRepository.findByIdWithDetalles(savedAsiento.getId())
                .orElseThrow();
        validarBalanceo(asientoCompleto);

        AsientoResponse asientoResponse = asientoMapper.toResponse(asientoCompleto);

        GenerarAsientoResponse response = new GenerarAsientoResponse();
        response.setAsientoId(asientoCompleto.getId());
        response.setVoucher(asientoCompleto.getVoucher());
        response.setModuloOrigen(tipoOperacion.getModulo());
        response.setTipoOperacion(tipoOperacion.name());
        response.setDocumentoOrigenId(documentoOrigenId);
        response.setTotalLineasDetalle(lineas);
        response.setAsiento(asientoResponse);

        log.info("Asiento generado id={}, voucher={}, lineas={}",
                savedAsiento.getId(), savedAsiento.getVoucher(), lineas);
        return response;
    }

    private void validarBalanceo(CntblAsiento asiento) {
        BigDecimal sumaDebe = asiento.getDetalles().stream()
                .filter(d -> FLAG_DEBE.equals(d.getFlagDebeHaber()))
                .map(d -> d.getImporteSol() != null ? d.getImporteSol() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal sumaHaber = asiento.getDetalles().stream()
                .filter(d -> !FLAG_DEBE.equals(d.getFlagDebeHaber()))
                .map(d -> d.getImporteSol() != null ? d.getImporteSol() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (sumaDebe.compareTo(sumaHaber) != 0) {
            log.error("Asiento NO balanceado - Debe: {}, Haber: {}", sumaDebe, sumaHaber);
            throw new BusinessException(
                    String.format("El asiento generado no está balanceado. Debe: %s, Haber: %s",
                            sumaDebe, sumaHaber),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.ASIENTO_NO_BALANCEADO);
        }
    }
}
