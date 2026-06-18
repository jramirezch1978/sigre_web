package pe.restaurant.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.almacen.dto.PageData;
import pe.restaurant.almacen.dto.StockArticuloAlmacenResponse;
import pe.restaurant.almacen.service.StockConsultaService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/stock")
@RequiredArgsConstructor
public class StockController {

    private final StockConsultaService stockConsultaService;

    /** Consulta de stock por almacén y/o por artículo (ambos filtros opcionales). */
    @GetMapping
    public ApiResponse<PageData<StockArticuloAlmacenResponse>> consultar(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            Pageable pageable) {
        var page = stockConsultaService.consultarStock(almacenId, articuloId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    /** Consulta de stock puntual de un artículo dentro de un almacén específico. */
    @GetMapping("/{almacenId}/{articuloId}")
    public ApiResponse<StockArticuloAlmacenResponse> consultarPorAlmacenYArticulo(
            @PathVariable Long almacenId,
            @PathVariable Long articuloId) {
        return ApiResponse.ok(stockConsultaService.consultarStockPorAlmacenYArticulo(almacenId, articuloId));
    }
}
