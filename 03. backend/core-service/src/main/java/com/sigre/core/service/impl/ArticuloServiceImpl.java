package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.core.dto.*;
import java.time.Instant;
import com.sigre.core.entity.Articulo;
import com.sigre.core.entity.ArticuloAlmacenConfig;
import com.sigre.core.entity.ArticuloImpuesto;
import com.sigre.core.entity.ArticuloProveedor;
import com.sigre.core.entity.TiposImpuesto;
import com.sigre.core.mapper.ArticuloAlmacenConfigMapper;
import com.sigre.core.mapper.ArticuloImpuestoMapper;
import com.sigre.core.mapper.ArticuloMapper;
import com.sigre.core.mapper.ArticuloProveedorMapper;
import com.sigre.core.repository.ArticuloAlmacenConfigRepository;
import com.sigre.core.repository.ArticuloCategRepository;
import com.sigre.core.repository.ArticuloImpuestoRepository;
import com.sigre.core.repository.ArticuloProveedorRepository;
import com.sigre.core.repository.ArticuloRepository;
import com.sigre.core.repository.ArticuloSubCategRepository;
import com.sigre.core.repository.RelacionComercialRepository;
import com.sigre.core.repository.TiposImpuestoRepository;
import com.sigre.core.repository.UnidadMedidaRepository;
import com.sigre.core.service.ArticuloService;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloServiceImpl implements ArticuloService {
    private final ArticuloRepository repository;
    private final ArticuloProveedorRepository proveedorRepository;
    private final ArticuloImpuestoRepository impuestoRepository;
    private final TiposImpuestoRepository tiposImpuestoRepository;
    private final ArticuloAlmacenConfigRepository almacenConfigRepository;
    private final UnidadMedidaRepository unidadMedidaRepository;
    private final ArticuloCategRepository articuloCategRepository;
    private final ArticuloSubCategRepository articuloSubCategRepository;
    private final RelacionComercialRepository relacionComercialRepository;
    private final JdbcTemplate jdbcTemplate;
    private final ArticuloMapper mapper;
    private final ArticuloProveedorMapper proveedorMapper;
    private final ArticuloImpuestoMapper impuestoMapper;
    private final ArticuloAlmacenConfigMapper almacenConfigMapper;

    private static final String IMPUESTO_DEFAULT = "IGV18";

    @Override
    public Page<Articulo> list(String codigo, String nombre, Long categoriaId, Pageable pageable) {
        return repository.findByCodigoContainingIgnoreCaseAndNombreContainingIgnoreCase(
                codigo == null ? "" : codigo,
                nombre == null ? "" : nombre,
                pageable
        );
    }

    @Override
    public ArticuloDetalleResponse getById(Long id) {
        Articulo entity = getEntity(id);
        ArticuloResponse base = mapper.toResponse(entity);
        ArticuloDetalleResponse response = new ArticuloDetalleResponse();
        response.setId(base.getId());
        response.setCodigo(base.getCodigo());
        response.setNombre(base.getNombre());
        response.setDescripcion(base.getDescripcion());
        response.setUnidadMedidaId(base.getUnidadMedidaId());
        response.setArticuloCategId(base.getArticuloCategId());
        response.setArticuloSubCategId(base.getArticuloSubCategId());
        response.setArticuloClaseId(base.getArticuloClaseId());
        response.setNaturalezaContableId(base.getNaturalezaContableId());
        response.setFlagEstado(base.getFlagEstado());
        response.setImpuestos(listImpuestos(id));
        return response;
    }

    @Override
    @Transactional
    public ArticuloResponse create(ArticuloRequest request) {
        if (repository.existsByCodigoIgnoreCase(request.getCodigo())) {
            throw new BusinessException("Ya existe un articulo con el mismo codigo", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        validateForeignKeys(request);
        Articulo entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Articulo saved = repository.save(entity);
        asignarImpuestoDefault(saved.getId());
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    public ArticuloResponse update(Long id, ArticuloRequest request) {
        Articulo entity = getEntity(id);
        if (repository.existsByCodigoIgnoreCaseAndIdNot(request.getCodigo(), id)) {
            throw new BusinessException("Ya existe un articulo con el mismo codigo", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        validateForeignKeys(request);
        mapper.updateEntity(request, entity);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando Articulo con id: {}", id);
        getEntity(id);
        repository.deleteById(id);
        log.info("Articulo eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo", "operation", "activate"})
    @Override
    @Transactional
    public Articulo activate(Long id) {
        log.info("Activando Articulo con id: {}", id);
        Articulo existing = getEntity(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo", "operation", "deactivate"})
    @Override
    @Transactional
    public Articulo deactivate(Long id) {
        log.info("Desactivando Articulo con id: {}", id);
        Articulo existing = getEntity(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Override
    public List<ArticuloProveedorResponse> listProveedores(Long articuloId) {
        getEntity(articuloId);
        return proveedorRepository.findByArticuloIdAndFlagEstado(articuloId, "1").stream()
                .map(proveedorMapper::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public ArticuloProveedorResponse createProveedor(Long articuloId, ArticuloProveedorRequest request) {
        getEntity(articuloId);
        if (!relacionComercialRepository.existsById(request.getProveedorId())) {
            throw new ResourceNotFoundException("Proveedor (RelacionComercial)", request.getProveedorId());
        }
        ArticuloProveedor entity = proveedorRepository.findByArticuloIdAndProveedorId(articuloId, request.getProveedorId())
                .orElseGet(ArticuloProveedor::new);
        boolean isNew = entity.getId() == null;
        entity.setArticuloId(articuloId);
        entity.setProveedorId(request.getProveedorId());
        entity.setFlagEstado("1");
        if (isNew) {
            entity.setCreatedBy(TenantContext.getUsuarioId());
            entity.setFecCreacion(Instant.now());
        } else {
            entity.setUpdatedBy(TenantContext.getUsuarioId());
            entity.setFecModificacion(Instant.now());
        }
        return proveedorMapper.toResponse(proveedorRepository.save(entity));
    }

    @Override
    public List<ArticuloAlmacenConfigResponse> listAlmacenesConfig(Long articuloId) {
        getEntity(articuloId);
        return almacenConfigRepository.findByArticuloId(articuloId).stream()
                .map(almacenConfigMapper::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public ArticuloAlmacenConfigResponse upsertAlmacenConfig(Long articuloId, ArticuloAlmacenConfigRequest request) {
        getEntity(articuloId);
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM almacen.almacen WHERE id = ?", Integer.class, request.getAlmacenId());
        if (count == null || count == 0) {
            throw new ResourceNotFoundException("Almacen", request.getAlmacenId());
        }
        ArticuloAlmacenConfig entity = almacenConfigRepository.findByArticuloIdAndAlmacenId(articuloId, request.getAlmacenId())
                .orElseGet(ArticuloAlmacenConfig::new);
        entity.setArticuloId(articuloId);
        entity.setAlmacenId(request.getAlmacenId());
        entity.setStockMin(request.getStockMin());
        entity.setStockMax(request.getStockMax());
        return almacenConfigMapper.toResponse(almacenConfigRepository.save(entity));
    }

    @Override
    public List<ArticuloImpuestoResponse> listImpuestos(Long articuloId) {
        getEntity(articuloId);
        return impuestoRepository.findByArticuloIdOrderByOrdenAsc(articuloId).stream()
                .map(this::toImpuestoResponse)
                .toList();
    }

    @Override
    @Transactional
    public ArticuloImpuestoResponse createImpuesto(Long articuloId, ArticuloImpuestoRequest request) {
        getEntity(articuloId);
        TiposImpuesto impuesto = tiposImpuestoRepository.findById(request.getTiposImpuestoId())
                .orElseThrow(() -> new ResourceNotFoundException("TiposImpuesto", request.getTiposImpuestoId()));

        ArticuloImpuesto entity = impuestoRepository
                .findByArticuloIdAndTiposImpuestoId(articuloId, request.getTiposImpuestoId())
                .orElseGet(ArticuloImpuesto::new);
        boolean isNew = entity.getId() == null;
        entity.setArticuloId(articuloId);
        entity.setTiposImpuestoId(impuesto.getId());
        entity.setOrden(request.getOrden() != null ? request.getOrden() : (short) 1);
        if (isNew) {
            entity.setCreatedBy(TenantContext.getUsuarioId());
            entity.setFecCreacion(Instant.now());
        } else {
            entity.setUpdatedBy(TenantContext.getUsuarioId());
            entity.setFecModificacion(Instant.now());
        }
        return toImpuestoResponse(impuestoRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteImpuesto(Long articuloId, Long impuestoId) {
        getEntity(articuloId);
        ArticuloImpuesto entity = impuestoRepository.findById(impuestoId)
                .filter(row -> articuloId.equals(row.getArticuloId()))
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloImpuesto", impuestoId));
        impuestoRepository.delete(entity);
    }

    private void asignarImpuestoDefault(Long articuloId) {
        tiposImpuestoRepository.findByTipoImpuesto(IMPUESTO_DEFAULT).ifPresent(impuesto -> {
            if (impuestoRepository.findByArticuloIdAndTiposImpuestoId(articuloId, impuesto.getId()).isEmpty()) {
                ArticuloImpuesto entity = new ArticuloImpuesto();
                entity.setArticuloId(articuloId);
                entity.setTiposImpuestoId(impuesto.getId());
                entity.setOrden((short) 1);
                entity.setCreatedBy(TenantContext.getUsuarioId());
                entity.setFecCreacion(Instant.now());
                impuestoRepository.save(entity);
            }
        });
    }

    private ArticuloImpuestoResponse toImpuestoResponse(ArticuloImpuesto entity) {
        TiposImpuesto impuesto = tiposImpuestoRepository.findById(entity.getTiposImpuestoId())
                .orElseThrow(() -> new ResourceNotFoundException("TiposImpuesto", entity.getTiposImpuestoId()));
        return impuestoMapper.toResponse(entity, impuesto);
    }

    private Articulo getEntity(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Articulo", id));
    }

    private void validateForeignKeys(ArticuloRequest request) {
        if (!unidadMedidaRepository.existsById(request.getUnidadMedidaId())) {
            throw new ResourceNotFoundException("UnidadMedida", request.getUnidadMedidaId());
        }
        if (request.getArticuloCategId() != null && !articuloCategRepository.existsById(request.getArticuloCategId())) {
            throw new ResourceNotFoundException("ArticuloCateg", request.getArticuloCategId());
        }
        if (request.getArticuloSubCategId() != null && !articuloSubCategRepository.existsById(request.getArticuloSubCategId())) {
            throw new ResourceNotFoundException("ArticuloSubCateg", request.getArticuloSubCategId());
        }
        if (request.getMarcaId() != null) {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM core.marca WHERE id = ?", Integer.class, request.getMarcaId());
            if (count == null || count == 0) {
                throw new ResourceNotFoundException("Marca", request.getMarcaId());
            }
        }
        if (request.getColorId() != null) {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM core.color WHERE id = ?", Integer.class, request.getColorId());
            if (count == null || count == 0) {
                throw new ResourceNotFoundException("Color", request.getColorId());
            }
        }
    }
}
