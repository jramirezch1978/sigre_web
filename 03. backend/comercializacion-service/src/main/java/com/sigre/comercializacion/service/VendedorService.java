package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.VendedorRequest;
import com.sigre.comercializacion.dto.response.VendedorResponse;
import com.sigre.comercializacion.entity.Vendedor;

public interface VendedorService {

    Page<Vendedor> findAll(Pageable pageable);

    // Método con filtros según contrato: usuarioId, nombre, flagEstado
    Page<Vendedor> findAllWithFilters(Long usuarioId, String nombre, String flagEstado, Pageable pageable);

    Vendedor findById(Long id);

    Vendedor create(Vendedor entity);

    Vendedor update(Long id, Vendedor entity);

    void delete(Long id);

    Vendedor activate(Long id);

    Vendedor deactivate(Long id);

    Vendedor findByUsuarioId(Long usuarioId);
}
