package com.sigre.seguridad.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.*;
import com.sigre.seguridad.service.AuthService;
import com.sigre.seguridad.service.DispositivoService;
import com.sigre.seguridad.service.HealthPingService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.JwtTokenProvider;

import java.util.List;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final JwtTokenProvider jwtTokenProvider;
    private final DispositivoService dispositivoService;
    private final HealthPingService healthPingService;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.login(request), "Login exitoso");
    }

    /**
     * Login sin verificación Turnstile.
     * Solo disponible cuando {@code app.auth.dev-login-enabled=true} (variable {@code DEV_LOGIN_ENABLED=true}).
     * Usar exclusivamente desde Postman / entornos de desarrollo.
     */
    @PostMapping("/login/dev")
    public ApiResponse<LoginResponse> loginDev(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.loginDev(request), "Login dev exitoso");
    }

    /**
     * Login para apps móviles nativas (Hermes, etc.) — sin Cloudflare Turnstile.
     * Requiere que {@code nroRegistroDispositivo} corresponda a un dispositivo ya dado de
     * alta con POST /dispositivo/registrar y autorizado (ver /admin/dispositivos).
     */
    @PostMapping("/login/mobile")
    public ApiResponse<LoginResponse> loginMobile(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.loginMobile(request), "Login exitoso");
    }

    /**
     * Alta del maestro (DEVICE_MOBILE) + apertura/reutilización de sesión (SEG_LOGIN_DEVICE).
     * El nro_registro retornado es de la sesión, no del dispositivo. Nace autorizado.
     */
    @PostMapping("/dispositivo/registrar")
    public ApiResponse<DispositivoRegistradoResponse> registrarDispositivo(
            @Valid @RequestBody RegistrarDispositivoRequest request,
            HttpServletRequest httpRequest) {
        // Si el cliente no pudo resolver la IP pública, usar la vista por el gateway/proxy.
        if (request.getIpPublica() == null || request.getIpPublica().isBlank()) {
            request.setIpPublica(resolveClientIp(httpRequest));
        }
        return ApiResponse.ok(dispositivoService.registrar(request), "Dispositivo registrado");
    }

    private static String resolveClientIp(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }
        return request.getRemoteAddr();
    }

    /**
     * Ping público para apps móviles (Hermes) — equivalente REST de SOAP {@code ImplHealth.ping}.
     * Devuelve tiempos de conexión y query a la BD security; la latencia total la mide el cliente.
     */
    @GetMapping("/health/ping")
    public ApiResponse<HealthPingResponse> healthPing() {
        HealthPingResponse ping = healthPingService.ping();
        return ApiResponse.ok(ping, ping.isOk() ? "pong" : "ping fallido");
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
