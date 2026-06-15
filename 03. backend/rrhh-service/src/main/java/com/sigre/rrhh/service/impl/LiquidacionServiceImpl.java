package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import io.micrometer.core.annotation.Timed;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.entity.Contrato;
import com.sigre.rrhh.entity.Liquidacion;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.ContratoRepository;
import com.sigre.rrhh.repository.LiquidacionRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.LiquidacionService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

/**
 * Implementación del servicio de liquidaciones de beneficios sociales.
 * Contiene la lógica de cálculo simplificado, validaciones de negocio
 * (RH-LQ-001 a RH-LQ-006) y la gestión de estados (Pendiente, Aprobada, Anulada).
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class LiquidacionServiceImpl implements LiquidacionService {

    private static final String REGIMEN_AGRICOLA = "AGRICOLA";
    private static final BigDecimal FACTOR_BONIFICACION = new BigDecimal("0.09");
    private static final BigDecimal FACTOR_ONP = new BigDecimal("0.13");
    private static final BigDecimal DOCE = new BigDecimal("12");
    private static final BigDecimal DOS = new BigDecimal("2");
    private static final int ESCALA = 4;

    private final LiquidacionRepository liquidacionRepo;
    private final TrabajadorRepository trabajadorRepo;
    private final ContratoRepository contratoRepo;

    /**
     * {@inheritDoc}
     * <p>Validaciones aplicadas (en orden):
     * <ul>
     *   <li>RH-LQ-001 — trabajadorId obligatorio</li>
     *   <li>RH-LQ-004 — el trabajador debe existir</li>
     *   <li>RH-LQ-002 — el trabajador debe tener fecha de cese registrada</li>
     *   <li>RH-LQ-003 — no debe existir otra liquidación activa</li>
     * </ul>
     * El cálculo es simplificado y depende del régimen laboral del trabajador.
     */
    @Override
    public Liquidacion calcular(Long trabajadorId, LocalDate fechaCese) {
        if (trabajadorId == null) {
            throw new BusinessException("Debe seleccionar un trabajador.",
                    HttpStatus.BAD_REQUEST, "RH-LQ-001");
        }

        Trabajador trabajador = trabajadorRepo.findById(trabajadorId)
                .orElseThrow(() -> new BusinessException("Liquidación no encontrada.",
                        HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND"));

        if (trabajador.getFechaCese() == null) {
            throw new BusinessException("El trabajador no tiene fecha de cese registrada.",
                    HttpStatus.BAD_REQUEST, "RH-LQ-002");
        }

        LocalDate fechaCeseEfectiva = fechaCese != null ? fechaCese : trabajador.getFechaCese();

        if (liquidacionRepo.existsActivaByTrabajadorAndFecha(trabajadorId, fechaCeseEfectiva)) {
            throw new BusinessException(
                    "Ya existe una liquidación activa para este trabajador y fecha de cese.",
                    HttpStatus.CONFLICT, "RH-LQ-003");
        }

        BigDecimal remuneracion = obtenerRemuneracionActiva(trabajadorId);
        String regimenCodigo = trabajador.getRegimenLaboralId() != null
                ? trabajadorRepo.findRegimenLaboralCodigoById(trabajador.getRegimenLaboralId())
                : null;
        boolean esAgricola = REGIMEN_AGRICOLA.equalsIgnoreCase(regimenCodigo);

        BigDecimal gratificacionTrunca;
        BigDecimal ctsPendiente;
        BigDecimal vacacionesTruncas;
        BigDecimal bonificacionExtraordinaria;

        // Vacaciones truncas aplican en todos los regímenes (simplificado = remuneración / 12).
        vacacionesTruncas = escala(remuneracion.divide(DOCE, ESCALA, RoundingMode.HALF_UP));

        if (esAgricola) {
            // Régimen AGRICOLA: solo vacaciones truncas.
            gratificacionTrunca = escala(BigDecimal.ZERO);
            ctsPendiente = escala(BigDecimal.ZERO);
            bonificacionExtraordinaria = escala(BigDecimal.ZERO);
        } else {
            // Régimen GENERAL u otros: todos los conceptos.
            gratificacionTrunca = escala(remuneracion);
            ctsPendiente = escala(remuneracion.divide(DOS, ESCALA, RoundingMode.HALF_UP));
            bonificacionExtraordinaria = escala(gratificacionTrunca.multiply(FACTOR_BONIFICACION));
        }

        BigDecimal indemnizacion = escala(BigDecimal.ZERO);

        BigDecimal totalBeneficios = escala(ctsPendiente
                .add(vacacionesTruncas)
                .add(gratificacionTrunca)
                .add(indemnizacion)
                .add(bonificacionExtraordinaria));

        BigDecimal totalDescuentos = escala(remuneracion.multiply(FACTOR_ONP));

        BigDecimal netoPagar = escala(totalBeneficios.subtract(totalDescuentos));

        Liquidacion liquidacion = Liquidacion.builder()
                .trabajadorId(trabajadorId)
                .fechaCese(fechaCeseEfectiva)
                .ctsPendiente(ctsPendiente)
                .vacacionesTruncas(vacacionesTruncas)
                .gratificacionTrunca(gratificacionTrunca)
                .indemnizacion(indemnizacion)
                .totalBeneficios(totalBeneficios)
                .totalDescuentos(totalDescuentos)
                .netoPagar(netoPagar)
                .build();
        liquidacion.setFlagEstado("1");
        setAuditCreacion(liquidacion);

        return liquidacionRepo.save(liquidacion);
    }

    /** {@inheritDoc} */
    @Override
    @Transactional(readOnly = true)
    public Page<Liquidacion> listar(Long trabajadorId, String flagEstado,
                                    LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        return liquidacionRepo.findWithFilters(trabajadorId, flagEstado, fechaDesde, fechaHasta, pageable);
    }

    /** {@inheritDoc} */
    @Override
    @Transactional(readOnly = true)
    public Liquidacion obtenerPorId(Long id) {
        return liquidacionRepo.findById(id)
                .orElseThrow(() -> new BusinessException("Liquidación no encontrada.",
                        HttpStatus.NOT_FOUND, "RH-LQ-004"));
    }

    /**
     * {@inheritDoc}
     * <p>Solo se pueden aprobar liquidaciones en estado Pendiente (RH-LQ-005).
     */
    @Override
    @Timed("rrhh.liquidacion.aprobar")
public Liquidacion aprobar(Long id) {
        Liquidacion liquidacion = obtenerPorId(id);
        if (!"1".equals(liquidacion.getFlagEstado())) {
            throw new BusinessException("Solo se pueden aprobar liquidaciones en estado Pendiente.",
                    HttpStatus.BAD_REQUEST, "RH-LQ-005");
        }
        liquidacion.setFlagEstado("2");
        setAuditModificacion(liquidacion);
        return liquidacionRepo.save(liquidacion);
    }

    /**
     * {@inheritDoc}
     * <p>Solo se pueden anular liquidaciones en estado Pendiente (RH-LQ-006).
     */
    @Override
    @Timed("rrhh.liquidacion.anular")
public Liquidacion anular(Long id) {
        Liquidacion liquidacion = obtenerPorId(id);
        if (!"1".equals(liquidacion.getFlagEstado())) {
            throw new BusinessException("Solo se pueden anular liquidaciones en estado Pendiente.",
                    HttpStatus.BAD_REQUEST, "RH-LQ-006");
        }
        liquidacion.setFlagEstado("0");
        setAuditModificacion(liquidacion);
        return liquidacionRepo.save(liquidacion);
    }

    // ── helpers ──────────────────────────────────────────────────

    /**
     * Obtiene la remuneración del contrato activo del trabajador.
     * Si no existe contrato activo o remuneración, retorna 0.
     */
    private BigDecimal obtenerRemuneracionActiva(Long trabajadorId) {
        List<Contrato> activos = contratoRepo
                .findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(trabajadorId, "1");
        if (activos.isEmpty() || activos.get(0).getRemuneracion() == null) {
            return BigDecimal.ZERO;
        }
        return activos.get(0).getRemuneracion();
    }

    /** Aplica escala monetaria de 4 decimales con redondeo HALF_UP. */
    private BigDecimal escala(BigDecimal value) {
        return value.setScale(ESCALA, RoundingMode.HALF_UP);
    }

    // ── Auditoría manual (compatible con AuditorAware de common) ─

    /** Setea created_by y fec_creacion antes del primer save. */
    private void setAuditCreacion(com.sigre.common.entity.BaseEntity entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
    }

    /** Setea updated_by y fec_modificacion antes de cada update. */
    private void setAuditModificacion(com.sigre.common.entity.BaseEntity entity) {
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
    }
}
