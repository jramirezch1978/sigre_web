package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.request.ComandaCabeceraRequest;
import pe.restaurant.ventas.dto.request.ComandaEstadoRequest;
import pe.restaurant.ventas.dto.request.ComandaItemsAppendRequest;
import pe.restaurant.ventas.dto.response.ComandaResponse;
import pe.restaurant.ventas.dto.response.PageData;
import pe.restaurant.ventas.entity.Comanda;
import pe.restaurant.ventas.service.ComandaService;

import java.time.Instant;
import java.util.List;

@RestController
@RequestMapping("/api/ventas/comandas")
@RequiredArgsConstructor
@Tag(name = "Comandas", description = "Comandas cocina/barra (ventas.comanda)")
public class ComandaController {

    private final ComandaService comandaService;

    @GetMapping
    @Operation(summary = "Listar comandas paginadas")
    public ApiResponse<PageData<ComandaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long puntoVentaId,
            @RequestParam(required = false) String mesa,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) Instant fechaDesde,
            @RequestParam(required = false) Instant fechaHasta) {
        Page<Comanda> page = comandaService.findAll(sucursalId, puntoVentaId, mesa, flagEstado, fechaDesde, fechaHasta, pageable);
        List<ComandaResponse> rows = page.getContent().stream().map(this::toListItem).toList();
        return ApiResponse.ok(PageData.of(page, rows));
    }

    private ComandaResponse toListItem(Comanda c) {
        return ComandaResponse.builder()
                .id(c.getId())
                .sucursalId(c.getSucursalId())
                .puntoVentaId(c.getPuntoVentaId())
                .turnoId(c.getTurnoId())
                .clienteId(c.getClienteId())
                .mesa(c.getMesa())
                .fechaHora(c.getFechaHora())
                .total(c.getTotal())
                .flagEstado(c.getFlagEstado())
                .createdBy(c.getCreatedBy())
                .fecCreacion(c.getFecCreacion())
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(c.getFecModificacion())
                .items(List.of())
                .build();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener comanda con detalle")
    public ApiResponse<ComandaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(comandaService.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear comanda")
    public ApiResponse<ComandaResponse> create(@Valid @RequestBody ComandaCabeceraRequest request) {
        return ApiResponse.ok(comandaService.create(request), "Comanda creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar comanda (solo ABIERTA)")
    public ApiResponse<ComandaResponse> update(@PathVariable Long id, @Valid @RequestBody ComandaCabeceraRequest request) {
        return ApiResponse.ok(comandaService.update(id, request), "Comanda actualizada");
    }

    @PostMapping("/{id}/items")
    @Operation(summary = "Agregar ítems (solo ABIERTA)")
    public ApiResponse<ComandaResponse> addItems(@PathVariable Long id, @Valid @RequestBody ComandaItemsAppendRequest request) {
        return ApiResponse.ok(comandaService.addItems(id, request), "Ítems agregados");
    }

    @PatchMapping("/{id}/estado")
    @Operation(summary = "Cambiar estado operativo")
    public ApiResponse<ComandaResponse> patchEstado(@PathVariable Long id, @Valid @RequestBody ComandaEstadoRequest request) {
        return ApiResponse.ok(comandaService.patchEstado(id, request), "Estado actualizado");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular comanda")
    public ApiResponse<ComandaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(comandaService.anular(id), "Comanda anulada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ComandaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(comandaService.activate(id), "Comanda activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ComandaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(comandaService.deactivate(id), "Comanda desactivada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        comandaService.delete(id);
        return ApiResponse.ok(null, "Comanda eliminada lógicamente");
    }
}
