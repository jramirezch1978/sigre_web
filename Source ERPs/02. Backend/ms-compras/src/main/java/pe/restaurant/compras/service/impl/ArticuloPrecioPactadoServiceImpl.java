package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.compras.entity.ArticuloPrecioPactado;
import pe.restaurant.compras.repository.ArticuloPrecioPactadoRepository;
import pe.restaurant.compras.repository.ArticuloRefRepository;
import pe.restaurant.compras.repository.EntidadContribuyenteRefRepository;
import pe.restaurant.compras.repository.MonedaRefRepository;
import pe.restaurant.compras.service.ArticuloPrecioPactadoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloPrecioPactadoServiceImpl implements ArticuloPrecioPactadoService {

    private final ArticuloPrecioPactadoRepository repository;
    private final ArticuloRefRepository articuloRefRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final MonedaRefRepository monedaRefRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "findAll"})
    @Override
    public Page<ArticuloPrecioPactado> findAll(Long articuloId, Long proveedorId, Pageable pageable) {
        log.info("Listando precios pactados - articuloId: {}, proveedorId: {}, page: {}, size: {}",
                articuloId, proveedorId, pageable.getPageNumber(), pageable.getPageSize());

        Specification<ArticuloPrecioPactado> spec = Specification.allOf();
        if (articuloId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("articuloId"), articuloId));
        }
        if (proveedorId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("proveedorId"), proveedorId));
        }

        Page<ArticuloPrecioPactado> page = repository.findAll(spec, pageable);
        log.info("Precios pactados encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "findById"})
    @Override
    public ArticuloPrecioPactado findById(Long id) {
        log.info("Buscando precio pactado con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Precio pactado no encontrado con id: {}", id);
                    return new ResourceNotFoundException("ArticuloPrecioPactado", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "create"})
    @Override
    @Transactional
    public ArticuloPrecioPactado create(ArticuloPrecioPactado entity) {
        log.info("Creando precio pactado para articuloId: {}, proveedorId: {}",
                entity.getArticuloId(), entity.getProveedorId());
        validateForeignKeys(entity);
        ArticuloPrecioPactado saved = repository.save(entity);
        log.info("Precio pactado creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "update"})
    @Override
    @Transactional
    public ArticuloPrecioPactado update(Long id, ArticuloPrecioPactado entity) {
        log.info("Actualizando precio pactado con id: {}", id);
        findById(id);
        entity.setId(id);
        validateForeignKeys(entity);
        ArticuloPrecioPactado updated = repository.save(entity);
        log.info("Precio pactado actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando precio pactado con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Precio pactado eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "activate"})
    @Override
    @Transactional
    public ArticuloPrecioPactado activate(Long id) {
        log.info("Activando precio pactado con id: {}", id);
        ArticuloPrecioPactado existing = findById(id);
        existing.setFlagEstado("1");
        ArticuloPrecioPactado activated = repository.save(existing);
        log.info("Precio pactado activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_precio_pactado", "operation", "deactivate"})
    @Override
    @Transactional
    public ArticuloPrecioPactado deactivate(Long id) {
        log.info("Desactivando precio pactado con id: {}", id);
        ArticuloPrecioPactado existing = findById(id);
        existing.setFlagEstado("0");
        ArticuloPrecioPactado deactivated = repository.save(existing);
        log.info("Precio pactado desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    private void validateForeignKeys(ArticuloPrecioPactado entity) {
        if (!articuloRefRepository.existsById(entity.getArticuloId())) {
            throw new ResourceNotFoundException("Articulo", entity.getArticuloId());
        }
        if (!entidadContribuyenteRefRepository.existsById(entity.getProveedorId())) {
            throw new ResourceNotFoundException("Proveedor", entity.getProveedorId());
        }
        if (entity.getMonedaId() != null) {
            if (!monedaRefRepository.existsById(entity.getMonedaId())) {
                throw new ResourceNotFoundException("Moneda", entity.getMonedaId());
            }
        }
    }
}
