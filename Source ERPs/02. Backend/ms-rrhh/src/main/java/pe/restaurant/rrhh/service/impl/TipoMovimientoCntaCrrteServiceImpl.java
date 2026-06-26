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

import java.time.Instant;
import pe.restaurant.rrhh.constants.TipoMovimientoCntaCrrteConstants;
import pe.restaurant.rrhh.dto.request.TipoMovimientoCntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoMovimientoCntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoMovimientoCntaCrrteResponse;
import pe.restaurant.rrhh.entity.TipoMovimientoCntaCrrte;
import pe.restaurant.rrhh.mapper.TipoMovimientoCntaCrrteMapper;
import pe.restaurant.rrhh.repository.TipoMovimientoCntaCrrteRepository;
import pe.restaurant.rrhh.specification.TipoMovimientoCntaCrrteSpecification;
import pe.restaurant.rrhh.service.TipoMovimientoCntaCrrteService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoMovimientoCntaCrrteServiceImpl implements TipoMovimientoCntaCrrteService {

    private final TipoMovimientoCntaCrrteRepository repository;
    private final TipoMovimientoCntaCrrteMapper mapper;

    @Override @Timed("rrhh.tipo_movimiento_cnta_crrte.listar")
    public Page<TipoMovimientoCntaCrrteResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoMovimientoCntaCrrteSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.tipo_movimiento_cnta_crrte.obtener")
    public TipoMovimientoCntaCrrteResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_movimiento_cnta_crrte.crear")
    public TipoMovimientoCntaCrrteResponse crear(TipoMovimientoCntaCrrteCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_movimiento_cnta_crrte.actualizar")
    public TipoMovimientoCntaCrrteResponse actualizar(Long id, TipoMovimientoCntaCrrteUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.tipo_movimiento_cnta_crrte.desactivar")
    public TipoMovimientoCntaCrrteResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoMovimientoCntaCrrteResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override @Transactional @Timed("rrhh.tipoMovimientoCntaCrrte.activar")
    public TipoMovimientoCntaCrrteResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private TipoMovimientoCntaCrrte buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("TipoMovimientoCntaCrrte no encontrado: {}", id);
            return new BusinessException(TipoMovimientoCntaCrrteConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoMovimientoCntaCrrteConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(TipoMovimientoCntaCrrteConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoMovimientoCntaCrrteConstants.ERROR_CODIGO_DUPLICADO);
        }
    }
}
