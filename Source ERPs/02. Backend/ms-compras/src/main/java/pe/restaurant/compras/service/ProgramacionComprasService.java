package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.dto.ProgramacionComprasDetalleResponse;
import pe.restaurant.compras.dto.ProgramacionComprasRequest;
import pe.restaurant.compras.dto.ProgramacionComprasResponse;

public interface ProgramacionComprasService {

    Page<ProgramacionComprasResponse> listar(Integer anio, Integer mes, String flagEstado, Pageable pageable);

    ProgramacionComprasDetalleResponse obtener(Long id);

    ProgramacionComprasDetalleResponse crear(ProgramacionComprasRequest request);

    ProgramacionComprasDetalleResponse actualizar(Long id, ProgramacionComprasRequest request);

    ProgramacionComprasDetalleResponse confirmar(Long id);

    ProgramacionComprasDetalleResponse anular(Long id);
}
