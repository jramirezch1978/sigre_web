package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.service.RegistroDemoService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import com.sigre.common.dto.ApiResponse;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Autogestión de usuarios para empresas DEMO desde el ERP (módulo de seguridad).
 * Solo usuarios demo pueden listar/agregar usuarios de SU empresa (máximo 5).
 * El usuario y la empresa se resuelven del token (no se pasan por ruta).
 */
@RestController
@RequestMapping("/api/auth/seguridad/empresa-demo")
@RequiredArgsConstructor
public class EmpresaDemoController {

    private final SeguridadContextHelper contextHelper;
    private final RegistroDemoService registroDemoService;

    /** Indica si el usuario actual es demo y lista los usuarios de su empresa. */
    @GetMapping("/info")
    public ApiResponse<Map<String, Object>> info(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        List<Map<String, Object>> usuarios = registroDemoService.listarUsuariosEmpresaDemo(empresaId);
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("esDemo", registroDemoService.esUsuarioDemo(uid));
        r.put("maxUsuarios", 5);
        r.put("usados", usuarios.size());
        r.put("usuarios", usuarios);
        return ApiResponse.ok(r, "Información de empresa demo");
    }

    /** Agrega un usuario a la empresa demo del usuario actual (solo demo, máx 5). */
    @PostMapping("/usuarios")
    public ApiResponse<Void> agregarUsuario(@RequestHeader("Authorization") String auth,
                                            @Valid @RequestBody RegistroDemoRequest.UsuarioDemo nuevo) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        registroDemoService.agregarUsuarioAEmpresaDemo(uid, empresaId, nuevo);
        return ApiResponse.ok(null, "Usuario agregado a la empresa demo");
    }
}
