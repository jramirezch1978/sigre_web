package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
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
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.constants.GratificacionConstants;
import pe.restaurant.rrhh.dto.request.GratificacionProcesarRequest;
import pe.restaurant.rrhh.dto.response.GratificacionResponse;
import pe.restaurant.rrhh.entity.Gratificacion;
import pe.restaurant.rrhh.mapper.GratificacionMapper;
import pe.restaurant.rrhh.repository.GratificacionRepository;
import pe.restaurant.rrhh.repository.PeriodoGratificacionRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;
import pe.restaurant.rrhh.service.GratificacionService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GratificacionServiceImpl implements GratificacionService {

    private static final BigDecimal BONIFICACION_PORCENTAJE = new BigDecimal("0.09");
    private static final int MESES_PERIODO = 6;

    private final GratificacionRepository repository;
    private final GratificacionMapper mapper;
    private final PeriodoGratificacionRepository periodoRepository;
    private final TrabajadorRepository trabajadorRepository;

    @Override
    @Transactional
    @Timed("rrhh.gratificacion.procesar")
    public List<GratificacionResponse> procesar(GratificacionProcesarRequest request) {
        log.info("Procesando gratificaciones - anio: {}, periodo: {}", request.getAnio(), request.getPeriodoGratificacionId());
        var periodo = periodoRepository.findById(request.getPeriodoGratificacionId())
                .orElseThrow(() -> new BusinessException("Período de gratificación no encontrado.",
                        HttpStatus.NOT_FOUND, "RH-GR-002"));

        List<Long> trabajadoresIds = trabajadorRepository.findActivosIds();
        if (trabajadoresIds.isEmpty()) {
            throw new BusinessException("No hay trabajadores activos para procesar gratificaciones.",
                    HttpStatus.BAD_REQUEST, "RH-GR-003");
        }

        Long usuarioId = TenantContext.getUsuarioId();
        List<GratificacionResponse> resultados = new ArrayList<>();

        for (Long trabajadorId : trabajadoresIds) {
            BigDecimal remuneracion = repository.findRemuneracionByTrabajadorId(trabajadorId);
            if (remuneracion == null || remuneracion.compareTo(BigDecimal.ZERO) <= 0) continue;
            
            int meses = calcularMesesLaborados(request.getAnio(), request.getPeriodoGratificacionId());
            BigDecimal montoGratif = remuneracion.multiply(BigDecimal.valueOf(meses))
                    .divide(BigDecimal.valueOf(MESES_PERIODO), 4, RoundingMode.HALF_UP);
            BigDecimal bonif = montoGratif.multiply(BONIFICACION_PORCENTAJE).setScale(4, RoundingMode.HALF_UP);
            BigDecimal total = montoGratif.add(bonif);
            
            // Buscar registro existente o crear nuevo
            Gratificacion gratificacion = repository.findByTrabajadorIdAndAnioAndPeriodoGratificacionId(
                    trabajadorId, request.getAnio(), request.getPeriodoGratificacionId())
                    .orElse(new Gratificacion());
            
            gratificacion.setTrabajadorId(trabajadorId);
            gratificacion.setAnio(request.getAnio());
            gratificacion.setPeriodoGratificacionId(request.getPeriodoGratificacionId());
            gratificacion.setRemuneracionComputable(remuneracion);
            gratificacion.setMesesLaborados(meses);
            gratificacion.setMontoGratificacion(montoGratif);
            gratificacion.setBonificacionExtraordinaria(bonif);
            gratificacion.setTotal(total);
            
            // Asignar fechas de auditoría manualmente
            if (gratificacion.getId() == null) {
                gratificacion.setCreatedBy(usuarioId);
                gratificacion.setFecCreacion(java.time.Instant.now());
            } else {
                gratificacion.setUpdatedBy(usuarioId);
                gratificacion.setFecModificacion(java.time.Instant.now());
            }
            
            repository.save(gratificacion);
        }

        var spec = especificacion(null, request.getAnio(), request.getPeriodoGratificacionId());
        return mapper.toResponseList(repository.findAll(spec));
    }

    @Override
    @Timed("rrhh.gratificacion.listar")
    public Page<GratificacionResponse> listar(Long trabajadorId, Integer anio, Long periodoGratificacionId, Pageable pageable) {
        return repository.findAll(especificacion(trabajadorId, anio, periodoGratificacionId), pageable).map(mapper::toResponse);
    }

    @Override
    @Timed("rrhh.gratificacion.obtener")
    public GratificacionResponse obtenerPorId(Long id) {
        return mapper.toResponse(repository.findById(id)
                .orElseThrow(() -> new BusinessException("Gratificación no encontrada.",
                        HttpStatus.NOT_FOUND, "RH-GR-004")));
    }

    private int calcularMesesLaborados(Integer anio, Long periodoGratificacionId) {
        return 6;
    }

    private Specification<Gratificacion> especificacion(Long trabajadorId, Integer anio, Long periodoGratificacionId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            if (anio != null) predicates.add(cb.equal(root.get("anio"), anio));
            if (periodoGratificacionId != null) predicates.add(cb.equal(root.get("periodoGratificacionId"), periodoGratificacionId));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
