package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.rrhh.dto.response.CalculoDetalleResponse;
import pe.restaurant.rrhh.dto.response.CalculoResponse;
import pe.restaurant.rrhh.entity.Calculo;
import pe.restaurant.rrhh.entity.CalculoDet;
import pe.restaurant.rrhh.entity.TipoPlanilla;
import pe.restaurant.rrhh.mapper.CalculoMapper;
import pe.restaurant.rrhh.repository.CalculoDetRepository;
import pe.restaurant.rrhh.repository.CalculoRepository;
import pe.restaurant.rrhh.repository.TipoPlanillaRepository;
import pe.restaurant.rrhh.service.CalculoService;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

/**
 * Thin wrapper: delega el cálculo al stored procedure {@code rrhh.sp_calcular_planilla}
 * en PostgreSQL. La lógica de negocio vive en la BD (§6.1 PLANIFICACION_DESARROLLO_JUNIO_2026.md).
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class CalculoServiceImpl implements CalculoService {

    private final CalculoRepository calculoRepo;
    private final CalculoDetRepository calculoDetRepo;
    private final TipoPlanillaRepository tipoPlanillaRepo;
    private final CalculoMapper mapper;
    private final JdbcTemplate jdbcTemplate;

    @Override
    @Transactional(readOnly = true)
    public Page<CalculoResponse> listar(Integer anio, Integer mes, Long tipoPlanillaId, Pageable pageable) {
        return calculoRepo.findWithFilters(anio, mes, tipoPlanillaId, pageable)
                .map(c -> mapper.toResponse(c, 0));
    }

    @Override
    @Transactional(readOnly = true)
    public CalculoDetalleResponse obtenerDetalle(Long id) {
        Calculo calculo = buscarOrThrow(id);
        List<CalculoDet> detalles = calculoDetRepo.findByCalculoIdOrderByConceptoIdAscItemAsc(id);
        return mapper.toDetalleResponse(calculo, detalles);
    }

    /**
     * Invoca {@code CALL rrhh.sp_calcular_planilla(origen, fec_proceso, tipo_planilla_codigo)}.
     * El SP resuelve internamente el id de {@code rrhh.tipo_planilla} o falla si no existe.
     */
    @Override
    @Timed("rrhh.calculo.procesar")
    public CalculoDetalleResponse procesar(Integer anio, Integer mes, String tipoPlanillaCodigo, String origen) {
        LocalDate fecProceso = LocalDate.of(anio, mes, 1);
        String codigo = tipoPlanillaCodigo.trim();

        log.info("Iniciando sp_calcular_planilla: origen={}, fec_proceso={}, tipoPlanillaCodigo={}",
                origen, fecProceso, codigo);

        jdbcTemplate.update(
                "CALL rrhh.sp_calcular_planilla(?, ?, ?)",
                origen,
                Date.valueOf(fecProceso),
                codigo);

        log.info("sp_calcular_planilla finalizado: origen={}, fec_proceso={}", origen, fecProceso);

        TipoPlanilla tipoPlanilla = tipoPlanillaRepo.findByCodigo(codigo)
                .orElseThrow(() -> new ResourceNotFoundException("TipoPlanilla", "codigo", codigo));

        List<Calculo> calculos = calculoRepo.findWithFilters(anio, mes, tipoPlanilla.getId(), Pageable.unpaged())
                .getContent();

        BigDecimal totalIngresos   = calculos.stream()
                .map(c -> c.getTotalIngresosSoles()   != null ? c.getTotalIngresosSoles()   : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalDescuentos = calculos.stream()
                .map(c -> c.getTotalDescuentosSoles() != null ? c.getTotalDescuentosSoles() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalAportes    = calculos.stream()
                .map(c -> c.getTotalAportesSoles()    != null ? c.getTotalAportesSoles()    : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return CalculoDetalleResponse.builder()
                .anio(anio)
                .mes(mes)
                .tipoPlanillaId(tipoPlanilla.getId())
                .tipoPlanillaNombre(tipoPlanilla.getNombre())
                .totalIngresos(totalIngresos)
                .totalDescuentos(totalDescuentos)
                .totalNeto(totalIngresos.subtract(totalDescuentos))
                .totalAportes(totalAportes)
                .totalTrabajadores(calculos.size())
                .detalles(List.of())
                .build();
    }

    @Override
    @Timed("rrhh.calculo.eliminar")
    public void eliminar(Long id) {
        Calculo calculo = buscarOrThrow(id);
        calculoDetRepo.deleteByCalculoId(id);
        calculoRepo.delete(calculo);
    }

    private Calculo buscarOrThrow(Long id) {
        return calculoRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Calculo", id));
    }
}
