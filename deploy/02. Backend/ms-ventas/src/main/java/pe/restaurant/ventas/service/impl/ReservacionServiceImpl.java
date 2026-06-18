package pe.restaurant.ventas.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.ReservacionCancelRequest;
import pe.restaurant.ventas.dto.request.ReservacionRequest;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.entity.Reservacion;
import pe.restaurant.ventas.entity.ReservacionDet;
import pe.restaurant.ventas.repository.ArticuloRepository;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.repository.ReservacionRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;
import pe.restaurant.ventas.service.ReservacionService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.ventas.specification.ReservacionSpecifications;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ReservacionServiceImpl implements ReservacionService {

    public static final String ESTADO_CONFIRMADA = "CONFIRMADA";
    public static final String ESTADO_CANCELADA = "CANCELADA";

    private final ReservacionRepository repository;
    private final VentasFkValidator fkValidator;
    private final MesaRepository mesaRepository;
    private final ArticuloRepository articuloRepository;

    @Override
    public Page<Reservacion> findAll(Long sucursalId, Long clienteId, Long mesaId, String estado,
                                    LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        return repository.findAll(
                ReservacionSpecifications.filtered(sucursalId, clienteId, mesaId, estado, fechaDesde, fechaHasta),
                pageable);
    }

    @Override
    public Reservacion getById(Long id) {
        return repository.findDetailById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reservacion", id));
    }

    @Override
    @Transactional
    public Reservacion create(ReservacionRequest request) {
        Long uid = requireUsuario();
        Reservacion r = new Reservacion();
        r.setEstado(ESTADO_CONFIRMADA);
        r.setFlagEstado("1");
        r.setCreatedBy(uid);
        applyCabecera(r, request, uid);
        validarFechaHoraNoPasada(r.getFecha(), r.getHora());
        validarSolapeMesa(r.getMesaId(), r.getFecha(), r.getHora(), null);
        validarCapacidadMesa(r.getMesaId(), r.getComensales());
        return repository.save(r);
    }

    @Override
    @Transactional
    public Reservacion update(Long id, ReservacionRequest request) {
        Long uid = requireUsuario();
        Reservacion r = getById(id);
        assertConfirmadaParaEdicion(r);
        applyCabecera(r, request, uid);
        validarFechaHoraNoPasada(r.getFecha(), r.getHora());
        validarSolapeMesa(r.getMesaId(), r.getFecha(), r.getHora(), r.getId());
        validarCapacidadMesa(r.getMesaId(), r.getComensales());
        r.setUpdatedBy(uid);
        return repository.save(r);
    }

    @Override
    @Transactional
    public Reservacion confirmar(Long id) {
        Long uid = requireUsuario();
        Reservacion r = getById(id);
        if (ESTADO_CANCELADA.equalsIgnoreCase(r.getEstado())) {
            throw new BusinessException("No se puede confirmar una reservación cancelada",
                    HttpStatus.CONFLICT, VentasErrorCodes.RESERVACION_STATE);
        }
        r.setEstado(ESTADO_CONFIRMADA);
        r.setUpdatedBy(uid);
        return repository.save(r);
    }

    @Override
    @Transactional
    public Reservacion cancelar(Long id, ReservacionCancelRequest request) {
        Long uid = requireUsuario();
        Reservacion r = getById(id);
        assertConfirmadaParaEdicion(r);
        r.setEstado(ESTADO_CANCELADA);
        r.setMotivoCancelacion(request != null ? request.getMotivo() : null);
        r.setUpdatedBy(uid);
        return repository.save(r);
    }

    @Override
    @Transactional
    public Reservacion activar(Long id) {
        Reservacion r = getById(id);
        r.setFlagEstado("1");
        r.setUpdatedBy(requireUsuario());
        return repository.save(r);
    }

    @Override
    @Transactional
    public Reservacion desactivar(Long id) {
        Reservacion r = getById(id);
        r.setFlagEstado("0");
        r.setUpdatedBy(requireUsuario());
        return repository.save(r);
    }

    private void assertConfirmadaParaEdicion(Reservacion r) {
        if (!ESTADO_CONFIRMADA.equalsIgnoreCase(r.getEstado())) {
            throw new BusinessException("Solo se permite en estado CONFIRMADA",
                    HttpStatus.CONFLICT, VentasErrorCodes.RESERVACION_STATE);
        }
    }

    private void applyCabecera(Reservacion r, ReservacionRequest request, Long uid) {
        Long sucursalId = request.getSucursalId() != null ? request.getSucursalId() : TenantContext.getSucursalId();
        r.setSucursalId(sucursalId);
        if (sucursalId != null && !fkValidator.existsSucursalActiva(sucursalId)) {
            throw new BusinessException("Sucursal no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_FK);
        }
        if (request.getClienteId() != null && !fkValidator.existsEntidadContribuyenteActiva(request.getClienteId())) {
            throw new BusinessException("Cliente no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_FK);
        }
        r.setClienteId(request.getClienteId());
        if (request.getMesaId() != null && !fkValidator.existsMesaActiva(request.getMesaId())) {
            throw new BusinessException("Mesa no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_FK);
        }
        r.setMesaId(request.getMesaId());
        if (request.getFsFacturaSimplId() != null && !fkValidator.existsFsFacturaSimplNoAnulada(request.getFsFacturaSimplId())) {
            throw new BusinessException("Comprobante simplificado no válido o anulado",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_FK);
        }
        r.setFsFacturaSimplId(request.getFsFacturaSimplId());
        r.setFecha(request.getFecha());
        r.setHora(request.getHora());
        r.setComensales(request.getComensales());
        r.setObservaciones(request.getObservaciones());

        r.getItems().clear();
        if (request.getItems() != null) {
            Instant now = Instant.now();
            for (ReservacionRequest.ReservacionItemRequest it : request.getItems()) {
                if (it.getArticuloId() != null && !articuloRepository.existsByIdAndFlagEstado(it.getArticuloId(), "1")) {
                    throw new BusinessException("Artículo no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_FK);
                }
                ReservacionDet d = new ReservacionDet();
                d.setReservacion(r);
                d.setArticuloId(it.getArticuloId());
                d.setCantidad(it.getCantidad());
                d.setObservacion(it.getObservacion());
                d.setCreatedBy(uid);
                d.setFecCreacion(now);
                r.getItems().add(d);
            }
        }
    }

    private void validarFechaHoraNoPasada(LocalDate fecha, LocalTime hora) {
        LocalDateTime dt = LocalDateTime.of(fecha, hora);
        if (dt.isBefore(LocalDateTime.now())) {
            throw new BusinessException("La fecha y hora de reservación no pueden estar en el pasado",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_VALIDATION);
        }
    }

    private void validarSolapeMesa(Long mesaId, LocalDate fecha, LocalTime hora, Long excludeId) {
        if (mesaId == null) {
            return;
        }
        long n = repository.countSolapeMesaFechaHora(mesaId, fecha, hora, excludeId);
        if (n > 0) {
            throw new BusinessException("Ya existe una reservación confirmada para la misma mesa, fecha y hora",
                    HttpStatus.CONFLICT, VentasErrorCodes.RESERVACION_MESA_OCUPADA);
        }
    }

    private void validarCapacidadMesa(Long mesaId, Integer comensales) {
        if (mesaId == null || comensales == null) {
            return;
        }
        Mesa mesa = mesaRepository.findById(mesaId).orElse(null);
        if (mesa != null && mesa.getCapacidad() != null && comensales > mesa.getCapacidad()) {
            throw new BusinessException("Los comensales superan la capacidad de la mesa",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_VALIDATION);
        }
    }

    private static Long requireUsuario() {
        Long uid = TenantContext.getUsuarioId();
        if (uid == null) {
            throw new BusinessException("Usuario no disponible en el contexto",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.RESERVACION_VALIDATION);
        }
        return uid;
    }
}
