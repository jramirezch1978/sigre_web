package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.OrdenTrasladoRequest;
import com.sigre.almacen.dto.OrdenTrasladoResponse;

import java.time.LocalDate;

public interface OrdenTrasladoOperacionService {

    Page<OrdenTrasladoResponse> buscar(Long almacenOrigenId,
                                       Long almacenDestinoId,
                                       String estado,
                                       LocalDate fechaDesde,
                                       LocalDate fechaHasta,
                                       Pageable pageable);

    OrdenTrasladoResponse obtener(Long id);

    OrdenTrasladoResponse crear(OrdenTrasladoRequest request);

    OrdenTrasladoResponse actualizar(Long id, OrdenTrasladoRequest request);

    OrdenTrasladoResponse cambiarEstado(Long id, String nuevoEstado);

    OrdenTrasladoResponse aprobar(Long id);

    OrdenTrasladoResponse rechazar(Long id);

    OrdenTrasladoResponse cerrar(Long id);

    OrdenTrasladoResponse anular(Long id);

    byte[] exportarExcel(Long almacenOrigenId,
                         Long almacenDestinoId,
                         String estado,
                         LocalDate fechaDesde,
                         LocalDate fechaHasta);

    byte[] generarPdf(Long id);
}
