package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.entity.FormaEmbarque;

public interface FormaEmbarqueService {

    Page<FormaEmbarque> findAll(Pageable pageable);

    FormaEmbarque findById(Long id);

    FormaEmbarque create(FormaEmbarque entity);

    FormaEmbarque update(Long id, FormaEmbarque entity);

    FormaEmbarque activate(Long id);

    FormaEmbarque deactivate(Long id);

    void delete(Long id);
}
