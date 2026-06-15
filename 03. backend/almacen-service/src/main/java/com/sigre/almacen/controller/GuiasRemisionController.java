package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import com.sigre.almacen.dto.GuiaRequest;
import com.sigre.almacen.dto.GuiaResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.service.GuiaRemisionService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/guias-remision")
@RequiredArgsConstructor
public class GuiasRemisionController {

    private final GuiaRemisionService service;

    @GetMapping
    public ApiResponse<PageData<GuiaResponse>> buscar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) String serie,
            @RequestParam(required = false) String numero,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) Long destinatarioId,
            Pageable pageable) {
        var page = service.buscar(sucursalId, estado, serie, numero, fechaDesde, fechaHasta, destinatarioId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<GuiaResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<GuiaResponse> crear(@Valid @RequestBody GuiaRequest request) {
        return ApiResponse.ok(service.crear(request), "Guía creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<GuiaResponse> actualizar(@PathVariable Long id, @Valid @RequestBody GuiaRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Guía actualizada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<GuiaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(service.anular(id), "Guía anulada");
    }

    /** Compatibilidad con clientes que aún invocan {@code PATCH /{id}/anular}. */
    @PatchMapping("/{id}/anular")
    public ApiResponse<GuiaResponse> anularPatch(@PathVariable Long id) {
        return anular(id);
    }

    @PostMapping("/{id}/en-transito")
    public ApiResponse<GuiaResponse> enTransito(@PathVariable Long id) {
        return ApiResponse.ok(service.ponerEnTransito(id), "Guía en tránsito");
    }

    @PostMapping("/{id}/entregar")
    public ApiResponse<GuiaResponse> entregar(@PathVariable Long id) {
        return ApiResponse.ok(service.marcarEntregada(id), "Guía entregada");
    }
}
