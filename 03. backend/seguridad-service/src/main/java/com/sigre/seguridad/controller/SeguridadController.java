package com.sigre.seguridad.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.seguridad.dto.EnviarCorreoBienvenidaResponse;
import com.sigre.seguridad.dto.seguridad.*;
import com.sigre.seguridad.service.SeguridadService;
import com.sigre.seguridad.service.TenantProvisioningService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import com.sigre.common.dto.ApiResponse;

import java.util.List;

/**
 * RBAC: módulos, opciones de menú, acciones, roles y asignaciones.
 * Requiere JWT definitivo; {@code empresaId} en ruta debe coincidir con el token salvo indicación.
 */
@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class SeguridadController {

    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;
    private final TenantProvisioningService tenantProvisioningService;

    // --- Empresas (acepta token temporal o definitivo) ---

    @GetMapping("/empresas")
    public ApiResponse<List<EmpresaAdminDto>> listarEmpresas(
            @RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdAny(auth);
        seguridadService.requireAdminSistema(uid);
        return ApiResponse.ok(seguridadService.listarEmpresasAdmin(), "Empresas");
    }

    @PutMapping("/empresas/{empresaId}")
    public ApiResponse<EmpresaAdminDto> actualizarEmpresa(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @Valid @RequestBody EmpresaAdminUpdateRequest body) {
        long uid = contextHelper.requireUserIdAny(auth);
        seguridadService.requireAdminSistema(uid);
        return ApiResponse.ok(seguridadService.actualizarEmpresaAdmin(empresaId, body), "Empresa actualizada");
    }

    @PatchMapping("/empresas/{empresaId}/estado")
    public ApiResponse<EmpresaAdminDto> cambiarEstadoEmpresa(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @Valid @RequestBody EmpresaEstadoRequest body) {
        long uid = contextHelper.requireUserIdAny(auth);
        seguridadService.requireAdminSistema(uid);
        boolean activo = Boolean.TRUE.equals(body.getActivo());
        return ApiResponse.ok(
                seguridadService.actualizarEstadoEmpresaAdmin(empresaId, activo),
                activo ? "Empresa reactivada" : "Empresa anulada");
    }

    @PostMapping("/empresas/{empresaId}/correo-bienvenida")
    public ApiResponse<EnviarCorreoBienvenidaResponse> enviarCorreoBienvenida(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId) {
        long uid = contextHelper.requireUserIdAny(auth);
        seguridadService.requireAdminSistema(uid);
        EnviarCorreoBienvenidaResponse data = tenantProvisioningService.enviarCorreoBienvenida(empresaId);
        return ApiResponse.ok(data, data.getMensaje());
    }

    // --- Catálogo global ---

    @GetMapping("/modulos")
    public ApiResponse<List<ModuloDto>> listarModulos(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(seguridadService.listarModulos(), "Módulos");
    }

    @PostMapping("/modulos")
    public ApiResponse<ModuloDto> crearModulo(
            @RequestHeader("Authorization") String auth,
            @Valid @RequestBody ModuloRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(seguridadService.crearModulo(body), "Módulo creado");
    }

    @PutMapping("/modulos/{id}")
    public ApiResponse<ModuloDto> actualizarModulo(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id,
            @Valid @RequestBody ModuloRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(seguridadService.actualizarModulo(id, body), "Módulo actualizado");
    }

    @GetMapping("/opciones-menu")
    public ApiResponse<List<OpcionMenuDto>> listarOpcionesMenu(
            @RequestHeader("Authorization") String auth,
            @RequestParam(required = false) Long moduloId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(seguridadService.listarOpcionesMenu(moduloId), "Opciones de menú");
    }

    @PostMapping("/opciones-menu")
    public ApiResponse<OpcionMenuDto> crearOpcionMenu(
            @RequestHeader("Authorization") String auth,
            @Valid @RequestBody OpcionMenuRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(seguridadService.crearOpcionMenu(body), "Opción creada");
    }

    @PutMapping("/opciones-menu/{id}")
    public ApiResponse<OpcionMenuDto> actualizarOpcionMenu(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id,
            @Valid @RequestBody OpcionMenuRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(seguridadService.actualizarOpcionMenu(id, body), "Opción actualizada");
    }

    @GetMapping("/acciones")
    public ApiResponse<List<AccionDto>> listarAcciones(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(seguridadService.listarAcciones(), "Acciones");
    }

    @PostMapping("/acciones")
    public ApiResponse<AccionDto> crearAccion(
            @RequestHeader("Authorization") String auth,
            @Valid @RequestBody AccionRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(seguridadService.crearAccion(body), "Acción creada");
    }

    @PutMapping("/acciones/{id}")
    public ApiResponse<AccionDto> actualizarAccion(
            @RequestHeader("Authorization") String auth,
            @PathVariable long id,
            @Valid @RequestBody AccionRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(seguridadService.actualizarAccion(id, body), "Acción actualizada");
    }

    // --- Roles ---

    @GetMapping("/empresas/{empresaId}/roles")
    public ApiResponse<List<RolDto>> listarRoles(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireUsuarioEmpresa(uid, empresaId);
        return ApiResponse.ok(seguridadService.listarRoles(empresaId), "Roles");
    }

    @PostMapping("/empresas/{empresaId}/roles")
    public ApiResponse<RolDto> crearRol(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @Valid @RequestBody RolRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        return ApiResponse.ok(seguridadService.crearRol(empresaId, body), "Rol creado");
    }

    @PutMapping("/empresas/{empresaId}/roles/{rolId}")
    public ApiResponse<RolDto> actualizarRol(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long rolId,
            @Valid @RequestBody RolRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        return ApiResponse.ok(seguridadService.actualizarRol(empresaId, rolId, body), "Rol actualizado");
    }

    // --- Rol ↔ opción menú ---

    @GetMapping("/empresas/{empresaId}/roles/{rolId}/opciones-menu")
    public ApiResponse<List<RolOpcionMenuDto>> listarRolOpciones(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long rolId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireUsuarioEmpresa(uid, empresaId);
        return ApiResponse.ok(seguridadService.listarRolOpcionesMenu(empresaId, rolId), "Opciones del rol");
    }

    @PostMapping("/empresas/{empresaId}/roles/{rolId}/opciones-menu/{opcionMenuId}")
    public ApiResponse<RolOpcionMenuDto> asignarOpcionRol(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long rolId,
            @PathVariable long opcionMenuId,
            @RequestParam(defaultValue = "true") boolean activo) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        return ApiResponse.ok(
                seguridadService.asignarOpcionARol(empresaId, rolId, opcionMenuId, activo),
                "Opción asignada al rol");
    }

    @DeleteMapping("/empresas/{empresaId}/roles/{rolId}/opciones-menu/{opcionMenuId}")
    public ApiResponse<Void> quitarOpcionRol(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long rolId,
            @PathVariable long opcionMenuId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        seguridadService.quitarOpcionDeRol(empresaId, rolId, opcionMenuId);
        return ApiResponse.ok(null, "Opción quitada del rol");
    }

    // --- Acciones por ítem de menú (rol) ---

    @GetMapping("/empresas/{empresaId}/roles/{rolId}/opciones-menu/{opcionMenuId}/acciones")
    public ApiResponse<List<RolOpcionAccionDto>> listarAccionesRolOpcion(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long rolId,
            @PathVariable long opcionMenuId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireUsuarioEmpresa(uid, empresaId);
        return ApiResponse.ok(
                seguridadService.listarAccionesRolOpcion(empresaId, rolId, opcionMenuId),
                "Acciones del rol para la opción");
    }

    @PutMapping("/empresas/{empresaId}/roles/{rolId}/opciones-menu/{opcionMenuId}/acciones/{accionId}")
    public ApiResponse<RolOpcionAccionDto> upsertAccionRolOpcion(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long rolId,
            @PathVariable long opcionMenuId,
            @PathVariable long accionId,
            @RequestBody(required = false) RolOpcionAccionPermisoRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        boolean permitido = body == null || body.getPermitido() == null || Boolean.TRUE.equals(body.getPermitido());
        boolean activo = body == null || body.getActivo() == null || Boolean.TRUE.equals(body.getActivo());
        return ApiResponse.ok(
                seguridadService.upsertAccionRolOpcion(empresaId, rolId, opcionMenuId, accionId, permitido, activo),
                "Permiso de acción actualizado");
    }

    // --- Usuario ↔ roles ---

    @GetMapping("/empresas/{empresaId}/usuarios/{usuarioId}/roles")
    public ApiResponse<List<RolUsuarioDto>> listarRolesUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireSelfOAdmin(uid, empresaId, usuarioId);
        return ApiResponse.ok(seguridadService.listarRolesUsuario(empresaId, usuarioId), "Roles del usuario");
    }

    @GetMapping("/empresas/{empresaId}/usuarios/{usuarioId}/permisos-menu-roles")
    public ApiResponse<UsuarioPermisosMenuRolesResponse> permisosMenuPorRoles(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireSelfOAdmin(uid, empresaId, usuarioId);
        return ApiResponse.ok(
                seguridadService.construirPermisosMenuPorRolesUsuario(usuarioId, empresaId),
                "Roles del usuario y opciones de menú con acciones (fusión de todos los roles)");
    }

    @PostMapping("/empresas/{empresaId}/usuarios/{usuarioId}/roles")
    public ApiResponse<RolUsuarioDto> asignarRolUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId,
            @Valid @RequestBody AsignarRolUsuarioRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        return ApiResponse.ok(
                seguridadService.asignarRolUsuario(empresaId, usuarioId, body.getRolId(),
                        Boolean.TRUE.equals(body.getActivo())),
                "Rol asignado");
    }

    @DeleteMapping("/empresas/{empresaId}/usuarios/{usuarioId}/roles/{rolId}")
    public ApiResponse<Void> quitarRolUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId,
            @PathVariable long rolId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        seguridadService.quitarRolUsuario(empresaId, usuarioId, rolId);
        return ApiResponse.ok(null, "Rol quitado al usuario");
    }

    // --- Usuario ↔ sucursales ---

    @GetMapping("/empresas/{empresaId}/usuarios/{usuarioId}/sucursales")
    public ApiResponse<List<UsuarioSucursalDto>> listarSucursalesUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireSelfOAdmin(uid, empresaId, usuarioId);
        return ApiResponse.ok(seguridadService.listarSucursalesUsuario(empresaId, usuarioId),
                "Sucursales del usuario");
    }

    @PostMapping("/empresas/{empresaId}/usuarios/{usuarioId}/sucursales/{sucursalId}")
    public ApiResponse<UsuarioSucursalDto> asignarSucursalUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId,
            @PathVariable long sucursalId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        return ApiResponse.ok(
                seguridadService.asignarSucursalUsuario(empresaId, usuarioId, sucursalId),
                "Sucursal asignada al usuario");
    }

    @DeleteMapping("/empresas/{empresaId}/usuarios/{usuarioId}/sucursales/{sucursalId}")
    public ApiResponse<Void> quitarSucursalUsuario(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId,
            @PathVariable long sucursalId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        seguridadService.quitarSucursalUsuario(empresaId, usuarioId, sucursalId);
        return ApiResponse.ok(null, "Sucursal quitada al usuario");
    }

    // --- Opciones libres (usuario_opcion_menu) ---

    @GetMapping("/empresas/{empresaId}/usuarios/{usuarioId}/opciones-libres")
    public ApiResponse<List<UsuarioOpcionLibreDto>> listarOpcionesLibres(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireSelfOAdmin(uid, empresaId, usuarioId);
        return ApiResponse.ok(seguridadService.listarOpcionesLibres(empresaId, usuarioId), "Opciones libres");
    }

    @PostMapping("/empresas/{empresaId}/usuarios/{usuarioId}/opciones-libres")
    public ApiResponse<UsuarioOpcionLibreDto> upsertOpcionLibre(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId,
            @Valid @RequestBody UsuarioOpcionLibreRequest body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        return ApiResponse.ok(
                seguridadService.upsertOpcionLibre(empresaId, usuarioId, body.getOpcionMenuId(),
                        Boolean.TRUE.equals(body.getHabilitado()),
                        Boolean.TRUE.equals(body.getActivo())),
                "Opción libre guardada");
    }

    @DeleteMapping("/empresas/{empresaId}/usuarios/{usuarioId}/opciones-libres/{opcionMenuId}")
    public ApiResponse<Void> eliminarOpcionLibre(
            @RequestHeader("Authorization") String auth,
            @PathVariable long empresaId,
            @PathVariable long usuarioId,
            @PathVariable long opcionMenuId) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        contextHelper.requireEmpresaEnToken(auth, empresaId);
        seguridadService.requireAdmin(uid, empresaId);
        seguridadService.eliminarOpcionLibre(empresaId, usuarioId, opcionMenuId);
        return ApiResponse.ok(null, "Opción libre eliminada");
    }

    // --- Menú efectivo del usuario en sesión ---

    @GetMapping("/mi-menu")
    public ApiResponse<MiMenuResponse> miMenu(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        return ApiResponse.ok(seguridadService.construirMiMenu(uid, empresaId), "Menú del usuario");
    }
}
