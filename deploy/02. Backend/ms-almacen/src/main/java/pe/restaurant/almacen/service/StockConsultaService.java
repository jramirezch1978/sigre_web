package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.StockArticuloAlmacenResponse;

public interface StockConsultaService {

    Page<StockArticuloAlmacenResponse> consultarStock(Long almacenId, Long articuloId, Pageable pageable);

    StockArticuloAlmacenResponse consultarStockPorAlmacenYArticulo(Long almacenId, Long articuloId);
}
