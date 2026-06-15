package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.entity.Carta;
import com.sigre.comercializacion.entity.CartaDet;

import java.math.BigDecimal;
import java.util.List;

public interface CartaService {

    Page<Carta> findAll(Pageable pageable);

    // Método con filtros según contrato
    Page<Carta> findAllWithFilters(Long sucursalId, String nombre, String flagEstado, Pageable pageable);

    Carta findById(Long id);

    Carta create(Carta entity);

    Carta update(Long id, Carta entity);

    void delete(Long id);

    Carta activate(Long id);

    Carta deactivate(Long id);

    List<Carta> findBySucursalId(Long sucursalId);

    // Métodos para gestión de ítems (contrato)
    List<CartaDet> findItemsByCartaId(Long cartaId);

    CartaDet addItem(Long cartaId, CartaDet item);

    CartaDet updateItem(Long cartaId, Long itemId, CartaDet item);

    CartaDet updateItemFields(Long cartaId, Long itemId, BigDecimal precio, Integer orden);

    void deleteItem(Long cartaId, Long itemId);
}
