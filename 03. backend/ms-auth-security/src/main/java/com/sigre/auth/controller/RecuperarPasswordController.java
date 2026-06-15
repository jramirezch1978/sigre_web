package com.sigre.auth.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.auth.dto.RecuperarPasswordRequest;
import com.sigre.auth.service.PasswordRecoveryService;
import com.sigre.common.dto.ApiResponse;

import java.util.Map;

@RestController
@RequestMapping("/api/auth/recuperar")
@RequiredArgsConstructor
public class RecuperarPasswordController {

    private final PasswordRecoveryService recoveryService;

    @PostMapping("/obtener-email-ofuscado")
    public ApiResponse<Map<String, String>> obtenerEmailOfuscado(
            @RequestBody RecuperarPasswordRequest request) {
        String emailOculto = recoveryService.obtenerEmailOfuscado(request.getUsername());
        return ApiResponse.ok(Map.of("emailOculto", emailOculto), "Email ofuscado obtenido");
    }

    @PostMapping("/verificar-email")
    public ApiResponse<Map<String, String>> verificarEmail(
            @Valid @RequestBody RecuperarPasswordRequest request) {
        String emailOculto = recoveryService.verificarEmail(request.getEmail());
        return ApiResponse.ok(Map.of("emailOculto", emailOculto), "Email verificado");
    }

    @PostMapping("/enviar-codigo")
    public ApiResponse<Void> enviarCodigo(
            @Valid @RequestBody RecuperarPasswordRequest request) {
        recoveryService.enviarCodigo(request.getEmail());
        return ApiResponse.ok(null, "Código enviado al correo electrónico");
    }

    @PostMapping("/validar-codigo")
    public ApiResponse<Void> validarCodigo(
            @Valid @RequestBody RecuperarPasswordRequest request) {
        recoveryService.validarCodigo(request.getEmail(), request.getCodigo());
        return ApiResponse.ok(null, "Código válido");
    }

    @PostMapping("/cambiar-password")
    public ApiResponse<Void> cambiarPassword(
            @Valid @RequestBody RecuperarPasswordRequest request) {
        recoveryService.cambiarPassword(request.getEmail(), request.getCodigo(), request.getNuevaPassword(), request.getNuevaPasswordHash());
        return ApiResponse.ok(null, "Contraseña actualizada correctamente");
    }

    @PostMapping("/limpiar-expirados")
    public ApiResponse<Void> limpiarCodigosExpirados() {
        recoveryService.desactivarCodigosExpiradosAsync();
        return ApiResponse.ok(null, "Limpieza de códigos expirados iniciada");
    }
}
