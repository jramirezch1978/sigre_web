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
import pe.restaurant.rrhh.constants.MotivoCeseConstants;
import pe.restaurant.rrhh.dto.request.MotivoCeseCreateRequest;
import pe.restaurant.rrhh.dto.request.MotivoCeseUpdateRequest;
import pe.restaurant.rrhh.dto.response.MotivoCeseResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.service.MotivoCeseService;
import java.util.List;

@Tag(name = "MotivoCese", description = "Catálogo motivo_cese")
@RestController
@RequestMapping("/api/rrhh/motivos-cese")
@RequiredArgsConstructor
public class MotivoCeseController {
    private final MotivoCeseService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<MotivoCeseResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), MotivoCeseConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<MotivoCeseResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<MotivoCeseResponse>> crear(@Valid @RequestBody MotivoCeseCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), MotivoCeseConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<MotivoCeseResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody MotivoCeseUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<MotivoCeseResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), MotivoCeseConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<MotivoCeseResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), MotivoCeseConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<MotivoCeseResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
