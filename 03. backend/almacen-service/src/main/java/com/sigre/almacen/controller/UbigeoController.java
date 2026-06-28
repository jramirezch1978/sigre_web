package com.sigre.almacen.controller;

import com.sigre.almacen.repository.TgUbigeoRepository;
import com.sigre.common.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** Catálogo TG_UBIGEO para poblar selects (almacén, etc.). */
@RestController
@RequestMapping("/api/almacen/ubigeos")
@RequiredArgsConstructor
public class UbigeoController {

    private final TgUbigeoRepository repository;

    /** value = código (CHAR 6, FK), label = "código — descripción". */
    public record UbigeoOption(String value, String label) {}

    @GetMapping
    public ApiResponse<List<UbigeoOption>> listar() {
        List<UbigeoOption> opciones = repository.findAllByOrderByUbigeDescripcionAsc().stream()
                .map(u -> new UbigeoOption(
                        u.getUbigeoCodigo(),
                        u.getUbigeoCodigo() + " — " + (u.getUbigeDescripcion() != null ? u.getUbigeDescripcion() : "")))
                .toList();
        return ApiResponse.ok(opciones, "Ubigeos");
    }
}
