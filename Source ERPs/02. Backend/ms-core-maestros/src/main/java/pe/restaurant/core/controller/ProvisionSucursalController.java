package pe.restaurant.core.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.core.dto.request.ProvisionSucursalRequest;
import pe.restaurant.core.dto.response.ProvisionSucursalResponse;
import pe.restaurant.core.service.ProvisionSucursalService;

import java.util.List;

/**
 * Endpoints provisionados para CRUD de sucursales en la BD tenant.
 * <p>Protegidos únicamente por cabecera {@code X-Provision-Secret}.
 * Sin dependencia de JWT ni de {@code TenantContext}. Diseñados para ser consumidos
 * por un proyecto externo de gestión/administración.</p>
 *
 * <p>Ruta base: {@code /api/core/empresas/{empresaId}/provision/sucursales}</p>
 */
@RestController
@RequestMapping("/api/core/empresas")
@RequiredArgsConstructor
public class ProvisionSucursalController {

    private final ProvisionSucursalService service;

    @Value("${app.provisioning.secret:}")
    private String provisionSecret;

    @PostMapping("/{empresaId}/provision/sucursales")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ProvisionSucursalResponse> crear(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId,
            @Valid @RequestBody ProvisionSucursalRequest body) {
        validateProvisionSecret(httpRequest);
        ProvisionSucursalResponse data = service.crear(empresaId, body);
        return ApiResponse.ok(data, "Sucursal creada");
    }

    @PutMapping("/{empresaId}/provision/sucursales/{id}")
    public ApiResponse<ProvisionSucursalResponse> actualizar(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId,
            @PathVariable Long id,
            @Valid @RequestBody ProvisionSucursalRequest body) {
        validateProvisionSecret(httpRequest);
        ProvisionSucursalResponse data = service.actualizar(empresaId, id, body);
        return ApiResponse.ok(data, "Sucursal actualizada");
    }

    @DeleteMapping("/{empresaId}/provision/sucursales/{id}")
    public ApiResponse<Void> eliminar(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId,
            @PathVariable Long id) {
        validateProvisionSecret(httpRequest);
        service.eliminar(empresaId, id);
        return ApiResponse.ok(null, "Sucursal eliminada");
    }

    @GetMapping("/{empresaId}/provision/sucursales")
    public ApiResponse<List<ProvisionSucursalResponse>> listar(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId) {
        validateProvisionSecret(httpRequest);
        List<ProvisionSucursalResponse> data = service.listar(empresaId);
        return ApiResponse.ok(data, "Sucursales del tenant");
    }

    @GetMapping("/{empresaId}/provision/sucursales/{id}")
    public ApiResponse<ProvisionSucursalResponse> obtener(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId,
            @PathVariable Long id) {
        validateProvisionSecret(httpRequest);
        ProvisionSucursalResponse data = service.obtener(empresaId, id);
        return ApiResponse.ok(data, "Sucursal encontrada");
    }

    private void validateProvisionSecret(HttpServletRequest request) {
        String header = request.getHeader("X-Provision-Secret");
        if (header == null || !provisionSecret.equals(header)) {
            throw new BusinessException(
                    "Cabecera X-Provision-Secret invalida",
                    HttpStatus.FORBIDDEN,
                    "PROVISION_UNAUTHORIZED");
        }
    }
}
