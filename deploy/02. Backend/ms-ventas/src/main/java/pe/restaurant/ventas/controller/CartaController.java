package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.dto.response.CartaResponse;
import pe.restaurant.ventas.entity.Carta;
import pe.restaurant.ventas.entity.CartaDet;
import pe.restaurant.ventas.mapper.CartaMapper;
import pe.restaurant.ventas.service.CartaService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

import java.util.List;

@RestController
@RequestMapping("/api/ventas/cartas")
@RequiredArgsConstructor
@Tag(name = "Cartas", description = "Gestión de cartas/menús del restaurante")
public class CartaController {

    private final CartaService service;
    private final CartaMapper mapper;

    @GetMapping
    @Operation(summary = "Listar cartas", description = "Obtiene un listado paginado de cartas con filtros opcionales")
    public ApiResponse<PageData<CartaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado) {
        Page<Carta> page = service.findAllWithFilters(sucursalId, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener carta por ID")
    public ApiResponse<CartaResponse> findById(@PathVariable Long id) {
        Carta carta = service.findById(id);
        CartaResponse response = mapper.toResponse(carta);
        
        // Cargar detalles según contrato
        List<CartaDet> items = service.findItemsByCartaId(id);
        response.setDetalles(mapper.toDetResponseList(items));
        
        return ApiResponse.ok(response);
    }

    @GetMapping("/sucursal/{sucursalId}")
    @Operation(summary = "Listar cartas por sucursal", description = "Obtiene cartas activas de una sucursal")
    public ApiResponse<List<CartaResponse>> findBySucursalId(@PathVariable Long sucursalId) {
        List<Carta> cartas = service.findBySucursalId(sucursalId);
        return ApiResponse.ok(mapper.toResponseList(cartas));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear carta", description = "Crea una nueva carta con sus detalles")
    public ApiResponse<CartaResponse> create(@Valid @RequestBody CartaRequest request) {
        Carta entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Carta creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar carta")
    public ApiResponse<CartaResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody CartaRequest request) {
        // Convertir request a entidad con detalles
        Carta entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.update(id, entity)), "Carta actualizada exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar carta")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Carta eliminada exitosamente");
    }

    
    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar carta")
    public ApiResponse<CartaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Carta activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar carta")
    public ApiResponse<CartaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Carta desactivada exitosamente");
    }
}
