package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.InventarioConteoRequest;
import com.sigre.almacen.dto.InventarioConteoResponse;

import java.time.LocalDate;

public interface InventarioConteoService {

    Page<InventarioConteoResponse> buscar(Long almacenId,
                                          Long articuloId,
                                          String estado,
                                          LocalDate fechaDesde,
                                          LocalDate fechaHasta,
                                          Pageable pageable);

    InventarioConteoResponse obtener(Long id);

    InventarioConteoResponse crear(InventarioConteoRequest request);

    InventarioConteoResponse actualizar(Long id, InventarioConteoRequest request);

    /** Calcula {@code diferencia} = cantidad conteo − saldo sistema y pasa a {@code COMPARADO}. */
    InventarioConteoResponse comparar(Long id);

    /** Cierra el conteo ({@code COMPARADO} → {@code CERRADO}). */
    InventarioConteoResponse cerrar(Long id);

    /** Anula ({@code EN_PROCESO} o {@code COMPARADO} → {@code ANULADO}). */
    InventarioConteoResponse anular(Long id);
}
