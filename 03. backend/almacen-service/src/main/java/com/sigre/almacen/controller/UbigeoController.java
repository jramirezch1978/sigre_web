package com.sigre.almacen.controller;

import com.sigre.almacen.repository.SunatUbigeoRepository;
import com.sigre.common.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** Catálogo SUNAT_UBIGEO para poblar selects (almacén, etc.). Solo ubigeos activos. */
@RestController
@RequestMapping("/api/almacen/ubigeos")
@RequiredArgsConstructor
public class UbigeoController {

    private final SunatUbigeoRepository repository;

    /** value = id (FK), label = "ubigeo — DISTRITO (PROVINCIA, DEPARTAMENTO)". */
    public record UbigeoOption(Long value, String label) {}

    @GetMapping
    public ApiResponse<List<UbigeoOption>> listar() {
        List<UbigeoOption> opciones = repository
                .findByFlagEstadoOrderByDepartamentoAscProvinciaAscDistritoAsc("1").stream()
                .map(u -> new UbigeoOption(
                        u.getId(),
                        u.getUbigeo() + " — " + u.getDistrito()
                                + " (" + u.getProvincia() + ", " + u.getDepartamento() + ")"))
                .toList();
        return ApiResponse.ok(opciones, "Ubigeos");
    }
}
