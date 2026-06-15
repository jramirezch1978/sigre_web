package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.entity.Liquidacion;

import java.time.LocalDate;

/**
 * Contrato de servicio para la gestión de liquidaciones de beneficios sociales
 * por cese de trabajadores.
 */
public interface LiquidacionService {

    /**
     * Calcula y registra una nueva liquidación para el trabajador indicado.
     *
     * @param trabajadorId ID del trabajador a liquidar
     * @param fechaCese    fecha de cese solicitada (opcional)
     * @return liquidación calculada y persistida en estado Pendiente
     */
    Liquidacion calcular(Long trabajadorId, LocalDate fechaCese);

    /**
     * Lista liquidaciones con filtros opcionales y paginación.
     *
     * @param trabajadorId filtro exacto por trabajador
     * @param flagEstado   filtro por estado
     * @param fechaDesde   límite inferior de fecha de cese
     * @param fechaHasta   límite superior de fecha de cese
     * @param pageable     paginación
     * @return página de liquidaciones
     */
    Page<Liquidacion> listar(Long trabajadorId, String flagEstado,
                             LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);

    /**
     * Obtiene el detalle de una liquidación por su ID.
     *
     * @param id ID de la liquidación
     * @return liquidación encontrada
     */
    Liquidacion obtenerPorId(Long id);

    /**
     * Aprueba una liquidación en estado Pendiente (flag_estado '1' → '2').
     *
     * @param id ID de la liquidación
     * @return liquidación aprobada
     */
    Liquidacion aprobar(Long id);

    /**
     * Anula una liquidación en estado Pendiente (flag_estado '1' → '0').
     *
     * @param id ID de la liquidación
     * @return liquidación anulada
     */
    Liquidacion anular(Long id);
}
