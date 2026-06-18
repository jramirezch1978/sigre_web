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
import pe.restaurant.rrhh.constants.TipoContratoConstants;
import pe.restaurant.rrhh.dto.request.TipoContratoCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoContratoUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoContratoResponse;
import pe.restaurant.rrhh.service.TipoContratoService;

import java.util.List;

@Tag(name = "TipoContratos", description = "Catálogo de tipo_contratos")
@RestController
@RequestMapping("/api/rrhh/tipos-contrato")
@RequiredArgsConstructor
public class TipoContratoController {

    private final TipoContratoService service;

    @Operation(summary = "Listar tipo_contratos")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoContratoResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), TipoContratoConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener tipo_contrato por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoContratoResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear tipo_contrato")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoContratoResponse>> crear(@Valid @RequestBody TipoContratoCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoContratoConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar tipo_contrato")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoContratoResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoContratoUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar tipo de contrato (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoContratoResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoContratoConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de contrato")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoContratoResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoContratoConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de contrato activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoContratoResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
