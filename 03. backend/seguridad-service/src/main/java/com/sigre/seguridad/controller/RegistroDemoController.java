package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.service.RegistroDemoService;
import com.sigre.seguridad.service.LicenciaService;
import com.sigre.seguridad.service.EmailService;
import com.sigre.seguridad.service.TenantProvisioningService;
import com.sigre.common.dto.ApiResponse;

import java.time.format.DateTimeFormatter;

@Slf4j
@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class RegistroDemoController {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final RegistroDemoService registroDemoService;
    private final EmailService emailService;
    private final TenantProvisioningService tenantProvisioningService;

    @PostMapping("/registro-demo")
    public ApiResponse<LicenciaService.LicenciaDemo> registroDemo(@Valid @RequestBody RegistroDemoRequest request) {
        // 1) Alta transaccional: empresa + usuarios + licencia.
        RegistroDemoService.RegistroDemoResult res = registroDemoService.registrarDemo(request);

        // 2) Provisión de la BD del tenant (fuera de la transacción). Best-effort:
        //    si falla, el registro ya quedó hecho; se loguea para reintentar.
        try {
            tenantProvisioningService.provisionarBaseDatosDemo(res.empresaId());
        } catch (Exception e) {
            log.error("Registro demo OK pero falló la provisión de BD {}: {}", res.dbName(), e.getMessage());
        }

        // 3) Correo con el número de licencia (async, best-effort).
        var emp = request.getEmpresa();
        emailService.enviarLicenciaDemo(
                emp.getCorreoContacto(), emp.getRazonSocial(),
                res.licencia().codigo(), res.licencia().vencimiento().format(FMT), res.licencia().diasVigencia());

        return ApiResponse.ok(res.licencia(), "Empresa demo registrada exitosamente");
    }
}
