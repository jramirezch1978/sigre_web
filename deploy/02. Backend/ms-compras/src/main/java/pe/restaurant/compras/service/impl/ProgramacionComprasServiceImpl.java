package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.ProgramacionCompras;
import pe.restaurant.compras.entity.ProgramacionComprasDet;
import pe.restaurant.compras.mapper.ProgramacionComprasMapper;
import pe.restaurant.compras.repository.ProgramacionComprasRepository;
import pe.restaurant.compras.service.ProgramacionComprasService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProgramacionComprasServiceImpl implements ProgramacionComprasService {

    private static final String NOMBRE_TABLA_DOCUMENTO = "compras.prog_compras";

    private final ProgramacionComprasRepository repository;
    private final ProgramacionComprasMapper mapper;
    private final NumeradorDocumentoService numeradorDocumentoService;

    @Timed(value = "app.db.query", extraTags = {"table", "prog_compras", "operation", "listar"})
    @Override
    public Page<ProgramacionComprasResponse> listar(Integer anio, Integer mes, String flagEstado, Pageable pageable) {
        Specification<ProgramacionCompras> spec = Specification.allOf();

        if (anio != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("anio"), anio));
        }
        if (mes != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("mes"), mes));
        }
        if (flagEstado != null && !flagEstado.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("flagEstado"), flagEstado));
        }

        Long sucursalId = TenantContext.getSucursalId();
        if (sucursalId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("sucursalId"), sucursalId));
        }

        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "prog_compras", "operation", "obtener"})
    @Override
    public ProgramacionComprasDetalleResponse obtener(Long id) {
        return mapper.toDetalleResponse(buscar(id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "prog_compras", "operation", "crear"})
    @Override
    @Transactional
    public ProgramacionComprasDetalleResponse crear(ProgramacionComprasRequest request) {
        ProgramacionCompras entity = new ProgramacionCompras();
        entity.setAnio(request.getAnio());
        entity.setMes(request.getMes());
        entity.setSucursalId(TenantContext.getSucursalId());
        entity.setFlagEstado("1");
        entity.setCreatedBy(TenantContext.getUsuarioId());

        entity.setNroProgramacion(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO, entity.getSucursalId(), request.getAnio()));

        for (ProgramacionComprasDetRequest lr : request.getLineas()) {
            ProgramacionComprasDet det = mapper.toDetEntity(lr);
            det.setCreatedBy(TenantContext.getUsuarioId());
            entity.addLinea(det);
        }

        ProgramacionCompras saved = repository.save(entity);
        return mapper.toDetalleResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "prog_compras", "operation", "actualizar"})
    @Override
    @Transactional
    public ProgramacionComprasDetalleResponse actualizar(Long id, ProgramacionComprasRequest request) {
        ProgramacionCompras entity = buscar(id);

        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede editar una programación activa",
                    HttpStatus.CONFLICT, "COM-300");
        }

        entity.setAnio(request.getAnio());
        entity.setMes(request.getMes());
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        entity.getLineas().clear();
        for (ProgramacionComprasDetRequest lr : request.getLineas()) {
            ProgramacionComprasDet det = mapper.toDetEntity(lr);
            det.setCreatedBy(TenantContext.getUsuarioId());
            entity.addLinea(det);
        }

        ProgramacionCompras saved = repository.save(entity);
        return mapper.toDetalleResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "prog_compras", "operation", "confirmar"})
    @Override
    @Transactional
    public ProgramacionComprasDetalleResponse confirmar(Long id) {
        ProgramacionCompras entity = buscar(id);

        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede confirmar una programación activa",
                    HttpStatus.CONFLICT, "COM-301");
        }

        entity.setFlagEstado("2");
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        return mapper.toDetalleResponse(repository.save(entity));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "prog_compras", "operation", "anular"})
    @Override
    @Transactional
    public ProgramacionComprasDetalleResponse anular(Long id) {
        ProgramacionCompras entity = buscar(id);

        if ("0".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "La programación ya se encuentra anulada",
                    HttpStatus.CONFLICT, "COM-302");
        }

        if ("2".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede anular una programación cerrada",
                    HttpStatus.CONFLICT, "COM-303");
        }

        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        return mapper.toDetalleResponse(repository.save(entity));
    }

    private ProgramacionCompras buscar(Long id) {
        ProgramacionCompras entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ProgramacionCompras", id));
        entity.getLineas().size();
        return entity;
    }
}
