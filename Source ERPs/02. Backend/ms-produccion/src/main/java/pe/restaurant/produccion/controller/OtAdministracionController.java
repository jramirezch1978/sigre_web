package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.OtAdminUderRequest;
import pe.restaurant.produccion.dto.response.OtAdminUderResponse;
import pe.restaurant.produccion.dto.request.OtAdministracionRequest;
import pe.restaurant.produccion.dto.response.OtAdministracionResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.OtAdminUderMapper;
import pe.restaurant.produccion.mapper.OtAdministracionMapper;
import pe.restaurant.produccion.service.OtAdministracionService;

import java.util.List;

@RestController
@RequestMapping("/api/produccion/ot-administraciones")
@RequiredArgsConstructor
public class OtAdministracionController {

    private final OtAdministracionService service;
    private final OtAdministracionMapper adminMapper;
    private final OtAdminUderMapper uderMapper;

    // ───────────────────────── Cabecera ─────────────────────────

    @GetMapping
    public ApiResponse<PageData<OtAdministracionResponse>> findAll(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagTipoCosto,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(codigo, nombre, flagTipoCosto, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, adminMapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<OtAdministracionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(adminMapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OtAdministracionResponse> create(@Valid @RequestBody OtAdministracionRequest request) {
        var entity = adminMapper.toEntity(request);
        return ApiResponse.ok(adminMapper.toResponse(service.create(entity)), "Administracion de OT creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<OtAdministracionResponse> update(@PathVariable Long id,
                                                       @Valid @RequestBody OtAdministracionRequest request) {
        var existing = service.findById(id);
        adminMapper.updateEntity(request, existing);
        return ApiResponse.ok(adminMapper.toResponse(service.update(id, existing)),
                "Administracion de OT actualizada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<OtAdministracionResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(adminMapper.toResponse(service.activate(id)), "Administracion de OT activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<OtAdministracionResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(adminMapper.toResponse(service.deactivate(id)), "Administracion de OT desactivada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Administracion de OT eliminada");
    }

    // ───────────────────────── Sub-recurso usuarios ─────────────────────────

    @GetMapping("/{id}/usuarios")
    public ApiResponse<List<OtAdminUderResponse>> findUsuarios(@PathVariable Long id) {
        return ApiResponse.ok(uderMapper.toResponseList(service.findUsuarios(id)));
    }

    @PostMapping("/{id}/usuarios")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OtAdminUderResponse> asignarUsuario(@PathVariable Long id,
                                                           @Valid @RequestBody OtAdminUderRequest request) {
        var saved = service.asignarUsuario(id, request.getUsuarioId());
        return ApiResponse.ok(uderMapper.toResponse(saved), "Usuario asignado a la administracion de OT");
    }

    @DeleteMapping("/{id}/usuarios/{usuarioId}")
    public ApiResponse<Boolean> desasignarUsuario(@PathVariable Long id, @PathVariable Long usuarioId) {
        service.desasignarUsuario(id, usuarioId);
        return ApiResponse.ok(true, "Usuario desasignado de la administracion de OT");
    }
}
