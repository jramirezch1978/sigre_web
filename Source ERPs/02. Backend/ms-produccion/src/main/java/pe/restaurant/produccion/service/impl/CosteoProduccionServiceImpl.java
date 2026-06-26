package pe.restaurant.produccion.service.impl;

import feign.FeignException;
import io.micrometer.core.annotation.Timed;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.produccion.client.CoreSucursalClient;
import pe.restaurant.produccion.dto.response.CosteoProduccionResponse;
import pe.restaurant.produccion.dto.response.ProcesarCosteoResponse;
import pe.restaurant.produccion.entity.CosteoProduccion;
import pe.restaurant.produccion.event.publisher.ProduccionEventPublisher;
import pe.restaurant.produccion.repository.CosteoProduccionRepository;
import pe.restaurant.produccion.service.CosteoProduccionService;
import pe.restaurant.produccion.service.ProduccionErrorCodes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CosteoProduccionServiceImpl implements CosteoProduccionService {

    private final CosteoProduccionRepository repository;
    private final CoreSucursalClient coreSucursalClient;
    private final pe.restaurant.produccion.mapper.CosteoProduccionMapper mapper;
    private final ProduccionEventPublisher eventPublisher;
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "costeo_produccion", "operation", "findAll"})
    public Page<CosteoProduccion> findAll(Long ordenTrabajoId, Integer anio, Integer mes, Pageable pageable) {
        Specification<CosteoProduccion> spec = buildSpecification(ordenTrabajoId, anio, mes);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "costeo_produccion", "operation", "findById"})
    public CosteoProduccion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CosteoProduccion", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "costeo_produccion", "operation", "procesar"})
    public ProcesarCosteoResponse procesar(Integer anio, Integer mes, Long sucursalId, Long almacenId) {
        validarPeriodo(anio, mes);

        if (sucursalId != null) {
            validarSucursal(sucursalId);
        }

        LocalDate fechaInicio = LocalDate.of(anio, mes, 1);
        LocalDate fechaFin = fechaInicio.plusMonths(1);

        List<Object[]> rows = findOtsConPartesEnPeriodo(fechaInicio, fechaFin, sucursalId, almacenId);

        if (rows.isEmpty()) {
            throw new BusinessException(
                    "No se encontraron órdenes de trabajo con actividad en el período " + anio + "-" + String.format("%02d", mes),
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.COSTEO_SIN_OTS_EN_PERIODO);
        }

        List<CosteoProduccion> procesados = new ArrayList<>();
        int totalCreadas = 0;
        int totalActualizadas = 0;

        for (Object[] row : rows) {
            Long otId = ((Number) row[0]).longValue();
            BigDecimal totalInsumos = row[1] != null ? new BigDecimal(row[1].toString()) : BigDecimal.ZERO;
            BigDecimal totalProducidos = row[2] != null ? new BigDecimal(row[2].toString()) : BigDecimal.ZERO;

            boolean existia = repository.findByOrdenTrabajoIdAndAnioAndMes(otId, anio, mes).isPresent();
            CosteoProduccion costeo = calcularYPersistir(otId, anio, mes, totalInsumos, totalProducidos);
            procesados.add(costeo);
            if (existia) {
                totalActualizadas++;
            } else {
                totalCreadas++;
            }
        }

        log.info("Costeo procesado para {}-{}: {} OTs procesadas", anio, mes, procesados.size());
        eventPublisher.publicarCosteoCompletado(anio, mes, sucursalId, almacenId,
                procesados.size(), totalCreadas, totalActualizadas);

        var detalle = mapper.toResponseList(procesados);
        BigDecimal costoMateriaPrimaTotal = detalle.stream()
                .map(c -> c.getCostoMateriaPrima() != null ? c.getCostoMateriaPrima() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal costoManoObraTotal = detalle.stream()
                .map(c -> c.getCostoManoObra() != null ? c.getCostoManoObra() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal costoIndirectoTotal = detalle.stream()
                .map(c -> c.getCostoIndirecto() != null ? c.getCostoIndirecto() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal costoGranTotal = detalle.stream()
                .map(c -> c.getCostoTotal() != null ? c.getCostoTotal() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return ProcesarCosteoResponse.builder()
                .anio(anio)
                .mes(mes)
                .totalOtsProcesadas(procesados.size())
                .totalCreadas(totalCreadas)
                .totalActualizadas(totalActualizadas)
                .costoMateriaPrimaTotal(costoMateriaPrimaTotal)
                .costoManoObraTotal(costoManoObraTotal)
                .costoIndirectoTotal(costoIndirectoTotal)
                .costoGranTotal(costoGranTotal)
                .detalle(detalle)
                .build();
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "costeo_produccion", "operation", "findByPeriodo"})
    public List<CosteoProduccion> findByPeriodo(Integer anio, Integer mes) {
        validarPeriodo(anio, mes);
        return repository.findAllByAnioAndMes(anio, mes);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "costeo_produccion", "operation", "guardar"})
    public CosteoProduccion guardar(CosteoProduccion entity) {
        if (entity.getAnio() == null || entity.getMes() == null) {
            LocalDate hoy = LocalDate.now();
            if (entity.getAnio() == null) entity.setAnio(hoy.getYear());
            if (entity.getMes() == null) entity.setMes(hoy.getMonthValue());
        }
        validarPeriodo(entity.getAnio(), entity.getMes());

        Long usuarioId = TenantContext.getUsuarioId();
        CosteoProduccion existing = repository
                .findByOrdenTrabajoIdAndAnioAndMes(entity.getOrdenTrabajoId(), entity.getAnio(), entity.getMes())
                .orElse(null);

        if (existing != null) {
            existing.setCostoMateriaPrima(entity.getCostoMateriaPrima());
            existing.setCostoManoObra(entity.getCostoManoObra());
            existing.setCostoIndirecto(entity.getCostoIndirecto());
            existing.setCostoTotal(entity.getCostoTotal());
            existing.setCostoUnitario(entity.getCostoUnitario());
            existing.setRendimientoReal(entity.getRendimientoReal());
            existing.setPorcentajeMermaReal(entity.getPorcentajeMermaReal());
            existing.setUpdatedBy(usuarioId);
            return repository.save(existing);
        }

        entity.setCreatedBy(usuarioId);
        return repository.save(entity);
    }

    // ───────────────────────── helpers ─────────────────────────

    private void validarPeriodo(Integer anio, Integer mes) {
        if (anio == null) {
            throw new BusinessException("El año es obligatorio",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.COSTEO_PERIODO_OBLIGATORIO);
        }
        if (mes == null) {
            throw new BusinessException("El mes es obligatorio",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.COSTEO_PERIODO_OBLIGATORIO);
        }
        if (anio < 2020) {
            throw new BusinessException("El año debe ser mayor o igual a 2020",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.COSTEO_PERIODO_INVALIDO);
        }
        if (mes < 1 || mes > 12) {
            throw new BusinessException("El mes debe estar entre 1 y 12",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.COSTEO_PERIODO_INVALIDO);
        }
    }

    private void validarSucursal(Long sucursalId) {
        try {
            var response = coreSucursalClient.obtenerPorId(sucursalId);
            if (!response.isSuccess() || response.getData() == null
                    || !"1".equals(response.getData().getFlagEstado())) {
                throw new BusinessException("La sucursal no existe o está inactiva",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.COSTEO_SUCURSAL_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("La sucursal no existe o está inactiva",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.COSTEO_SUCURSAL_INEXISTENTE);
        }
    }

    @SuppressWarnings("unchecked")
    private List<Object[]> findOtsConPartesEnPeriodo(LocalDate fechaInicio, LocalDate fechaFin,
                                                     Long sucursalId, Long almacenId) {
        String sql = "SELECT pp.orden_trabajo_id, " +
                "COALESCE(SUM(ppi.cantidad_consumida), 0), " +
                "COALESCE(SUM(ppp.cantidad_producida), 0) " +
                "FROM produccion.parte_produccion pp " +
                "LEFT JOIN produccion.parte_produccion_insumo ppi ON ppi.parte_produccion_id = pp.id " +
                "LEFT JOIN produccion.parte_produccion_producido ppp ON ppp.parte_produccion_id = pp.id " +
                "WHERE pp.fecha >= :fechaInicio AND pp.fecha < :fechaFin AND pp.flag_estado = '1' " +
                (sucursalId != null ? "AND pp.orden_trabajo_id IN (SELECT id FROM produccion.orden_trabajo WHERE sucursal_id = :sucursalId) " : "") +
                (almacenId != null ? "AND pp.orden_trabajo_id IN (SELECT orden_trabajo_id FROM almacen.vale_mov WHERE almacen_id = :almacenId AND orden_trabajo_id IS NOT NULL) " : "") +
                "GROUP BY pp.orden_trabajo_id " +
                "ORDER BY pp.orden_trabajo_id";

        var query = entityManager.createNativeQuery(sql)
                .setParameter("fechaInicio", fechaInicio)
                .setParameter("fechaFin", fechaFin);

        if (sucursalId != null) {
            query.setParameter("sucursalId", sucursalId);
        }
        if (almacenId != null) {
            query.setParameter("almacenId", almacenId);
        }

        return query.getResultList();
    }

    private CosteoProduccion calcularYPersistir(Long otId, Integer anio, Integer mes,
                                                BigDecimal totalInsumos, BigDecimal totalProducidos) {
        BigDecimal costoMO = obtenerCostoManoObra(otId);
        BigDecimal costoIndirecto = obtenerCostoIndirecto(otId);
        BigDecimal costoMateriaPrima = obtenerCostoMateriaPrima(otId, totalInsumos);

        BigDecimal costoTotal = BigDecimal.ZERO
                .add(costoMateriaPrima != null ? costoMateriaPrima : BigDecimal.ZERO)
                .add(costoMO != null ? costoMO : BigDecimal.ZERO)
                .add(costoIndirecto != null ? costoIndirecto : BigDecimal.ZERO);

        BigDecimal costoUnitario = BigDecimal.ZERO;
        if (totalProducidos != null && totalProducidos.compareTo(BigDecimal.ZERO) > 0) {
            costoUnitario = costoTotal.divide(totalProducidos, 4, RoundingMode.HALF_UP);
        }

        BigDecimal porcentajeMerma = BigDecimal.ZERO;
        if (totalInsumos != null && totalInsumos.compareTo(BigDecimal.ZERO) > 0
                && totalProducidos != null) {
            BigDecimal diferencia = totalInsumos.subtract(totalProducidos);
            porcentajeMerma = diferencia.multiply(BigDecimal.valueOf(100))
                    .divide(totalInsumos, 4, RoundingMode.HALF_UP);
        }

        Long usuarioId = TenantContext.getUsuarioId();

        CosteoProduccion existing = repository.findByOrdenTrabajoIdAndAnioAndMes(otId, anio, mes).orElse(null);
        if (existing != null) {
            existing.setCostoMateriaPrima(costoMateriaPrima);
            existing.setCostoManoObra(costoMO);
            existing.setCostoIndirecto(costoIndirecto);
            existing.setCostoTotal(costoTotal);
            existing.setCostoUnitario(costoUnitario);
            existing.setRendimientoReal(totalProducidos);
            existing.setPorcentajeMermaReal(porcentajeMerma);
            existing.setUpdatedBy(usuarioId);
            return repository.save(existing);
        }

        CosteoProduccion nuevo = new CosteoProduccion();
        nuevo.setOrdenTrabajoId(otId);
        nuevo.setAnio(anio);
        nuevo.setMes(mes);
        nuevo.setCostoMateriaPrima(costoMateriaPrima);
        nuevo.setCostoManoObra(costoMO);
        nuevo.setCostoIndirecto(costoIndirecto);
        nuevo.setCostoTotal(costoTotal);
        nuevo.setCostoUnitario(costoUnitario);
        nuevo.setRendimientoReal(totalProducidos);
        nuevo.setPorcentajeMermaReal(porcentajeMerma);
        nuevo.setCreatedBy(usuarioId);
        return repository.save(nuevo);
    }

    private BigDecimal obtenerCostoManoObra(Long otId) {
        Object result = entityManager.createNativeQuery(
                        "SELECT COALESCE(r.costo_mano_obra, 0) FROM produccion.orden_trabajo ot " +
                                "LEFT JOIN produccion.programacion_produccion pp ON pp.orden_trabajo_id = ot.id " +
                                "LEFT JOIN produccion.receta r ON r.id = pp.receta_id " +
                                "WHERE ot.id = :otId LIMIT 1")
                .setParameter("otId", otId)
                .getSingleResult();
        return result != null ? new BigDecimal(result.toString()) : BigDecimal.ZERO;
    }

    private BigDecimal obtenerCostoIndirecto(Long otId) {
        Object result = entityManager.createNativeQuery(
                        "SELECT COALESCE(r.costo_indirecto, 0) FROM produccion.orden_trabajo ot " +
                                "LEFT JOIN produccion.programacion_produccion pp ON pp.orden_trabajo_id = ot.id " +
                                "LEFT JOIN produccion.receta r ON r.id = pp.receta_id " +
                                "WHERE ot.id = :otId LIMIT 1")
                .setParameter("otId", otId)
                .getSingleResult();
        return result != null ? new BigDecimal(result.toString()) : BigDecimal.ZERO;
    }

    private BigDecimal obtenerCostoMateriaPrima(Long otId, BigDecimal totalInsumos) {
        return totalInsumos;
    }

    private Specification<CosteoProduccion> buildSpecification(Long ordenTrabajoId, Integer anio, Integer mes) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (ordenTrabajoId != null) {
                predicates.add(cb.equal(root.get("ordenTrabajoId"), ordenTrabajoId));
            }
            if (anio != null) {
                predicates.add(cb.equal(root.get("anio"), anio));
            }
            if (mes != null) {
                predicates.add(cb.equal(root.get("mes"), mes));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
