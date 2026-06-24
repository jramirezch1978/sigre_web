package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
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
import com.sigre.rrhh.entity.TipoPlanilla;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.ContratoRepository;
import com.sigre.rrhh.repository.QuintaCategoriaRepository;
import com.sigre.rrhh.repository.TipoPlanillaRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.QuintaCategoriaService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

/**
 * Servicio de quinta categoría con esquema SIGRE (fec_proceso + montos rem_*).
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class QuintaCategoriaServiceImpl implements QuintaCategoriaService {

    private static final BigDecimal UIT = BigDecimal.valueOf(5350);
    private static final BigDecimal DEDUCCION_7UIT = UIT.multiply(BigDecimal.valueOf(7));
    private static final BigDecimal REMUNERACIONES_ANUALES = BigDecimal.valueOf(14);
    private static final String TIPO_PLANILLA_NORMAL = "N";
    private static final int ESCALA = 2;

    private final QuintaCategoriaRepository quintaCategoriaRepo;
    private final TrabajadorRepository trabajadorRepo;
    private final ContratoRepository contratoRepo;
    private final TipoPlanillaRepository tipoPlanillaRepo;

    @Override
    @Timed("rrhh.quintaCategoria.procesar")
    public List<QuintaCategoria> procesar(Integer anio, Integer mes) {
        log.info("Iniciando proceso de quinta categoría: anio={}, mes={}", anio, mes);
        validarPeriodo(anio, mes);

        TipoPlanilla tipoPlanilla = tipoPlanillaRepo.findByCodigo(TIPO_PLANILLA_NORMAL)
                .orElseThrow(() -> new BusinessException(
                        "No existe tipo de planilla normal (N).",
                        HttpStatus.BAD_REQUEST, "RH-QC-005"));

        LocalDate fecProceso = YearMonth.of(anio, mes).atEndOfMonth();
        LocalDate inicioMes = fecProceso.withDayOfMonth(1);

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

        quintaCategoriaRepo.deleteByFecProcesoBetween(inicioMes, fecProceso);

        List<QuintaCategoria> resultados = new ArrayList<>();

        for (Trabajador trabajador : activos) {
            Contrato contrato = findContratoActivo(trabajador.getId());
            if (contrato == null) {
                continue;
            }

            BigDecimal sueldo = contrato.getRemuneracion() != null
                    ? contrato.getRemuneracion()
                    : BigDecimal.ZERO;

            BigDecimal remProyectable = scale(sueldo.multiply(REMUNERACIONES_ANUALES));
            BigDecimal rentaNeta = scale(remProyectable.subtract(DEDUCCION_7UIT));
            BigDecimal remRetencion;

            if (rentaNeta.compareTo(BigDecimal.ZERO) <= 0) {
                remRetencion = BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP);
            } else {
                BigDecimal impuestoAnual = calcularImpuestoProgresivo(rentaNeta);
                remRetencion = scale(impuestoAnual.divide(BigDecimal.valueOf(12), ESCALA, RoundingMode.HALF_UP));
            }

            QuintaCategoria registro = QuintaCategoria.builder()
                    .trabajadorId(trabajador.getId())
                    .fecProceso(fecProceso)
                    .remProyectable(remProyectable)
                    .remImprecisa(BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP))
                    .remRetencion(remRetencion)
                    .remGratif(BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP))
                    .flagReplicacion("1")
                    .nroDias((short) fecProceso.getDayOfMonth())
                    .sueldo(scale(sueldo))
                    .flagAutomatico("1")
                    .gratifProyect(BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP))
                    .remExterna(BigDecimal.ZERO.setScale(ESCALA, RoundingMode.HALF_UP))
                    .tipoPlanillaId(tipoPlanilla.getId())
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

    @Override
    @Transactional(readOnly = true)
    public Page<QuintaCategoria> listar(Long trabajadorId, Integer anio, Integer mes, Pageable pageable) {
        return quintaCategoriaRepo.findWithFilters(trabajadorId, anio, mes, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public QuintaCategoria obtenerPorId(Long id) {
        return quintaCategoriaRepo.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Registro de quinta categoría no encontrado.",
                        HttpStatus.NOT_FOUND, "RH-QC-004"));
    }

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

    private Contrato findContratoActivo(Long trabajadorId) {
        List<Contrato> contratos =
                contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(trabajadorId, "1");
        return contratos.isEmpty() ? null : contratos.get(0);
    }

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

        BigDecimal baseTramo = rentaNeta.subtract(limiteInferior);
        impuesto = impuesto.add(baseTramo.multiply(tasas[tasas.length - 1]));
        return scale(impuesto);
    }

    private BigDecimal scale(BigDecimal value) {
        return value.setScale(ESCALA, RoundingMode.HALF_UP);
    }
}
