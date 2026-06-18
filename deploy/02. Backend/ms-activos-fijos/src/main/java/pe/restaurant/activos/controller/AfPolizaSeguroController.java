package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfPolizaSeguroRequest;
import pe.restaurant.activos.dto.AfPolizaSeguroResponse;
import pe.restaurant.activos.dto.AfPrimaDevengoResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfPolizaSeguroMapper;
import pe.restaurant.activos.mapper.AfPrimaDevengoMapper;
import pe.restaurant.activos.service.AfPolizaSeguroService;
import pe.restaurant.activos.service.AfPrimaDevengoService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/polizas")
@RequiredArgsConstructor
public class AfPolizaSeguroController {

    private final AfPolizaSeguroService service;
    private final AfPolizaSeguroMapper mapper;
    private final AfPrimaDevengoService primaDevengoService;
    private final AfPrimaDevengoMapper primaDevengoMapper;

    @GetMapping
    public ApiResponse<PageData<AfPolizaSeguroResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfPolizaSeguroResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfPolizaSeguroResponse> crear(@Valid @RequestBody AfPolizaSeguroRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfPolizaSeguroResponse> actualizar(@PathVariable Long id,
                                                           @Valid @RequestBody AfPolizaSeguroRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/vigentes")
    public ApiResponse<PageData<AfPolizaSeguroResponse>> listarVigentes(Pageable pageable) {
        var page = service.findPolizasVigentes(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/por-vencer/{dias}")
    public ApiResponse<List<AfPolizaSeguroResponse>> listarPorVencer(@PathVariable Integer dias) {
        var polizas = service.findPolizasPorVencer(dias);
        return ApiResponse.ok(mapper.toResponseList(polizas));
    }

    @GetMapping("/aseguradora/{id}")
    public ApiResponse<PageData<AfPolizaSeguroResponse>> listarPorAseguradora(@PathVariable Long id, Pageable pageable) {
        var page = service.findByAseguradora(id, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @PatchMapping("/{id}/renovar")
    public ApiResponse<AfPolizaSeguroResponse> renovar(@PathVariable Long id,
                                                        @Valid @RequestBody AfPolizaSeguroRequest request) {
        var datosRenovacion = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.renovarPoliza(id, datosRenovacion)), "Póliza renovada");
    }

    @PostMapping("/{id}/devengo-mensual")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfPrimaDevengoResponse> registrarDevengoMensual(
            @PathVariable Long id,
            @RequestParam Integer anio,
            @RequestParam Integer mes) {
        var saved = primaDevengoService.registrarDevengoMensual(id, anio, mes);
        return ApiResponse.ok(primaDevengoMapper.toResponse(saved), "Devengo de prima registrado");
    }

    @GetMapping("/{id}/devengos")
    public ApiResponse<List<AfPrimaDevengoResponse>> listarDevengos(@PathVariable Long id) {
        return ApiResponse.ok(primaDevengoMapper.toResponseList(primaDevengoService.listByPoliza(id)));
    }
}
