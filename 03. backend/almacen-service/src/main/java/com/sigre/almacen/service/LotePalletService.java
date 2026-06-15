package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.entity.LotePallet;

public interface LotePalletService {

    Page<LotePallet> buscar(Long almacenId, Long articuloId, Pageable pageable);

    LotePallet findById(Long id);

    LotePallet create(LotePallet entity);

    LotePallet update(Long id, LotePallet entity);

    LotePallet activate(Long id);

    LotePallet deactivate(Long id);
}
