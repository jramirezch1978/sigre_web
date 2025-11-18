package com.sigre.seguridad.controller;

import com.sigre.seguridad.model.dto.LoginRequest;
import com.sigre.seguridad.model.dto.LoginResponse;
import com.sigre.seguridad.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Controlador REST para Autenticación
 */
@Slf4j
@RestController
@RequestMapping
@RequiredArgsConstructor
@Tag(name = "Autenticación", description = "APIs para login, logout y refresh de tokens")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    @Operation(summary = "Login de usuario", description = "Autentica usuario y retorna tokens JWT")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        log.info("POST /login - Usuario: {}", request.getUsuario());
        try {
            LoginResponse response = authService.login(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error en login: {}", e.getMessage());
            throw new RuntimeException(e.getMessage());
        }
    }

    @PostMapping("/logout")
    @Operation(summary = "Logout de usuario", description = "Invalida el token actual del usuario")
    public ResponseEntity<Map<String, String>> logout(
            @RequestHeader("X-User-Id") String usuario) {
        log.info("POST /logout - Usuario: {}", usuario);
        authService.logout(usuario);
        return ResponseEntity.ok(Map.of("message", "Logout exitoso"));
    }

    @PostMapping("/refresh")
    @Operation(summary = "Refrescar token", description = "Genera un nuevo access token usando el refresh token")
    public ResponseEntity<LoginResponse> refreshToken(@RequestBody Map<String, String> request) {
        log.info("POST /refresh");
        String refreshToken = request.get("refreshToken");
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new RuntimeException("Refresh token es requerido");
        }
        
        LoginResponse response = authService.refreshToken(refreshToken);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    @Operation(summary = "Health check", description = "Verifica que el servicio esté funcionando")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "service", "seguridad-service",
            "timestamp", java.time.LocalDateTime.now().toString()
        ));
    }
}

