package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.service.RegistroDemoService;
import com.sigre.seguridad.service.LicenciaService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class RegistroDemoController {

    private final RegistroDemoService registroDemoService;

    @PostMapping("/registro-demo")
    public ApiResponse<LicenciaService.LicenciaDemo> registroDemo(@Valid @RequestBody RegistroDemoRequest request) {
        LicenciaService.LicenciaDemo licencia = registroDemoService.registrarDemo(request);
        return ApiResponse.ok(licencia, "Empresa demo registrada exitosamente");
    }
}
