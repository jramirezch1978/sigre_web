package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.CierreCajaCerrarRequest;
import pe.restaurant.ventas.dto.request.CierreCajaRequest;
import pe.restaurant.ventas.entity.CierreCaja;

public interface CierreCajaService {

    Page<CierreCaja> findAll(Long turnoId, Boolean abierto, Pageable pageable);

    CierreCaja findById(Long id);

    CierreCaja create(CierreCajaRequest request);

    CierreCaja cerrar(Long id, CierreCajaCerrarRequest request);
}
