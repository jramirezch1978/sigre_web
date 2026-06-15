package com.sigre.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.dto.ContratoMarcoRequest;
import com.sigre.compras.dto.ContratoMarcoResponse;
import com.sigre.compras.dto.OrdenCompraContratoResponse;

import java.util.List;

public interface ContratoMarcoService {

    Page<ContratoMarcoResponse> listar(Long proveedorId, String flagEstado,
                                       java.time.LocalDate vigenteEn, Pageable pageable);

    ContratoMarcoResponse obtener(Long id);

    ContratoMarcoResponse crear(ContratoMarcoRequest request);

    ContratoMarcoResponse actualizar(Long id, ContratoMarcoRequest request);

    ContratoMarcoResponse suspender(Long id, String motivo);

    ContratoMarcoResponse reabrir(Long id, String motivo);

    ContratoMarcoResponse cerrar(Long id, String motivo);

    ContratoMarcoResponse anular(Long id, String motivo);

    Page<ContratoMarcoResponse> porVencer(Integer dias, Long proveedorId, Pageable pageable);

    List<OrdenCompraContratoResponse> ocGeneradas(Long id);
}
