package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.service.RegistroDemoService;
import com.sigre.seguridad.service.LicenciaService;
import com.sigre.seguridad.service.EmailService;
import com.sigre.common.dto.ApiResponse;

import java.time.format.DateTimeFormatter;

@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class RegistroDemoController {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final RegistroDemoService registroDemoService;
    private final EmailService emailService;

    @PostMapping("/registro-demo")
    public ApiResponse<LicenciaService.LicenciaDemo> registroDemo(@Valid @RequestBody RegistroDemoRequest request) {
        LicenciaService.LicenciaDemo licencia = registroDemoService.registrarDemo(request);

        // Correo con el número de licencia (async, best-effort).
        var emp = request.getEmpresa();
        emailService.enviarLicenciaDemo(
                emp.getCorreoContacto(), emp.getRazonSocial(),
                licencia.codigo(), licencia.vencimiento().format(FMT), licencia.diasVigencia());

        return ApiResponse.ok(licencia, "Empresa demo registrada exitosamente");
    }
}
