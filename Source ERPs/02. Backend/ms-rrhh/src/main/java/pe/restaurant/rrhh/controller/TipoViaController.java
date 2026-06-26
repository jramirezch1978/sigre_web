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
import pe.restaurant.rrhh.constants.TipoViaConstants;
import pe.restaurant.rrhh.dto.request.TipoViaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoViaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoViaResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.service.TipoViaService;
import java.util.List;

@Tag(name = "TipoVia", description = "Catálogo tipo_via")
@RestController
@RequestMapping("/api/rrhh/tipos-via")
@RequiredArgsConstructor
public class TipoViaController {
    private final TipoViaService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoViaResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), TipoViaConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoViaResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoViaResponse>> crear(@Valid @RequestBody TipoViaCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoViaConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoViaResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoViaUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoViaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoViaConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoViaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoViaConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoViaResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
