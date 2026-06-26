package pe.restaurant.contabilidad.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.contabilidad.dto.request.CentrosCostoRequest;
import pe.restaurant.contabilidad.entity.CentrosCosto;
import pe.restaurant.contabilidad.mapper.CentrosCostoMapper;
import pe.restaurant.contabilidad.repository.CentrosCostoRepository;
import pe.restaurant.contabilidad.service.CentrosCostoService;

import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CentrosCostoServiceImpl implements CentrosCostoService {

    private final CentrosCostoRepository repository;
    private final CentrosCostoMapper mapper;

    @Override
    public Page<CentrosCosto> findAll(String q, String flagEstado, Pageable pageable) {
        Specification<CentrosCosto> spec = Specification.allOf();
        if (StringUtils.hasText(q)) {
            String pattern = "%" + q.trim().toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("cencos")), pattern),
                    cb.like(cb.lower(root.get("descCencos")), pattern)
            ));
        }
        if (StringUtils.hasText(flagEstado)) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado.trim()));
        }
        return repository.findAll(spec, pageable);
    }

    @Override
    public CentrosCosto findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CentrosCosto", id));
    }

    @Override
    @Transactional
    public CentrosCosto create(CentrosCostoRequest request) {
        validateCodigoUnico(request.getCencos(), null);
        CentrosCosto entity = mapper.toEntity(request);
        entity.setFlagEstado(resolveFlagEstado(request.getFlagEstado()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public CentrosCosto update(Long id, CentrosCostoRequest request) {
        CentrosCosto existing = findById(id);
        validateCodigoUnico(request.getCencos(), id);
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
        CentrosCosto existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        repository.save(existing);
    }

    private void validateCodigoUnico(String cencos, Long id) {
        if (!StringUtils.hasText(cencos)) {
            return;
        }
        boolean duplicado = id == null
                ? repository.findByCencos(cencos.trim()).isPresent()
                : repository.existsByCencosAndIdNot(cencos.trim(), id);
        if (duplicado) {
            throw new BusinessException(
                    "Ya existe un centro de costo con el código " + cencos.trim(),
                    HttpStatus.CONFLICT,
                    "BUSINESS_ERROR"
            );
        }
    }

    private String resolveFlagEstado(String flagEstado) {
        return StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1";
    }
}
