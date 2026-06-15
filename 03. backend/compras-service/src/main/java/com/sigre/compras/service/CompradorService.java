package com.sigre.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.entity.Comprador;
import com.sigre.compras.entity.CompradorCategoria;

import java.util.List;

public interface CompradorService {
    Page<Comprador> findAll(Pageable pageable);
    Comprador findById(Long id);
    Comprador create(Comprador entity);
    Comprador update(Long id, Comprador entity);
    void delete(Long id);
    Comprador activate(Long id);
    Comprador deactivate(Long id);
    List<CompradorCategoria> findCategorias(Long compradorId);
    CompradorCategoria assignCategoria(Long compradorId, Long articuloCategId);
}
