package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.constants.TipoSangreConstants;
import pe.restaurant.rrhh.dto.request.TipoSangreCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSangreUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSangreResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.service.TipoSangreService;
import java.util.List;

@Tag(name = "TipoSangre", description = "Catálogo tipo_sangre")
@RestController
@RequestMapping("/api/rrhh/tipos-sangre")
@RequiredArgsConstructor
public class TipoSangreController {
    private final TipoSangreService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoSangreResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), TipoSangreConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoSangreResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoSangreResponse>> crear(@Valid @RequestBody TipoSangreCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoSangreConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoSangreResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoSangreUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoSangreResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoSangreConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoSangreResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoSangreConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoSangreResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
