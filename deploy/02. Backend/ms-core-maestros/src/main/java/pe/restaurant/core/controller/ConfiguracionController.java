package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.service.ConfiguracionService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/core/config")
@RequiredArgsConstructor
public class ConfiguracionController {
    private final ConfiguracionService service;

    @GetMapping("/claves")
    public ApiResponse<List<ConfigClaveResponse>> listClaves(
            @RequestParam(required = false) String modulo,
            @RequestParam(required = false) String nivel,
            @RequestParam(required = false) String flagEstado
    ) {
        return ApiResponse.ok(service.listClaves(modulo, nivel, flagEstado));
    }

    @PostMapping("/resolver")
    public ApiResponse<ConfigResolverResult> resolver(@Valid @RequestBody ConfigResolverRequest request) {
        return ApiResponse.ok(service.resolver(request));
    }

    @GetMapping("/empresa")
    public ApiResponse<Map<String, Object>> getEmpresa(
            @RequestParam Long empresaId,
            @RequestParam(required = false) List<String> claves
    ) {
        return ApiResponse.ok(service.getEmpresa(empresaId, claves));
    }

    @PutMapping("/empresa")
    public ApiResponse<Map<String, Object>> saveEmpresa(@Valid @RequestBody ConfigEmpresaSaveRequest request) {
        return ApiResponse.ok(service.saveEmpresa(request), "Configuracion empresa guardada");
    }

    @GetMapping("/sucursal")
    public ApiResponse<Map<String, Object>> getSucursal(
            @RequestParam Long empresaId,
            @RequestParam Long sucursalId,
            @RequestParam(required = false) List<String> claves
    ) {
        return ApiResponse.ok(service.getSucursal(empresaId, sucursalId, claves));
    }

    @PutMapping("/sucursal")
    public ApiResponse<Map<String, Object>> saveSucursal(@Valid @RequestBody ConfigSucursalSaveRequest request) {
        return ApiResponse.ok(service.saveSucursal(request), "Configuracion sucursal guardada");
    }

    @GetMapping("/usuario")
    public ApiResponse<Map<String, Object>> getUsuario(
            @RequestParam Long empresaId,
            @RequestParam Long usuarioId,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) List<String> claves
    ) {
        return ApiResponse.ok(service.getUsuario(empresaId, usuarioId, sucursalId, claves));
    }

    @PutMapping("/usuario")
    public ApiResponse<Map<String, Object>> saveUsuario(@Valid @RequestBody ConfigUsuarioSaveRequest request) {
        return ApiResponse.ok(service.saveUsuario(request), "Configuracion usuario guardada");
    }
}
