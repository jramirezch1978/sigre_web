package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.ProcesarCosteoRequest;
import pe.restaurant.produccion.dto.response.CosteoProduccionResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.dto.response.ProcesarCosteoResponse;
import pe.restaurant.produccion.mapper.CosteoProduccionMapper;
import pe.restaurant.produccion.service.CosteoProduccionService;

import java.util.List;

@RestController
@RequestMapping({"/api/produccion/costeos", "/api/produccion/costeo-produccion"})
@RequiredArgsConstructor
public class CosteoProduccionController {

    private final CosteoProduccionService service;
    private final CosteoProduccionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CosteoProduccionResponse>> findAll(
            @RequestParam(required = false) Long ordenTrabajoId,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Integer mes,
            Pageable pageable) {
        var page = service.findAll(ordenTrabajoId, anio, mes, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CosteoProduccionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping("/procesar")
    public ApiResponse<ProcesarCosteoResponse> procesar(@Valid @RequestBody ProcesarCosteoRequest request) {
        var result = service.procesar(request.getAnio(), request.getMes(),
                request.getSucursalId(), request.getAlmacenId());
        return ApiResponse.ok(result, "Costeo procesado exitosamente");
    }

    @GetMapping("/por-periodo")
    public ApiResponse<List<CosteoProduccionResponse>> findByPeriodo(
            @RequestParam Integer anio,
            @RequestParam Integer mes) {
        var list = service.findByPeriodo(anio, mes);
        return ApiResponse.ok(mapper.toResponseList(list));
    }
}
