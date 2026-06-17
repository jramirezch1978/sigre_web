package com.sigre.seguridad.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.seguridad.dto.seguridad.UbigeoItemDto;
import com.sigre.seguridad.service.SeguridadService;

import java.util.List;

@RestController
@RequestMapping("/api/admin/ubigeo")
@RequiredArgsConstructor
public class AdminUbigeoController {

    private final SeguridadService seguridadService;

    @GetMapping("/departamentos")
    public ApiResponse<List<UbigeoItemDto>> listarDepartamentos() {
        return ApiResponse.ok(seguridadService.listarDepartamentos());
    }

    @GetMapping("/provincias/{departamentoId}")
    public ApiResponse<List<UbigeoItemDto>> listarProvincias(@PathVariable long departamentoId) {
        return ApiResponse.ok(seguridadService.listarProvinciasPorDepartamento(departamentoId));
    }

    @GetMapping("/distritos/{provinciaId}")
    public ApiResponse<List<UbigeoItemDto>> listarDistritos(@PathVariable long provinciaId) {
        return ApiResponse.ok(seguridadService.listarDistritosPorProvincia(provinciaId));
    }
}
