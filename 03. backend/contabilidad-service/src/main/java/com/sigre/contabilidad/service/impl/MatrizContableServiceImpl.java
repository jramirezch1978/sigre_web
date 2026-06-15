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
import com.sigre.contabilidad.dto.request.MatrizContableDetRequest;
import com.sigre.contabilidad.dto.request.MatrizContableRequest;
import com.sigre.contabilidad.entity.MatrizContable;
import com.sigre.contabilidad.entity.MatrizContableDet;
import com.sigre.contabilidad.mapper.MatrizContableMapper;
import com.sigre.contabilidad.repository.GrupoMatrizCntblRepository;
import com.sigre.contabilidad.repository.MatrizContableDetRepository;
import com.sigre.contabilidad.repository.MatrizContableRepository;
import com.sigre.contabilidad.repository.PlanContableDetRepository;
import com.sigre.contabilidad.service.MatrizContableService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MatrizContableServiceImpl implements MatrizContableService {

    private final MatrizContableRepository matrizRepository;
    private final MatrizContableDetRepository detalleRepository;
    private final GrupoMatrizCntblRepository grupoRepository;
    private final PlanContableDetRepository planContableDetRepository;
    private final MatrizContableMapper mapper;

    @Override
    public Page<MatrizContable> findAll(String q, Long grupoMatrizCntblId, String flagEstado, Pageable pageable) {
        Specification<MatrizContable> spec = Specification.allOf();
        if (StringUtils.hasText(q)) {
            String pattern = "%" + q.trim().toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("codigo")), pattern),
                    cb.like(cb.lower(root.get("descripcion")), pattern)
            ));
        }
        if (grupoMatrizCntblId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("grupoMatrizCntblId"), grupoMatrizCntblId));
        }
        if (StringUtils.hasText(flagEstado)) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado.trim()));
        }
        return matrizRepository.findAll(spec, pageable);
    }

    @Override
    public MatrizContable findById(Long id) {
        return matrizRepository.findByIdWithDetallesAll(id)
                .orElseThrow(() -> new ResourceNotFoundException("MatrizContable", id));
    }

    @Override
    @Transactional
    public MatrizContable create(MatrizContableRequest request) {
        validateGrupo(request.getGrupoMatrizCntblId());
        validateCodigoUnico(request.getCodigo(), null);
        MatrizContable entity = mapper.toEntity(request);
        entity.setFlagEstado(resolveFlagEstado(request.getFlagEstado()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return matrizRepository.save(entity);
    }

    @Override
    @Transactional
    public MatrizContable update(Long id, MatrizContableRequest request) {
        MatrizContable existing = findById(id);
        validateGrupo(request.getGrupoMatrizCntblId());
        validateCodigoUnico(request.getCodigo(), id);
        mapper.updateEntity(request, existing);
        if (StringUtils.hasText(request.getFlagEstado())) {
            existing.setFlagEstado(request.getFlagEstado().trim());
        } else if (existing.getFlagEstado() == null) {
            existing.setFlagEstado("1");
        }
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return matrizRepository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        MatrizContable existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        matrizRepository.save(existing);
    }

    @Override
    public List<MatrizContableDet> findDetalles(Long matrizId) {
        assertMatrizExists(matrizId);
        return detalleRepository.findByMatrizContableIdOrderBySecuenciaAsc(matrizId);
    }

    @Override
    @Transactional
    public MatrizContableDet createDetalle(Long matrizId, MatrizContableDetRequest request) {
        MatrizContable matriz = findById(matrizId);
        validatePlanContableDet(request.getPlanContableDetId());
        Integer secuencia = resolveSecuencia(matrizId, request.getSecuencia());
        validateSecuenciaUnica(matrizId, secuencia, null);

        MatrizContableDet detalle = mapper.toDetalleEntity(request);
        detalle.setMatrizContable(matriz);
        detalle.setSecuencia(secuencia);
        detalle.setCreatedBy(TenantContext.getUsuarioId());
        detalle.setFecCreacion(Instant.now());
        return detalleRepository.save(detalle);
    }

    @Override
    @Transactional
    public MatrizContableDet updateDetalle(Long matrizId, Long detalleId, MatrizContableDetRequest request) {
        MatrizContableDet detalle = findDetalle(matrizId, detalleId);
        validatePlanContableDet(request.getPlanContableDetId());
        Integer secuencia = request.getSecuencia() != null ? request.getSecuencia() : detalle.getSecuencia();
        validateSecuenciaUnica(matrizId, secuencia, detalleId);
        mapper.updateDetalleEntity(request, detalle);
        detalle.setSecuencia(secuencia);
        detalle.setUpdatedBy(TenantContext.getUsuarioId());
        detalle.setFecModificacion(Instant.now());
        return detalleRepository.save(detalle);
    }

    @Override
    @Transactional
    public void deleteDetalle(Long matrizId, Long detalleId) {
        MatrizContableDet detalle = findDetalle(matrizId, detalleId);
        detalleRepository.delete(detalle);
    }

    private MatrizContableDet findDetalle(Long matrizId, Long detalleId) {
        return detalleRepository.findByIdAndMatrizContableId(detalleId, matrizId)
                .orElseThrow(() -> new ResourceNotFoundException("MatrizContableDet", detalleId));
    }

    private void assertMatrizExists(Long matrizId) {
        if (!matrizRepository.existsById(matrizId)) {
            throw new ResourceNotFoundException("MatrizContable", matrizId);
        }
    }

    private void validateGrupo(Long grupoMatrizCntblId) {
        if (!grupoRepository.existsById(grupoMatrizCntblId)) {
            throw new ResourceNotFoundException("GrupoMatrizCntbl", grupoMatrizCntblId);
        }
    }

    private void validatePlanContableDet(Long planContableDetId) {
        if (planContableDetId != null && !planContableDetRepository.existsById(planContableDetId)) {
            throw new ResourceNotFoundException("PlanContableDet", planContableDetId);
        }
    }

    private void validateCodigoUnico(String codigo, Long id) {
        if (!StringUtils.hasText(codigo)) {
            return;
        }
        boolean duplicado = id == null
                ? matrizRepository.existsByCodigo(codigo.trim())
                : matrizRepository.existsByCodigoAndIdNot(codigo.trim(), id);
        if (duplicado) {
            throw new BusinessException(
                    "Ya existe una matriz contable con el código " + codigo.trim(),
                    HttpStatus.CONFLICT,
                    "BUSINESS_ERROR"
            );
        }
    }

    private void validateSecuenciaUnica(Long matrizId, Integer secuencia, Long detalleId) {
        detalleRepository.findByMatrizContableIdAndSecuencia(matrizId, secuencia)
                .filter(existing -> detalleId == null || !existing.getId().equals(detalleId))
                .ifPresent(existing -> {
                    throw new BusinessException(
                            "Ya existe una línea con secuencia " + secuencia + " en la matriz",
                            HttpStatus.CONFLICT,
                            "BUSINESS_ERROR"
                    );
                });
    }

    private Integer resolveSecuencia(Long matrizId, Integer secuencia) {
        if (secuencia != null) {
            return secuencia;
        }
        return detalleRepository.findTopByMatrizContableIdOrderBySecuenciaDesc(matrizId)
                .map(det -> det.getSecuencia() + 1)
                .orElse(1);
    }

    private String resolveFlagEstado(String flagEstado) {
        return StringUtils.hasText(flagEstado) ? flagEstado.trim() : "1";
    }
}
