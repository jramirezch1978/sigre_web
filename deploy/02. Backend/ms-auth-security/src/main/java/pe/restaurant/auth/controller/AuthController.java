package pe.restaurant.auth.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.auth.dto.*;
import pe.restaurant.auth.service.AuthService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.JwtTokenProvider;

import java.util.List;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final JwtTokenProvider jwtTokenProvider;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.login(request), "Login exitoso");
    }

    @GetMapping("/empresas")
    public ApiResponse<List<EmpresaUsuarioDto>> listarEmpresas(
            @RequestHeader("Authorization") String authHeader) {
        Long userId = extractAndValidateToken(authHeader, true);
        List<EmpresaUsuarioDto> empresas = authService.listarEmpresas(userId);
        return ApiResponse.ok(empresas, "Empresas del usuario");
    }

    @PostMapping("/seleccionar-empresa")
    public ApiResponse<LoginResponse> seleccionarEmpresa(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @Valid @RequestBody SeleccionEmpresaRequest request) {
        Long userId = resolveUserIdForSeleccionarEmpresa(authHeader, request);
        LoginResponse response = authService.seleccionarEmpresa(userId, request);
        return ApiResponse.ok(response, "Empresa seleccionada correctamente");
    }

    @PostMapping("/logout")
    public ApiResponse<Void> logout(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ApiResponse.ok(null, "Sesión cerrada");
        }
        String token = authHeader.substring(7);
        if (!jwtTokenProvider.validateToken(token)) {
            return ApiResponse.ok(null, "Sesión cerrada");
        }
        Long userId = jwtTokenProvider.getUserId(token);
        authService.logout(userId, authHeader);
        return ApiResponse.ok(null, "Sesión cerrada");
    }

    @PostMapping("/refresh")
    public ApiResponse<RefreshTokenResponse> refresh(@Valid @RequestBody RefreshTokenRequest request) {
        return ApiResponse.ok(authService.refreshToken(request), "Token renovado");
    }

    @GetMapping("/me")
    public ApiResponse<AuthMeResponse> me(@RequestHeader("Authorization") String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new BusinessException("Token requerido",
                    HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }
        String token = authHeader.substring(7);
        return ApiResponse.ok(authService.getProfile(token), "Perfil del usuario autenticado");
    }

    private Long extractAndValidateToken(String authHeader, boolean requireTemporal) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new BusinessException("Token requerido",
                    HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }
        String token = authHeader.substring(7);

        if (!jwtTokenProvider.validateToken(token)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }

        if (requireTemporal) {
            Boolean isTemporal = jwtTokenProvider.getClaim(token, "temporal", Boolean.class);
            if (isTemporal == null || !isTemporal) {
                // También acepta token definitivo para consultar empresas
            }
        }

        return jwtTokenProvider.getUserId(token);
    }

    /**
     * Bearer temporal/definitivo válido, o autenticación por credenciales en el cuerpo (sin paso intermedio de token temporal).
     */
    private Long resolveUserIdForSeleccionarEmpresa(String authHeader, SeleccionEmpresaRequest request) {
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String raw = authHeader.substring(7).trim();
            if (!raw.isEmpty()) {
                return extractAndValidateToken(authHeader, true);
            }
        }
        return authService.authenticateCredentialsForSeleccionEmpresa(request);
    }
}
