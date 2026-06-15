package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.CierreCajaCerrarRequest;
import com.sigre.comercializacion.dto.request.CierreCajaRequest;
import com.sigre.comercializacion.entity.CierreCaja;

public interface CierreCajaService {

    Page<CierreCaja> findAll(Long turnoId, Boolean abierto, Pageable pageable);

    CierreCaja findById(Long id);

    CierreCaja create(CierreCajaRequest request);

    CierreCaja cerrar(Long id, CierreCajaCerrarRequest request);
}
