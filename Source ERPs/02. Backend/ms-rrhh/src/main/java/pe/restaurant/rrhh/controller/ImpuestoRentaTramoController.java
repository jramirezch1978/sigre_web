package pe.restaurant.rrhh.controller;

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
import pe.restaurant.rrhh.constants.ImpuestoRentaTramoConstants;
import pe.restaurant.rrhh.dto.request.ImpuestoRentaTramoCreateRequest;
import pe.restaurant.rrhh.dto.request.ImpuestoRentaTramoUpdateRequest;
import pe.restaurant.rrhh.dto.response.ImpuestoRentaTramoResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.service.ImpuestoRentaTramoService;

import java.time.LocalDate;
import java.util.List;

@Tag(name = "ImpuestoRentaTramo", description = "Tramos retención quinta categoría (SIGRE RRHH_IMPUESTO_RENTA)")
@RestController
@RequestMapping("/api/rrhh/impuesto-renta-tramos")
@RequiredArgsConstructor
public class ImpuestoRentaTramoController {

    private final ImpuestoRentaTramoService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<ImpuestoRentaTramoResponse>>> listar(
            @RequestParam(required = false) LocalDate fechaVigIni,
            @RequestParam(required = false) Integer secuencia,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fechaVigIni", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<ImpuestoRentaTramoResponse> page = service.listar(fechaVigIni, secuencia, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), ImpuestoRentaTramoConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ImpuestoRentaTramoResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<ImpuestoRentaTramoResponse>> crear(
            @Valid @RequestBody ImpuestoRentaTramoCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(service.crear(request), ImpuestoRentaTramoConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ImpuestoRentaTramoResponse>> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody ImpuestoRentaTramoUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ImpuestoRentaTramoResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), ImpuestoRentaTramoConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ImpuestoRentaTramoResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), ImpuestoRentaTramoConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<ImpuestoRentaTramoResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
