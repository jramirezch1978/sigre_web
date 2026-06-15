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
import com.sigre.comercializacion.dto.request.PedidoMesaRequest;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.dto.response.PedidoMesaResponse;
import com.sigre.comercializacion.entity.PedidoMesa;
import com.sigre.comercializacion.service.PedidoMesaService;

@RestController
@RequestMapping("/api/ventas/pedidos-mesa")
@RequiredArgsConstructor
@Tag(name = "Pedidos mesa", description = "Sesión de atención por mesa (ventas.pedido_mesa)")
public class PedidoMesaController {

    private final PedidoMesaService pedidoMesaService;

    @GetMapping
    @Operation(summary = "Listar pedidos mesa")
    public ApiResponse<PageData<PedidoMesaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long mesaId,
            @RequestParam(required = false) Long meseroId,
            @RequestParam(required = false) Long turnoId,
            @RequestParam(required = false) String flagEstado) {
        Page<PedidoMesa> page = pedidoMesaService.findAll(sucursalId, mesaId, meseroId, turnoId, flagEstado, pageable);
        var rows = page.getContent().stream().map(this::toRow).toList();
        return ApiResponse.ok(PageData.of(page, rows));
    }

    private PedidoMesaResponse toRow(PedidoMesa p) {
        return PedidoMesaResponse.builder()
                .id(p.getId())
                .sucursalId(p.getSucursalId())
                .tipo(p.getTipo())
                .mesaId(p.getMesa() != null ? p.getMesa().getId() : null)
                .mesaNumero(p.getMesa() != null ? p.getMesa().getNumero() : null)
                .meseroId(p.getMeseroId())
                .turnoId(p.getTurnoId())
                .numero(p.getNumero())
                .comensales(p.getComensales())
                .apertura(p.getApertura())
                .cierre(p.getCierre())
                .observaciones(p.getObservaciones())
                .flagEstado(p.getFlagEstado())
                .createdBy(p.getCreatedBy())
                .fecCreacion(p.getFecCreacion())
                .updatedBy(p.getUpdatedBy())
                .fecModificacion(p.getFecModificacion())
                .build();
    }

    @GetMapping("/{id}")
    public ApiResponse<PedidoMesaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(pedidoMesaService.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<PedidoMesaResponse> create(@Valid @RequestBody PedidoMesaRequest request) {
        return ApiResponse.ok(pedidoMesaService.create(request), "Pedido mesa creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<PedidoMesaResponse> update(@PathVariable Long id, @Valid @RequestBody PedidoMesaRequest request) {
        return ApiResponse.ok(pedidoMesaService.update(id, request), "Pedido mesa actualizado");
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<PedidoMesaResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(pedidoMesaService.cerrar(id), "Pedido cerrado");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<PedidoMesaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(pedidoMesaService.anular(id), "Pedido anulado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<PedidoMesaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(pedidoMesaService.activate(id), "Pedido activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<PedidoMesaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(pedidoMesaService.deactivate(id), "Pedido desactivado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        pedidoMesaService.delete(id);
        return ApiResponse.ok(null, "Pedido eliminado lógicamente");
    }
}
