package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ServiciosCxCRequest;
import com.sigre.comercializacion.dto.response.ServiciosCxCResponse;
import com.sigre.comercializacion.entity.ServiciosCxC;

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
