package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoMovAsistenciaResponse;
import pe.restaurant.rrhh.entity.TipoMovAsistencia;
import pe.restaurant.rrhh.mapper.TipoMovAsistenciaMapper;
import pe.restaurant.rrhh.repository.TipoMovAsistenciaRepository;
import pe.restaurant.rrhh.specification.TipoMovAsistenciaSpecification;
import java.time.Instant;
import pe.restaurant.rrhh.service.TipoMovAsistenciaService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoMovAsistenciaServiceImpl implements TipoMovAsistenciaService {

    private final TipoMovAsistenciaRepository repository;
    private final TipoMovAsistenciaMapper mapper;

    @Override @Timed("rrhh.tipo_mov_asistencia.listar")
    public Page<TipoMovAsistenciaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoMovAsistenciaSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.tipo_mov_asistencia.obtener")
    public TipoMovAsistenciaResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_mov_asistencia.crear")
    public TipoMovAsistenciaResponse crear(TipoMovAsistenciaCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_mov_asistencia.actualizar")
    public TipoMovAsistenciaResponse actualizar(Long id, TipoMovAsistenciaUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.tipo_mov_asistencia.desactivar")
    public TipoMovAsistenciaResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoMovAsistenciaResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional
    @Timed("rrhh.tipoMovAsistencia.activar")
    public TipoMovAsistenciaResponse activar(Long id) {
        TipoMovAsistencia tipoMovAsistencia = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("TipoMovAsistencia", id));
        tipoMovAsistencia.setFlagEstado("1");
        tipoMovAsistencia.setUpdatedBy(TenantContext.getUsuarioId());
        tipoMovAsistencia.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(tipoMovAsistencia));
    }

    private TipoMovAsistencia buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("TipoMovAsistencia no encontrado: {}", id);
            return new ResourceNotFoundException("TipoMovAsistencia", id);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException("Ya existe un tipo de movimiento con ese código.", HttpStatus.CONFLICT, "RH-TM-001");
        }
    }
}
