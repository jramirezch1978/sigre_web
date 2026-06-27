package com.sigre.seguridad.controller;

import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.seguridad.service.LicenciaService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Licencias: consulta del costo mensual (frontend) y disparador del aviso de renovación
 * (lo invoca worker-service de forma agendada, con la cabecera X-Provision-Secret).
 */
@RestController
@RequestMapping("/api/auth/seguridad/licencias")
@RequiredArgsConstructor
public class LicenciaController {

    private final LicenciaService licenciaService;
    private final SeguridadContextHelper contextHelper;

    @Value("${app.provisioning.secret:}")
    private String provisionSecret;

    /** Costo mensual de la licencia de la empresa del usuario actual (desglose para mostrar en el ERP). */
    @GetMapping("/costo")
    public ApiResponse<LicenciaService.CostoMensual> costoMensual(@RequestHeader("Authorization") String auth) {
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        return ApiResponse.ok(licenciaService.calcularCostoMensual(empresaId), "Costo mensual de la licencia");
    }

    /**
     * Procesa los avisos de renovación de licencias por vencer. Endpoint interno: solo se
     * acepta con la cabecera {@code X-Provision-Secret}. Lo llama worker-service a diario.
     */
    @PostMapping("/procesar-renovaciones")
    public ApiResponse<Map<String, Object>> procesarRenovaciones(HttpServletRequest request,
                                                                 @RequestParam(required = false) Integer diasAviso) {
        validateProvisionSecret(request);
        int dias = diasAviso != null ? diasAviso : LicenciaService.DIAS_AVISO_RENOVACION;
        int enviados = licenciaService.procesarRenovacionesPorVencer(dias);
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("diasAviso", dias);
        r.put("avisosEnviados", enviados);
        return ApiResponse.ok(r, "Renovaciones procesadas");
    }

    private void validateProvisionSecret(HttpServletRequest request) {
        String header = request.getHeader("X-Provision-Secret");
        if (header == null || provisionSecret == null || provisionSecret.isBlank() || !provisionSecret.equals(header)) {
            throw new BusinessException("Cabecera X-Provision-Secret invalida", HttpStatus.FORBIDDEN, "PROVISION_UNAUTHORIZED");
        }
    }
}
