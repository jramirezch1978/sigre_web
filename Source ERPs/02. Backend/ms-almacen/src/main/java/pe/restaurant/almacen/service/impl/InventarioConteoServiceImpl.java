package pe.restaurant.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.dto.InventarioConteoRequest;
import pe.restaurant.almacen.dto.InventarioConteoResponse;
import pe.restaurant.almacen.entity.InventarioConteo;
import pe.restaurant.almacen.repository.AlmacenRepository;
import pe.restaurant.almacen.repository.InventarioConteoRepository;
import pe.restaurant.almacen.repository.LotePalletRepository;
import pe.restaurant.almacen.repository.UbicacionAlmacenRepository;
import pe.restaurant.almacen.service.InventarioConteoService;
import pe.restaurant.almacen.spec.InventarioConteoSpecifications;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InventarioConteoServiceImpl implements InventarioConteoService {

    private final InventarioConteoRepository repository;
    private final AlmacenRepository almacenRepository;
    private final LotePalletRepository lotePalletRepository;
    private final UbicacionAlmacenRepository ubicacionAlmacenRepository;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public Page<InventarioConteoResponse> buscar(Long almacenId,
                                                 Long articuloId,
                                                 String estado,
                                                 LocalDate fechaDesde,
                                                 LocalDate fechaHasta,
                                                 Pageable pageable) {
        return repository.findAll(
                        InventarioConteoSpecifications.conFiltros(
                                almacenId, articuloId, estado, fechaDesde, fechaHasta),
                        pageable)
                .map(this::toResponse);
    }

    @Override
    public InventarioConteoResponse obtener(Long id) {
        return toResponse(repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("InventarioConteo", id)));
    }

    @Override
    @Transactional
    public InventarioConteoResponse crear(InventarioConteoRequest request) {
        validarFks(request);
        InventarioConteo e = map(request, new InventarioConteo());
        if (e.getNroConteo() == null) {
            e.setNroConteo(1);
        }
        return toResponse(repository.save(e));
    }

    @Override
    @Transactional
    public InventarioConteoResponse actualizar(Long id, InventarioConteoRequest request) {
        InventarioConteo existing = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("InventarioConteo", id));
        if ("2".equals(existing.getFlagEstado()) || "0".equals(existing.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede modificar un conteo cerrado o anulado.",
                    HttpStatus.CONFLICT, "ALM-INV-002");
        }
        validarFks(request);
        InventarioConteo mapped = map(request, existing);
        return toResponse(repository.save(mapped));
    }

    @Override
    @Transactional
    public InventarioConteoResponse comparar(Long id) {
        InventarioConteo e = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("InventarioConteo", id));
        if (!"1".equals(e.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede comparar un conteo activo.",
                    HttpStatus.CONFLICT,
                    "ALM-INV-006");
        }
        if (e.getSaldoSistema() == null) {
            throw new BusinessException(
                    "Se requiere saldo sistema para comparar.",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "ALM-INV-007");
        }
        BigDecimal cantidad = e.getCantidadConteo2() != null ? e.getCantidadConteo2() : e.getCantidadConteo1();
        if (cantidad == null) {
            throw new BusinessException(
                    "Se requiere cantidad conteo 1 o cantidad conteo 2 para comparar.",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "ALM-INV-008");
        }
        e.setDiferencia(cantidad.subtract(e.getSaldoSistema()));
        return toResponse(repository.save(e));
    }

    @Override
    @Transactional
    public InventarioConteoResponse cerrar(Long id) {
        InventarioConteo e = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("InventarioConteo", id));
        if (!"1".equals(e.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede cerrar un conteo activo.",
                    HttpStatus.CONFLICT,
                    "ALM-INV-009");
        }
        e.setFlagEstado("2");
        return toResponse(repository.save(e));
    }

    @Override
    @Transactional
    public InventarioConteoResponse anular(Long id) {
        InventarioConteo e = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("InventarioConteo", id));
        if ("2".equals(e.getFlagEstado()) || "0".equals(e.getFlagEstado())) {
            throw new BusinessException(
                    "El conteo ya está cerrado o anulado.",
                    HttpStatus.CONFLICT,
                    "ALM-INV-010");
        }
        e.setFlagEstado("0");
        return toResponse(repository.save(e));
    }

    private void validarFks(InventarioConteoRequest request) {
        if (!almacenRepository.existsById(request.getAlmacenId())) {
            throw new ResourceNotFoundException("Almacen", request.getAlmacenId());
        }
        assertArticuloExiste(request.getArticuloId());
        if (request.getLotePalletId() != null && !lotePalletRepository.existsById(request.getLotePalletId())) {
            throw new ResourceNotFoundException("LotePallet", request.getLotePalletId());
        }
        if (request.getUbicacionId() != null
                && ubicacionAlmacenRepository.findById(request.getUbicacionId()).isEmpty()) {
            throw new ResourceNotFoundException("UbicacionAlmacen", request.getUbicacionId());
        }
        if (request.getUbicacionId() != null) {
            ubicacionAlmacenRepository.findById(request.getUbicacionId()).ifPresent(u -> {
                if (!u.getAlmacenId().equals(request.getAlmacenId())) {
                    throw new BusinessException("La ubicación no pertenece al almacén indicado.",
                            HttpStatus.UNPROCESSABLE_ENTITY, "ALM-INV-001");
                }
            });
        }
    }

    private void assertArticuloExiste(Long articuloId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.articulo WHERE id = ?", Integer.class, articuloId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Articulo", articuloId);
        }
    }

    private InventarioConteo map(InventarioConteoRequest r, InventarioConteo e) {
        e.setAlmacenId(r.getAlmacenId());
        e.setArticuloId(r.getArticuloId());
        e.setFechaConteo(r.getFechaConteo());
        if (r.getNroConteo() != null) {
            e.setNroConteo(r.getNroConteo());
        }
        e.setSaldoSistema(r.getSaldoSistema());
        e.setCantidadConteo1(r.getCantidadConteo1());
        e.setAuditorConteo1(r.getAuditorConteo1());
        e.setNroFichaConteo1(r.getNroFichaConteo1());
        e.setCantidadConteo2(r.getCantidadConteo2());
        e.setAuditorConteo2(r.getAuditorConteo2());
        e.setNroFichaConteo2(r.getNroFichaConteo2());
        e.setCostoUnitario(r.getCostoUnitario());
        e.setDiferencia(r.getDiferencia());
        e.setValeMovAjusteId(r.getValeMovAjusteId());
        e.setLotePalletId(r.getLotePalletId());
        e.setUbicacionId(r.getUbicacionId());
        e.setUsuarioId(r.getUsuarioId());
        return e;
    }

    private InventarioConteoResponse toResponse(InventarioConteo e) {
        return InventarioConteoResponse.builder()
                .id(e.getId())
                .almacenId(e.getAlmacenId())
                .articuloId(e.getArticuloId())
                .fechaConteo(e.getFechaConteo())
                .nroConteo(e.getNroConteo())
                .saldoSistema(e.getSaldoSistema())
                .cantidadConteo1(e.getCantidadConteo1())
                .auditorConteo1(e.getAuditorConteo1())
                .nroFichaConteo1(e.getNroFichaConteo1())
                .cantidadConteo2(e.getCantidadConteo2())
                .auditorConteo2(e.getAuditorConteo2())
                .nroFichaConteo2(e.getNroFichaConteo2())
                .costoUnitario(e.getCostoUnitario())
                .diferencia(e.getDiferencia())
                .valeMovAjusteId(e.getValeMovAjusteId())
                .lotePalletId(e.getLotePalletId())
                .ubicacionId(e.getUbicacionId())
                .usuarioId(e.getUsuarioId())
                .flagEstado(e.getFlagEstado())
                .build();
    }
}
