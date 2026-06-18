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
import pe.restaurant.contabilidad.dto.request.CntblTipoDetraccionRequest;
import pe.restaurant.contabilidad.entity.CntblTipoDetraccion;
import pe.restaurant.contabilidad.mapper.CntblTipoDetraccionMapper;
import pe.restaurant.contabilidad.repository.CntblTipoDetraccionRepository;
import pe.restaurant.contabilidad.repository.PlanContableDetRepository;
import pe.restaurant.contabilidad.service.CntblTipoDetraccionService;
import pe.restaurant.contabilidad.service.ContabilidadErrorCodes;

import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CntblTipoDetraccionServiceImpl implements CntblTipoDetraccionService {

    private final CntblTipoDetraccionRepository repository;
    private final PlanContableDetRepository planContableDetRepository;
    private final CntblTipoDetraccionMapper mapper;

    @Override
    public Page<CntblTipoDetraccion> findAll(String q, String flagEstado, Pageable pageable) {
        Specification<CntblTipoDetraccion> spec = Specification.allOf();
        if (StringUtils.hasText(q)) {
            String pattern = "%" + q.trim().toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("codigo")), pattern),
                    cb.like(cb.lower(root.get("descripcion")), pattern)
            ));
        }
        if (StringUtils.hasText(flagEstado)) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado.trim()));
        }
        return repository.findAll(spec, pageable);
    }

    @Override
    public CntblTipoDetraccion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CntblTipoDetraccion", id));
    }

    @Override
    @Transactional
    public CntblTipoDetraccion create(CntblTipoDetraccionRequest request) {
        validateCodigoUnico(request.getCodigo(), null);
        validatePlanContableDet(request.getPlanContableDetId());
        CntblTipoDetraccion entity = mapper.toEntity(request);
        entity.setFlagEstado(resolveFlagEstado(request.getFlagEstado()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public CntblTipoDetraccion update(Long id, CntblTipoDetraccionRequest request) {
        CntblTipoDetraccion existing = findById(id);
        validateCodigoUnico(request.getCodigo(), id);
        validatePlanContableDet(request.getPlanContableDetId());
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
        CntblTipoDetraccion existing = findById(id);
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
                    "Ya existe un tipo de detracción con el código " + codigo.trim(),
                    HttpStatus.CONFLICT,
                    ContabilidadErrorCodes.TIPO_DETRACCION_DUPLICADO
            );
        }
    }

    private void validatePlanContableDet(Long planContableDetId) {
        if (planContableDetId == null) {
            return;
        }
        planContableDetRepository.findById(planContableDetId)
                .orElseThrow(() -> new BusinessException(
                        "Cuenta contable no encontrada",
                        HttpStatus.NOT_FOUND,
                        ContabilidadErrorCodes.PLAN_CONTABLE_NO_ENCONTRADO
                ));
    }

    private String resolveFlagEstado(String flagEstado) {
        return StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1";
    }
}
