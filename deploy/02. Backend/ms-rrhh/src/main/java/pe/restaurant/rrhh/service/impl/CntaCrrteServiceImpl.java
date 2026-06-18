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
import pe.restaurant.rrhh.constants.CntaCrrteConstants;
import pe.restaurant.rrhh.dto.request.CntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.CntaCrrteDetResponse;
import pe.restaurant.rrhh.dto.response.CntaCrrteResponse;
import pe.restaurant.rrhh.entity.CntaCrrte;
import pe.restaurant.rrhh.entity.CntaCrrteDet;
import pe.restaurant.rrhh.mapper.CntaCrrteMapper;
import pe.restaurant.rrhh.repository.CntaCrrteDetRepository;
import pe.restaurant.rrhh.repository.CntaCrrteRepository;
import pe.restaurant.rrhh.service.CntaCrrteService;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CntaCrrteServiceImpl implements CntaCrrteService {

    private final CntaCrrteRepository repository;
    private final CntaCrrteDetRepository detRepository;
    private final CntaCrrteMapper mapper;

    @Override @Timed("rrhh.cntaCrrte.listar")
    public Page<CntaCrrteResponse> listar(Long trabajadorId, String flagEstado, Pageable pageable) {
        return repository.findAll(especificacion(trabajadorId, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.cntaCrrte.obtener")
    public CntaCrrteResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.cntaCrrte.crear")
    public CntaCrrteResponse crear(CntaCrrteCreateRequest request) {
        if (repository.existsByTrabajadorIdAndFlagEstado(request.getTrabajadorId(), "1"))
            throw new BusinessException(CntaCrrteConstants.MSG_CUENTA_DUPLICADA, HttpStatus.CONFLICT, CntaCrrteConstants.ERROR_CUENTA_DUPLICADA);
        var entity = mapper.toEntity(request);
        entity.setSaldoActual(request.getSaldoInicial() != null ? request.getSaldoInicial() : BigDecimal.ZERO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.cntaCrrte.actualizar")
    public CntaCrrteResponse actualizar(Long id, CntaCrrteUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.cntaCrrte.cambiarEstado")
    public CntaCrrteResponse cambiarEstado(Long id) {
        var entity = buscarOrThrow(id);
        if ("1".equals(entity.getFlagEstado())) {
            if (entity.getSaldoActual().compareTo(BigDecimal.ZERO) != 0)
                throw new BusinessException(CntaCrrteConstants.MSG_CIERRE_CON_SALDO, HttpStatus.BAD_REQUEST, CntaCrrteConstants.ERROR_CIERRE_CON_SALDO);
            entity.setFlagEstado("0");
        } else {
            entity.setFlagEstado("1");
        }
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Timed("rrhh.cntaCrrte.listarMovimientos")
    public List<CntaCrrteDetResponse> listarMovimientos(Long id) {
        return mapper.toDetResponseList(detRepository.findByCntaCrrteIdOrderByFechaMovimientoDesc(id));
    }

    @Override @Timed("rrhh.cntaCrrte.obtenerMovimiento")
    public CntaCrrteDetResponse obtenerMovimiento(Long id, Long movimientoId) {
        CntaCrrteDet detalle = detRepository.findById(movimientoId)
                .orElseThrow(() -> new BusinessException("Movimiento no encontrado.", HttpStatus.NOT_FOUND, CntaCrrteConstants.ERROR_NO_ENCONTRADO));
        if (!detalle.getCntaCrrteId().equals(id)) {
            throw new BusinessException("El movimiento no pertenece a esta cuenta.", HttpStatus.BAD_REQUEST, CntaCrrteConstants.ERROR_DATOS_INCOMPLETOS);
        }
        return mapper.toDetResponse(detalle);
    }

    @Override @Transactional @Timed("rrhh.cntaCrrte.crearMovimiento")
    public CntaCrrteDetResponse crearMovimiento(Long id, CntaCrrteMovimientoRequest request) {
        var cuenta = buscarOrThrow(id);
        if (!"1".equals(cuenta.getFlagEstado()))
            throw new BusinessException(CntaCrrteConstants.MSG_MOVIMIENTO_INACTIVA, HttpStatus.BAD_REQUEST, CntaCrrteConstants.ERROR_MOVIMIENTO_INACTIVA);
        var det = mapper.toDetEntity(request);
        det.setCntaCrrteId(id);
        det.setCreatedBy(TenantContext.getUsuarioId());
        det.setFecCreacion(Instant.now());
        cuenta.setSaldoActual(cuenta.getSaldoActual().add(request.getMonto()));
        cuenta.setUpdatedBy(TenantContext.getUsuarioId());
        cuenta.setFecModificacion(Instant.now());
        repository.save(cuenta);
        return mapper.toDetResponse(detRepository.save(det));
    }

    @Override @Transactional @Timed("rrhh.cntaCrrte.actualizarMovimiento")
    public CntaCrrteDetResponse actualizarMovimiento(Long id, Long movimientoId, CntaCrrteMovimientoUpdateRequest request) {
        var cuenta = buscarOrThrow(id);
        var det = detRepository.findById(movimientoId)
                .orElseThrow(() -> new BusinessException("Movimiento no encontrado.", HttpStatus.NOT_FOUND, CntaCrrteConstants.ERROR_NO_ENCONTRADO));
        if (!det.getCntaCrrteId().equals(id))
            throw new BusinessException("El movimiento no pertenece a esta cuenta.", HttpStatus.BAD_REQUEST, CntaCrrteConstants.ERROR_DATOS_INCOMPLETOS);
        var montoAnterior = det.getMonto();
        mapper.updateDetEntity(det, request);
        det.setUpdatedBy(TenantContext.getUsuarioId());
        det.setFecModificacion(Instant.now());
        cuenta.setSaldoActual(cuenta.getSaldoActual().subtract(montoAnterior).add(request.getMonto()));
        cuenta.setUpdatedBy(TenantContext.getUsuarioId());
        cuenta.setFecModificacion(Instant.now());
        repository.save(cuenta);
        return mapper.toDetResponse(detRepository.save(det));
    }

    @Override @Transactional @Timed("rrhh.cntaCrrte.eliminarMovimiento")
    public void eliminarMovimiento(Long id, Long movimientoId) {
        var cuenta = buscarOrThrow(id);
        var det = detRepository.findById(movimientoId)
                .orElseThrow(() -> new BusinessException("Movimiento no encontrado.", HttpStatus.NOT_FOUND, CntaCrrteConstants.ERROR_NO_ENCONTRADO));
        if (!det.getCntaCrrteId().equals(id))
            throw new BusinessException("El movimiento no pertenece a esta cuenta.", HttpStatus.BAD_REQUEST, CntaCrrteConstants.ERROR_DATOS_INCOMPLETOS);
        cuenta.setSaldoActual(cuenta.getSaldoActual().subtract(det.getMonto()));
        cuenta.setUpdatedBy(TenantContext.getUsuarioId());
        cuenta.setFecModificacion(Instant.now());
        repository.save(cuenta);
        detRepository.delete(det);
    }

    private CntaCrrte buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Cuenta corriente no encontrada: {}", id);
            return new BusinessException(CntaCrrteConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, CntaCrrteConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private Specification<CntaCrrte> especificacion(Long trabajadorId, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            if (flagEstado != null && !flagEstado.isEmpty()) predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
