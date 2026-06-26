package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import pe.restaurant.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.constants.PeriodoCtsConstants;
import pe.restaurant.rrhh.dto.request.PeriodoCtsCreateRequest;
import pe.restaurant.rrhh.dto.request.PeriodoCtsUpdateRequest;
import pe.restaurant.rrhh.dto.response.PeriodoCtsResponse;
import pe.restaurant.rrhh.service.PeriodoCtsService;

import java.util.List;

@Tag(name = "Períodos de CTS", description = "Catálogo de períodos de CTS (MAYO, NOVIEMBRE)")
@RestController
@RequestMapping("/api/rrhh/periodos-cts")
@RequiredArgsConstructor
public class PeriodoCtsController {

    private final PeriodoCtsService service;

    @Operation(summary = "Listar períodos de CTS")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<PeriodoCtsResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), PeriodoCtsConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener período de CTS por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PeriodoCtsResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear período de CTS")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<PeriodoCtsResponse>> crear(@Valid @RequestBody PeriodoCtsCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), PeriodoCtsConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar período de CTS")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<PeriodoCtsResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody PeriodoCtsUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar período de CTS (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<PeriodoCtsResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), PeriodoCtsConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar período de CTS")
    @PatchMapping("/{id}/activar")
    public ApiResponse<PeriodoCtsResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), PeriodoCtsConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar períodos de CTS activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<PeriodoCtsResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
