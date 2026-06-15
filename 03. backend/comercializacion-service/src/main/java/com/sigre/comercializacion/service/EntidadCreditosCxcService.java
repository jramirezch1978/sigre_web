package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.EntidadCreditosCxcRequest;
import com.sigre.comercializacion.entity.EntidadCreditosCxc;

public interface EntidadCreditosCxcService {

    Page<EntidadCreditosCxc> findAll(Long entidadContribuyenteId, Long monedaId, String flagEstado, Pageable pageable);

    EntidadCreditosCxc findById(Long id);

    EntidadCreditosCxc create(EntidadCreditosCxcRequest request);

    EntidadCreditosCxc update(Long id, EntidadCreditosCxcRequest request);

    EntidadCreditosCxc activar(Long id);

    EntidadCreditosCxc desactivar(Long id);

    void delete(Long id);
}
