package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.EntidadCreditosCxcRequest;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;

public interface EntidadCreditosCxcService {

    Page<EntidadCreditosCxc> findAll(Long entidadContribuyenteId, Long monedaId, String flagEstado, Pageable pageable);

    EntidadCreditosCxc findById(Long id);

    EntidadCreditosCxc create(EntidadCreditosCxcRequest request);

    EntidadCreditosCxc update(Long id, EntidadCreditosCxcRequest request);

    EntidadCreditosCxc activar(Long id);

    EntidadCreditosCxc desactivar(Long id);

    void delete(Long id);
}
