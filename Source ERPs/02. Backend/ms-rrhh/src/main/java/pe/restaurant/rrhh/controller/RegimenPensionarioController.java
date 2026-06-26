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
import pe.restaurant.rrhh.constants.RegimenPensionarioConstants;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioCreateRequest;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioUpdateRequest;
import pe.restaurant.rrhh.dto.response.RegimenPensionarioResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.service.RegimenPensionarioService;
import java.util.List;

@Tag(name = "RegimenPensionario", description = "Catálogo regimen_pensionario")
@RestController
@RequestMapping("/api/rrhh/regimenes-pensionario")
@RequiredArgsConstructor
public class RegimenPensionarioController {
    private final RegimenPensionarioService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<RegimenPensionarioResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), RegimenPensionarioConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RegimenPensionarioResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<RegimenPensionarioResponse>> crear(@Valid @RequestBody RegimenPensionarioCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), RegimenPensionarioConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RegimenPensionarioResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody RegimenPensionarioUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<RegimenPensionarioResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), RegimenPensionarioConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<RegimenPensionarioResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), RegimenPensionarioConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<RegimenPensionarioResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
