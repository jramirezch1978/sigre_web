package com.sigre.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.compras.entity.AprobadorConfigurado;
import com.sigre.compras.repository.AprobadorConfiguradoRepository;
import com.sigre.compras.service.AprobadorConfiguradoService;

@Slf4j
@Service
@Transactional(readOnly = true)
public class AprobadorConfiguradoServiceImpl implements AprobadorConfiguradoService {

    private final AprobadorConfiguradoRepository repository;
    private final JdbcTemplate securityJdbcTemplate;

    public AprobadorConfiguradoServiceImpl(
            AprobadorConfiguradoRepository repository,
            @Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate) {
        this.repository = repository;
        this.securityJdbcTemplate = securityJdbcTemplate;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "findAll"})
    @Override
    public Page<AprobadorConfigurado> findAll(Pageable pageable) {
        log.info("Listando aprobadores configurados - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AprobadorConfigurado> page = repository.findAll(pageable);
        log.info("Aprobadores configurados encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "findById"})
    @Override
    public AprobadorConfigurado findById(Long id) {
        log.info("Buscando aprobador configurado con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Aprobador configurado no encontrado con id: {}", id);
                    return new ResourceNotFoundException("AprobadorConfigurado", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "create"})
    @Override
    @Transactional
    public AprobadorConfigurado create(AprobadorConfigurado entity) {
        log.info("Creando aprobador configurado para docTipoId: {}, nivel: {}", entity.getDocTipoId(), entity.getNivel());
        validateAprobadorExists(entity.getAprobadorId());
        AprobadorConfigurado saved = repository.save(entity);
        log.info("Aprobador configurado creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "update"})
    @Override
    @Transactional
    public AprobadorConfigurado update(Long id, AprobadorConfigurado entity) {
        log.info("Actualizando aprobador configurado con id: {}", id);
        findById(id);
        entity.setId(id);
        validateAprobadorExists(entity.getAprobadorId());
        AprobadorConfigurado updated = repository.save(entity);
        log.info("Aprobador configurado actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando aprobador configurado con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Aprobador configurado eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "activate"})
    @Override
    @Transactional
    public AprobadorConfigurado activate(Long id) {
        log.info("Activando aprobador configurado con id: {}", id);
        AprobadorConfigurado existing = findById(id);
        existing.setFlagEstado("1");
        AprobadorConfigurado activated = repository.save(existing);
        log.info("Aprobador configurado activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "aprobador_configurado", "operation", "deactivate"})
    @Override
    @Transactional
    public AprobadorConfigurado deactivate(Long id) {
        log.info("Desactivando aprobador configurado con id: {}", id);
        AprobadorConfigurado existing = findById(id);
        existing.setFlagEstado("0");
        AprobadorConfigurado deactivated = repository.save(existing);
        log.info("Aprobador configurado desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    private void validateAprobadorExists(Long aprobadorId) {
        Integer count = securityJdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario WHERE id = ? AND flag_estado = '1'",
                Integer.class, aprobadorId);
        if (count == null || count == 0) {
            throw new ResourceNotFoundException("Usuario aprobador", aprobadorId);
        }
    }
}
