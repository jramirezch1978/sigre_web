package pe.restaurant.contabilidad.service;

import org.springframework.data.domain.Pageable;
import pe.restaurant.contabilidad.dto.request.AsientoDetalleRequest;
import pe.restaurant.contabilidad.dto.request.AsientoRequest;
import pe.restaurant.contabilidad.dto.request.AsientoSearchRequest;
import pe.restaurant.contabilidad.dto.response.AsientoResponse;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.entity.CntblAsiento;

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
