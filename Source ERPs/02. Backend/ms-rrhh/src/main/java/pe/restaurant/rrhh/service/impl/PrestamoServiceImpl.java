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
import pe.restaurant.rrhh.constants.PrestamoConstants;
import pe.restaurant.rrhh.dto.request.PrestamoCreateRequest;
import pe.restaurant.rrhh.dto.request.PrestamoUpdateRequest;
import pe.restaurant.rrhh.dto.response.PrestamoResponse;
import pe.restaurant.rrhh.entity.Prestamo;
import pe.restaurant.rrhh.mapper.PrestamoMapper;
import pe.restaurant.rrhh.repository.PrestamoRepository;
import pe.restaurant.rrhh.service.PrestamoService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PrestamoServiceImpl implements PrestamoService {

    private final PrestamoRepository repository;
    private final PrestamoMapper mapper;

    @Override @Timed("rrhh.prestamo.listar")
    public Page<PrestamoResponse> listar(Long trabajadorId, String flagEstado, Pageable pageable) {
        return repository.findAll(especificacion(trabajadorId, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.prestamo.obtener")
    public PrestamoResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.prestamo.crear")
    public PrestamoResponse crear(PrestamoCreateRequest request) {
        if (request.getCuotas() <= 0 || request.getMontoTotal().compareTo(BigDecimal.ZERO) <= 0)
            throw new BusinessException(PrestamoConstants.MSG_MONTO_CUOTAS_INVALIDO, HttpStatus.BAD_REQUEST, PrestamoConstants.ERROR_MONTO_CUOTAS_INVALIDO);
        var entity = mapper.toEntity(request);
        entity.setCuotaMensual(request.getMontoTotal().divide(BigDecimal.valueOf(request.getCuotas()), 4, RoundingMode.HALF_UP));
        entity.setSaldo(request.getMontoTotal());
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.prestamo.actualizar")
    public PrestamoResponse actualizar(Long id, PrestamoUpdateRequest request) {
        var existing = buscarOrThrow(id);
        if (!"1".equals(existing.getFlagEstado()))
            throw new BusinessException("No se puede modificar un préstamo cancelado.", HttpStatus.BAD_REQUEST, PrestamoConstants.ERROR_MODIFICACION_CON_CUOTAS);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.prestamo.cambiarEstado")
    public PrestamoResponse cambiarEstado(Long id) {
        var entity = buscarOrThrow(id);
        if ("1".equals(entity.getFlagEstado())) {
            entity.setFlagEstado("0");
        } else {
            entity.setFlagEstado("1");
        }
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private Prestamo buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Préstamo no encontrado: {}", id);
            return new BusinessException(PrestamoConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, PrestamoConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private Specification<Prestamo> especificacion(Long trabajadorId, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            if (flagEstado != null && !flagEstado.isEmpty()) predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
