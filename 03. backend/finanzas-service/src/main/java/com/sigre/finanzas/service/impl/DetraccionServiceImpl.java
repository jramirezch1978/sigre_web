package com.sigre.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.finanzas.dto.request.DetraccionRequest;
import com.sigre.finanzas.dto.response.DetraccionResponse;
import com.sigre.finanzas.entity.Detraccion;
import com.sigre.finanzas.mapper.DetraccionMapper;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.repository.DetraccionRepository;
import com.sigre.finanzas.service.DetraccionService;
import com.sigre.finanzas.service.FinanzasErrorCodes;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DetraccionServiceImpl implements DetraccionService {

    private static final String FLAG_ESTADO_ACTIVO = "1";
    private static final String FLAG_ESTADO_INACTIVO = "0";
    private static final String NOMBRE_TABLA_DOCUMENTO = "finanzas.detraccion";

    private final DetraccionRepository repository;
    private final CntasPagarRepository cntasPagarRepository;
    private final DetraccionMapper mapper;
    private final NumeradorDocumentoService numeradorDocumentoService;

    @Override
    public Page<DetraccionResponse> listar(String nroDetraccion, Long cntasPagarId, 
                                           String flagEstado, Pageable pageable) {
        log.info("Listando detracciones - nro: {}, cxp: {}, estado: {}", 
                nroDetraccion, cntasPagarId, flagEstado);

        Specification<Detraccion> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (nroDetraccion != null && !nroDetraccion.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("nroDetraccion")), 
                        "%" + nroDetraccion.toLowerCase() + "%"));
            }
            if (cntasPagarId != null) {
                predicates.add(cb.equal(root.get("cntasPagarId"), cntasPagarId));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            } else {
                predicates.add(cb.equal(root.get("flagEstado"), FLAG_ESTADO_ACTIVO));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Detraccion> page = repository.findAll(spec, pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    public DetraccionResponse obtenerPorId(Long id) {
        log.info("Obteniendo detracción por ID: {}", id);

        Detraccion detraccion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Detracción", id));

        return mapper.toResponse(detraccion);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "detraccion", "operation", "create"})
    @Override
    @Transactional
    public DetraccionResponse crear(DetraccionRequest request) {
        log.info("Creando detracción");

        validarCuentaPorPagar(request.getCntasPagarId());

        Detraccion detraccion = mapper.toEntity(request);
        
        // Generar número automáticamente si no viene del request
        if (detraccion.getNroDetraccion() == null || detraccion.getNroDetraccion().isEmpty()) {
            Long sucursalId = TenantContext.getSucursalId();
            String nroDetraccion = numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO,
                sucursalId,
                LocalDate.now().getYear()
            );
            detraccion.setNroDetraccion(nroDetraccion);
            log.info("Número de detracción generado: {}", nroDetraccion);
        } else {
            validarUnicidad(detraccion.getNroDetraccion());
            log.info("Creando detracción con número proporcionado: {}", detraccion.getNroDetraccion());
        }
        
        detraccion.setFlagEstado(FLAG_ESTADO_ACTIVO);
        detraccion.setCreatedBy(TenantContext.getUsuarioId());
        asignarCodUsr(detraccion);

        Detraccion saved = repository.save(detraccion);
        log.info("Detracción creada con ID: {}", saved.getId());

        return mapper.toResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "detraccion", "operation", "update"})
    @Override
    @Transactional
    public DetraccionResponse actualizar(Long id, DetraccionRequest request) {
        log.info("Actualizando detracción ID: {}", id);

        Detraccion detraccion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Detracción", id));

        validarEstadoEditable(detraccion);
        validarCuentaPorPagar(request.getCntasPagarId());

        if (!detraccion.getNroDetraccion().equals(request.getNroDetraccion())) {
            validarUnicidad(request.getNroDetraccion());
        }

        detraccion.setCntasPagarId(request.getCntasPagarId());
        detraccion.setNroDetraccion(request.getNroDetraccion());
        detraccion.setFechaRegistro(request.getFechaRegistro());
        detraccion.setNroDeposito(request.getNroDeposito());
        detraccion.setFechaDeposito(request.getFechaDeposito());
        detraccion.setImporte(request.getImporte());
        detraccion.setOrgCajaBanc(request.getOrgCajaBanc());
        detraccion.setNroRegCajaBanc(request.getNroRegCajaBanc());
        detraccion.setTipoDocCxc(request.getTipoDocCxc());
        detraccion.setNroDocCxc(request.getNroDocCxc());
        detraccion.setUpdatedBy(TenantContext.getUsuarioId());

        Detraccion updated = repository.save(detraccion);
        log.info("Detracción actualizada: {}", id);

        return mapper.toResponse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "detraccion", "operation", "activar"})
    @Override
    @Transactional
    public DetraccionResponse activar(Long id) {
        log.info("Activando detracción ID: {}", id);

        Detraccion detraccion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Detracción", id));

        if (FLAG_ESTADO_ACTIVO.equals(detraccion.getFlagEstado())) {
            throw new BusinessException(
                    "La detracción ya está activa",
                    FinanzasErrorCodes.DETRACCION_ESTADO_INVALIDO);
        }

        detraccion.setFlagEstado(FLAG_ESTADO_ACTIVO);
        detraccion.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(detraccion);

        log.info("Detracción activada: {}", id);
        return mapper.toResponse(detraccion);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "detraccion", "operation", "desactivar"})
    @Override
    @Transactional
    public DetraccionResponse desactivar(Long id) {
        log.info("Desactivando detracción ID: {}", id);

        Detraccion detraccion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Detracción", id));

        if (FLAG_ESTADO_INACTIVO.equals(detraccion.getFlagEstado())) {
            throw new BusinessException(
                    "La detracción ya está inactiva",
                    FinanzasErrorCodes.DETRACCION_ESTADO_INVALIDO);
        }

        detraccion.setFlagEstado(FLAG_ESTADO_INACTIVO);
        detraccion.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(detraccion);

        log.info("Detracción desactivada: {}", id);
        return mapper.toResponse(detraccion);
    }

    private void validarUnicidad(String nroDetraccion) {
        if (repository.existsByNroDetraccionAndFlagEstado(nroDetraccion, FLAG_ESTADO_ACTIVO)) {
            throw new BusinessException(
                    "Ya existe una detracción activa con el número " + nroDetraccion,
                    FinanzasErrorCodes.DETRACCION_DUPLICADA);
        }
    }

    private void validarCuentaPorPagar(Long cntasPagarId) {
        if (cntasPagarId != null && !cntasPagarRepository.existsById(cntasPagarId)) {
            throw new BusinessException(
                    "La cuenta por pagar con ID " + cntasPagarId + " no existe. Verifique que la cuenta esté registrada.",
                    FinanzasErrorCodes.DOCUMENTO_DUPLICADO);
        }
    }

    private void validarEstadoEditable(Detraccion detraccion) {
        if (!FLAG_ESTADO_ACTIVO.equals(detraccion.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede actualizar una detracción inactiva",
                    FinanzasErrorCodes.DETRACCION_NO_EDITABLE);
        }
    }

    private void asignarCodUsr(Detraccion detraccion) {
        Long userId = TenantContext.getUsuarioId();
        String codUsr = String.valueOf(userId);
        if (codUsr.length() > 6) {
            codUsr = codUsr.substring(codUsr.length() - 6);
        }
        detraccion.setCodUsr(codUsr);
    }
}
