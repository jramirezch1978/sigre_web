package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.ImpuestoRentaTramoCreateRequest;
import com.sigre.rrhh.dto.request.ImpuestoRentaTramoUpdateRequest;
import com.sigre.rrhh.dto.response.ImpuestoRentaTramoResponse;

import java.time.LocalDate;
import java.util.List;

public interface ImpuestoRentaTramoService {

    Page<ImpuestoRentaTramoResponse> listar(LocalDate fechaVigIni, Integer secuencia, String flagEstado, Pageable pageable);

    ImpuestoRentaTramoResponse obtenerPorId(Long id);

    ImpuestoRentaTramoResponse crear(ImpuestoRentaTramoCreateRequest request);

    ImpuestoRentaTramoResponse actualizar(Long id, ImpuestoRentaTramoUpdateRequest request);

    ImpuestoRentaTramoResponse desactivar(Long id);

    ImpuestoRentaTramoResponse activar(Long id);

    List<ImpuestoRentaTramoResponse> listarActivos();
}
