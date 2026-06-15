package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.CtsConstants;
import com.sigre.rrhh.dto.request.CtsProcesarRequest;
import com.sigre.rrhh.dto.response.CtsResponse;
import com.sigre.rrhh.service.CtsService;
import java.util.List;

@Tag(name = "CTS", description = "Cálculo batch de CTS (Mayo/Noviembre)")
@RestController
@RequestMapping("/api/rrhh/cts")
@RequiredArgsConstructor
public class CtsController {

    private final CtsService service;

    @Operation(summary = "Procesar CTS (batch)")
    @PostMapping("/procesar")
    public ResponseEntity<ApiResponse<List<CtsResponse>>> procesar(@Valid @RequestBody CtsProcesarRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.procesar(request), CtsConstants.MSG_PROCESADO));
    }

    @Operation(summary = "Listar CTS")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<CtsResponse>>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Long periodoCtsId,
            Pageable pageable) {
        var _page = service.listar(trabajadorId, anio, periodoCtsId, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), CtsConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener CTS por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CtsResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }
}
