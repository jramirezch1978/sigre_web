package com.sigre.produccion.service.impl;

import feign.FeignException;
import io.micrometer.core.annotation.Timed;
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
import com.sigre.produccion.client.AuthUsuarioClient;
import com.sigre.produccion.entity.OtAdminUder;
import com.sigre.produccion.entity.OtAdministracion;
import com.sigre.produccion.repository.OtAdminUderRepository;
import com.sigre.produccion.repository.OtAdministracionRepository;
import com.sigre.produccion.service.OtAdministracionService;
import com.sigre.produccion.service.ProduccionErrorCodes;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OtAdministracionServiceImpl implements OtAdministracionService {

    private final OtAdministracionRepository administracionRepository;
    private final OtAdminUderRepository uderRepository;
    private final AuthUsuarioClient authUsuarioClient;

    // ───────────────────────── CRUD administracion ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "findAll"})
    public Page<OtAdministracion> findAll(String codigo, String nombre, String flagTipoCosto,
                                          String flagEstado, Pageable pageable) {
        log.info("Listando administraciones de OT - codigo: {}, nombre: {}, flagTipoCosto: {}, flagEstado: {}",
                codigo, nombre, flagTipoCosto, flagEstado);
        Specification<OtAdministracion> spec = buildSpecification(codigo, nombre, flagTipoCosto, flagEstado);
        Page<OtAdministracion> page = administracionRepository.findAll(spec, pageable);
        log.info("Administraciones de OT encontradas: {}", page.getTotalElements());
        return page;
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "findById"})
    public OtAdministracion findById(Long id) {
        log.info("Buscando administracion de OT con id: {}", id);
        return administracionRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("OtAdministracion no encontrada con id: {}", id);
                    return new ResourceNotFoundException("OtAdministracion", id);
                });
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "create"})
    public OtAdministracion create(OtAdministracion entity) {
        log.info("Creando administracion de OT con codigo: {}", entity.getCodigo());
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), null);
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        OtAdministracion saved = administracionRepository.save(entity);
        log.info("OtAdministracion creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "update"})
    public OtAdministracion update(Long id, OtAdministracion entity) {
        log.info("Actualizando administracion de OT con id: {}", id);
        OtAdministracion existing = findById(id);
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setFlagTipoCosto(entity.getFlagTipoCosto());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        OtAdministracion updated = administracionRepository.save(existing);
        log.info("OtAdministracion actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "activate"})
    public OtAdministracion activate(Long id) {
        log.info("Activando administracion de OT con id: {}", id);
        OtAdministracion existing = findById(id);
        existing.setFlagEstado("1");
        return administracionRepository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "deactivate"})
    public OtAdministracion deactivate(Long id) {
        log.info("Desactivando administracion de OT con id: {}", id);
        OtAdministracion existing = findById(id);
        existing.setFlagEstado("0");
        return administracionRepository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_administracion", "operation", "delete"})
    public void delete(Long id) {
        log.info("Eliminando administracion de OT con id: {}", id);
        OtAdministracion existing = findById(id);
        if (administracionRepository.existsOrdenTrabajoByOtAdministracionId(id)) {
            log.warn("No se puede eliminar OtAdministracion id {}: tiene ordenes de trabajo asociadas", id);
            throw new BusinessException(
                    "No se puede eliminar la administracion de OT porque tiene ordenes de trabajo asociadas",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "PRD-OA-005");
        }
        // Baja logica.
        existing.setFlagEstado("0");
        administracionRepository.save(existing);
        log.info("OtAdministracion desactivada (baja logica) exitosamente con id: {}", id);
    }

    // ───────────────────────── Sub-recurso usuarios ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ot_admin_uder", "operation", "findByAdmin"})
    public List<OtAdminUder> findUsuarios(Long otAdministracionId) {
        log.info("Listando usuarios asignados a administracion id: {}", otAdministracionId);
        findById(otAdministracionId); // valida existencia y arroja 404 si no
        return uderRepository.findByOtAdministracionIdOrderByIdAsc(otAdministracionId);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_admin_uder", "operation", "asignar"})
    public OtAdminUder asignarUsuario(Long otAdministracionId, Long usuarioId) {
        log.info("Asignando usuario {} a administracion {}", usuarioId, otAdministracionId);
        findById(otAdministracionId);
        validarUsuarioExiste(usuarioId);
        if (uderRepository.existsByOtAdministracionIdAndUsuarioId(otAdministracionId, usuarioId)) {
            log.warn("Usuario {} ya esta asignado a administracion {}", usuarioId, otAdministracionId);
            throw new BusinessException(
                    "El usuario ya esta asignado a esta administracion de OT",
                    HttpStatus.CONFLICT,
                    "PRD-OA-003");
        }
        OtAdminUder uder = new OtAdminUder();
        uder.setOtAdministracionId(otAdministracionId);
        uder.setUsuarioId(usuarioId);
        uder.setFlagEstado("1");
        uder.setCreatedBy(TenantContext.getUsuarioId());
        OtAdminUder saved = uderRepository.save(uder);
        log.info("OtAdminUder creado con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_admin_uder", "operation", "desasignar"})
    public void desasignarUsuario(Long otAdministracionId, Long usuarioId) {
        log.info("Desasignando usuario {} de administracion {}", usuarioId, otAdministracionId);
        findById(otAdministracionId);
        OtAdminUder uder = uderRepository.findByOtAdministracionIdAndUsuarioId(otAdministracionId, usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "OtAdminUder (admin=" + otAdministracionId + ", usuario=" + usuarioId + ")", null));
        uderRepository.delete(uder);
        log.info("OtAdminUder eliminado: admin={}, usuario={}", otAdministracionId, usuarioId);
    }

    // ───────────────────────── helpers ─────────────────────────

    private static final List<String> FLAG_TIPO_COSTO_VALIDOS = List.of("0", "D", "I", "F");

    private void normalizar(OtAdministracion entity) {
        if (entity.getCodigo() != null) {
            entity.setCodigo(entity.getCodigo().trim().toUpperCase());
        }
        if (entity.getNombre() != null) {
            entity.setNombre(entity.getNombre().trim());
        }
        entity.setFlagTipoCosto(normalizarFlagTipoCosto(entity.getFlagTipoCosto()));
        validarFlagTipoCosto(entity.getFlagTipoCosto());
    }

    private String normalizarFlagTipoCosto(String flagTipoCosto) {
        if (flagTipoCosto == null || flagTipoCosto.isBlank()) {
            return "0";
        }
        String valor = flagTipoCosto.trim().toUpperCase();
        return switch (valor) {
            case "DIRECTO" -> "D";
            case "INDIRECTO" -> "I";
            case "FIJO" -> "F";
            default -> valor;
        };
    }

    private void validarFlagTipoCosto(String flagTipoCosto) {
        if (flagTipoCosto != null && !FLAG_TIPO_COSTO_VALIDOS.contains(flagTipoCosto)) {
            throw new BusinessException(
                    "flagTipoCosto debe ser 0, D, I o F",
                    HttpStatus.BAD_REQUEST,
                    ProduccionErrorCodes.OT_ADMIN_FLAG_TIPO_COSTO_INVALIDO);
        }
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? administracionRepository.existsByCodigoIgnoreCase(codigo)
                : administracionRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de administracion de OT: {}", codigo);
            throw new BusinessException(
                    "Ya existe una administracion de OT activa con codigo " + codigo,
                    HttpStatus.CONFLICT,
                    "PRD-OA-003");
        }
    }

    private void validarUsuarioExiste(Long usuarioId) {
        try {
            var response = authUsuarioClient.obtenerPorId(usuarioId);
            if (!response.isSuccess() || response.getData() == null) {
                log.warn("Usuario inexistente al asignar a administracion de OT: id={}", usuarioId);
                throw new BusinessException("El usuario especificado no existe",
                        HttpStatus.UNPROCESSABLE_ENTITY, "PRD-OA-002");
            }
        } catch (FeignException e) {
            log.warn("Usuario inexistente al asignar a administracion de OT: id={}", usuarioId);
            throw new BusinessException("El usuario especificado no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, "PRD-OA-002");
        }
    }

    private Specification<OtAdministracion> buildSpecification(String codigo, String nombre,
                                                                String flagTipoCosto, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (codigo != null && !codigo.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("codigo")), "%" + codigo.trim().toUpperCase() + "%"));
            }
            if (nombre != null && !nombre.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("nombre")), "%" + nombre.trim().toUpperCase() + "%"));
            }
            if (flagTipoCosto != null && !flagTipoCosto.isBlank()) {
                predicates.add(cb.equal(root.get("flagTipoCosto"), normalizarFlagTipoCosto(flagTipoCosto)));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
