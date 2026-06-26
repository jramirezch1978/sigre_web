package pe.restaurant.contabilidad.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
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
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PlanContableDetServiceImpl implements PlanContableDetService {

    private static final Long PAIS_PERU_ID = 1L;

    /**
     * Reglas de longitud máxima del código contable ({@code cnta_ctbl}) por nivel para Perú.
     * <p>
     * Cada entrada mapea {@code nivCnta → maxLength} según la estructura del PCGE:
     * <ul>
     *   <li>Nivel 1 (elemento): 2 caracteres — ej. {@code 10}</li>
     *   <li>Nivel 2 (rubro):    3 caracteres — ej. {@code 101}</li>
     *   <li>Nivel 3 (cuenta):   5 caracteres — ej. {@code 10101}</li>
     *   <li>Nivel 4 (subcuenta): 6 caracteres — ej. {@code 101011}</li>
     *   <li>Nivel 5 (auxiliar): 8 caracteres — ej. {@code 10101101}</li>
     * </ul>
     * Cuando se soporten más países, cada uno tendrá su propio mapa con las reglas
     * que defina su plan contable local.
     */
    private static final Map<Integer, Integer> LONGITUD_POR_NIVEL_PERU = Map.of(
            1, 2,
            2, 3,
            3, 5,
            4, 6,
            5, 8
    );

    private final PlanContableDetRepository repository;
    private final PlanContableRepository planContableRepository;
    private final PlanContableDetMapper mapper;

    @Override
    public List<PlanContableDet> findAllActivos(Long planContableId, String q, String flagEstado) {
        Specification<PlanContableDet> spec = Specification.allOf(
                (root, query, cb) -> cb.equal(root.get("planContableId"), planContableId),
                (root, query, cb) -> cb.equal(root.get("flagEstado"),
                        StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1")
        );
        if (StringUtils.hasText(q)) {
            String pattern = "%" + q.trim().toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("cntaCtbl")), pattern),
                    cb.like(cb.lower(root.get("descCnta")), pattern)
            ));
        }
        return repository.findAll(spec, Sort.by("cntaCtbl"));
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
        validateLongitudCntaCtbl(request.getCntaCtbl(), request.getNivCnta(), PAIS_PERU_ID);
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
        validateLongitudCntaCtbl(request.getCntaCtbl(), request.getNivCnta(), PAIS_PERU_ID);
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
        PlanContableDet saved = repository.save(existing);
        propagateFlagsToDescendants(saved);
        return saved;
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

    /**
     * Propaga los flags de configuración de una cuenta contable padre a todas sus
     * cuentas hijas (descendientes directos e indirectos).
     * <p>
     * La relación padre-hijo se determina por el prefijo del código contable:
     * una cuenta hija es aquella cuyo {@code cnta_ctbl} empieza con el código del padre
     * y pertenece al mismo {@code planContableId}. Ej: padre {@code 10} → hijos
     * {@code 101}, {@code 10101}, {@code 10101101}, etc.
     * <p>
     * Flags propagados:
     * <ul>
     *   <li>{@code flagCencos}</li>
     *   <li>{@code flagCodRelacion}</li>
     *   <li>{@code flagDocRef}</li>
     *   <li>{@code flagPermiteMov}</li>
     *   <li>{@code flagCtabco}</li>
     *   <li>{@code flagTipoSaldo}</li>
     *   <li>{@code flagEstado}</li>
     * </ul>
     *
     * @param parent cuenta contable actualizada cuyos flags se usarán como referencia
     */
    private void propagateFlagsToDescendants(PlanContableDet parent) {
        String pattern = parent.getCntaCtbl() + "%";
        List<PlanContableDet> descendants = repository.findDescendants(
                parent.getPlanContableId(), pattern, parent.getId());

        if (descendants.isEmpty()) return;

        Long usuarioId = TenantContext.getUsuarioId();
        Instant now = Instant.now();

        for (PlanContableDet child : descendants) {
            child.setFlagCencos(parent.getFlagCencos());
            child.setFlagCodRelacion(parent.getFlagCodRelacion());
            child.setFlagDocRef(parent.getFlagDocRef());
            child.setFlagPermiteMov(parent.getFlagPermiteMov());
            child.setFlagCtabco(parent.getFlagCtabco());
            child.setFlagTipoSaldo(parent.getFlagTipoSaldo());
            child.setFlagEstado(parent.getFlagEstado());
            child.setUpdatedBy(usuarioId);
            child.setFecModificacion(now);
        }

        repository.saveAll(descendants);
    }

    /**
     * Valida que la longitud del código contable no exceda el máximo permitido
     * según el nivel de la cuenta y el país.
     * <p>
     * La restricción aplica solo si existe una regla definida para el país
     * (ej. Perú: nivel 1 → 2 caracteres, nivel 2 → 3, etc.). Países sin reglas
     * definidas no son validados, lo que hace esta funcionalidad transparente
     * para entornos multi-país.
     * <p>
     * Esta validación se ejecuta tanto en {@link #create(PlanContableDetRequest)}
     * como en {@link #update(Long, PlanContableDetRequest)}.
     *
     * @param cntaCtbl código contable a validar
     * @param nivCnta  nivel de la cuenta (1-5)
     * @param paisId   identificador del país para resolver las reglas aplicables
     * @throws BusinessException si la longitud excede el máximo del nivel (código CONT-112)
     */
    private void validateLongitudCntaCtbl(String cntaCtbl, Integer nivCnta, Long paisId) {
        if (!StringUtils.hasText(cntaCtbl) || nivCnta == null) {
            return;
        }
        Map<Integer, Integer> reglas = reglasLongitudPorPais(paisId);
        if (reglas == null) return;
        int maxLength = reglas.getOrDefault(nivCnta, -1);
        if (maxLength == -1) return;
        String trimmed = cntaCtbl.trim();
        if (trimmed.length() > maxLength) {
            throw new BusinessException(
                    "La longitud del código contable para el nivel " + nivCnta
                            + " no puede exceder " + maxLength + " caracteres",
                    HttpStatus.BAD_REQUEST,
                    ContabilidadErrorCodes.PLAN_CONTABLE_DET_LONGITUD_INVALIDA
            );
        }
    }

    /**
     * Resuelve el mapa de reglas de longitud ({@code nivCnta → maxLength})
     * aplicable para un país dado.
     * <p>
     Si el país no tiene reglas definidas retorna {@code null}, y la validación
     * se omite (comportamiento multi-país transparente).
     *
     * @param paisId identificador del país
     * @return mapa nivel → longitud máxima, o {@code null} si el país no tiene reglas
     */
    private Map<Integer, Integer> reglasLongitudPorPais(Long paisId) {
        if (PAIS_PERU_ID.equals(paisId)) {
            return LONGITUD_POR_NIVEL_PERU;
        }
        return null;
    }
}
