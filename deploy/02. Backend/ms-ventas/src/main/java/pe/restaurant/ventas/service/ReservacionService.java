package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ReservacionCancelRequest;
import pe.restaurant.ventas.dto.request.ReservacionRequest;
import pe.restaurant.ventas.entity.Reservacion;

public interface ReservacionService {

    Page<Reservacion> findAll(Long sucursalId, Long clienteId, Long mesaId, String estado,
                              java.time.LocalDate fechaDesde, java.time.LocalDate fechaHasta, Pageable pageable);

    Reservacion getById(Long id);

    Reservacion create(ReservacionRequest request);

    Reservacion update(Long id, ReservacionRequest request);

    Reservacion confirmar(Long id);

    Reservacion cancelar(Long id, ReservacionCancelRequest request);

    Reservacion activar(Long id);

    Reservacion desactivar(Long id);
}
