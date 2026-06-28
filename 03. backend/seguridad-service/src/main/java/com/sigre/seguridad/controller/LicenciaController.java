package com.sigre.seguridad.controller;

import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.seguridad.service.LicenciaService;
import com.sigre.seguridad.service.SeguridadService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.List;
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
    private final SeguridadService seguridadService;

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

    // ── Administración de licencias (solo perfil ventas/licensing) ──────────────

    /** Listado de licencias para la consola admin (LICENSING o SALES). */
    @GetMapping("/admin")
    public ApiResponse<List<Map<String, Object>>> adminListar(@RequestHeader("Authorization") String auth) {
        requireRenovador(auth);
        return ApiResponse.ok(licenciaService.listarLicencias(), "Licencias");
    }

    public record CrearLicenciaBody(Long empresaId, String edicionCodigo, String tipo,
                                    Integer maxUsuarios, String correoResponsable) {}
    public record ModificarLicenciaBody(String edicionCodigo, Integer maxUsuarios, String correoResponsable) {}

    /** Crea y asigna una nueva licencia a una empresa. Solo LICENSING. */
    @PostMapping("/admin/licencias")
    public ApiResponse<LicenciaService.LicenciaInfo> crearLicencia(@RequestHeader("Authorization") String auth,
                                                                   @RequestBody CrearLicenciaBody body) {
        requireLicensing(auth);
        if (body.empresaId() == null || body.edicionCodigo() == null || body.edicionCodigo().isBlank()) {
            throw new BusinessException("Empresa y edición son obligatorias.", HttpStatus.BAD_REQUEST);
        }
        LicenciaService.LicenciaInfo lic = licenciaService.crearLicencia(
                body.empresaId(), body.edicionCodigo(), body.tipo(), body.maxUsuarios(), body.correoResponsable());
        return ApiResponse.ok(lic, "Licencia creada");
    }

    /** Modifica una licencia (edición, máximo de usuarios, correo responsable). Solo LICENSING. */
    @PutMapping("/admin/licencias/{id}")
    public ApiResponse<LicenciaService.LicenciaInfo> modificarLicencia(@RequestHeader("Authorization") String auth,
                                                                       @PathVariable long id,
                                                                       @RequestBody ModificarLicenciaBody body) {
        requireLicensing(auth);
        return ApiResponse.ok(
                licenciaService.modificarLicencia(id, body.edicionCodigo(), body.maxUsuarios(), body.correoResponsable()),
                "Licencia modificada");
    }

    /** Anula una licencia. Solo LICENSING. */
    @PostMapping("/admin/licencias/{id}/anular")
    public ApiResponse<Void> anularLicencia(@RequestHeader("Authorization") String auth, @PathVariable long id) {
        requireLicensing(auth);
        licenciaService.anularLicencia(id);
        return ApiResponse.ok(null, "Licencia anulada");
    }

    /** Elimina una licencia. Solo LICENSING. */
    @DeleteMapping("/admin/licencias/{id}")
    public ApiResponse<Void> eliminarLicencia(@RequestHeader("Authorization") String auth, @PathVariable long id) {
        requireLicensing(auth);
        licenciaService.eliminarLicencia(id);
        return ApiResponse.ok(null, "Licencia eliminada");
    }

    private void requireLicensing(String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        seguridadService.requireLicensing(uid);
    }

    /** Resumen de la licencia + costo mensual de una empresa (consola admin de licencias). */
    @GetMapping("/admin/{empresaId}")
    public ApiResponse<Map<String, Object>> adminInfo(@RequestHeader("Authorization") String auth,
                                                      @PathVariable long empresaId) {
        // LICENSING y SALES pueden consultar (SALES necesita verla para renovar).
        requireRenovador(auth);
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("licencia", licenciaService.obtenerLicenciaActiva(empresaId));
        r.put("costo", licenciaService.calcularCostoMensual(empresaId));
        return ApiResponse.ok(r, "Licencia de la empresa");
    }

    /** Amplía el vencimiento de una licencia demo (tope: un mes desde el inicio). Solo LICENSING. */
    @PostMapping("/admin/{empresaId}/ampliar-demo")
    public ApiResponse<OffsetDateTime> ampliarDemo(@RequestHeader("Authorization") String auth,
                                                   @PathVariable long empresaId,
                                                   @RequestParam OffsetDateTime nuevaFecha) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        seguridadService.requireLicensing(uid);
        return ApiResponse.ok(licenciaService.ampliarVencimientoDemo(empresaId, nuevaFecha),
                "Vencimiento de la demo ampliado");
    }

    /**
     * Renueva una licencia de pago un mes más (recuenta exceso). Requiere fecha de pago y voucher
     * del cliente; registra quién renovó. LICENSING o SALES.
     */
    @PostMapping("/admin/{empresaId}/renovar")
    public ApiResponse<LicenciaService.CostoMensual> renovar(@RequestHeader("Authorization") String auth,
                                                             @PathVariable long empresaId,
                                                             @RequestParam LocalDate fechaPago,
                                                             @RequestParam String voucher) {
        long uid = requireRenovador(auth);
        return ApiResponse.ok(licenciaService.renovarLicencia(empresaId, fechaPago, voucher, uid),
                "Licencia renovada");
    }

    private long requireRenovador(String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        seguridadService.requireRenovador(uid);
        return uid;
    }

    private void validateProvisionSecret(HttpServletRequest request) {
        String header = request.getHeader("X-Provision-Secret");
        if (header == null || provisionSecret == null || provisionSecret.isBlank() || !provisionSecret.equals(header)) {
            throw new BusinessException("Cabecera X-Provision-Secret invalida", HttpStatus.FORBIDDEN, "PROVISION_UNAUTHORIZED");
        }
    }
}
