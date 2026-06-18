package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.format.annotation.DateTimeFormat;
import pe.restaurant.compras.dto.ContratoMarcoRequest;
import pe.restaurant.compras.dto.ContratoMarcoResponse;
import pe.restaurant.compras.dto.OrdenCompraContratoResponse;
import pe.restaurant.compras.dto.OrdenCompraMotivoRequest;
import pe.restaurant.compras.dto.PageData;

import java.time.LocalDate;
import pe.restaurant.compras.service.ContratoMarcoService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/compras/contratos-marco")
@RequiredArgsConstructor
public class ContratoMarcoController {

    private final ContratoMarcoService contratoMarcoService;

    @GetMapping
    public ApiResponse<PageData<ContratoMarcoResponse>> listar(
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate vigenteEn,
            Pageable pageable) {
        var page = contratoMarcoService.listar(proveedorId, flagEstado, vigenteEn, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/por-vencer")
    public ApiResponse<PageData<ContratoMarcoResponse>> porVencer(
            @RequestParam(required = false, defaultValue = "30") Integer dias,
            @RequestParam(required = false) Long proveedorId,
            Pageable pageable) {
        var page = contratoMarcoService.porVencer(dias, proveedorId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<ContratoMarcoResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(contratoMarcoService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ContratoMarcoResponse> crear(
            @Valid @RequestBody ContratoMarcoRequest request) {
        return ApiResponse.ok(contratoMarcoService.crear(request), "Contrato marco creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ContratoMarcoResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody ContratoMarcoRequest request) {
        return ApiResponse.ok(contratoMarcoService.actualizar(id, request), "Contrato marco actualizado");
    }

    @PostMapping("/{id}/suspender")
    public ApiResponse<ContratoMarcoResponse> suspender(
            @PathVariable Long id,
            @RequestBody(required = false) OrdenCompraMotivoRequest body) {
        return ApiResponse.ok(contratoMarcoService.suspender(id, body != null ? body.getMotivo() : null), "Contrato suspendido");
    }

    @PostMapping("/{id}/reabrir")
    public ApiResponse<ContratoMarcoResponse> reabrir(
            @PathVariable Long id,
            @RequestBody(required = false) OrdenCompraMotivoRequest body) {
        return ApiResponse.ok(contratoMarcoService.reabrir(id, body != null ? body.getMotivo() : null), "Contrato reabierto");
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<ContratoMarcoResponse> cerrar(
            @PathVariable Long id,
            @RequestBody(required = false) OrdenCompraMotivoRequest body) {
        return ApiResponse.ok(contratoMarcoService.cerrar(id, body != null ? body.getMotivo() : null), "Contrato cerrado");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<ContratoMarcoResponse> anular(
            @PathVariable Long id,
            @RequestBody(required = false) OrdenCompraMotivoRequest body) {
        return ApiResponse.ok(contratoMarcoService.anular(id, body != null ? body.getMotivo() : null), "Contrato anulado");
    }

    @GetMapping("/{id}/oc-generadas")
    public ApiResponse<java.util.List<OrdenCompraContratoResponse>> ocGeneradas(@PathVariable Long id) {
        return ApiResponse.ok(contratoMarcoService.ocGeneradas(id));
    }
}
