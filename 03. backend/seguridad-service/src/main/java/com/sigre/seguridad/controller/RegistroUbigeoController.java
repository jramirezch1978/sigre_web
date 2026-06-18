package com.sigre.seguridad.controller;

import com.sigre.common.dto.ApiResponse;
import com.sigre.seguridad.dto.seguridad.UbigeoItemDto;
import com.sigre.seguridad.dto.seguridad.UbigeoLookupDto;
import com.sigre.seguridad.service.SeguridadService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/auth/seguridad/ubigeo")
@RequiredArgsConstructor
public class RegistroUbigeoController {

    private final SeguridadService seguridadService;

    @GetMapping("/departamentos")
    public ApiResponse<List<UbigeoItemDto>> listarDepartamentos() {
        return ApiResponse.ok(seguridadService.listarDepartamentos(), "Departamentos obtenidos");
    }

    @GetMapping("/provincias/{departamentoId}")
    public ApiResponse<List<UbigeoItemDto>> listarProvincias(@PathVariable long departamentoId) {
        return ApiResponse.ok(seguridadService.listarProvinciasPorDepartamento(departamentoId), "Provincias obtenidas");
    }

    @GetMapping("/distritos/{provinciaId}")
    public ApiResponse<List<UbigeoItemDto>> listarDistritos(@PathVariable long provinciaId) {
        return ApiResponse.ok(seguridadService.listarDistritosPorProvincia(provinciaId), "Distritos obtenidos");
    }

    @GetMapping("/por-codigo/{codigo}")
    public ApiResponse<UbigeoLookupDto> obtenerPorCodigo(@PathVariable String codigo) {
        return ApiResponse.ok(
                seguridadService.obtenerUbigeoPorCodigoDistrito(codigo),
                "Ubigeo obtenido");
    }
}
