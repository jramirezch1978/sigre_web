package pe.restaurant.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.entity.CodigoFlujoCaja;
import pe.restaurant.finanzas.repository.CodigoFlujoCajaRepository;
import pe.restaurant.finanzas.service.CodigoFlujoCajaService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CodigoFlujoCajaServiceImpl implements CodigoFlujoCajaService {

    private final CodigoFlujoCajaRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "findAll"})
    @Override
    public Page<CodigoFlujoCaja> findAll(Pageable pageable) {
        log.info("Listando códigos de flujo de caja - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<CodigoFlujoCaja> page = repository.findAll(pageable);
        log.info("Códigos de flujo de caja encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "findById"})
    @Override
    public CodigoFlujoCaja findById(Long id) {
        log.info("Buscando código de flujo de caja con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Código de flujo de caja no encontrado con id: {}", id);
                    return new ResourceNotFoundException("CodigoFlujoCaja", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "create"})
    @Override
    @Transactional
    public CodigoFlujoCaja create(CodigoFlujoCaja entity) {
        log.info("Creando código de flujo de caja con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        CodigoFlujoCaja saved = repository.save(entity);
        log.info("Código de flujo de caja creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "update"})
    @Override
    @Transactional
    public CodigoFlujoCaja update(Long id, CodigoFlujoCaja entity) {
        log.info("Actualizando código de flujo de caja con id: {}", id);
        CodigoFlujoCaja existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setTipo(entity.getTipo());
        existing.setGrupoCodigoFlujoCajaId(entity.getGrupoCodigoFlujoCajaId());
        if (entity.getFlagEstado() != null) {
            existing.setFlagEstado(entity.getFlagEstado());
        }
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        CodigoFlujoCaja updated = repository.save(existing);
        log.info("Código de flujo de caja actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "activate"})
    @Override
    @Transactional
    public CodigoFlujoCaja activate(Long id) {
        log.info("Activando código de flujo de caja con id: {}", id);
        CodigoFlujoCaja existing = findById(id);
        existing.setFlagEstado("1");
        CodigoFlujoCaja activated = repository.save(existing);
        log.info("Código de flujo de caja activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "deactivate"})
    @Override
    @Transactional
    public CodigoFlujoCaja deactivate(Long id) {
        log.info("Desactivando código de flujo de caja con id: {}", id);
        CodigoFlujoCaja existing = findById(id);
        existing.setFlagEstado("0");
        CodigoFlujoCaja deactivated = repository.save(existing);
        log.info("Código de flujo de caja desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "codigo_flujo_caja", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando código de flujo de caja con id: {}", id);
        CodigoFlujoCaja existing = findById(id);
        repository.delete(existing);
        log.info("Código de flujo de caja eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar código de flujo de caja: {}", codigo);
            throw new BusinessException(
                    "Ya existe un código de flujo de caja con código: " + codigo,
                    org.springframework.http.HttpStatus.CONFLICT, "FIN-002");
        }
    }
}
