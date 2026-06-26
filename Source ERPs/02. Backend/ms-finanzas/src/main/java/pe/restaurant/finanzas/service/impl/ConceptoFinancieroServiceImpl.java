package pe.restaurant.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.entity.ConceptoFinanciero;
import pe.restaurant.finanzas.repository.ConceptoFinancieroRepository;
import pe.restaurant.finanzas.service.ConceptoFinancieroService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ConceptoFinancieroServiceImpl implements ConceptoFinancieroService {

    private final ConceptoFinancieroRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "findAll"})
    @Override
    public Page<ConceptoFinanciero> findAll(Pageable pageable) {
        log.info("Listando conceptos financieros - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ConceptoFinanciero> page = repository.findAll(pageable);
        log.info("Conceptos financieros encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "findById"})
    @Override
    public ConceptoFinanciero findById(Long id) {
        log.info("Buscando concepto financiero con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Concepto financiero no encontrado con id: {}", id);
                    return new ResourceNotFoundException("ConceptoFinanciero", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "create"})
    @Override
    @Transactional
    public ConceptoFinanciero create(ConceptoFinanciero entity) {
        log.info("Creando concepto financiero con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        ConceptoFinanciero saved = repository.save(entity);
        log.info("Concepto financiero creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "update"})
    @Override
    @Transactional
    public ConceptoFinanciero update(Long id, ConceptoFinanciero entity) {
        log.info("Actualizando concepto financiero con id: {}", id);
        ConceptoFinanciero existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        if (entity.getMatrizContableId() != null) {
            existing.setMatrizContableId(entity.getMatrizContableId());
        }
        if (entity.getFlagEstado() != null) {
            existing.setFlagEstado(entity.getFlagEstado());
        }
        ConceptoFinanciero updated = repository.save(existing);
        log.info("Concepto financiero actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "activate"})
    @Override
    @Transactional
    public ConceptoFinanciero activate(Long id) {
        log.info("Activando concepto financiero con id: {}", id);
        ConceptoFinanciero existing = findById(id);
        existing.setFlagEstado("1");
        ConceptoFinanciero activated = repository.save(existing);
        log.info("Concepto financiero activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "deactivate"})
    @Override
    @Transactional
    public ConceptoFinanciero deactivate(Long id) {
        log.info("Desactivando concepto financiero con id: {}", id);
        ConceptoFinanciero existing = findById(id);
        existing.setFlagEstado("0");
        ConceptoFinanciero deactivated = repository.save(existing);
        log.info("Concepto financiero desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "concepto_financiero", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando concepto financiero con id: {}", id);
        ConceptoFinanciero existing = findById(id);
        repository.delete(existing);
        log.info("Concepto financiero eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de concepto financiero: {}", codigo);
            throw new BusinessException(
                    "Ya existe un concepto financiero con código: " + codigo,
                    org.springframework.http.HttpStatus.CONFLICT, "FIN-001");
        }
    }
}
