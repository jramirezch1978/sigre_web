package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.service.RegistroDemoService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class RegistroDemoController {

    private final RegistroDemoService registroDemoService;

    @PostMapping("/registro-demo")
    public ApiResponse<Void> registroDemo(@Valid @RequestBody RegistroDemoRequest request) {
        registroDemoService.registrarDemo(request);
        return ApiResponse.ok(null, "Empresa demo registrada exitosamente");
    }
}
