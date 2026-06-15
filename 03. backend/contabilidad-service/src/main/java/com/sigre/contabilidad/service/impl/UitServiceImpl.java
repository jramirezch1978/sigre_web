package com.sigre.contabilidad.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.contabilidad.dto.request.UitRequest;
import com.sigre.contabilidad.entity.Uit;
import com.sigre.contabilidad.mapper.UitMapper;
import com.sigre.contabilidad.repository.UitRepository;
import com.sigre.contabilidad.service.ContabilidadErrorCodes;
import com.sigre.contabilidad.service.UitService;

import java.time.Instant;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UitServiceImpl implements UitService {

    private final UitRepository repository;
    private final UitMapper mapper;

    @Override
    public Page<Uit> findAll(Integer ano, String flagEstado, Pageable pageable) {
        Specification<Uit> spec = Specification.allOf();
        if (ano != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("ano"), ano));
        }
        if (StringUtils.hasText(flagEstado)) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado.trim()));
        }
        return repository.findAll(spec, pageable);
    }

    @Override
    public Uit findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Uit", id));
    }

    @Override
    public Uit findUltimaVigente(LocalDate fecha) {
        LocalDate referencia = fecha != null ? fecha : LocalDate.now();
        return repository
                .findFirstByFlagEstadoAndFecIniVigenLessThanEqualOrderByFecIniVigenDescAnoDesc("1", referencia)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Uit", "vigente", referencia.toString()));
    }

    @Override
    @Transactional
    public Uit create(UitRequest request) {
        validateClaveNaturalUnica(request.getAno(), request.getFecIniVigen(), null);
        Uit entity = mapper.toEntity(request);
        entity.setFlagEstado(resolveFlagEstado(request.getFlagEstado()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public Uit update(Long id, UitRequest request) {
        Uit existing = findById(id);
        validateClaveNaturalUnica(request.getAno(), request.getFecIniVigen(), id);
        mapper.updateEntity(request, existing);
        if (StringUtils.hasText(request.getFlagEstado())) {
            existing.setFlagEstado(request.getFlagEstado().trim());
        } else if (existing.getFlagEstado() == null) {
            existing.setFlagEstado("1");
        }
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Uit existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        repository.save(existing);
    }

    private void validateClaveNaturalUnica(Integer ano, java.time.LocalDate fecIniVigen, Long id) {
        if (ano == null || fecIniVigen == null) {
            return;
        }
        boolean duplicado = id == null
                ? repository.existsByAnoAndFecIniVigen(ano, fecIniVigen)
                : repository.existsByAnoAndFecIniVigenAndIdNot(ano, fecIniVigen, id);
        if (duplicado) {
            throw new BusinessException(
                    "Ya existe UIT para el año " + ano + " con vigencia " + fecIniVigen,
                    HttpStatus.CONFLICT,
                    ContabilidadErrorCodes.UIT_DUPLICADA
            );
        }
    }

    private String resolveFlagEstado(String flagEstado) {
        return StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1";
    }
}
