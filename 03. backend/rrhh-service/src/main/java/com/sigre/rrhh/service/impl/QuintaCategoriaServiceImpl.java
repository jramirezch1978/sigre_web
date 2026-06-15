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
import com.sigre.rrhh.entity.QuintaCategoria;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.ContratoRepository;
import com.sigre.rrhh.repository.QuintaCategoriaRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.QuintaCategoriaService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementación del servicio de retención de impuesto a la renta de quinta categoría.
 * <p>
 * Contiene la lógica de procesamiento por lotes que proyecta la renta anual de cada
 * trabajador activo con contrato vigente y calcula la retención mensual aplicando
 * la escala progresiva acumulativa basada en la UIT.
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class QuintaCategoriaServiceImpl implements QuintaCategoriaService {

    private final QuintaCategoriaRepository quintaCategoriaRepo;
    private final TrabajadorRepository trabajadorRepo;
    private final ContratoRepository contratoRepo;

    /** Valor de la UIT para el ejercicio 2026. */
    private static final BigDecimal UIT = BigDecimal.valueOf(5350);

    /** Deducción fija de 7 UIT aplicable a la renta de quinta categoría. */
    private static final BigDecimal DEDUCCION_7UIT = UIT.multiply(BigDecimal.valueOf(7));

    /** Cantidad de remuneraciones proyectadas al año (12 mensuales + 2 gratificaciones). */
    private static final BigDecimal REMUNERACIONES_ANUALES = BigDecimal.valueOf(14);

    private static final int ESCALA = 4;

    // ══════════════════════════════════════════════════════════════
    //  PROCESAMIENTO
    // ══════════════════════════════════════════════════════════════

    /**
     * {@inheritDoc}
     * <p>Pasos del procesamiento:
     * <ol>
     *   <li>Valida año (RH-QC-001) y mes (RH-QC-002)</li>
     *   <li>Obtiene trabajadores activos; si no hay afectos, lanza RH-QC-003</li>
     *   <li>Elimina los registros previos del período (reproceso idempotente)</li>
     *   <li>Para cada trabajador con contrato vigente, proyecta la renta anual</li>
     *   <li>Aplica la escala progresiva acumulativa y persiste la retención</li>
     * </ol>
     */
    @Override
    @Timed("rrhh.quintaCategoria.procesar")
public List<QuintaCategoria> procesar(Integer anio, Integer mes) {
        log.info("Iniciando proceso de quinta categoría: anio={}, mes={}", anio, mes);

        validarPeriodo(anio, mes);

        List<Trabajador> activos = trabajadorRepo.findAll().stream()
                .filter(t -> "1".equals(t.getFlagEstado()))
                .toList();

        if (activos.isEmpty()) {
            throw new BusinessException(
                    "No se encontraron trabajadores afectos a quinta categoría en el periodo.",
                    HttpStatus.BAD_REQUEST, "RH-QC-003");
        }

        Long userId = TenantContext.getUsuarioId();
        Instant now = Instant.now();

        // Reproceso idempotente: se eliminan los registros previos del período.
        quintaCategoriaRepo.deleteByAnioAndMes(anio, mes);

        List<QuintaCategoria> resultados = new ArrayList<>();

        for (Trabajador trabajador : activos) {
            Contrato contrato = findContratoActivo(trabajador.getId());
            if (contrato == null) {
                log.debug("Trabajador ID={} sin contrato activo, se omite", trabajador.getId());
                continue;
            }

            BigDecimal remuneracion = contrato.getRemuneracion() != null
                    ? contrato.getRemuneracion()
                    : BigDecimal.ZERO;

            BigDecimal rentaBrutaAcumulada = scale(remuneracion.multiply(BigDecimal.valueOf(mes)));
            BigDecimal rentaBrutaProyectada = scale(remuneracion.multiply(REMUNERACIONES_ANUALES));
            BigDecimal rentaNeta = scale(rentaBrutaProyectada.subtract(DEDUCCION_7UIT));

            BigDecimal impuestoAnual;
            BigDecimal retencionMensual;
            BigDecimal retencionAcumulada;

            if (rentaNeta.compareTo(BigDecimal.ZERO) <= 0) {
                rentaNeta = BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP);
                impuestoAnual = BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP);
                retencionMensual = BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP);
                retencionAcumulada = BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP);
            } else {
                impuestoAnual = calcularImpuestoProgresivo(rentaNeta);
                retencionMensual = scale(impuestoAnual.divide(BigDecimal.valueOf(12), ESCALA, RoundingMode.HALF_UP));
                retencionAcumulada = scale(retencionMensual.multiply(BigDecimal.valueOf(mes)));
            }

            QuintaCategoria registro = QuintaCategoria.builder()
                    .trabajadorId(trabajador.getId())
                    .anio(anio)
                    .mes(mes)
                    .rentaBrutaAcumulada(rentaBrutaAcumulada)
                    .rentaBrutaProyectada(rentaBrutaProyectada)
                    .deduccion7uit(scale(DEDUCCION_7UIT))
                    .rentaNeta(rentaNeta)
                    .impuestoAnualProyectado(impuestoAnual)
                    .retencionMensual(retencionMensual)
                    .retencionAcumulada(retencionAcumulada)
                    .createdBy(userId)
                    .fecCreacion(now)
                    .build();

            resultados.add(registro);
        }

        List<QuintaCategoria> guardados = quintaCategoriaRepo.saveAll(resultados);

        log.info("Proceso de quinta categoría completado: anio={}, mes={}, registros={}",
                anio, mes, guardados.size());

        return guardados;
    }

    // ══════════════════════════════════════════════════════════════
    //  CONSULTAS
    // ══════════════════════════════════════════════════════════════

    /** {@inheritDoc} */
    @Override
    @Transactional(readOnly = true)
    public Page<QuintaCategoria> listar(Long trabajadorId, Integer anio, Integer mes, Pageable pageable) {
        return quintaCategoriaRepo.findWithFilters(trabajadorId, anio, mes, pageable);
    }

    /** {@inheritDoc} */
    @Override
    @Transactional(readOnly = true)
    public QuintaCategoria obtenerPorId(Long id) {
        return quintaCategoriaRepo.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Registro de quinta categoría no encontrado.",
                        HttpStatus.NOT_FOUND, "RH-QC-004"));
    }

    // ══════════════════════════════════════════════════════════════
    //  MÉTODOS PRIVADOS
    // ══════════════════════════════════════════════════════════════

    /**
     * Valida los parámetros del período.
     *
     * @param anio año (obligatorio)
     * @param mes  mes (1-12)
     */
    private void validarPeriodo(Integer anio, Integer mes) {
        if (anio == null) {
            throw new BusinessException(
                    "El año es obligatorio.", HttpStatus.BAD_REQUEST, "RH-QC-001");
        }
        if (mes == null || mes < 1 || mes > 12) {
            throw new BusinessException(
                    "El mes debe estar entre 1 y 12.", HttpStatus.BAD_REQUEST, "RH-QC-002");
        }
    }

    /**
     * Obtiene el contrato vigente (flagEstado='1') más reciente del trabajador.
     *
     * @param trabajadorId ID del trabajador
     * @return contrato activo o {@code null} si no tiene
     */
    private Contrato findContratoActivo(Long trabajadorId) {
        List<Contrato> contratos =
                contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(trabajadorId, "1");
        return contratos.isEmpty() ? null : contratos.get(0);
    }

    /**
     * Calcula el impuesto anual aplicando la escala progresiva acumulativa
     * de quinta categoría sobre la renta neta, usando tramos expresados en UIT:
     * <ul>
     *   <li>Hasta 5 UIT: 8%</li>
     *   <li>De 5 a 20 UIT: 14%</li>
     *   <li>De 20 a 35 UIT: 17%</li>
     *   <li>De 35 a 45 UIT: 20%</li>
     *   <li>Más de 45 UIT: 30%</li>
     * </ul>
     *
     * @param rentaNeta renta neta imponible (mayor a cero)
     * @return impuesto anual proyectado
     */
    private BigDecimal calcularImpuestoProgresivo(BigDecimal rentaNeta) {
        BigDecimal[] limitesUit = {
                BigDecimal.valueOf(5),
                BigDecimal.valueOf(20),
                BigDecimal.valueOf(35),
                BigDecimal.valueOf(45)
        };
        BigDecimal[] tasas = {
                BigDecimal.valueOf(0.08),
                BigDecimal.valueOf(0.14),
                BigDecimal.valueOf(0.17),
                BigDecimal.valueOf(0.20),
                BigDecimal.valueOf(0.30)
        };

        BigDecimal impuesto = BigDecimal.ZERO;
        BigDecimal limiteInferior = BigDecimal.ZERO;

        for (int i = 0; i < limitesUit.length; i++) {
            BigDecimal limiteSuperior = limitesUit[i].multiply(UIT);
            if (rentaNeta.compareTo(limiteSuperior) > 0) {
                BigDecimal baseTramo = limiteSuperior.subtract(limiteInferior);
                impuesto = impuesto.add(baseTramo.multiply(tasas[i]));
                limiteInferior = limiteSuperior;
            } else {
                BigDecimal baseTramo = rentaNeta.subtract(limiteInferior);
                impuesto = impuesto.add(baseTramo.multiply(tasas[i]));
                return scale(impuesto);
            }
        }

        // Excedente sobre 45 UIT tributa con la última tasa (30%).
        BigDecimal baseTramo = rentaNeta.subtract(limiteInferior);
        impuesto = impuesto.add(baseTramo.multiply(tasas[tasas.length - 1]));
        return scale(impuesto);
    }

    /** Normaliza un monto a 4 decimales con redondeo HALF_UP. */
    private BigDecimal scale(BigDecimal value) {
        return value.setScale(ESCALA, RoundingMode.HALF_UP);
    }
}
