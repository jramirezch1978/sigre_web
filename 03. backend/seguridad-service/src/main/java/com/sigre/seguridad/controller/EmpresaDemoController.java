package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.service.LicenciaService;
import com.sigre.seguridad.service.RegistroDemoService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import com.sigre.common.dto.ApiResponse;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Autogestión de usuarios de la empresa desde el ERP (módulo de seguridad). Vale tanto para
 * empresas demo (límite duro de 5) como de pago (advertencia + costo al exceder el límite).
 * El usuario y la empresa se resuelven del token (no se pasan por ruta).
 */
@RestController
@RequestMapping("/api/auth/seguridad/empresa-demo")
@RequiredArgsConstructor
public class EmpresaDemoController {

    private final SeguridadContextHelper contextHelper;
    private final RegistroDemoService registroDemoService;
    private final LicenciaService licenciaService;

    /** Usuarios de la empresa + estado de la licencia (límite, activos, si el siguiente excede). */
    @GetMapping("/info")
    public ApiResponse<Map<String, Object>> info(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        List<Map<String, Object>> usuarios = registroDemoService.listarUsuariosEmpresaDemo(empresaId);
        LicenciaService.AltaUsuarioEval eval = licenciaService.evaluarAltaUsuario(empresaId);
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("esDemo", eval.esDemo());
        r.put("maxUsuarios", eval.maxUsuarios());
        r.put("usados", usuarios.size());
        r.put("usuariosActivos", eval.usuariosActivos());
        r.put("proximoExcede", eval.excede());
        r.put("costoUsuarioAdicional", eval.costoUsuarioAdicional());
        r.put("usuarios", usuarios);
        return ApiResponse.ok(r, "Información de la empresa");
    }

    /** Evalúa si dar de alta un usuario más excede el límite (para mostrar la advertencia). */
    @GetMapping("/evaluar-alta")
    public ApiResponse<LicenciaService.AltaUsuarioEval> evaluarAlta(@RequestHeader("Authorization") String auth) {
        contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        return ApiResponse.ok(licenciaService.evaluarAltaUsuario(empresaId), "Evaluación de alta de usuario");
    }

    /**
     * Agrega un usuario a la empresa del usuario actual. Si excede el límite de la licencia,
     * debe enviarse {@code confirmarExceso=true} (tras aceptar la advertencia) para registrar el cobro.
     */
    @PostMapping("/usuarios")
    public ApiResponse<Void> agregarUsuario(@RequestHeader("Authorization") String auth,
                                            @RequestParam(defaultValue = "false") boolean confirmarExceso,
                                            @Valid @RequestBody RegistroDemoRequest.UsuarioDemo nuevo) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        registroDemoService.agregarUsuarioEmpresa(uid, empresaId, nuevo, confirmarExceso);
        return ApiResponse.ok(null, "Usuario agregado");
    }
}
