package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.entity.ArticuloMovTipo;

import java.util.List;

public interface ArticuloMovTipoService {

    List<ArticuloMovTipo> findAll();

    Page<ArticuloMovTipo> findAll(Pageable pageable);

    ArticuloMovTipo findById(Long id);

    ArticuloMovTipo findByTipoMov(String tipoMov);

    ArticuloMovTipo create(ArticuloMovTipo entity);

    ArticuloMovTipo update(Long id, ArticuloMovTipo entity);

    void delete(Long id);
}
