package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.dto.request.QuintaCategoriaProcesarRequest;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.dto.response.QuintaCategoriaResponse;
import com.sigre.rrhh.mapper.QuintaCategoriaMapper;
import com.sigre.rrhh.service.QuintaCategoriaService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/quinta-categoria")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Quinta Categoría", description = "Procesamiento y consulta de retenciones de quinta categoría")
public class QuintaCategoriaController {

    private final QuintaCategoriaService service;
    private final QuintaCategoriaMapper mapper;

    @PostMapping("/procesar")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Procesar quinta categoría")
    public ResponseEntity<ApiResponse<List<QuintaCategoriaResponse>>> procesar(@Valid @RequestBody QuintaCategoriaProcesarRequest request) {
        List<QuintaCategoriaResponse> data = service.procesar(request.getAnio(), request.getMes())
                .stream().map(mapper::toResponse).toList();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(data, "Quinta categoría procesada"));
    }

    @GetMapping
    @Operation(summary = "Listar quinta categoría")
    public ResponseEntity<ApiResponse<PageData<QuintaCategoriaResponse>>> listar(
            Pageable pageable,
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Integer mes) {
        Page<QuintaCategoriaResponse> page = service.listar(trabajadorId, anio, mes, pageable)
                .map(mapper::toResponse);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle de quinta categoría")
    public ResponseEntity<ApiResponse<QuintaCategoriaResponse>> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.obtenerPorId(id))));
    }
}
