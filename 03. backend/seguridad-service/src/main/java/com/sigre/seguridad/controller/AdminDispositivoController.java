package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.seguridad.ActualizarAutorizacionDispositivoRequest;
import com.sigre.seguridad.dto.seguridad.DispositivoAdminDto;
import com.sigre.seguridad.dto.seguridad.DispositivoLoginDto;
import com.sigre.seguridad.service.DispositivoService;
import com.sigre.seguridad.service.SeguridadService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import com.sigre.common.dto.ApiResponse;

import java.util.List;

/**
 * Gestión de dispositivos móviles (autorizar/revocar) — solo administradores del sistema,
 * ya que un dispositivo puede haber iniciado sesión con usuarios de distintas empresas.
 */
@RestController
@RequestMapping("/api/auth/seguridad/admin/dispositivos")
@RequiredArgsConstructor
public class AdminDispositivoController {

    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;
    private final DispositivoService dispositivoService;

    @GetMapping
    public ApiResponse<List<DispositivoAdminDto>> listar(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        seguridadService.requireAdminSistema(uid);
        return ApiResponse.ok(dispositivoService.listar(), "Dispositivos registrados");
    }

    @PutMapping("/{id}/autorizacion")
    public ApiResponse<Void> actualizarAutorizacion(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id,
            @Valid @RequestBody ActualizarAutorizacionDispositivoRequest request) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        seguridadService.requireAdminSistema(uid);
        dispositivoService.actualizarAutorizacion(id, request.isAutorizado());
        return ApiResponse.ok(null, request.isAutorizado() ? "Dispositivo autorizado" : "Dispositivo revocado");
    }

    @GetMapping("/{id}/logins")
    public ApiResponse<List<DispositivoLoginDto>> listarLogins(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        seguridadService.requireAdminSistema(uid);
        return ApiResponse.ok(dispositivoService.listarLogins(id), "Historial de inicios de sesión");
    }
}
