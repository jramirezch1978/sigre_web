package com.sigre.contabilidad.service;

import org.springframework.data.domain.Pageable;
import com.sigre.contabilidad.dto.request.AsientoDetalleRequest;
import com.sigre.contabilidad.dto.request.AsientoRequest;
import com.sigre.contabilidad.dto.request.AsientoSearchRequest;
import com.sigre.contabilidad.dto.response.AsientoResponse;
import com.sigre.contabilidad.dto.response.PageData;
import com.sigre.contabilidad.entity.CntblAsiento;

import java.util.List;

public interface AsientoService {
    
    CntblAsiento crear(AsientoRequest request);
    
    CntblAsiento obtenerPorId(Long id);
    
    CntblAsiento actualizar(Long id, AsientoRequest request);
    
    CntblAsiento anular(Long id);
    
    void validarAsientoBalanceado(List<AsientoDetalleRequest> detalles);
    
    void validarCuentasDetalle(List<AsientoDetalleRequest> detalles);

    PageData<AsientoResponse> buscar(AsientoSearchRequest request, Pageable pageable);
}
