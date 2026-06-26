package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.compras.entity.Comprador;
import pe.restaurant.compras.entity.CompradorCategoria;
import pe.restaurant.compras.repository.ArticuloCategoriaRefRepository;
import pe.restaurant.compras.repository.CompradorCategoriaRepository;
import pe.restaurant.compras.repository.CompradorRepository;
import pe.restaurant.compras.service.CompradorService;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
public class CompradorServiceImpl implements CompradorService {

    private final CompradorRepository repository;
    private final CompradorCategoriaRepository categoriaRepository;
    private final ArticuloCategoriaRefRepository articuloCategoriaRefRepository;
    private final JdbcTemplate securityJdbcTemplate;

    public CompradorServiceImpl(
            CompradorRepository repository,
            CompradorCategoriaRepository categoriaRepository,
            ArticuloCategoriaRefRepository articuloCategoriaRefRepository,
            @Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate) {
        this.repository = repository;
        this.categoriaRepository = categoriaRepository;
        this.articuloCategoriaRefRepository = articuloCategoriaRefRepository;
        this.securityJdbcTemplate = securityJdbcTemplate;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "findAll"})
    @Override
    public Page<Comprador> findAll(Pageable pageable) {
        log.info("Listando compradores - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Comprador> page = repository.findAll(pageable);
        log.info("Compradores encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "findById"})
    @Override
    public Comprador findById(Long id) {
        log.info("Buscando comprador con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Comprador no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Comprador", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "create"})
    @Override
    @Transactional
    public Comprador create(Comprador entity) {
        if (entity.getUsuarioId() == null) {
            Long tokenUserId = TenantContext.getUsuarioId();
            if (tokenUserId == null) {
                throw new BusinessException("El usuarioId es obligatorio al crear un comprador", HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
            }
            entity.setUsuarioId(tokenUserId);
        }
        validateUsuarioExists(entity.getUsuarioId());
        if (repository.existsByUsuarioId(entity.getUsuarioId())) {
            log.warn("Ya existe un comprador vinculado al usuarioId: {}", entity.getUsuarioId());
            throw new BusinessException(
                    "Ya existe un comprador registrado para este usuario",
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        log.info("Creando comprador para usuarioId {}: {}", entity.getUsuarioId(), entity.getNombre());
        Comprador saved = repository.save(entity);
        log.info("Comprador creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "update"})
    @Override
    @Transactional
    public Comprador update(Long id, Comprador entity) {
        log.info("Actualizando comprador con id: {}", id);
        Comprador existing = findById(id);
        if (entity.getUsuarioId() != null) {
            validateUsuarioExists(entity.getUsuarioId());
            existing.setUsuarioId(entity.getUsuarioId());
        }
        if (entity.getNombre() != null) {
            existing.setNombre(entity.getNombre());
        }
        if (entity.getFlagEstado() != null) {
            existing.setFlagEstado(entity.getFlagEstado());
        }
        Comprador updated = repository.save(existing);
        log.info("Comprador actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando comprador con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Comprador eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "deactivate"})
    @Override
    @Transactional
    public Comprador deactivate(Long id) {
        log.info("Desactivando comprador con id: {}", id);
        Comprador existing = findById(id);
        existing.setFlagEstado("0");
        Comprador deactivated = repository.save(existing);
        log.info("Comprador desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador", "operation", "activate"})
    @Override
    @Transactional
    public Comprador activate(Long id) {
        log.info("Activando comprador con id: {}", id);
        Comprador existing = findById(id);
        existing.setFlagEstado("1");
        Comprador activated = repository.save(existing);
        log.info("Comprador activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador_categoria", "operation", "findCategorias"})
    @Override
    public List<CompradorCategoria> findCategorias(Long compradorId) {
        log.info("Listando categorias del comprador id: {}", compradorId);
        findById(compradorId);
        List<CompradorCategoria> categorias = categoriaRepository.findByCompradorId(compradorId);
        log.info("Categorias encontradas para comprador {}: {}", compradorId, categorias.size());
        return categorias;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "comprador_categoria", "operation", "assignCategoria"})
    @Override
    @Transactional
    public CompradorCategoria assignCategoria(Long compradorId, Long articuloCategId) {
        log.info("Asignando categoria {} al comprador {}", articuloCategId, compradorId);
        findById(compradorId);
        validateArticuloCategExists(articuloCategId);
        if (categoriaRepository.existsByCompradorIdAndArticuloCategId(compradorId, articuloCategId)) {
            log.warn("La categoria {} ya esta asignada al comprador {}", articuloCategId, compradorId);
            throw new BusinessException("La categoría ya está asignada a este comprador", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        CompradorCategoria cc = new CompradorCategoria();
        cc.setCompradorId(compradorId);
        cc.setArticuloCategId(articuloCategId);
        CompradorCategoria saved = categoriaRepository.save(cc);
        log.info("Categoria {} asignada exitosamente al comprador {}", articuloCategId, compradorId);
        return saved;
    }

    private void validateUsuarioExists(Long usuarioId) {
        Integer count = securityJdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario WHERE id = ?", Integer.class, usuarioId);
        if (count == null || count == 0) {
            throw new ResourceNotFoundException("Usuario", usuarioId);
        }
    }

    private void validateArticuloCategExists(Long articuloCategId) {
        if (!articuloCategoriaRefRepository.existsById(articuloCategId)) {
            throw new ResourceNotFoundException("ArticuloCateg", articuloCategId);
        }
    }
}
