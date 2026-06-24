package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.constants.ImpuestoRentaTramoConstants;
import com.sigre.rrhh.dto.request.ImpuestoRentaTramoCreateRequest;
import com.sigre.rrhh.dto.request.ImpuestoRentaTramoUpdateRequest;
import com.sigre.rrhh.dto.response.ImpuestoRentaTramoResponse;
import com.sigre.rrhh.entity.ImpuestoRentaTramo;
import com.sigre.rrhh.mapper.ImpuestoRentaTramoMapper;
import com.sigre.rrhh.repository.ImpuestoRentaTramoRepository;
import com.sigre.rrhh.service.ImpuestoRentaTramoService;
import com.sigre.rrhh.specification.ImpuestoRentaTramoSpecification;

import java.time.Instant;
import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ImpuestoRentaTramoServiceImpl implements ImpuestoRentaTramoService {

    private final ImpuestoRentaTramoRepository repository;
    private final ImpuestoRentaTramoMapper mapper;

    @Override
    @Timed("rrhh.impuesto_renta_tramo.listar")
    public Page<ImpuestoRentaTramoResponse> listar(LocalDate fechaVigIni, Integer secuencia, String flagEstado, Pageable pageable) {
        Pageable effectivePageable = resolverPageable(pageable);
        return repository.findAll(ImpuestoRentaTramoSpecification.filtros(fechaVigIni, secuencia, flagEstado), effectivePageable)
                .map(mapper::toResponse);
    }

    @Override
    public ImpuestoRentaTramoResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override
    @Transactional
    @Timed("rrhh.impuesto_renta_tramo.crear")
    public ImpuestoRentaTramoResponse crear(ImpuestoRentaTramoCreateRequest request) {
        validarDuplicado(request.getFechaVigIni(), request.getSecuencia(), null);

        var entity = mapper.toEntity(request);
        if (entity.getFlagReplicacion() == null || entity.getFlagReplicacion().isBlank()) {
            entity.setFlagReplicacion("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.impuesto_renta_tramo.actualizar")
    public ImpuestoRentaTramoResponse actualizar(Long id, ImpuestoRentaTramoUpdateRequest request) {
        var existing = buscarOrThrow(id);
        validarDuplicado(request.getFechaVigIni(), request.getSecuencia(), id);

        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override
    @Transactional
    public ImpuestoRentaTramoResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public ImpuestoRentaTramoResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<ImpuestoRentaTramoResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByFechaVigIniDescSecuenciaAsc("1"));
    }

    private ImpuestoRentaTramo buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                ImpuestoRentaTramoConstants.MSG_NO_ENCONTRADO,
                HttpStatus.NOT_FOUND,
                ImpuestoRentaTramoConstants.ERROR_NO_ENCONTRADO));
    }

    private void validarDuplicado(LocalDate fechaVigIni, Integer secuencia, Long excluirId) {
        boolean duplicado = excluirId == null
                ? repository.existsByFechaVigIniAndSecuencia(fechaVigIni, secuencia)
                : repository.existsByFechaVigIniAndSecuenciaAndIdNot(fechaVigIni, secuencia, excluirId);
        if (duplicado) {
            throw new BusinessException(
                    ImpuestoRentaTramoConstants.MSG_DUPLICADO,
                    HttpStatus.CONFLICT,
                    ImpuestoRentaTramoConstants.ERROR_DUPLICADO);
        }
    }

    private Pageable resolverPageable(Pageable pageable) {
        if (!pageable.getSort().isSorted()) {
            return PageRequest.of(
                    pageable.getPageNumber(),
                    pageable.getPageSize(),
                    Sort.by(Sort.Order.desc("fechaVigIni"), Sort.Order.asc("secuencia")));
        }
        Sort sort = pageable.getSort();
        if (sort.stream().noneMatch(order -> "secuencia".equals(order.getProperty()))) {
            sort = sort.and(Sort.by(Sort.Order.asc("secuencia")));
        }
        return PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort);
    }
}
