package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.StockArticuloAlmacenResponse;

public interface StockConsultaService {

    Page<StockArticuloAlmacenResponse> consultarStock(Long almacenId, Long articuloId, Pageable pageable);

    StockArticuloAlmacenResponse consultarStockPorAlmacenYArticulo(Long almacenId, Long articuloId);
}
