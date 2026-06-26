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
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.constants.RegimenPensionarioConstants;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioCreateRequest;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioUpdateRequest;
import pe.restaurant.rrhh.dto.response.RegimenPensionarioResponse;
import pe.restaurant.rrhh.entity.RegimenPensionario;
import pe.restaurant.rrhh.mapper.RegimenPensionarioMapper;
import pe.restaurant.rrhh.repository.RegimenPensionarioRepository;
import pe.restaurant.rrhh.specification.RegimenPensionarioSpecification;
import pe.restaurant.rrhh.service.RegimenPensionarioService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RegimenPensionarioServiceImpl implements RegimenPensionarioService {
    private final RegimenPensionarioRepository repository;
    private final RegimenPensionarioMapper mapper;

    @Override @Timed("rrhh.regimen_pensionario.listar")
    public Page<RegimenPensionarioResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(RegimenPensionarioSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public RegimenPensionarioResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.regimen_pensionario.crear")
    public RegimenPensionarioResponse crear(RegimenPensionarioCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(RegimenPensionarioConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, RegimenPensionarioConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.regimen_pensionario.actualizar")
    public RegimenPensionarioResponse actualizar(Long id, RegimenPensionarioUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public RegimenPensionarioResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public RegimenPensionarioResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<RegimenPensionarioResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private RegimenPensionario buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                RegimenPensionarioConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, RegimenPensionarioConstants.ERROR_NO_ENCONTRADO));
    }
}
