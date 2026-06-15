package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ProformaRequest;
import com.sigre.comercializacion.entity.Proforma;

public interface ProformaService {

    Page<Proforma> findAll(Long sucursalId, Long clienteId, String numero, Pageable pageable);

    Proforma findById(Long id);

    Proforma create(ProformaRequest request);

    Proforma update(Long id, ProformaRequest request);

    Proforma anular(Long id);

    Proforma marcarVencida(Long id);

    Proforma marcarConvertida(Long id);
}
