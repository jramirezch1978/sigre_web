package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.dto.ProgramacionComprasDetalleResponse;
import pe.restaurant.compras.dto.ProgramacionComprasRequest;
import pe.restaurant.compras.dto.ProgramacionComprasResponse;
import pe.restaurant.compras.service.ProgramacionComprasService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/compras/programaciones")
@RequiredArgsConstructor
public class ProgramacionComprasController {

    private final ProgramacionComprasService programacionComprasService;

    @GetMapping
    public ApiResponse<PageData<ProgramacionComprasResponse>> listar(
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Integer mes,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = programacionComprasService.listar(anio, mes, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<ProgramacionComprasDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(programacionComprasService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ProgramacionComprasDetalleResponse> crear(
            @Valid @RequestBody ProgramacionComprasRequest request) {
        return ApiResponse.ok(programacionComprasService.crear(request), "Programación de compras creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<ProgramacionComprasDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody ProgramacionComprasRequest request) {
        return ApiResponse.ok(programacionComprasService.actualizar(id, request), "Programación de compras actualizada");
    }

    @PostMapping("/{id}/confirmar")
    public ApiResponse<ProgramacionComprasDetalleResponse> confirmar(@PathVariable Long id) {
        return ApiResponse.ok(programacionComprasService.confirmar(id), "Programación confirmada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<ProgramacionComprasDetalleResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(programacionComprasService.anular(id), "Programación anulada");
    }
}
