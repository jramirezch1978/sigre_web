package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ProformaRequest;
import pe.restaurant.ventas.entity.Proforma;

public interface ProformaService {

    Page<Proforma> findAll(Long sucursalId, Long clienteId, String numero, Pageable pageable);

    Proforma findById(Long id);

    Proforma create(ProformaRequest request);

    Proforma update(Long id, ProformaRequest request);

    Proforma anular(Long id);

    Proforma marcarVencida(Long id);

    Proforma marcarConvertida(Long id);
}
