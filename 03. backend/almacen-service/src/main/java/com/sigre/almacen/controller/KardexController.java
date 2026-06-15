package com.sigre.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.almacen.dto.KardexResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.service.ReporteAlmacenService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;

/**
 * Kardex valorizado (HU-ALM-CON-KDX-001). Fuente: {@code almacen.articulo_saldo_mensual}.
 */
@RestController
@RequestMapping("/api/almacen/kardex")
@RequiredArgsConstructor
public class KardexController {

    private final ReporteAlmacenService reporteAlmacenService;

    @GetMapping
    public ApiResponse<PageData<KardexResponse>> consultar(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = reporteAlmacenService.kardex(almacenId, articuloId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }
}
