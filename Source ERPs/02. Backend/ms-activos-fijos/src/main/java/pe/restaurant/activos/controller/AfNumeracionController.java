package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfNumeracionConfigRequest;
import pe.restaurant.activos.dto.AfNumeracionConfigResponse;
import pe.restaurant.activos.dto.SiguienteCodigoResponse;
import pe.restaurant.activos.service.AfNumeracionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/numeracion")
@RequiredArgsConstructor
public class AfNumeracionController {

    private final AfNumeracionService service;

    @GetMapping("/{tipo}")
    public ApiResponse<AfNumeracionConfigResponse> obtenerConfig(@PathVariable String tipo) {
        return ApiResponse.ok(service.obtenerConfig(tipo));
    }

    @PutMapping("/{tipo}")
    public ApiResponse<AfNumeracionConfigResponse> actualizarConfig(
            @PathVariable String tipo,
            @Valid @RequestBody AfNumeracionConfigRequest request) {
        return ApiResponse.ok(service.actualizarConfig(tipo, request));
    }

    @PostMapping("/{tipo}/siguiente-codigo")
    public ApiResponse<SiguienteCodigoResponse> siguienteCodigo(@PathVariable String tipo) {
        return ApiResponse.ok(service.generarSiguienteCodigo(tipo));
    }
}
