package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import io.micrometer.core.annotation.Timed;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.GanDescFijoEstadoRequest;
import com.sigre.rrhh.dto.request.GanDescFijoRequest;
import com.sigre.rrhh.entity.GanDescFijo;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.GanDescFijoRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.GanDescFijoService;
import com.sigre.rrhh.service.RrhhErrorCodes;

import java.math.BigDecimal;
import java.time.Instant;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class GanDescFijoServiceImpl implements GanDescFijoService {

    private final GanDescFijoRepository repository;
    private final TrabajadorRepository trabajadorRepo;
    private final ConceptoPlanillaRepository conceptoPlanillaRepo;

    @Override
    @Transactional(readOnly = true)
    public Page<GanDescFijo> listar(Long trabajadorId, Long conceptoId, String flagEstado, Pageable pageable) {
        return repository.findWithFilters(trabajadorId, conceptoId, flagEstado, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public GanDescFijo obtenerPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Ganancia/Descuento Fijo no encontrado con ID: " + id,
                        HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND"));
    }

    @Override
    @Timed("rrhh.ganDescFijo.crear")
public GanDescFijo crear(GanDescFijoRequest request) {
        validarTrabajadorActivo(request.getTrabajadorId());
        validarConceptoExiste(request.getConceptoId());
        validarImporteOPorcentaje(request.getImpGanDesc(), request.getPorcentaje());
        validarNoDuplicadoActivo(request.getTrabajadorId(), request.getConceptoId());

        GanDescFijo entity = new GanDescFijo();
        entity.setTrabajadorId(request.getTrabajadorId());
        entity.setConceptoId(request.getConceptoId());
        entity.setImpGanDesc(request.getImpGanDesc());
        entity.setPorcentaje(request.getPorcentaje());
        entity.setImpMaxGanDesc(request.getImpMaxGanDesc());
        entity.setFlagEstado(request.getFlagEstado() != null ? request.getFlagEstado() : "1");
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());

        GanDescFijo saved = repository.save(entity);
        log.info("GanDescFijo creado con ID: {}", saved.getId());
        return saved;
    }

    @Override
    @Timed("rrhh.ganDescFijo.actualizar")
public GanDescFijo actualizar(Long id, GanDescFijoRequest request) {
        GanDescFijo existing = obtenerPorId(id);
        validarTrabajadorActivo(request.getTrabajadorId());
        validarConceptoExiste(request.getConceptoId());
        validarImporteOPorcentaje(request.getImpGanDesc(), request.getPorcentaje());

        existing.setTrabajadorId(request.getTrabajadorId());
        existing.setConceptoId(request.getConceptoId());
        existing.setImpGanDesc(request.getImpGanDesc());
        existing.setPorcentaje(request.getPorcentaje());
        existing.setImpMaxGanDesc(request.getImpMaxGanDesc());
        if (request.getFlagEstado() != null) {
            existing.setFlagEstado(request.getFlagEstado());
        }
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());

        GanDescFijo saved = repository.save(existing);
        log.info("GanDescFijo actualizado con ID: {}", saved.getId());
        return saved;
    }

    @Override
    @Timed("rrhh.ganDescFijo.cambiarEstado")
public GanDescFijo cambiarEstado(Long id, GanDescFijoEstadoRequest request) {
        GanDescFijo existing = obtenerPorId(id);
        existing.setFlagEstado(request.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());

        GanDescFijo saved = repository.save(existing);
        log.info("GanDescFijo {} con ID: {}",
                "1".equals(request.getFlagEstado()) ? "activado" : "inactivado", id);
        return saved;
    }

    private void validarTrabajadorActivo(Long trabajadorId) {
        var trabajador = trabajadorRepo.findById(trabajadorId)
                .orElseThrow(() -> new BusinessException(
                        "El trabajador con ID " + trabajadorId + " no existe.",
                        HttpStatus.UNPROCESSABLE_ENTITY, RrhhErrorCodes.GF_TRABAJADOR_OBLIGATORIO));
        if (!"1".equals(trabajador.getFlagEstado())) {
            throw new BusinessException(
                    "El trabajador con ID " + trabajadorId + " no está activo.",
                    HttpStatus.UNPROCESSABLE_ENTITY, RrhhErrorCodes.GF_TRABAJADOR_OBLIGATORIO);
        }
    }

    private void validarConceptoExiste(Long conceptoId) {
        if (!conceptoPlanillaRepo.existsById(conceptoId)) {
            throw new BusinessException(
                    "El concepto de planilla con ID " + conceptoId + " no existe.",
                    HttpStatus.UNPROCESSABLE_ENTITY, RrhhErrorCodes.GF_CONCEPTO_OBLIGATORIO);
        }
    }

    private void validarImporteOPorcentaje(BigDecimal impGanDesc, BigDecimal porcentaje) {
        if ((impGanDesc == null || impGanDesc.compareTo(BigDecimal.ZERO) == 0)
                && (porcentaje == null || porcentaje.compareTo(BigDecimal.ZERO) == 0)) {
            throw new BusinessException(
                    "Debe indicar un importe fijo o un porcentaje.",
                    HttpStatus.UNPROCESSABLE_ENTITY, RrhhErrorCodes.GF_IMPORTE_O_PORCENTAJE_REQUERIDO);
        }
    }

    private void validarNoDuplicadoActivo(Long trabajadorId, Long conceptoId) {
        if (repository.existsByTrabajadorIdAndConceptoIdAndFlagEstado(trabajadorId, conceptoId, "1")) {
            throw new BusinessException(
                    "Ya existe una ganancia/descuento fijo activo para este trabajador y concepto.",
                    HttpStatus.CONFLICT, RrhhErrorCodes.GF_DUPLICADO_ACTIVO);
        }
    }
}
