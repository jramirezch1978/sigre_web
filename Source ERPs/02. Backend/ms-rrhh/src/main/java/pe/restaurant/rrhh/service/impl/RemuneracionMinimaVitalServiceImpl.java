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
import pe.restaurant.rrhh.constants.RemuneracionMinimaVitalConstants;
import pe.restaurant.rrhh.dto.request.RemuneracionMinimaVitalCreateRequest;
import pe.restaurant.rrhh.dto.request.RemuneracionMinimaVitalUpdateRequest;
import pe.restaurant.rrhh.dto.response.RemuneracionMinimaVitalResponse;
import pe.restaurant.rrhh.entity.RemuneracionMinimaVital;
import pe.restaurant.rrhh.mapper.RemuneracionMinimaVitalMapper;
import pe.restaurant.rrhh.repository.RemuneracionMinimaVitalRepository;
import pe.restaurant.rrhh.repository.TipoTrabajadorRepository;
import pe.restaurant.rrhh.service.RemuneracionMinimaVitalService;
import pe.restaurant.rrhh.specification.RemuneracionMinimaVitalSpecification;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RemuneracionMinimaVitalServiceImpl implements RemuneracionMinimaVitalService {

    private final RemuneracionMinimaVitalRepository repository;
    private final TipoTrabajadorRepository tipoTrabajadorRepository;
    private final RemuneracionMinimaVitalMapper mapper;

    @Override
    @Timed("rrhh.remuneracion_minima_vital.listar")
    public Page<RemuneracionMinimaVitalResponse> listar(Long tipoTrabajadorId, String flagEstado, Pageable pageable) {
        return repository.findAll(RemuneracionMinimaVitalSpecification.filtros(tipoTrabajadorId, flagEstado), pageable)
                .map(mapper::toResponse);
    }

    @Override
    public RemuneracionMinimaVitalResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override
    @Transactional
    @Timed("rrhh.remuneracion_minima_vital.crear")
    public RemuneracionMinimaVitalResponse crear(RemuneracionMinimaVitalCreateRequest request) {
        validarTipoTrabajador(request.getTipoTrabajadorId());
        validarDuplicado(request.getTipoTrabajadorId(), request.getRmv(), request.getFechaDesde(), null);

        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.remuneracion_minima_vital.actualizar")
    public RemuneracionMinimaVitalResponse actualizar(Long id, RemuneracionMinimaVitalUpdateRequest request) {
        var existing = buscarOrThrow(id);
        validarTipoTrabajador(request.getTipoTrabajadorId());
        validarDuplicado(request.getTipoTrabajadorId(), request.getRmv(), request.getFechaDesde(), id);

        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override
    @Transactional
    public RemuneracionMinimaVitalResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public RemuneracionMinimaVitalResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<RemuneracionMinimaVitalResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByFechaDesdeDesc("1"));
    }

    private RemuneracionMinimaVital buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                RemuneracionMinimaVitalConstants.MSG_NO_ENCONTRADO,
                HttpStatus.NOT_FOUND,
                RemuneracionMinimaVitalConstants.ERROR_NO_ENCONTRADO));
    }

    private void validarTipoTrabajador(Long tipoTrabajadorId) {
        if (!tipoTrabajadorRepository.existsById(tipoTrabajadorId)) {
            throw new BusinessException(
                    RemuneracionMinimaVitalConstants.MSG_TIPO_TRABAJADOR_NO_ENCONTRADO,
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    RemuneracionMinimaVitalConstants.ERROR_TIPO_TRABAJADOR_NO_ENCONTRADO);
        }
    }

    private void validarDuplicado(Long tipoTrabajadorId, BigDecimal rmv, LocalDate fechaDesde, Long excluirId) {
        boolean duplicado = excluirId == null
                ? repository.existsByTipoTrabajadorIdAndRmvAndFechaDesde(tipoTrabajadorId, rmv, fechaDesde)
                : repository.existsByTipoTrabajadorIdAndRmvAndFechaDesdeAndIdNot(tipoTrabajadorId, rmv, fechaDesde, excluirId);
        if (duplicado) {
            throw new BusinessException(
                    RemuneracionMinimaVitalConstants.MSG_DUPLICADO,
                    HttpStatus.CONFLICT,
                    RemuneracionMinimaVitalConstants.ERROR_DUPLICADO);
        }
    }
}
