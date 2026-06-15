package com.sigre.core.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.DefinitiveTokenClaims;
import com.sigre.common.security.JwtDefinitiveTokenResolver;
import com.sigre.core.dto.SucursalDto;
import com.sigre.core.dto.UsuarioSucursalSyncResponse;
import com.sigre.core.service.SucursalMaestroService;

import java.util.List;
import java.util.Optional;

/**
 * Sucursales por empresa (tenant) y asignación usuario–sucursal (BD security).
 * <ul>
 *   <li>Con {@code X-Provision-Secret} válido: operaciones de aprovisionamiento (sin JWT).</li>
 *   <li>Sin secret (o vacío): JWT definitivo, empresa del token y rol administrador en la empresa.</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/core/empresas")
@RequiredArgsConstructor
public class EmpresaSucursalController {

    private final SucursalMaestroService sucursalMaestroService;
    private final JwtDefinitiveTokenResolver tokenResolver;

    @Value("${app.provisioning.secret:}")
    private String provisionSecret;

    @GetMapping("/{empresaId}/sucursales")
    public ApiResponse<List<SucursalDto>> listarSucursalesCompletas(
            HttpServletRequest request,
            Authentication authentication,
            @PathVariable Long empresaId) {
        resolveProvisionOrJwtAdmin(request, authentication, empresaId);
        List<SucursalDto> data = sucursalMaestroService.listarSucursalesCompletasPorEmpresa(empresaId);
        return ApiResponse.ok(data, "Sucursales del tenant");
    }

    /**
     * Sucursales asignadas a un usuario (vista administrador). Misma autorización que el catálogo completo.
     */
    @GetMapping("/{empresaId}/usuarios/{usuarioId}/sucursales")
    public ApiResponse<List<SucursalDto>> listarSucursalesAsignadasAUsuario(
            HttpServletRequest request,
            Authentication authentication,
            @PathVariable Long empresaId,
            @PathVariable Long usuarioId) {
        resolveProvisionOrJwtAdmin(request, authentication, empresaId);
        List<SucursalDto> data = sucursalMaestroService.listarSucursalesPorUsuario(usuarioId, empresaId);
        return ApiResponse.ok(data, "Sucursales asignadas al usuario");
    }

    /**
     * Sucursales asignadas al usuario autenticado (JWT) para la empresa indicada.
     */
    @GetMapping("/{empresaId}/sucursales/mias")
    public ApiResponse<List<SucursalDto>> listarSucursalesDelUsuario(
            Authentication authentication,
            @PathVariable Long empresaId) {
        Long userId = extractUserId(authentication);
        List<SucursalDto> data = sucursalMaestroService.listarSucursalesPorUsuario(userId, empresaId);
        return ApiResponse.ok(data, "Sucursales asignadas al usuario para la empresa");
    }

    @PostMapping("/{empresaId}/usuarios/{usuarioId}/sucursales/{sucursalId}")
    public ApiResponse<UsuarioSucursalSyncResponse> asociarUsuarioASucursal(
            HttpServletRequest request,
            Authentication authentication,
            @PathVariable Long empresaId,
            @PathVariable Long usuarioId,
            @PathVariable Long sucursalId) {
        resolveProvisionOrJwtAdmin(request, authentication, empresaId);
        UsuarioSucursalSyncResponse data =
                sucursalMaestroService.asociarUsuarioASucursal(empresaId, usuarioId, sucursalId);
        return ApiResponse.ok(data, data.getMensaje());
    }

    @DeleteMapping("/{empresaId}/usuarios/{usuarioId}/sucursales/{sucursalId}")
    public ApiResponse<UsuarioSucursalSyncResponse> retirarUsuarioDeSucursal(
            HttpServletRequest request,
            Authentication authentication,
            @PathVariable Long empresaId,
            @PathVariable Long usuarioId,
            @PathVariable Long sucursalId) {
        resolveProvisionOrJwtAdmin(request, authentication, empresaId);
        UsuarioSucursalSyncResponse data =
                sucursalMaestroService.retirarUsuarioDeSucursal(empresaId, usuarioId, sucursalId);
        return ApiResponse.ok(data, data.getMensaje());
    }

    private void resolveProvisionOrJwtAdmin(
            HttpServletRequest request,
            Authentication authentication,
            Long empresaId) {
        String header = request.getHeader("X-Provision-Secret");
        if (header != null && !header.isBlank()) {
            validateProvisionSecret(request);
            return;
        }

        String authHeader = request.getHeader("Authorization");
        Optional<DefinitiveTokenClaims> optClaims = tokenResolver.resolve(authHeader);
        if (optClaims.isPresent()) {
            DefinitiveTokenClaims claims = optClaims.get();
            Long userId = claims.getUserId();

            if (userId != null && sucursalMaestroService.isAdminSistema(userId)) {
                return;
            }

            if (claims.isTemporal()) {
                throw new BusinessException(
                        "Se requiere sesión definitiva (empresa seleccionada)",
                        HttpStatus.FORBIDDEN, "TOKEN_TEMPORAL");
            }
            requireEmpresaCoincide(claims, empresaId);
            sucursalMaestroService.requireUsuarioEsAdminEmpresa(userId, empresaId);
            return;
        }

        DefinitiveTokenClaims claims = requireDefinitiveClaims(authentication);
        requireEmpresaCoincide(claims, empresaId);
        sucursalMaestroService.requireUsuarioEsAdminEmpresa(claims.getUserId(), empresaId);
    }

    private void validateProvisionSecret(HttpServletRequest request) {
        String header = request.getHeader("X-Provision-Secret");
        if (header == null || !provisionSecret.equals(header)) {
            throw new BusinessException("Cabecera X-Provision-Secret invalida", HttpStatus.FORBIDDEN, "PROVISION_UNAUTHORIZED");
        }
    }

    private static DefinitiveTokenClaims requireDefinitiveClaims(Authentication authentication) {
        if (authentication == null || authentication.getDetails() == null) {
            throw new BusinessException("No autenticado", HttpStatus.UNAUTHORIZED, "NO_AUTENTICADO");
        }
        Object d = authentication.getDetails();
        if (!(d instanceof DefinitiveTokenClaims claims)) {
            throw new BusinessException("Token sin claims definitivos", HttpStatus.UNAUTHORIZED, "USUARIO_TOKEN_INVALIDO");
        }
        if (claims.isTemporal()) {
            throw new BusinessException(
                    "Se requiere sesión definitiva (empresa seleccionada)",
                    HttpStatus.FORBIDDEN,
                    "TOKEN_TEMPORAL");
        }
        return claims;
    }

    private static void requireEmpresaCoincide(DefinitiveTokenClaims claims, Long empresaId) {
        if (claims.getEmpresaId() == null || !claims.getEmpresaId().equals(empresaId)) {
            throw new BusinessException(
                    "La empresa no coincide con el token",
                    HttpStatus.FORBIDDEN,
                    "EMPRESA_TOKEN_MISMATCH");
        }
    }

    private static Long extractUserId(Authentication authentication) {
        if (authentication == null || authentication.getDetails() == null) {
            throw new BusinessException("No autenticado", HttpStatus.UNAUTHORIZED, "NO_AUTENTICADO");
        }
        Object d = authentication.getDetails();
        if (d instanceof DefinitiveTokenClaims claims) {
            return claims.getUserId();
        }
        if (d instanceof Number n) {
            return n.longValue();
        }
        throw new BusinessException("Token sin identificador de usuario", HttpStatus.UNAUTHORIZED, "USUARIO_TOKEN_INVALIDO");
    }
}
