package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ServiciosCxCRequest;
import pe.restaurant.ventas.dto.response.ServiciosCxCResponse;
import pe.restaurant.ventas.entity.ServiciosCxC;

public interface ServiciosCxCService {

    Page<ServiciosCxC> findAll(Pageable pageable);

    // Método con filtros según contrato: codServicio, descServicio, codMoneda, flagEstado
    Page<ServiciosCxC> findAllWithFilters(String codServicio, String descServicio, String codMoneda, String flagEstado, Pageable pageable);

    ServiciosCxC findById(Long id);

    ServiciosCxC create(ServiciosCxC entity);

    ServiciosCxC update(Long id, ServiciosCxC entity);

    void delete(Long id);

    ServiciosCxC activate(Long id);

    ServiciosCxC deactivate(Long id);
}
