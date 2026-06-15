package com.sigre.produccion.service.impl;

import feign.FeignException;
import io.micrometer.core.annotation.Timed;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.produccion.client.CoreArticuloClient;
import com.sigre.produccion.client.CoreUnidadMedidaClient;
import com.sigre.produccion.dto.response.CaractDetResponse;
import com.sigre.produccion.entity.ArticuloDocTecnica;
import com.sigre.produccion.entity.ArticuloDocTecnicaCaractDet;
import com.sigre.produccion.repository.ArticuloDocTecnicaRepository;
import com.sigre.produccion.repository.CaractDetRepository;
import com.sigre.produccion.service.ArticuloDocTecnicaService;
import com.sigre.produccion.service.ProduccionErrorCodes;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloDocTecnicaServiceImpl implements ArticuloDocTecnicaService {

    private final ArticuloDocTecnicaRepository repository;
    private final CaractDetRepository caractDetRepository;
    private final CoreArticuloClient coreArticuloClient;
    private final CoreUnidadMedidaClient coreUnidadMedidaClient;
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "findAll"})
    public Page<ArticuloDocTecnica> findAll(Long docTipoId, String nombreDocumento, String flagEstado,
                                            Long articuloId, Pageable pageable) {
        Specification<ArticuloDocTecnica> spec = buildSpecification(docTipoId, nombreDocumento, flagEstado, articuloId);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "findById"})
    public ArticuloDocTecnica findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloDocTecnica", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "create"})
    public ArticuloDocTecnica create(ArticuloDocTecnica entity, List<ArticuloDocTecnicaCaractDet> caracteristicas) {
        normalizar(entity);
        validarArticulo(entity.getArticuloId());
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        ArticuloDocTecnica saved = repository.save(entity);
        guardarCaracteristicas(saved.getId(), caracteristicas);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "update"})
    public ArticuloDocTecnica update(Long id, ArticuloDocTecnica entity,
                                     List<ArticuloDocTecnicaCaractDet> caracteristicas) {
        ArticuloDocTecnica existing = findById(id);
        if ("0".equals(existing.getFlagEstado())) {
            throw new BusinessException("No se puede modificar un documento inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.DOC_TECNICA_INACTIVO);
        }
        normalizar(entity);
        validarArticulo(entity.getArticuloId());

        existing.setArticuloId(entity.getArticuloId());
        existing.setDocTipoId(entity.getDocTipoId());
        existing.setNombreDocumento(entity.getNombreDocumento());
        existing.setDocumentoExtension(entity.getDocumentoExtension());
        existing.setArchivoUrl(entity.getArchivoUrl());
        existing.setDocumentoBlob(entity.getDocumentoBlob());
        existing.setObservacion(entity.getObservacion());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        ArticuloDocTecnica saved = repository.save(existing);
        sincronizarCaracteristicas(saved.getId(), caracteristicas);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "activate"})
    public ArticuloDocTecnica activate(Long id) {
        ArticuloDocTecnica existing = findById(id);
        existing.setFlagEstado("1");
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "deactivate"})
    public ArticuloDocTecnica deactivate(Long id) {
        ArticuloDocTecnica existing = findById(id);
        existing.setFlagEstado("0");
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica", "operation", "delete"})
    public void delete(Long id) {
        ArticuloDocTecnica existing = findById(id);
        existing.setFlagEstado("0");
        repository.save(existing);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "articulo_doc_tecnica_caract_det", "operation", "findByDoc"})
    public List<ArticuloDocTecnicaCaractDet> findCaracteristicas(Long docTecnicaId) {
        return caractDetRepository.findByArticuloDocTecnicaIdOrderByIdAsc(docTecnicaId);
    }

    // ───────────────────────── helpers ─────────────────────────

    private void guardarCaracteristicas(Long docTecnicaId, List<ArticuloDocTecnicaCaractDet> caracteristicas) {
        if (caracteristicas == null) return;
        for (ArticuloDocTecnicaCaractDet det : caracteristicas) {
            det.setArticuloDocTecnicaId(docTecnicaId);
            det.setCreatedBy(TenantContext.getUsuarioId());
            if (det.getUnidadMedidaId() != null) {
                validarUnidadMedida(det.getUnidadMedidaId());
            }
            caractDetRepository.save(det);
        }
    }

    private void sincronizarCaracteristicas(Long docTecnicaId, List<ArticuloDocTecnicaCaractDet> caracteristicas) {
        caractDetRepository.deleteByArticuloDocTecnicaId(docTecnicaId);
        guardarCaracteristicas(docTecnicaId, caracteristicas);
    }

    private void normalizar(ArticuloDocTecnica entity) {
        if (entity.getNombreDocumento() != null) {
            entity.setNombreDocumento(entity.getNombreDocumento().trim());
        }
        if (entity.getDocumentoExtension() != null) {
            entity.setDocumentoExtension(entity.getDocumentoExtension().trim().toLowerCase());
        }
    }

    // ───────────────────────── enrichment ─────────────────────────

    @Override
    @SuppressWarnings("unchecked")
    public void enrichCaractDetResponses(List<CaractDetResponse> responses) {
        if (responses == null || responses.isEmpty()) return;
        Set<Long> umIds = responses.stream()
                .map(CaractDetResponse::getUnidadMedidaId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (umIds.isEmpty()) return;
        List<Object[]> rows = entityManager.createNativeQuery(
                "SELECT id, codigo FROM core.unidad_medida WHERE id IN (:ids)")
                .setParameter("ids", umIds)
                .getResultList();
        Map<Long, String> unidades = new java.util.HashMap<>();
        for (Object[] row : rows) {
            unidades.put(((Number) row[0]).longValue(), (String) row[1]);
        }
        for (CaractDetResponse r : responses) {
            if (r.getUnidadMedidaId() != null) {
                r.setUnidadMedidaCodigo(unidades.get(r.getUnidadMedidaId()));
            }
        }
    }

    private void validarArticulo(Long articuloId) {
        try {
            var response = coreArticuloClient.obtenerPorId(articuloId);
            if (!response.isSuccess() || response.getData() == null
                    || !"1".equals(response.getData().getFlagEstado())) {
                throw new BusinessException("El artículo no existe o está inactivo",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.DOC_TECNICA_ARTICULO_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("El artículo no existe o está inactivo",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.DOC_TECNICA_ARTICULO_INEXISTENTE);
        }
    }

    private void validarUnidadMedida(Long unidadMedidaId) {
        try {
            var response = coreUnidadMedidaClient.obtenerPorId(unidadMedidaId);
            if (!response.isSuccess() || response.getData() == null) {
                throw new BusinessException("La unidad de medida no existe",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.DOC_TECNICA_UM_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("La unidad de medida no existe",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.DOC_TECNICA_UM_INEXISTENTE);
        }
    }

    private Specification<ArticuloDocTecnica> buildSpecification(Long docTipoId, String nombreDocumento,
                                                                  String flagEstado, Long articuloId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (docTipoId != null) {
                predicates.add(cb.equal(root.get("docTipoId"), docTipoId));
            }
            if (nombreDocumento != null && !nombreDocumento.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("nombreDocumento")), "%" + nombreDocumento.toUpperCase() + "%"));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            if (articuloId != null) {
                predicates.add(cb.equal(root.get("articuloId"), articuloId));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
