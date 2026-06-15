package com.sigre.auth.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.auth.dto.seguridad.ActualizarUsuarioRequest;
import com.sigre.auth.dto.seguridad.CrearUsuarioRequest;
import com.sigre.auth.dto.seguridad.UsuarioAdminDto;
import com.sigre.auth.service.SeguridadService;
import com.sigre.auth.service.UsuarioAdminCrudService;
import com.sigre.auth.support.SeguridadContextHelper;
import com.sigre.common.dto.ApiResponse;

import java.util.List;

/**
 * CRUD de usuarios para la sección de administración.
 * Todos los endpoints requieren JWT definitivo con rol admin en la empresa.
 */
@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class AdminUsuarioController {

    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;
    private final UsuarioAdminCrudService usuarioAdminCrudService;

    @GetMapping("/usuarios")
    public ApiResponse<List<UsuarioAdminDto>> listarUsuarios(
            @RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(usuarioAdminCrudService.listarUsuarios(), "Usuarios");
    }

    @GetMapping("/usuarios/{id}")
    public ApiResponse<UsuarioAdminDto> obtenerUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(usuarioAdminCrudService.obtenerUsuario(id), "Usuario");
    }

    @PostMapping("/usuarios")
    public ApiResponse<UsuarioAdminDto> crearUsuario(
            @RequestHeader("Authorization") String auth,
            @Valid @RequestBody CrearUsuarioRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(usuarioAdminCrudService.crearUsuario(body), "Usuario creado");
    }

    @PutMapping("/usuarios/{id}")
    public ApiResponse<UsuarioAdminDto> actualizarUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id,
            @Valid @RequestBody ActualizarUsuarioRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(usuarioAdminCrudService.actualizarUsuario(id, body), "Usuario actualizado");
    }

    @GetMapping("/empresas/{empresaId}/usuarios")
    public ApiResponse<List<UsuarioAdminDto>> listarUsuariosEmpresa(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId) {
        long uid = contextHelper.requireUserIdAny(auth);
        if (!seguridadService.isAdminSistema(uid)) {
            contextHelper.requireEmpresaEnToken(auth, empresaId);
            seguridadService.requireAdmin(uid, empresaId);
        }
        return ApiResponse.ok(usuarioAdminCrudService.listarUsuariosDeEmpresa(empresaId), "Usuarios de empresa");
    }
}
