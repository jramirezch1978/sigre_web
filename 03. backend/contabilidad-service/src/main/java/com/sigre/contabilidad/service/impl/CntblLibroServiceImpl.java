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
import com.sigre.contabilidad.dto.request.CntblLibroRequest;
import com.sigre.contabilidad.entity.CntblLibro;
import com.sigre.contabilidad.mapper.CntblLibroMapper;
import com.sigre.contabilidad.repository.CntblLibroRepository;
import com.sigre.contabilidad.service.CntblLibroService;
import com.sigre.contabilidad.service.ContabilidadErrorCodes;

import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CntblLibroServiceImpl implements CntblLibroService {

    private final CntblLibroRepository repository;
    private final CntblLibroMapper mapper;

    @Override
    public Page<CntblLibro> findAll(String q, String flagEstado, Pageable pageable) {
        Specification<CntblLibro> spec = Specification.allOf();
        if (StringUtils.hasText(q)) {
            String pattern = "%" + q.trim().toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("codigo")), pattern),
                    cb.like(cb.lower(root.get("nombre")), pattern)
            ));
        }
        if (StringUtils.hasText(flagEstado)) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado.trim()));
        }
        return repository.findAll(spec, pageable);
    }

    @Override
    public CntblLibro findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CntblLibro", id));
    }

    @Override
    public CntblLibro findByCodigo(String codigo) {
        return repository.findByCodigo(codigo.trim())
                .orElseThrow(() -> new ResourceNotFoundException("CntblLibro", "codigo", codigo.trim()));
    }

    @Override
    @Transactional
    public CntblLibro create(CntblLibroRequest request) {
        validateCodigoUnico(request.getCodigo(), null);
        CntblLibro entity = mapper.toEntity(request);
        entity.setCodigo(request.getCodigo().trim());
        entity.setFlagEstado(resolveFlagEstado(request.getFlagEstado()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public CntblLibro update(Long id, CntblLibroRequest request) {
        CntblLibro existing = findById(id);
        validateCodigoUnico(request.getCodigo(), id);
        mapper.updateEntity(request, existing);
        existing.setCodigo(request.getCodigo().trim());
        if (StringUtils.hasText(request.getFlagEstado())) {
            existing.setFlagEstado(request.getFlagEstado().trim());
        }
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        CntblLibro existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        repository.save(existing);
    }

    private void validateCodigoUnico(String codigo, Long id) {
        if (!StringUtils.hasText(codigo)) {
            return;
        }
        boolean duplicado = id == null
                ? repository.findByCodigo(codigo.trim()).isPresent()
                : repository.existsByCodigoAndIdNot(codigo.trim(), id);
        if (duplicado) {
            throw new BusinessException(
                    "Ya existe un libro contable con el código " + codigo.trim(),
                    HttpStatus.CONFLICT,
                    ContabilidadErrorCodes.LIBRO_CONTABLE_DUPLICADO
            );
        }
    }

    private String resolveFlagEstado(String flagEstado) {
        return StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1";
    }
}
