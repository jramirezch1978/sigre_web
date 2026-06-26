package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.StockArticuloAlmacenResponse;
import pe.restaurant.almacen.dto.StockLoteResponse;

public interface StockConsultaService {

    Page<StockArticuloAlmacenResponse> consultarStock(Long almacenId, Long articuloId, Pageable pageable);

    StockArticuloAlmacenResponse consultarStockPorAlmacenYArticulo(Long almacenId, Long articuloId);

    Page<StockLoteResponse> consultarStockLote(Long almacenId, Long articuloId, Long lotePalletId, Pageable pageable);
}
