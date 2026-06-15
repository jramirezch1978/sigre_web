package com.sigre.finanzas.service;

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
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.ProgramacionPagoDetalleRequest;
import com.sigre.finanzas.dto.request.ProgramacionPagoRequest;
import com.sigre.finanzas.dto.response.EjecucionProgramacionResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoDetalleResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoListResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.Pago;
import com.sigre.finanzas.entity.ProgramacionPago;
import com.sigre.finanzas.entity.ProgramacionPagoDet;
import com.sigre.finanzas.mapper.ProgramacionPagoDetMapper;
import com.sigre.finanzas.mapper.ProgramacionPagoMapper;
import com.sigre.finanzas.repository.CntasPagarRepository;
import com.sigre.finanzas.repository.PagoRepository;
import com.sigre.finanzas.repository.ProgramacionPagoRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProgramacionPagoService {

    private static final String FLAG_ESTADO_ACTIVO = "1";
    private static final String FLAG_ESTADO_CERRADO = "2";
    private static final String FLAG_ESTADO_ANULADO = "0";

    private final ProgramacionPagoRepository repository;
    private final CntasPagarRepository cntasPagarRepository;
    private final PagoRepository pagoRepository;
    private final ProgramacionPagoMapper mapper;
    private final ProgramacionPagoDetMapper detMapper;
    private final CoreMaestrosClient coreMaestrosClient;

    @Transactional(readOnly = true)
    public Page<ProgramacionPagoListResponse> listar(LocalDate fechaDesde, LocalDate fechaHasta, String estado, Pageable pageable) {
        Page<ProgramacionPago> page = repository.buscarConFiltros(fechaDesde, fechaHasta, estado, pageable);
        return page.map(mapper::toListResponse);
    }

    @Transactional(readOnly = true)
    public ProgramacionPagoResponse obtenerPorId(Long id) {
        ProgramacionPago entity = buscarPorId(id);
        ProgramacionPagoResponse response = mapper.toResponse(entity);
        
        if (response.getDetalles() != null && !response.getDetalles().isEmpty()) {
            for (ProgramacionPagoDetalleResponse detalle : response.getDetalles()) {
                enriquecerDetalleConDatosCxP(detalle);
            }
        }
        
        return response;
    }

    @Transactional
    public ProgramacionPagoResponse crear(ProgramacionPagoRequest request) {
        validarRequest(request);
        
        Long usuarioId = TenantContext.getUsuarioId();
        
        ProgramacionPago entity = mapper.toEntity(request);
        entity.setFlagEstado(FLAG_ESTADO_ACTIVO);
        entity.setCreatedBy(usuarioId);
        
        ProgramacionPago saved = repository.save(entity);
        
        for (ProgramacionPagoDetalleRequest detalleReq : request.getDetalles()) {
            validarDetalle(detalleReq);
            
            ProgramacionPagoDet detalle = detMapper.toEntity(detalleReq);
            detalle.setCreatedBy(usuarioId);
            saved.addDetalle(detalle);
        }
        
        repository.save(saved);
        
        return mapper.toResponse(saved);
    }

    @Transactional
    public ProgramacionPagoResponse actualizar(Long id, ProgramacionPagoRequest request) {
        ProgramacionPago entity = buscarPorId(id);
        
        validarEstadoParaEdicion(entity);
        validarRequest(request);
        
        Long usuarioId = TenantContext.getUsuarioId();
        
        mapper.updateEntity(entity, request);
        entity.setUpdatedBy(usuarioId);
        
        entity.clearDetalles();
        
        for (ProgramacionPagoDetalleRequest detalleReq : request.getDetalles()) {
            validarDetalle(detalleReq);
            
            ProgramacionPagoDet detalle = detMapper.toEntity(detalleReq);
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            entity.addDetalle(detalle);
        }
        
        repository.save(entity);
        
        return mapper.toResponse(entity);
    }

    @Transactional
    public EjecucionProgramacionResponse ejecutar(Long id) {
        ProgramacionPago entity = buscarPorId(id);
        
        validarEstadoParaEjecucion(entity);
        
        Long usuarioId = TenantContext.getUsuarioId();
        List<Pago> pagosGenerados = new ArrayList<>();
        BigDecimal totalPagado = BigDecimal.ZERO;
        
        try {
            for (ProgramacionPagoDet detalle : entity.getDetalles()) {
                if (!FLAG_ESTADO_ACTIVO.equals(detalle.getFlagEstado())) {
                    continue;
                }
                
                CntasPagar cxp = cntasPagarRepository.findById(detalle.getCntasPagarId())
                    .orElseThrow(() -> new BusinessException(
                        "Cuenta por pagar no encontrada: " + detalle.getCntasPagarId(),
                        HttpStatus.NOT_FOUND,
                        "FIN-VALIDACION"
                    ));
                
                validarSaldoSuficiente(cxp, detalle.getMontoProgramado());
                
                Pago pago = new Pago();
                pago.setCntasPagarId(detalle.getCntasPagarId());
                pago.setFecha(LocalDate.now());
                pago.setMonto(detalle.getMontoProgramado());
                pago.setReferencia("Programación de pago #" + id);
                pago.setFlagEstado(FLAG_ESTADO_ACTIVO);
                pago.setCreatedBy(usuarioId);
                pago.setUpdatedBy(usuarioId);
                
                Pago pagoGuardado = pagoRepository.save(pago);
                pagosGenerados.add(pagoGuardado);
                
                BigDecimal nuevoSaldo = cxp.getSaldo().subtract(detalle.getMontoProgramado());
                cxp.setSaldo(nuevoSaldo);
                cxp.setUpdatedBy(usuarioId);
                
                if (nuevoSaldo.compareTo(BigDecimal.ZERO) == 0) {
                    cxp.setFlagEstado("5");
                }
                
                cntasPagarRepository.save(cxp);
                
                totalPagado = totalPagado.add(detalle.getMontoProgramado());
            }
            
            entity.setFlagEstado(FLAG_ESTADO_CERRADO);
            entity.setUpdatedBy(usuarioId);
            repository.save(entity);
            
            EjecucionProgramacionResponse response = new EjecucionProgramacionResponse();
            response.setId(entity.getId());
            response.setPagosGenerados(pagosGenerados.size());
            response.setTotalPagado(totalPagado);
            response.setFlagEstado(entity.getFlagEstado());
            response.setUpdatedBy(entity.getUpdatedBy());
            response.setFecModificacion(entity.getFecModificacion());
            
            return response;
            
        } catch (Exception e) {
            log.error("Error al ejecutar programación de pago {}: {}", id, e.getMessage(), e);
            throw new BusinessException(
                "Error al ejecutar la programación de pago: " + e.getMessage(),
                HttpStatus.INTERNAL_SERVER_ERROR,
                "FIN-ERROR_EJECUCION"
            );
        }
    }

    @Transactional
    public ProgramacionPagoResponse anular(Long id) {
        ProgramacionPago entity = buscarPorId(id);
        
        validarEstadoParaAnulacion(entity);
        
        Long usuarioId = TenantContext.getUsuarioId();
        
        entity.setFlagEstado(FLAG_ESTADO_ANULADO);
        entity.setUpdatedBy(usuarioId);
        
        repository.save(entity);
        
        return mapper.toResponse(entity);
    }

    private ProgramacionPago buscarPorId(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("ProgramacionPago", id));
    }

    private void validarRequest(ProgramacionPagoRequest request) {
        if (request.getFechaProgramada() == null) {
            throw new BusinessException(
                "La fecha programada es obligatoria",
                HttpStatus.BAD_REQUEST,
                "VALIDATION_ERROR"
            );
        }
        
        if (request.getDetalles() == null || request.getDetalles().isEmpty()) {
            throw new BusinessException(
                "Debe incluir al menos un detalle",
                HttpStatus.BAD_REQUEST,
                "VALIDATION_ERROR"
            );
        }
    }

    private void validarDetalle(ProgramacionPagoDetalleRequest detalle) {
        if (detalle.getCntasPagarId() == null) {
            throw new BusinessException(
                "La cuenta por pagar es obligatoria en el detalle",
                HttpStatus.BAD_REQUEST,
                "VALIDATION_ERROR"
            );
        }
        
        if (detalle.getMontoProgramado() == null || detalle.getMontoProgramado().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                "El monto programado debe ser mayor a cero",
                HttpStatus.BAD_REQUEST,
                "VALIDATION_ERROR"
            );
        }
        
        CntasPagar cxp = cntasPagarRepository.findById(detalle.getCntasPagarId())
            .orElseThrow(() -> new BusinessException(
                "Cuenta por pagar no encontrada: " + detalle.getCntasPagarId(),
                HttpStatus.NOT_FOUND,
                "RESOURCE_NOT_FOUND"
            ));
        
        if (!FLAG_ESTADO_ACTIVO.equals(cxp.getFlagEstado())) {
            throw new BusinessException(
                "La cuenta por pagar " + detalle.getCntasPagarId() + " no está activa",
                HttpStatus.UNPROCESSABLE_ENTITY,
                "FIN-VALIDACION"
            );
        }
        
        validarSaldoSuficiente(cxp, detalle.getMontoProgramado());
    }

    private void validarSaldoSuficiente(CntasPagar cxp, BigDecimal montoProgramado) {
        if (cxp.getSaldo().compareTo(montoProgramado) < 0) {
            throw new BusinessException(
                String.format("El monto programado (%.2f) excede el saldo pendiente (%.2f) de la CxP %d",
                    montoProgramado, cxp.getSaldo(), cxp.getId()),
                HttpStatus.UNPROCESSABLE_ENTITY,
                "FIN-SALDO_INVALIDO"
            );
        }
    }

    private void validarEstadoParaEdicion(ProgramacionPago entity) {
        if (!FLAG_ESTADO_ACTIVO.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se puede actualizar una programación activa",
                HttpStatus.CONFLICT,
                "FIN-ESTADO_INVALIDO"
            );
        }
    }

    private void validarEstadoParaEjecucion(ProgramacionPago entity) {
        if (!FLAG_ESTADO_ACTIVO.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se puede ejecutar una programación activa",
                HttpStatus.CONFLICT,
                "FIN-ESTADO_INVALIDO"
            );
        }
    }

    private void validarEstadoParaAnulacion(ProgramacionPago entity) {
        if (FLAG_ESTADO_CERRADO.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "No se puede anular una programación que ya fue ejecutada",
                HttpStatus.CONFLICT,
                "FIN-CONFLICT"
            );
        }
    }

    private void enriquecerDetalleConDatosCxP(ProgramacionPagoDetalleResponse detalle) {
        if (detalle.getCntasPagarId() == null) {
            return;
        }
        
        try {
            CntasPagar cxp = cntasPagarRepository.findById(detalle.getCntasPagarId()).orElse(null);
            if (cxp != null) {
                detalle.setSerie(cxp.getSerie());
                detalle.setNumero(cxp.getNumero());
                detalle.setTotalCxP(cxp.getTotal());
                detalle.setSaldoCxP(cxp.getSaldo());
                
                try {
                    var entidadResponse = coreMaestrosClient.obtenerEntidadPorId(cxp.getProveedorId());
                    if (entidadResponse != null && entidadResponse.getData() != null) {
                        detalle.setProveedorRazonSocial(entidadResponse.getData().getRazonSocial());
                    }
                } catch (Exception e) {
                    log.warn("No se pudo obtener datos del proveedor {}: {}", cxp.getProveedorId(), e.getMessage());
                }
                
                try {
                    var docTipoResponse = coreMaestrosClient.obtenerDocTipoPorId(cxp.getDocTipoId());
                    if (docTipoResponse != null && docTipoResponse.getData() != null) {
                        detalle.setDocTipoCodigo(docTipoResponse.getData().getCodigo());
                    }
                } catch (Exception e) {
                    log.warn("No se pudo obtener datos del tipo de documento {}: {}", cxp.getDocTipoId(), e.getMessage());
                }
            }
        } catch (Exception e) {
            log.warn("Error al enriquecer detalle con datos de CxP {}: {}", detalle.getCntasPagarId(), e.getMessage());
        }
    }
}
