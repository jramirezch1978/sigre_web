package com.sigre.compras.service.impl;

import io.micrometer.core.annotation.Timed;
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
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.compras.dto.ContratoMarcoRequest;
import com.sigre.compras.dto.ContratoMarcoResponse;
import com.sigre.compras.dto.OrdenCompraContratoResponse;
import com.sigre.compras.entity.ContratoMarco;
import com.sigre.compras.entity.EntidadContribuyenteRef;
import com.sigre.compras.entity.OrdenCompra;
import com.sigre.compras.mapper.ContratoMarcoMapper;
import com.sigre.compras.repository.ContratoMarcoRepository;
import com.sigre.compras.repository.EntidadContribuyenteRefRepository;
import com.sigre.compras.repository.OrdenCompraRepository;
import com.sigre.compras.service.ContratoMarcoService;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ContratoMarcoServiceImpl implements ContratoMarcoService {

    private final ContratoMarcoRepository contratoMarcoRepository;
    private final ContratoMarcoMapper contratoMarcoMapper;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final OrdenCompraRepository ordenCompraRepository;

    @Override
    @Timed(value = "contrato_marco.listar")
    public Page<ContratoMarcoResponse> listar(Long proveedorId, String flagEstado,
                                                  LocalDate vigenteEn, Pageable pageable) {
        Specification<ContratoMarco> spec = Specification.allOf();

        if (proveedorId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("proveedorId"), proveedorId));
        }
        if (flagEstado != null && !flagEstado.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("flagEstado"), flagEstado));
        }
        if (vigenteEn != null) {
            spec = spec.and((root, q, cb) -> cb.and(
                    cb.lessThanOrEqualTo(root.get("fechaInicio"), vigenteEn),
                    cb.or(cb.isNull(root.get("fechaFin")),
                          cb.greaterThanOrEqualTo(root.get("fechaFin"), vigenteEn))));
        }

        return contratoMarcoRepository.findAll(spec, pageable).map(this::toResponse);
    }

    @Override
    @Timed(value = "contrato_marco.obtener")
    public ContratoMarcoResponse obtener(Long id) {
        return toResponse(buscar(id));
    }

    @Override
    @Transactional
    @Timed(value = "contrato_marco.crear")
    public ContratoMarcoResponse crear(ContratoMarcoRequest request) {
        validarProveedorExiste(request.getProveedorId());

        ContratoMarco contrato = contratoMarcoMapper.toEntity(request);
        contrato.setFlagEstado("1");
        contrato.setCreatedBy(TenantContext.getUsuarioId());

        Long sucursalId = TenantContext.getSucursalId();
        int anio = LocalDate.now().getYear();
        contrato.setNroContrato(numeradorDocumentoService.siguienteNroDocumento("compras.contrato_marco", sucursalId, anio));

        ContratoMarco saved = contratoMarcoRepository.save(contrato);
        log.info("Contrato marco {} creado por usuario {}", saved.getNroContrato(), TenantContext.getUsuarioId());
        return toResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "contrato_marco.actualizar")
    public ContratoMarcoResponse actualizar(Long id, ContratoMarcoRequest request) {
        ContratoMarco contrato = buscar(id);

        if (!"1".equals(contrato.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede editar un contrato activo",
                    HttpStatus.CONFLICT, "CTM-002");
        }

        validarProveedorExiste(request.getProveedorId());
        contratoMarcoMapper.updateEntity(request, contrato);
        contrato.setUpdatedBy(TenantContext.getUsuarioId());

        ContratoMarco saved = contratoMarcoRepository.save(contrato);
        log.info("Contrato marco {} actualizado por usuario {}", saved.getNroContrato(), TenantContext.getUsuarioId());
        return toResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "contrato_marco.suspender")
    public ContratoMarcoResponse suspender(Long id, String motivo) {
        ContratoMarco contrato = buscar(id);

        if (!"1".equals(contrato.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede suspender un contrato activo",
                    HttpStatus.CONFLICT, "CTM-003");
        }

        contrato.setFlagEstado("0");
        contrato.setCondiciones(appendMotivo(contrato.getCondiciones(), "SUSPENDIDO", motivo));
        contrato.setUpdatedBy(TenantContext.getUsuarioId());

        ContratoMarco saved = contratoMarcoRepository.save(contrato);
        log.info("Contrato marco {} suspendido por usuario {}", saved.getNroContrato(), TenantContext.getUsuarioId());
        return toResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "contrato_marco.reabrir")
    public ContratoMarcoResponse reabrir(Long id, String motivo) {
        ContratoMarco contrato = buscar(id);

        if (!"0".equals(contrato.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede reabrir un contrato suspendido",
                    HttpStatus.CONFLICT, "CTM-004");
        }

        contrato.setFlagEstado("1");
        contrato.setCondiciones(appendMotivo(contrato.getCondiciones(), "REABIERTO", motivo));
        contrato.setUpdatedBy(TenantContext.getUsuarioId());

        ContratoMarco saved = contratoMarcoRepository.save(contrato);
        log.info("Contrato marco {} reabierto por usuario {}", saved.getNroContrato(), TenantContext.getUsuarioId());
        return toResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "contrato_marco.cerrar")
    public ContratoMarcoResponse cerrar(Long id, String motivo) {
        ContratoMarco contrato = buscar(id);

        if ("0".equals(contrato.getFlagEstado()) || "2".equals(contrato.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede cerrar un contrato anulado o cerrado",
                    HttpStatus.CONFLICT, "CTM-005");
        }

        contrato.setFlagEstado("2");
        contrato.setCondiciones(appendMotivo(contrato.getCondiciones(), "CERRADO", motivo));
        contrato.setUpdatedBy(TenantContext.getUsuarioId());

        ContratoMarco saved = contratoMarcoRepository.save(contrato);
        log.info("Contrato marco {} cerrado por usuario {}", saved.getNroContrato(), TenantContext.getUsuarioId());
        return toResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "contrato_marco.anular")
    public ContratoMarcoResponse anular(Long id, String motivo) {
        ContratoMarco contrato = buscar(id);

        if ("0".equals(contrato.getFlagEstado())) {
            throw new BusinessException(
                    "El contrato ya se encuentra anulado",
                    HttpStatus.CONFLICT, "CTM-006");
        }

        contrato.setFlagEstado("0");
        contrato.setCondiciones(appendMotivo(contrato.getCondiciones(), "ANULADO", motivo));
        contrato.setUpdatedBy(TenantContext.getUsuarioId());

        ContratoMarco saved = contratoMarcoRepository.save(contrato);
        log.info("Contrato marco {} anulado por usuario {}", saved.getNroContrato(), TenantContext.getUsuarioId());
        return toResponse(saved);
    }

    private String appendMotivo(String existing, String accion, String motivo) {
        if (motivo == null || motivo.isBlank()) return existing;
        String entry = "[" + accion + "] " + motivo;
        return existing != null ? existing + "\n" + entry : entry;
    }

    @Override
    @Timed(value = "contrato_marco.por_vencer")
    public Page<ContratoMarcoResponse> porVencer(Integer dias, Long proveedorId, Pageable pageable) {
        LocalDate limite = LocalDate.now().plusDays(dias != null ? dias : 30);

        Specification<ContratoMarco> spec = (root, q, cb) -> {
            var predicates = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
            predicates.add(cb.equal(root.get("flagEstado"), "1"));
            predicates.add(cb.isNotNull(root.get("fechaFin")));
            predicates.add(cb.lessThanOrEqualTo(root.get("fechaFin"), limite));
            predicates.add(cb.greaterThanOrEqualTo(root.get("fechaFin"), LocalDate.now()));
            if (proveedorId != null) {
                predicates.add(cb.equal(root.get("proveedorId"), proveedorId));
            }
            return cb.and(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };

        return contratoMarcoRepository.findAll(spec, pageable).map(this::toResponse);
    }

    @Override
    public List<OrdenCompraContratoResponse> ocGeneradas(Long id) {
        ContratoMarco cm = buscar(id);

        Specification<OrdenCompra> spec = (root, q, cb) -> {
            var predicates = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
            predicates.add(cb.equal(root.get("proveedorId"), cm.getProveedorId()));
            predicates.add(cb.equal(root.get("flagEstado"), "1"));
            if (cm.getFechaInicio() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaEmision"), cm.getFechaInicio()));
            }
            if (cm.getFechaFin() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaEmision"), cm.getFechaFin()));
            }
            return cb.and(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };

        return ordenCompraRepository.findAll(spec).stream()
                .map(oc -> OrdenCompraContratoResponse.builder()
                        .id(oc.getId())
                        .nroOrdenCompra(oc.getNroOrdenCompra())
                        .fechaEmision(oc.getFechaEmision())
                        .total(oc.getTotal())
                        .flagEstado(oc.getFlagEstado())
                        .build())
                .collect(java.util.stream.Collectors.toList());
    }

    private ContratoMarco buscar(Long id) {
        return contratoMarcoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ContratoMarco", id));
    }

    private void validarProveedorExiste(Long proveedorId) {
        EntidadContribuyenteRef proveedor = entidadContribuyenteRefRepository.findById(proveedorId)
                .orElseThrow(() -> new BusinessException(
                        "Proveedor con id " + proveedorId + " no existe o está inactivo",
                        HttpStatus.UNPROCESSABLE_ENTITY, "CTM-010"));
        if (!"1".equals(proveedor.getFlagEstado())) {
            throw new BusinessException(
                    "Proveedor con id " + proveedorId + " no existe o está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, "CTM-010");
        }
    }

    private ContratoMarcoResponse toResponse(ContratoMarco c) {
        EntidadContribuyenteRef prov = c.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(c.getProveedorId()).orElse(null)
                : null;

        return ContratoMarcoResponse.builder()
                .id(c.getId())
                .proveedorId(c.getProveedorId())
                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                .proveedorRuc(prov != null ? prov.getNroDocumento() : null)
                .numero(c.getNroContrato())
                .fechaInicio(c.getFechaInicio())
                .fechaFin(c.getFechaFin())
                .condiciones(c.getCondiciones())
                .flagEstado(c.getFlagEstado())
                .createdBy(c.getCreatedBy())
                .fecCreacion(c.getFecCreacion())
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(c.getFecModificacion())
                .build();
    }
}
