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
import com.sigre.produccion.client.AlmacenValeMovClient;
import com.sigre.produccion.client.CoreArticuloClient;
import com.sigre.produccion.client.CoreUnidadMedidaClient;
import com.sigre.produccion.entity.ParteProduccion;
import com.sigre.produccion.entity.ParteProduccionInsumo;
import com.sigre.produccion.entity.ParteProduccionProducido;
import com.sigre.produccion.repository.ParteProduccionInsumoRepository;
import com.sigre.produccion.repository.ParteProduccionProducidoRepository;
import com.sigre.produccion.repository.ParteProduccionRepository;
import com.sigre.produccion.service.ParteProduccionService;
import com.sigre.produccion.service.ProduccionErrorCodes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ParteProduccionServiceImpl implements ParteProduccionService {

    private final ParteProduccionRepository repository;
    private final ParteProduccionInsumoRepository insumoRepository;
    private final ParteProduccionProducidoRepository producidoRepository;
    private final CoreArticuloClient coreArticuloClient;
    private final CoreUnidadMedidaClient coreUnidadMedidaClient;
    private final AlmacenValeMovClient almacenValeMovClient;
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "findAll"})
    public Page<ParteProduccion> findAll(Long ordenTrabajoId, LocalDate fechaDesde, LocalDate fechaHasta,
                                         String flagEstado, Pageable pageable) {
        Specification<ParteProduccion> spec = buildSpecification(ordenTrabajoId, fechaDesde, fechaHasta, flagEstado);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "findById"})
    public ParteProduccion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ParteProduccion", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "create"})
    public ParteProduccion create(ParteProduccion entity, List<ParteProduccionInsumo> insumos,
                                  List<ParteProduccionProducido> producidos) {
        validarDatosObligatorios(entity);
        validarOrdenTrabajo(entity.getOrdenTrabajoId());
        validarInsumosYProducidos(insumos, producidos);
        validarInsumos(insumos);
        validarProducidos(producidos);

        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        ParteProduccion saved = repository.save(entity);
        guardarInsumos(saved.getId(), insumos);
        guardarProducidos(saved.getId(), producidos);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "update"})
    public ParteProduccion update(Long id, ParteProduccion entity, List<ParteProduccionInsumo> insumos,
                                  List<ParteProduccionProducido> producidos) {
        ParteProduccion existing = findById(id);
        validarParteActiva(existing);
        validarDatosObligatorios(entity);
        validarOrdenTrabajo(entity.getOrdenTrabajoId());
        validarInsumosYProducidos(insumos, producidos);
        validarInsumos(insumos);
        validarProducidos(producidos);

        existing.setOrdenTrabajoId(entity.getOrdenTrabajoId());
        existing.setFecha(entity.getFecha());
        existing.setTurnoId(entity.getTurnoId());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        ParteProduccion saved = repository.save(existing);
        sincronizarInsumos(saved.getId(), insumos);
        sincronizarProducidos(saved.getId(), producidos);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "activate"})
    public ParteProduccion activate(Long id) {
        ParteProduccion existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "deactivate"})
    public ParteProduccion deactivate(Long id) {
        ParteProduccion existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion", "operation", "delete"})
    public void delete(Long id) {
        ParteProduccion existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(existing);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion_insumo", "operation", "findByParte"})
    public List<ParteProduccionInsumo> findInsumos(Long parteProduccionId) {
        return insumoRepository.findByParteProduccionIdOrderByIdAsc(parteProduccionId);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "parte_produccion_producido", "operation", "findByParte"})
    public List<ParteProduccionProducido> findProducidos(Long parteProduccionId) {
        return producidoRepository.findByParteProduccionIdOrderByIdAsc(parteProduccionId);
    }

    // ───────────────────────── helpers ─────────────────────────

    private void guardarInsumos(Long parteProduccionId, List<ParteProduccionInsumo> insumos) {
        if (insumos == null) return;
        for (ParteProduccionInsumo insumo : insumos) {
            insumo.setParteProduccionId(parteProduccionId);
            insumo.setCreatedBy(TenantContext.getUsuarioId());
            insumoRepository.save(insumo);
        }
    }

    private void guardarProducidos(Long parteProduccionId, List<ParteProduccionProducido> producidos) {
        if (producidos == null) return;
        for (ParteProduccionProducido prod : producidos) {
            prod.setParteProduccionId(parteProduccionId);
            prod.setCreatedBy(TenantContext.getUsuarioId());
            producidoRepository.save(prod);
        }
    }

    private void sincronizarInsumos(Long parteProduccionId, List<ParteProduccionInsumo> insumos) {
        insumoRepository.deleteByParteProduccionId(parteProduccionId);
        guardarInsumos(parteProduccionId, insumos);
    }

    private void sincronizarProducidos(Long parteProduccionId, List<ParteProduccionProducido> producidos) {
        producidoRepository.deleteByParteProduccionId(parteProduccionId);
        guardarProducidos(parteProduccionId, producidos);
    }

    private void validarDatosObligatorios(ParteProduccion entity) {
        if (entity.getOrdenTrabajoId() == null || entity.getFecha() == null) {
            throw new BusinessException("Faltan datos obligatorios para el parte de producción",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.PARTE_DATOS_INCOMPLETOS);
        }
    }

    private void validarOrdenTrabajo(Long ordenTrabajoId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.orden_trabajo WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", ordenTrabajoId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La orden de trabajo no existe o está inactiva",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_OT_INEXISTENTE);
        }
    }

    private void validarInsumosYProducidos(List<ParteProduccionInsumo> insumos,
                                           List<ParteProduccionProducido> producidos) {
        boolean sinInsumos = insumos == null || insumos.isEmpty();
        boolean sinProducidos = producidos == null || producidos.isEmpty();
        if (sinInsumos && sinProducidos) {
            throw new BusinessException("Debe incluir al menos un insumo o un producido",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.PARTE_SIN_INSUMOS_NI_PRODUCIDOS);
        }
    }

    private void validarParteActiva(ParteProduccion parte) {
        if ("0".equals(parte.getFlagEstado())) {
            throw new BusinessException("El parte de producción está inactivo y no puede modificarse",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.PARTE_INACTIVO);
        }
    }

    private void validarInsumos(List<ParteProduccionInsumo> insumos) {
        if (insumos == null) return;
        for (ParteProduccionInsumo insumo : insumos) {
            validarArticuloExiste(insumo.getArticuloId());
            validarCantidadPositiva(insumo.getCantidadConsumida());
            if (insumo.getUnidadMedidaId() != null) {
                validarUnidadMedidaExiste(insumo.getUnidadMedidaId());
            }
            if (insumo.getValeMovId() != null) {
                validarValeMovExiste(insumo.getValeMovId());
            }
        }
    }

    private void validarProducidos(List<ParteProduccionProducido> producidos) {
        if (producidos == null) return;
        for (ParteProduccionProducido prod : producidos) {
            validarArticuloExiste(prod.getArticuloId());
            validarCantidadPositiva(prod.getCantidadProducida());
            if (prod.getUnidadMedidaId() != null) {
                validarUnidadMedidaExiste(prod.getUnidadMedidaId());
            }
        }
    }

    private void validarArticuloExiste(Long articuloId) {
        if (articuloId == null) return;
        try {
            var response = coreArticuloClient.obtenerPorId(articuloId);
            if (!response.isSuccess() || response.getData() == null) {
                throw new BusinessException("El artículo no existe",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_ARTICULO_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("El artículo no existe",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_ARTICULO_INEXISTENTE);
        }
    }

    private void validarCantidadPositiva(BigDecimal cantidad) {
        if (cantidad != null && cantidad.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("La cantidad debe ser mayor a 0",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.PARTE_CANTIDAD_INVALIDA);
        }
    }

    private void validarUnidadMedidaExiste(Long unidadMedidaId) {
        try {
            var response = coreUnidadMedidaClient.obtenerPorId(unidadMedidaId);
            if (!response.isSuccess() || response.getData() == null) {
                throw new BusinessException("La unidad de medida no existe",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_UM_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("La unidad de medida no existe",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_UM_INEXISTENTE);
        }
    }

    private void validarValeMovExiste(Long valeMovId) {
        try {
            var response = almacenValeMovClient.obtenerPorId(valeMovId);
            if (!response.isSuccess() || response.getData() == null) {
                throw new BusinessException("El vale de movimiento no existe",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_VALE_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("El vale de movimiento no existe",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PARTE_VALE_INEXISTENTE);
        }
    }

    private Specification<ParteProduccion> buildSpecification(Long ordenTrabajoId, LocalDate fechaDesde,
                                                              LocalDate fechaHasta, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (ordenTrabajoId != null) {
                predicates.add(cb.equal(root.get("ordenTrabajoId"), ordenTrabajoId));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
