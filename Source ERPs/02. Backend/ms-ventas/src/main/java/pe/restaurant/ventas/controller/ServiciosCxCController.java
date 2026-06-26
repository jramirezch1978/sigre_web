package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.ServiciosCxCRequest;
import pe.restaurant.ventas.dto.response.ServiciosCxCResponse;
import pe.restaurant.ventas.entity.ServiciosCxC;
import pe.restaurant.ventas.mapper.ServiciosCxCMapper;
import pe.restaurant.ventas.service.ServiciosCxCService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

@RestController
@RequestMapping("/api/ventas/servicios-cxc")
@RequiredArgsConstructor
@Tag(name = "Servicios CxC", description = "Gestión de servicios para cuentas por cobrar")
public class ServiciosCxCController {

    private final ServiciosCxCService service;
    private final ServiciosCxCMapper mapper;

    @GetMapping
    @Operation(summary = "Listar servicios CxC", description = "Obtiene un listado paginado de servicios CxC con filtros opcionales")
    public ApiResponse<PageData<ServiciosCxCResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) String codServicio,
            @RequestParam(required = false) String descServicio,
            @RequestParam(required = false) String codMoneda,
            @RequestParam(required = false) String flagEstado) {
        Page<ServiciosCxC> page = service.findAllWithFilters(codServicio, descServicio, codMoneda, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener servicio CxC por ID")
    public ApiResponse<ServiciosCxCResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear servicio CxC", description = "Crea un nuevo servicio CxC")
    public ApiResponse<ServiciosCxCResponse> create(@Valid @RequestBody ServiciosCxCRequest request) {
        ServiciosCxC entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Servicio CxC creado exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar servicio CxC")
    public ApiResponse<ServiciosCxCResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ServiciosCxCRequest request) {
        ServiciosCxC existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Servicio CxC actualizado exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar servicio CxC")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Servicio CxC eliminado exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar servicio CxC")
    public ApiResponse<ServiciosCxCResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Servicio CxC activado exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar servicio CxC")
    public ApiResponse<ServiciosCxCResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Servicio CxC desactivado exitosamente");
    }
}
