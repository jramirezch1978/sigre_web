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
import pe.restaurant.contabilidad.dto.request.PlanContableDetRequest;
import pe.restaurant.contabilidad.entity.PlanContable;
import pe.restaurant.contabilidad.entity.PlanContableDet;
import pe.restaurant.contabilidad.mapper.PlanContableDetMapper;
import pe.restaurant.contabilidad.repository.PlanContableDetRepository;
import pe.restaurant.contabilidad.repository.PlanContableRepository;
import pe.restaurant.contabilidad.service.ContabilidadErrorCodes;
import pe.restaurant.contabilidad.service.PlanContableDetService;

import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PlanContableDetServiceImpl implements PlanContableDetService {

    private final PlanContableDetRepository repository;
    private final PlanContableRepository planContableRepository;
    private final PlanContableDetMapper mapper;

    @Override
    public Page<PlanContableDet> findAll(Long planContableId, String q, String flagEstado, Pageable pageable) {
        Specification<PlanContableDet> spec = Specification.allOf();
        if (planContableId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("planContableId"), planContableId));
        }
        if (StringUtils.hasText(q)) {
            String pattern = "%" + q.trim().toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("cntaCtbl")), pattern),
                    cb.like(cb.lower(root.get("descCnta")), pattern)
            ));
        }
        if (StringUtils.hasText(flagEstado)) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado.trim()));
        }
        return repository.findAll(spec, pageable);
    }

    @Override
    public PlanContableDet findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("PlanContableDet", id));
    }

    @Override
    @Transactional
    public PlanContableDet create(PlanContableDetRequest request) {
        Long planContableId = resolvePlanContableId(request.getPlanContableId());
        validateCuentaUnica(planContableId, request.getCntaCtbl(), null);
        PlanContableDet entity = mapper.toEntity(request);
        entity.setPlanContableId(planContableId);
        applyDefaults(entity, request);
        entity.setFlagEstado(resolveFlagEstado(request.getFlagEstado()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public PlanContableDet update(Long id, PlanContableDetRequest request) {
        PlanContableDet existing = findById(id);
        validateCuentaUnica(existing.getPlanContableId(), request.getCntaCtbl(), id);
        mapper.updateEntity(request, existing);
        applyDefaults(existing, request);
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
        PlanContableDet existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        repository.save(existing);
    }

    @Override
    @Transactional
    public PlanContableDet activate(Long id) {
        PlanContableDet existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public PlanContableDet deactivate(Long id) {
        PlanContableDet existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private Long resolvePlanContableId(Long planContableId) {
        if (planContableId != null) {
            planContableRepository.findById(planContableId)
                    .orElseThrow(() -> new ResourceNotFoundException("PlanContable", planContableId));
            return planContableId;
        }
        return planContableRepository.findFirstByFlagEstadoOrderByEffectiveFromDesc("1")
                .map(PlanContable::getId)
                .orElseThrow(() -> new BusinessException(
                        "No existe un plan contable vigente",
                        HttpStatus.NOT_FOUND,
                        ContabilidadErrorCodes.PLAN_CONTABLE_NO_ENCONTRADO
                ));
    }

    private void validateCuentaUnica(Long planContableId, String cntaCtbl, Long id) {
        if (!StringUtils.hasText(cntaCtbl)) {
            return;
        }
        String codigo = cntaCtbl.trim();
        boolean duplicado = id == null
                ? repository.existsByPlanContableIdAndCntaCtbl(planContableId, codigo)
                : repository.existsByPlanContableIdAndCntaCtblAndIdNot(planContableId, codigo, id);
        if (duplicado) {
            throw new BusinessException(
                    "Ya existe la cuenta contable " + codigo + " en el plan",
                    HttpStatus.CONFLICT,
                    ContabilidadErrorCodes.PLAN_CONTABLE_DET_DUPLICADO
            );
        }
    }

    private void applyDefaults(PlanContableDet entity, PlanContableDetRequest request) {
        if (entity.getNivCnta() == null) {
            entity.setNivCnta(1);
        }
        if (!StringUtils.hasText(entity.getFlagCencos())) {
            entity.setFlagCencos(flagOrDefault(request.getFlagCencos(), "0"));
        }
        if (!StringUtils.hasText(entity.getFlagCodRelacion())) {
            entity.setFlagCodRelacion(flagOrDefault(request.getFlagCodRelacion(), "0"));
        }
        if (!StringUtils.hasText(entity.getFlagDocRef())) {
            entity.setFlagDocRef(flagOrDefault(request.getFlagDocRef(), "0"));
        }
        if (!StringUtils.hasText(entity.getFlagPermiteMov())) {
            entity.setFlagPermiteMov(flagOrDefault(request.getFlagPermiteMov(), "0"));
        }
        if (!StringUtils.hasText(entity.getFlagCtabco())) {
            entity.setFlagCtabco(flagOrDefault(request.getFlagCtabco(), "0"));
        }
        if (!StringUtils.hasText(entity.getFlagTipoSaldo())) {
            entity.setFlagTipoSaldo(flagOrDefault(request.getFlagTipoSaldo(), "D"));
        }
    }

    private String flagOrDefault(String value, String defaultValue) {
        return StringUtils.hasText(value) ? value.trim() : defaultValue;
    }

    private String resolveFlagEstado(String flagEstado) {
        return StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1";
    }
}
