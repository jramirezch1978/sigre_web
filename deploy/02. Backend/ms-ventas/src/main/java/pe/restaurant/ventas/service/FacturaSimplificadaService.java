package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.FacturaSimplCabeceraRequest;
import pe.restaurant.ventas.dto.response.FacturaSimplPagoResponse;
import pe.restaurant.ventas.dto.response.FacturaSimplificadaResponse;
import pe.restaurant.ventas.entity.FsFacturaSimpl;

import java.time.LocalDate;
import java.util.List;

public interface FacturaSimplificadaService {

    Page<FsFacturaSimpl> findAll(Long sucursalId, Long clienteId, Long docTipoId, String serie, String numero,
                                 String flagEstado, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);

    FacturaSimplificadaResponse getById(Long id);

    FacturaSimplificadaResponse create(FacturaSimplCabeceraRequest request);

    FacturaSimplificadaResponse update(Long id, FacturaSimplCabeceraRequest request);

    FacturaSimplificadaResponse emitir(Long id);

    FacturaSimplificadaResponse anular(Long id);

    List<FacturaSimplPagoResponse> listPagos(Long id);

    FacturaSimplificadaResponse activate(Long id);

    FacturaSimplificadaResponse deactivate(Long id);

    void delete(Long id);
}
