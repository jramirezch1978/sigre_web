package pe.restaurant.finanzas.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.entity.Liquidacion;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.mapper.LiquidacionMapper;
import pe.restaurant.finanzas.repository.LiquidacionDetRepository;
import pe.restaurant.finanzas.repository.LiquidacionRepository;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;

import java.math.BigDecimal;

/**
 * Flujo de aprobación de liquidaciones de rendición de gastos (HU-FIN-OPE-004).
 * Se aísla en un servicio propio para NO impactar el {@link LiquidacionService}
 * (alta/edición/cierre simple) ni el {@link LiquidacionCierreService} (cierre contable),
 * siguiendo el mismo patrón no invasivo ya usado en el módulo.
 *
 * <p>Cubre, SIN modificar la base de datos (reutiliza la columna {@code flag_estado} y
 * {@code observacion} existentes):
 * <ul>
 *   <li><b>Aprobar</b> (6.5): valida cuadre, calcula el saldo a devolver/regularizar
 *       contra el monto del adelanto y bloquea la edición.</li>
 *   <li><b>Rechazar</b> (6.6): exige justificación obligatoria y bloquea la edición.</li>
 *   <li><b>Observar</b> (6.7): exige motivo obligatorio y deja la liquidación editable
 *       de nuevo (vuelve a estado editable para corrección).</li>
 * </ul>
 *
 * <p>Estados de decisión modelados sobre el {@code flag_estado} (String) existente, con
 * valores nuevos que no colisionan con los del cierre contable
 * (1=Pendiente/Activa, 2=Cerrada, 0=Anulada):
 * <ul>
 *   <li>{@code 3} = Observada</li>
 *   <li>{@code 4} = Aprobada</li>
 *   <li>{@code 5} = Rechazada</li>
 * </ul>
 *
 * <p>Quedan fuera por requerir infraestructura inexistente (NO por la BD): validación de
 * comprobantes con serie/número/proveedor por línea, adjuntos, asiento contable de
 * aprobación e historial de auditoría persistente.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LiquidacionAprobacionService {

    public static final String ESTADO_PENDIENTE = "1";
    public static final String ESTADO_OBSERVADA = "3";
    public static final String ESTADO_APROBADA = "4";
    public static final String ESTADO_RECHAZADA = "5";

    private final LiquidacionRepository repository;
    private final LiquidacionDetRepository detRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final LiquidacionMapper mapper;
    private final PermisoCierreValidator permisoValidator;

    /**
     * Aprueba la liquidación (6.5): valida cuadre, calcula el saldo a devolver/regularizar
     * contra el monto del adelanto y la deja bloqueada para edición.
     */
    @Transactional
    public LiquidacionDetalleResponse aprobar(Long id, String observacion) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_APROBAR);

        Liquidacion entity = cargarDecidible(id);

        BigDecimal totalGastado = sumaDetalles(id);
        if (entity.getImporteNeto().compareTo(totalGastado) != 0) {
            throw new BusinessException(
                    "Los detalles no cuadran con el importe neto",
                    FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN);
        }

        // Saldo a devolver (>0) / por regularizar (<0) = monto del adelanto - total gastado.
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(entity.getSolicitudGiroId()).orElse(null);
        if (solicitudGiro != null && solicitudGiro.getMonto() != null) {
            BigDecimal saldo = solicitudGiro.getMonto().subtract(totalGastado);
            entity.setSaldo(saldo);
            if (saldo.signum() < 0) {
                // 6.4: advertencia (no bloqueante) si el total gastado excede el adelanto.
                log.warn("Liquidación {} aprobada con total gastado ({}) que excede el adelanto ({})",
                        id, totalGastado, solicitudGiro.getMonto());
            }
        }

        entity.setFlagEstado(ESTADO_APROBADA);
        if (observacion != null && !observacion.isBlank()) {
            entity.setObservacion(observacion);
        }
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(entity);

        log.info("Liquidación {} APROBADA por usuario {}", id, TenantContext.getUsuarioId());
        return mapper.toDetalleResponse(entity);
    }

    /**
     * Rechaza la liquidación (6.6) con justificación obligatoria y la bloquea para edición.
     */
    @Transactional
    public LiquidacionDetalleResponse rechazar(Long id, String justificacion) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_RECHAZAR);

        Liquidacion entity = cargarDecidible(id);

        entity.setFlagEstado(ESTADO_RECHAZADA);
        entity.setObservacion(truncar("[RECHAZADA] " + justificacion, 200));
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(entity);

        log.info("Liquidación {} RECHAZADA por usuario {}", id, TenantContext.getUsuarioId());
        return mapper.toDetalleResponse(entity);
    }

    /**
     * Observa la liquidación (6.7) con motivo obligatorio. Vuelve a estado editable
     * (Observada) para que quien la registró la corrija.
     */
    @Transactional
    public LiquidacionDetalleResponse observar(Long id, String motivo) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_OBSERVAR);

        Liquidacion entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));

        if (!ESTADO_PENDIENTE.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden observar liquidaciones pendientes",
                    FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO);
        }

        entity.setFlagEstado(ESTADO_OBSERVADA);
        entity.setObservacion(truncar("[OBSERVADA] " + motivo, 200));
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(entity);

        log.info("Liquidación {} OBSERVADA por usuario {}", id, TenantContext.getUsuarioId());
        return mapper.toDetalleResponse(entity);
    }

    /**
     * Carga una liquidación que admite decisión (Aprobar/Rechazar): debe estar Pendiente
     * u Observada. Las Aprobadas/Rechazadas/Cerradas/Anuladas son terminales.
     */
    private Liquidacion cargarDecidible(Long id) {
        Liquidacion entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));

        if (!ESTADO_PENDIENTE.equals(entity.getFlagEstado())
                && !ESTADO_OBSERVADA.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden aprobar o rechazar liquidaciones pendientes u observadas",
                    FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO);
        }
        return entity;
    }

    private BigDecimal sumaDetalles(Long id) {
        BigDecimal suma = detRepository.calcularSumaImportes(id);
        return suma != null ? suma : BigDecimal.ZERO;
    }

    private String truncar(String valor, int max) {
        if (valor == null) {
            return null;
        }
        return valor.length() > max ? valor.substring(0, max) : valor;
    }
}
