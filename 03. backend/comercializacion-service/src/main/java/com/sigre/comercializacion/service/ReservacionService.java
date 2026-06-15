package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ReservacionCancelRequest;
import com.sigre.comercializacion.dto.request.ReservacionRequest;
import com.sigre.comercializacion.entity.Reservacion;

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
