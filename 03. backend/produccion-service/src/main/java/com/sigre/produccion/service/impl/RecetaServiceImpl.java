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
import com.sigre.produccion.entity.FichaTecnica;
import com.sigre.produccion.entity.Receta;
import com.sigre.produccion.entity.RecetaLabor;
import com.sigre.produccion.entity.RecetaLaborConsumible;
import com.sigre.produccion.dto.response.RecetaConsumibleResponse;
import com.sigre.produccion.dto.response.RecetaLaborResponse;
import com.sigre.produccion.dto.response.RecetaResponse;
import com.sigre.produccion.repository.FichaTecnicaRepository;
import com.sigre.produccion.repository.RecetaLaborConsumibleRepository;
import com.sigre.produccion.repository.RecetaLaborRepository;
import com.sigre.produccion.repository.RecetaRepository;
import com.sigre.produccion.service.ProduccionErrorCodes;
import com.sigre.produccion.service.RecetaService;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RecetaServiceImpl implements RecetaService {

    private final RecetaRepository recetaRepository;
    private final RecetaLaborRepository recetaLaborRepository;
    private final RecetaLaborConsumibleRepository consumibleRepository;
    private final FichaTecnicaRepository fichaTecnicaRepository;
    private final CoreArticuloClient coreArticuloClient;
    @PersistenceContext
    private EntityManager entityManager;

    // ───────────────────────── CRUD ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "findAll"})
    public Page<Receta> findAll(String nroReceta, String nombre, String flagTipoReceta, String flagEstado,
                                Long articuloProducidoId, Pageable pageable) {
        log.info("Listando recetas - nroReceta: {}, nombre: {}, flagTipoReceta: {}, flagEstado: {}, articulo: {}",
                nroReceta, nombre, flagTipoReceta, flagEstado, articuloProducidoId);
        Specification<Receta> spec = buildSpecification(nroReceta, nombre, flagTipoReceta, flagEstado, articuloProducidoId);
        Page<Receta> page = recetaRepository.findAll(spec, pageable);
        log.info("Recetas encontradas: {}", page.getTotalElements());
        return page;
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "findById"})
    public Receta findById(Long id) {
        log.info("Buscando receta con id: {}", id);
        return recetaRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Receta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Receta", id);
                });
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "create"})
    public Receta create(Receta receta, List<RecetaLabor> labores, List<RecetaLaborConsumible> consumibles,
                         FichaTecnica fichaTecnica) {
        log.info("Creando receta con nroReceta: {}", receta.getNroReceta());
        normalizar(receta);
        validateUniqueNroReceta(receta.getNroReceta(), null);
        validarArticuloProducido(receta.getArticuloProducidoId());
        if (receta.getFlagEstado() == null || receta.getFlagEstado().isBlank()) {
            receta.setFlagEstado("1");
        }
        if (receta.getVersion() == null) {
            receta.setVersion(1);
        }
    receta.setCostoTotalEstimado(calcularCostoTotal(receta));
    receta.setCreatedBy(TenantContext.getUsuarioId());

    Receta saved = recetaRepository.save(receta);

        guardarLabores(saved.getId(), labores);
        guardarConsumibles(saved.getId(), consumibles);
        guardarFichaTecnica(saved.getId(), fichaTecnica);

        log.info("Receta creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "update"})
    public Receta update(Long id, Receta receta, List<RecetaLabor> labores,
                         List<RecetaLaborConsumible> consumibles, FichaTecnica fichaTecnica) {
        log.info("Actualizando receta con id: {}", id);
        Receta existing = findById(id);
        if ("0".equals(existing.getFlagEstado())) {
            throw new BusinessException("No se puede modificar una receta inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.RECETA_INACTIVA);
        }

        normalizar(receta);
        validateUniqueNroReceta(receta.getNroReceta(), id);
        validarArticuloProducido(receta.getArticuloProducidoId());

        existing.setArticuloProducidoId(receta.getArticuloProducidoId());
        existing.setNroReceta(receta.getNroReceta());
        existing.setNombre(receta.getNombre());
        existing.setFlagTipoReceta(receta.getFlagTipoReceta());
        existing.setRendimientoEsperado(receta.getRendimientoEsperado());
        existing.setPorcentajeMerma(receta.getPorcentajeMerma());
        existing.setCostoManoObra(receta.getCostoManoObra());
        existing.setCostoIndirecto(receta.getCostoIndirecto());
        existing.setCostoTotalEstimado(calcularCostoTotal(receta));
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        Receta saved = recetaRepository.save(existing);

        sincronizarLabores(saved.getId(), labores);
        sincronizarConsumibles(saved.getId(), consumibles);
        sincronizarFichaTecnica(saved.getId(), fichaTecnica);

        log.info("Receta actualizada exitosamente con id: {}", id);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "activate"})
    public Receta activate(Long id) {
        log.info("Activando receta con id: {}", id);
        Receta existing = findById(id);
        existing.setFlagEstado("1");
        return recetaRepository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "deactivate"})
    public Receta deactivate(Long id) {
        log.info("Desactivando receta con id: {}", id);
        Receta existing = findById(id);
        validarSinProgramacionesActivas(id);
        existing.setFlagEstado("0");
        return recetaRepository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "nuevaVersion"})
    public Receta nuevaVersion(Long id) {
        log.info("Creando nueva version de receta id: {}", id);
        Receta source = findById(id);

        Integer nuevaVersion = source.getVersion() + 1;

        Receta nueva = new Receta();
        nueva.setArticuloProducidoId(source.getArticuloProducidoId());
        nueva.setNroReceta(source.getNroReceta() + "-V" + nuevaVersion);
        nueva.setNombre(source.getNombre());
        nueva.setVersion(nuevaVersion);
        nueva.setRendimientoEsperado(source.getRendimientoEsperado());
        nueva.setPorcentajeMerma(source.getPorcentajeMerma());
        nueva.setFlagTipoReceta(source.getFlagTipoReceta());
        nueva.setCostoManoObra(source.getCostoManoObra());
        nueva.setCostoIndirecto(source.getCostoIndirecto());
        nueva.setCostoTotalEstimado(source.getCostoTotalEstimado());
        nueva.setFlagEstado("1");
        nueva.setCreatedBy(TenantContext.getUsuarioId());

        Receta saved = recetaRepository.save(nueva);

        List<RecetaLabor> labores = recetaLaborRepository.findByRecetaIdOrderBySecuenciaAsc(id);
        for (RecetaLabor labor : labores) {
            RecetaLabor copy = new RecetaLabor();
            copy.setRecetaId(saved.getId());
            copy.setLaborId(labor.getLaborId());
            copy.setSecuencia(labor.getSecuencia());
            copy.setDescripcionPaso(labor.getDescripcionPaso());
            copy.setCreatedBy(TenantContext.getUsuarioId());
            recetaLaborRepository.save(copy);
        }

        List<RecetaLaborConsumible> consumibles = consumibleRepository.findByRecetaPadreIdOrderByIdAsc(id);
        for (RecetaLaborConsumible cons : consumibles) {
            RecetaLaborConsumible copy = new RecetaLaborConsumible();
            copy.setRecetaPadreId(saved.getId());
            copy.setArticuloId(cons.getArticuloId());
            copy.setCantidad(cons.getCantidad());
            copy.setCreatedBy(TenantContext.getUsuarioId());
            consumibleRepository.save(copy);
        }

        Optional<FichaTecnica> ft = fichaTecnicaRepository.findByRecetaId(id);
        ft.ifPresent(ficha -> {
            FichaTecnica copy = new FichaTecnica();
            copy.setRecetaId(saved.getId());
            copy.setAlergenos(ficha.getAlergenos());
            copy.setCalorias(ficha.getCalorias());
            copy.setProteinasG(ficha.getProteinasG());
            copy.setCarbohidratosG(ficha.getCarbohidratosG());
            copy.setGrasasG(ficha.getGrasasG());
            copy.setFibraG(ficha.getFibraG());
            copy.setSodioMg(ficha.getSodioMg());
            copy.setTipoDieta(ficha.getTipoDieta());
            copy.setFotoPresentacionUrl(ficha.getFotoPresentacionUrl());
            copy.setInstruccionesEmplatado(ficha.getInstruccionesEmplatado());
            copy.setTiempoPreparacionMin(ficha.getTiempoPreparacionMin());
            copy.setTiempoCoccionMin(ficha.getTiempoCoccionMin());
            copy.setTemperaturaServicio(ficha.getTemperaturaServicio());
            copy.setCreatedBy(TenantContext.getUsuarioId());
            fichaTecnicaRepository.save(copy);
        });

        source.setFlagEstado("0");
        recetaRepository.save(source);

        log.info("Nueva version creada: {} -> version {}", saved.getId(), saved.getVersion());
        return saved;
    }

    // ───────────────────────── Sub-recursos ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "receta_labor", "operation", "findByReceta"})
    public List<RecetaLabor> findLabores(Long recetaId) {
        return recetaLaborRepository.findByRecetaIdOrderBySecuenciaAsc(recetaId);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "receta_labor_consumible", "operation", "findByReceta"})
    public List<RecetaLaborConsumible> findConsumibles(Long recetaId) {
        return consumibleRepository.findByRecetaPadreIdOrderByIdAsc(recetaId);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ficha_tecnica", "operation", "findByReceta"})
    public FichaTecnica findFichaTecnica(Long recetaId) {
        return fichaTecnicaRepository.findByRecetaId(recetaId).orElse(null);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "receta", "operation", "delete"})
    public void delete(Long id) {
        log.info("Eliminando receta con id: {}", id);
        Receta existing = findById(id);
        existing.setFlagEstado("0");
        recetaRepository.save(existing);
        log.info("Receta desactivada (baja logica) con id: {}", id);
    }

    // ───────────────────────── enrichment ─────────────────────────

    @Override
    @SuppressWarnings("unchecked")
    public void enrichRecetaResponses(List<RecetaResponse> responses) {
        if (responses == null || responses.isEmpty()) return;
        try {
            Set<Long> articuloIds = responses.stream()
                    .map(RecetaResponse::getArticuloProducidoId)
                    .collect(Collectors.toSet());
            List<Object[]> rows = entityManager.createNativeQuery(
                    "SELECT id, codigo, nombre FROM core.articulo WHERE id IN (:ids)")
                    .setParameter("ids", articuloIds)
                    .getResultList();
            Map<Long, String[]> articulos = new java.util.HashMap<>();
            for (Object[] row : rows) {
                articulos.put(((Number) row[0]).longValue(), new String[]{(String) row[1], (String) row[2]});
            }
            for (RecetaResponse r : responses) {
                String[] info = articulos.get(r.getArticuloProducidoId());
                if (info != null) {
                    r.setArticuloCodigo(info[0]);
                    r.setArticuloDescripcion(info[1]);
                }
            }
        } catch (Exception e) {
            log.warn("No se pudo enriquecer articulos desde core.articulo: {}", e.getMessage());
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void enrichLaborResponses(List<RecetaLaborResponse> responses) {
        if (responses == null || responses.isEmpty()) return;
        try {
            Set<Long> laborIds = responses.stream()
                    .map(RecetaLaborResponse::getLaborId)
                    .collect(Collectors.toSet());
            List<Object[]> rows = entityManager.createNativeQuery(
                    "SELECT id, codigo, nombre FROM produccion.labor WHERE id IN (:ids)")
                    .setParameter("ids", laborIds)
                    .getResultList();
            Map<Long, String[]> labores = new java.util.HashMap<>();
            for (Object[] row : rows) {
                labores.put(((Number) row[0]).longValue(), new String[]{(String) row[1], (String) row[2]});
            }
            for (RecetaLaborResponse r : responses) {
                String[] info = labores.get(r.getLaborId());
                if (info != null) {
                    r.setLaborCodigo(info[0]);
                    r.setLaborNombre(info[1]);
                }
            }
        } catch (Exception e) {
            log.warn("No se pudo enriquecer labores desde produccion.labor: {}", e.getMessage());
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void enrichConsumibleResponses(List<RecetaConsumibleResponse> responses) {
        if (responses == null || responses.isEmpty()) return;
        try {
            Set<Long> articuloIds = responses.stream()
                    .map(RecetaConsumibleResponse::getArticuloId)
                    .collect(Collectors.toSet());
            List<Object[]> rows = entityManager.createNativeQuery(
                    "SELECT id, codigo, nombre FROM core.articulo WHERE id IN (:ids)")
                    .setParameter("ids", articuloIds)
                    .getResultList();
            Map<Long, String[]> articulos = new java.util.HashMap<>();
            for (Object[] row : rows) {
                articulos.put(((Number) row[0]).longValue(), new String[]{(String) row[1], (String) row[2]});
            }
            for (RecetaConsumibleResponse r : responses) {
                String[] info = articulos.get(r.getArticuloId());
                if (info != null) {
                    r.setArticuloCodigo(info[0]);
                    r.setArticuloDescripcion(info[1]);
                }
            }
        } catch (Exception e) {
            log.warn("No se pudo enriquecer artículos consumibles desde core.articulo: {}", e.getMessage());
        }
    }

    // ───────────────────────── helpers sincronizacion ─────────────────────────

    private void guardarLabores(Long recetaId, List<RecetaLabor> labores) {
        if (labores == null) return;
        Set<Integer> secuencias = new java.util.HashSet<>();
        for (RecetaLabor labor : labores) {
            if (!secuencias.add(labor.getSecuencia())) {
                throw new BusinessException(
                        "Secuencia duplicada en labores: " + labor.getSecuencia(),
                        HttpStatus.CONFLICT,
                        ProduccionErrorCodes.RECETA_SECUENCIA_DUPLICADA);
            }
            labor.setRecetaId(recetaId);
            labor.setCreatedBy(TenantContext.getUsuarioId());
            validarLabor(labor.getLaborId());
            recetaLaborRepository.save(labor);
        }
    }

    private void guardarConsumibles(Long recetaId, List<RecetaLaborConsumible> consumibles) {
        if (consumibles == null) return;
        for (RecetaLaborConsumible cons : consumibles) {
            validarArticuloConsumible(cons.getArticuloId());
            cons.setRecetaPadreId(recetaId);
            cons.setCreatedBy(TenantContext.getUsuarioId());
            consumibleRepository.save(cons);
        }
    }

    private void guardarFichaTecnica(Long recetaId, FichaTecnica fichaTecnica) {
        if (fichaTecnica == null) return;
        fichaTecnica.setRecetaId(recetaId);
        fichaTecnica.setCreatedBy(TenantContext.getUsuarioId());
        fichaTecnicaRepository.save(fichaTecnica);
    }

    private void sincronizarLabores(Long recetaId, List<RecetaLabor> labores) {
        recetaLaborRepository.deleteByRecetaId(recetaId);
        guardarLabores(recetaId, labores);
    }

    private void sincronizarConsumibles(Long recetaId, List<RecetaLaborConsumible> consumibles) {
        consumibleRepository.deleteByRecetaPadreId(recetaId);
        guardarConsumibles(recetaId, consumibles);
    }

    private void sincronizarFichaTecnica(Long recetaId, FichaTecnica fichaTecnica) {
        fichaTecnicaRepository.deleteByRecetaId(recetaId);
        guardarFichaTecnica(recetaId, fichaTecnica);
    }

    // ───────────────────────── helpers validacion ─────────────────────────

    private void normalizar(Receta entity) {
        if (entity.getNroReceta() != null) {
            entity.setNroReceta(entity.getNroReceta().trim().toUpperCase());
        }
        if (entity.getNombre() != null) {
            entity.setNombre(entity.getNombre().trim());
        }
    }

    private void validateUniqueNroReceta(String nroReceta, Long excludeId) {
        boolean exists = (excludeId == null)
                ? recetaRepository.existsByNroRecetaIgnoreCase(nroReceta)
                : recetaRepository.existsByNroRecetaIgnoreCaseAndIdNot(nroReceta, excludeId);
        if (exists) {
            log.warn("Intento de duplicar nro_receta: {}", nroReceta);
            throw new BusinessException(
                    "Ya existe una receta con número " + nroReceta,
                    HttpStatus.CONFLICT,
                    ProduccionErrorCodes.RECETA_CODIGO_DUPLICADO);
        }
    }

    private void validarArticuloProducido(Long articuloId) {
        try {
            var response = coreArticuloClient.obtenerPorId(articuloId);
            if (!response.isSuccess() || response.getData() == null
                    || !"1".equals(response.getData().getFlagEstado())) {
                log.warn("Articulo producido inexistente o inactivo: id={}", articuloId);
                throw new BusinessException("El articulo producido no existe o esta inactivo",
                        HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.RECETA_ARTICULO_INEXISTENTE);
            }
        } catch (FeignException e) {
            log.warn("Articulo producido inexistente o inactivo: id={}", articuloId);
            throw new BusinessException("El articulo producido no existe o esta inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.RECETA_ARTICULO_INEXISTENTE);
        }
    }

    private void validarLabor(Long laborId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.labor WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", laborId)
                .getSingleResult();
        if (count == null || count == 0) {
            log.warn("Labor inexistente o inactiva: id={}", laborId);
            throw new BusinessException(
                    "La labor no existe o esta inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ProduccionErrorCodes.RECETA_LABOR_INEXISTENTE);
        }
    }

    private void validarArticuloConsumible(Long articuloId) {
        try {
            var response = coreArticuloClient.obtenerPorId(articuloId);
            if (!response.isSuccess() || response.getData() == null
                    || !"1".equals(response.getData().getFlagEstado())) {
                log.warn("Artículo consumible inexistente o inactivo: id={}", articuloId);
                throw new BusinessException("El artículo consumible no existe o está inactivo",
                        HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.RECETA_HIJA_INEXISTENTE);
            }
        } catch (FeignException e) {
            log.warn("Artículo consumible inexistente o inactivo: id={}", articuloId);
            throw new BusinessException("El artículo consumible no existe o está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.RECETA_HIJA_INEXISTENTE);
        }
    }

    private void validarSinProgramacionesActivas(Long recetaId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.programacion_produccion WHERE receta_id = :id AND flag_estado = '1'")
                .setParameter("id", recetaId)
                .getSingleResult();
        if (count != null && count > 0) {
            log.warn("Receta {} tiene {} programaciones activas, no se puede desactivar", recetaId, count);
            throw new BusinessException(
                    "No se puede desactivar la receta porque tiene " + count + " programacion(es) de produccion activa(s)",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ProduccionErrorCodes.RECETA_PROGRAMACIONES_ACTIVAS);
        }
    }

    private BigDecimal calcularCostoTotal(Receta receta) {
        BigDecimal mo = Optional.ofNullable(receta.getCostoManoObra()).orElse(BigDecimal.ZERO);
        BigDecimal ci = Optional.ofNullable(receta.getCostoIndirecto()).orElse(BigDecimal.ZERO);
        return mo.add(ci);
    }

    private Specification<Receta> buildSpecification(String nroReceta, String nombre, String flagTipoReceta,
                                                     String flagEstado, Long articuloProducidoId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (nroReceta != null && !nroReceta.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("nroReceta")), "%" + nroReceta.trim().toUpperCase() + "%"));
            }
            if (nombre != null && !nombre.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("nombre")), "%" + nombre.trim().toUpperCase() + "%"));
            }
            if (flagTipoReceta != null && !flagTipoReceta.isBlank()) {
                predicates.add(cb.equal(root.get("flagTipoReceta"), flagTipoReceta));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            if (articuloProducidoId != null) {
                predicates.add(cb.equal(root.get("articuloProducidoId"), articuloProducidoId));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
