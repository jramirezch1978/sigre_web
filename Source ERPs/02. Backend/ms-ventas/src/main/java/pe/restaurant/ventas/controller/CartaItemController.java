package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.dto.response.CartaResponse;
import pe.restaurant.ventas.entity.CartaDet;
import pe.restaurant.ventas.mapper.CartaMapper;
import pe.restaurant.ventas.service.CartaService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/ventas/cartas/{cartaId}/items")
@RequiredArgsConstructor
@Tag(name = "Ítems de Carta", description = "Gestión de ítems/artículos de una carta")
public class CartaItemController {

    private final CartaService service;
    private final CartaMapper mapper;

    @GetMapping
    @Operation(summary = "Listar ítems de carta", description = "Obtiene todos los ítems activos de una carta específica (según contrato)")
    public ApiResponse<List<CartaResponse.CartaDetResponse>> findAllByCartaId(@PathVariable Long cartaId) {
        List<CartaDet> items = service.findItemsByCartaId(cartaId);
        return ApiResponse.ok(mapper.toDetResponseList(items));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Agregar ítem a carta", description = "Agrega un nuevo artículo a la carta con precio y orden (según contrato)")
    public ApiResponse<CartaResponse.CartaDetResponse> addItem(
            @PathVariable Long cartaId,
            @Valid @RequestBody CartaRequest.CartaDetRequest request) {
        CartaDet item = mapper.toDetEntity(request);
        CartaDet saved = service.addItem(cartaId, item);
        return ApiResponse.ok(mapper.toDetResponse(saved), "Ítem agregado exitosamente");
    }

    @PutMapping("/{itemId}")
    @Operation(summary = "Actualizar ítem de carta", description = "Actualiza precio y orden de un ítem existente (según contrato)")
    public ApiResponse<CartaResponse.CartaDetResponse> updateItem(
            @PathVariable Long cartaId,
            @PathVariable Long itemId,
            @Valid @RequestBody CartaRequest.CartaDetUpdateRequest request) {
        CartaDet updated = service.updateItemFields(cartaId, itemId, request.getPrecio(), request.getOrden());
        return ApiResponse.ok(mapper.toDetResponse(updated), "Ítem actualizado exitosamente");
    }

    @DeleteMapping("/{itemId}")
    @Operation(summary = "Eliminar ítem de carta", description = "Elimina lógicamente un ítem de la carta (baja lógica según contrato)")
    public ApiResponse<Void> deleteItem(
            @PathVariable Long cartaId,
            @PathVariable Long itemId) {
        service.deleteItem(cartaId, itemId);
        return ApiResponse.ok(null, "Ítem eliminado exitosamente");
    }
}
