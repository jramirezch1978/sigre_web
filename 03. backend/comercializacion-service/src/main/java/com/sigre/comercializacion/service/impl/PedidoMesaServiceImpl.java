package com.sigre.comercializacion.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.PedidoMesaRequest;
import com.sigre.comercializacion.dto.response.PedidoMesaResponse;
import com.sigre.comercializacion.entity.Mesa;
import com.sigre.comercializacion.entity.PedidoMesa;
import com.sigre.comercializacion.repository.MesaRepository;
import com.sigre.comercializacion.repository.PedidoMesaRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;
import com.sigre.comercializacion.specification.PedidoMesaSpecifications;
import com.sigre.comercializacion.service.PedidoMesaService;
import com.sigre.comercializacion.service.VentasErrorCodes;

import java.time.Instant;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PedidoMesaServiceImpl implements PedidoMesaService {

    private final PedidoMesaRepository pedidoMesaRepository;
    private final MesaRepository mesaRepository;
    private final VentasFkValidator fkValidator;

    @Override
    public Page<PedidoMesa> findAll(Long sucursalId, Long mesaId, Long meseroId, Long turnoId, String flagEstado, Pageable pageable) {
        Long sid = sucursalId != null ? sucursalId : TenantContext.getSucursalId();
        return pedidoMesaRepository.findAll(
                PedidoMesaSpecifications.filtered(sid, mesaId, meseroId, turnoId, flagEstado),
                pageable);
    }

    @Override
    public PedidoMesaResponse getById(Long id) {
        return toResponse(load(id));
    }

    @Override
    @Transactional
    public PedidoMesaResponse create(PedidoMesaRequest request) {
        Long usuarioId = requireUsuario();
        Long sucursalId = resolveSucursalId(request.getSucursalId());

        String numero = request.getNumero().trim();
        if (pedidoMesaRepository.existsByNumeroAndFlagEstado(numero, "1")) {
            throw new BusinessException("Número de pedido duplicado", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_DUPLICATE_NUMERO);
        }

        Mesa mesaEntity = null;
        if (request.getMesaId() != null) {
            mesaEntity = mesaRepository.findByIdWithRelations(request.getMesaId())
                    .orElseThrow(() -> new ResourceNotFoundException("Mesa", request.getMesaId()));
            validateMesaSucursal(mesaEntity, sucursalId);
            if (pedidoMesaRepository.existsByMesa_IdAndFlagEstado(request.getMesaId(), "1")) {
                throw new BusinessException("La mesa ya tiene un pedido activo", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_MESA_ABIERTA);
            }
        }

        PedidoMesa p = new PedidoMesa();
        p.setSucursalId(sucursalId);
        p.setTipo(request.getTipo().trim().toUpperCase());
        p.setMesa(mesaEntity);
        p.setMeseroId(request.getMeseroId());
        p.setTurnoId(request.getTurnoId());
        p.setNumero(numero);
        p.setComensales(request.getComensales());
        p.setApertura(request.getApertura() != null ? request.getApertura() : Instant.now());
        p.setCierre(request.getCierre());
        p.setObservaciones(request.getObservaciones());
        p.setCreatedBy(usuarioId);
        p.setFlagEstado("1");

        return toResponse(pedidoMesaRepository.save(p));
    }

    @Override
    @Transactional
    public PedidoMesaResponse update(Long id, PedidoMesaRequest request) {
        Long usuarioId = requireUsuario();
        PedidoMesa p = load(id);
        requireActivo(p);

        if (!"1".equals(p.getFlagEstado())) {
            throw new BusinessException("Solo se puede editar un pedido activo", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_STATE);
        }

        Long sucursalId = resolveSucursalId(request.getSucursalId());
        if (p.getSucursalId() != null && !Objects.equals(p.getSucursalId(), sucursalId)) {
            throw new BusinessException("sucursalId inconsistente", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_FK);
        }

        String numero = request.getNumero().trim();
        if (pedidoMesaRepository.existsByNumeroAndFlagEstadoAndIdNot(numero, "1", id)) {
            throw new BusinessException("Número de pedido duplicado", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_DUPLICATE_NUMERO);
        }

        Long oldMesaId = p.getMesa() != null ? p.getMesa().getId() : null;
        Long newMesaId = request.getMesaId();

        if (!Objects.equals(oldMesaId, newMesaId)) {
            if (oldMesaId != null) {
                mesaRepository.findByIdWithRelations(oldMesaId).ifPresent(m -> {
                    m.setUpdatedBy(usuarioId);
                    mesaRepository.save(m);
                });
            }
            Mesa nueva = null;
            if (newMesaId != null) {
                nueva = mesaRepository.findByIdWithRelations(newMesaId)
                        .orElseThrow(() -> new ResourceNotFoundException("Mesa", newMesaId));
                validateMesaSucursal(nueva, sucursalId);
                if (pedidoMesaRepository.existsByMesa_IdAndFlagEstadoAndIdNot(newMesaId, "1", id)) {
                    throw new BusinessException("La mesa ya tiene un pedido activo", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_MESA_ABIERTA);
                }
            }
            p.setMesa(nueva);
        }

        p.setSucursalId(sucursalId);
        p.setTipo(request.getTipo().trim().toUpperCase());
        p.setMeseroId(request.getMeseroId());
        p.setTurnoId(request.getTurnoId());
        p.setNumero(numero);
        p.setComensales(request.getComensales());
        if (request.getApertura() != null) {
            p.setApertura(request.getApertura());
        }
        p.setObservaciones(request.getObservaciones());
        p.setUpdatedBy(usuarioId);

        return toResponse(pedidoMesaRepository.save(p));
    }

    @Override
    @Transactional
    public PedidoMesaResponse cerrar(Long id) {
        Long usuarioId = requireUsuario();
        PedidoMesa p = load(id);
        requireActivo(p);
        p.setFlagEstado("2");
        p.setCierre(Instant.now());
        p.setUpdatedBy(usuarioId);
        return toResponse(pedidoMesaRepository.save(p));
    }

    @Override
    @Transactional
    public PedidoMesaResponse anular(Long id) {
        Long usuarioId = requireUsuario();
        PedidoMesa p = load(id);
        if ("2".equals(p.getFlagEstado()) || "0".equals(p.getFlagEstado())) {
            throw new BusinessException("El pedido ya está cerrado o anulado", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_STATE);
        }
        p.setFlagEstado("0");
        p.setUpdatedBy(usuarioId);
        return toResponse(pedidoMesaRepository.save(p));
    }

    @Override
    @Transactional
    public PedidoMesaResponse activate(Long id) {
        Long usuarioId = requireUsuario();
        PedidoMesa p = load(id);
        p.setFlagEstado("1");
        p.setUpdatedBy(usuarioId);
        return toResponse(pedidoMesaRepository.save(p));
    }

    @Override
    @Transactional
    public PedidoMesaResponse deactivate(Long id) {
        Long usuarioId = requireUsuario();
        PedidoMesa p = load(id);
        p.setFlagEstado("0");
        p.setUpdatedBy(usuarioId);
        return toResponse(pedidoMesaRepository.save(p));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        deactivate(id);
    }

    private PedidoMesa load(Long id) {
        return pedidoMesaRepository.findByIdWithRelations(id)
                .orElseThrow(() -> new ResourceNotFoundException("PedidoMesa", id));
    }

    private void requireActivo(PedidoMesa p) {
        if (!"1".equals(p.getFlagEstado())) {
            throw new BusinessException("Pedido inactivo", HttpStatus.CONFLICT, VentasErrorCodes.PEDIDO_MESA_STATE);
        }
    }

    private void validateMesaSucursal(Mesa mesa, Long sucursalId) {
        if (sucursalId == null || mesa.getZona() == null || mesa.getZona().getSucursal() == null) {
            return;
        }
        if (!Objects.equals(mesa.getZona().getSucursal().getId(), sucursalId)) {
            throw new BusinessException("La mesa no pertenece a la sucursal del contexto", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.PEDIDO_MESA_FK);
        }
    }

    private Long resolveSucursalId(Long requested) {
        Long ctx = TenantContext.getSucursalId();
        if (requested == null) {
            if (ctx == null) {
                throw new BusinessException("sucursalId requerido", HttpStatus.BAD_REQUEST, VentasErrorCodes.PEDIDO_MESA_FK);
            }
            return ctx;
        }
        if (ctx != null && !ctx.equals(requested)) {
            throw new BusinessException("sucursalId no coincide con el token", HttpStatus.FORBIDDEN, VentasErrorCodes.PEDIDO_MESA_FK);
        }
        if (!fkValidator.existsSucursalActiva(requested)) {
            throw new BusinessException("Sucursal no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.PEDIDO_MESA_FK);
        }
        return requested;
    }

    private Long requireUsuario() {
        Long uid = TenantContext.getUsuarioId();
        if (uid == null) {
            throw new BusinessException("Usuario no resoluble desde el token", HttpStatus.UNAUTHORIZED, VentasErrorCodes.PEDIDO_MESA_FK);
        }
        return uid;
    }

    private PedidoMesaResponse toResponse(PedidoMesa p) {
        return PedidoMesaResponse.builder()
                .id(p.getId())
                .sucursalId(p.getSucursalId())
                .tipo(p.getTipo())
                .mesaId(p.getMesa() != null ? p.getMesa().getId() : null)
                .mesaNumero(p.getMesa() != null ? p.getMesa().getNumero() : null)
                .meseroId(p.getMeseroId())
                .turnoId(p.getTurnoId())
                .numero(p.getNumero())
                .comensales(p.getComensales())
                .apertura(p.getApertura())
                .cierre(p.getCierre())
                .observaciones(p.getObservaciones())
                .flagEstado(p.getFlagEstado())
                .createdBy(p.getCreatedBy())
                .fecCreacion(p.getFecCreacion())
                .updatedBy(p.getUpdatedBy())
                .fecModificacion(p.getFecModificacion())
                .build();
    }
}
