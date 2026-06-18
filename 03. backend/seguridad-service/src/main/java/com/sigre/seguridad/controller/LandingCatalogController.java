package com.sigre.seguridad.controller;

import com.sigre.common.dto.ApiResponse;
import com.sigre.seguridad.dto.seguridad.EdicionErpDto;
import com.sigre.seguridad.dto.seguridad.LandingCatalogoDto;
import com.sigre.seguridad.dto.seguridad.PlanSuscripcionDto;
import com.sigre.seguridad.service.LandingCatalogService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/auth/seguridad/landing")
@RequiredArgsConstructor
public class LandingCatalogController {

    private final LandingCatalogService landingCatalogService;

    @GetMapping("/catalogo")
    public ApiResponse<LandingCatalogoDto> obtenerCatalogo() {
        return ApiResponse.ok(landingCatalogService.obtenerCatalogo(), "Catálogo de landing obtenido");
    }

    @GetMapping("/ediciones")
    public ApiResponse<List<EdicionErpDto>> listarEdiciones() {
        return ApiResponse.ok(landingCatalogService.listarEdiciones(), "Ediciones del ERP obtenidas");
    }

    @GetMapping("/planes")
    public ApiResponse<List<PlanSuscripcionDto>> listarPlanes() {
        return ApiResponse.ok(landingCatalogService.listarPlanes(), "Planes de suscripción obtenidos");
    }
}
