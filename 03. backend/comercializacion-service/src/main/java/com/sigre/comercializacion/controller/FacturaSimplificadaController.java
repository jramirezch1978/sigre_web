package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.FacturaSimplCabeceraRequest;
import com.sigre.comercializacion.dto.response.FacturaSimplPagoResponse;
import com.sigre.comercializacion.dto.response.FacturaSimplificadaResponse;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.entity.FsFacturaSimpl;
import com.sigre.comercializacion.service.FacturaSimplificadaService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/ventas/facturas-simplificadas")
@RequiredArgsConstructor
@Tag(name = "Facturas simplificadas", description = "Boleta/factura simplificada sigree")
public class FacturaSimplificadaController {

    private final FacturaSimplificadaService facturaSimplificadaService;

    @GetMapping
    @Operation(summary = "Listar facturas simplificadas")
    public ApiResponse<PageData<FacturaSimplificadaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) Long docTipoId,
            @RequestParam(required = false) String serie,
            @RequestParam(required = false) String numero,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta) {
        Page<FsFacturaSimpl> page = facturaSimplificadaService.findAll(
                sucursalId, clienteId, docTipoId, serie, numero, flagEstado, fechaDesde, fechaHasta, pageable);
        List<FacturaSimplificadaResponse> rows = page.getContent().stream().map(this::toSummary).toList();
        return ApiResponse.ok(PageData.of(page, rows));
    }

    private FacturaSimplificadaResponse toSummary(FsFacturaSimpl f) {
        return FacturaSimplificadaResponse.builder()
                .id(f.getId())
                .sucursalId(f.getSucursalId())
                .puntoVentaId(f.getPuntoVentaId())
                .clienteId(f.getClienteId())
                .docTipoId(f.getDocTipoId())
                .serie(f.getSerie())
                .numero(f.getNumero())
                .fechaEmision(f.getFechaEmision())
                .monedaId(f.getMonedaId())
                .subtotal(f.getSubtotal())
                .impuesto(f.getImpuesto())
                .total(f.getTotal())
                .flagEstado(f.getFlagEstado())
                .createdBy(f.getCreatedBy())
                .fecCreacion(f.getFecCreacion())
                .updatedBy(f.getUpdatedBy())
                .fecModificacion(f.getFecModificacion())
                .items(List.of())
                .pagos(List.of())
                .build();
    }

    @GetMapping("/{id}")
    public ApiResponse<FacturaSimplificadaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(facturaSimplificadaService.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<FacturaSimplificadaResponse> create(@Valid @RequestBody FacturaSimplCabeceraRequest request) {
        return ApiResponse.ok(facturaSimplificadaService.create(request), "Factura registrada en borrador");
    }

    @PutMapping("/{id}")
    public ApiResponse<FacturaSimplificadaResponse> update(@PathVariable Long id, @Valid @RequestBody FacturaSimplCabeceraRequest request) {
        return ApiResponse.ok(facturaSimplificadaService.update(id, request), "Factura actualizada");
    }

    @PostMapping("/{id}/emitir")
    public ApiResponse<FacturaSimplificadaResponse> emitir(@PathVariable Long id) {
        return ApiResponse.ok(facturaSimplificadaService.emitir(id), "Comprobante emitido");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<FacturaSimplificadaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(facturaSimplificadaService.anular(id), "Comprobante anulado");
    }

    @GetMapping("/{id}/pagos")
    public ApiResponse<List<FacturaSimplPagoResponse>> pagos(@PathVariable Long id) {
        return ApiResponse.ok(facturaSimplificadaService.listPagos(id));
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<FacturaSimplificadaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(facturaSimplificadaService.activate(id), "Factura activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<FacturaSimplificadaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(facturaSimplificadaService.deactivate(id), "Factura desactivada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        facturaSimplificadaService.delete(id);
        return ApiResponse.ok(null, "Factura eliminada lógicamente");
    }
}
