package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.dto.seguridad.*;
import com.sigre.common.exception.BusinessException;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.*;

/**
 * RBAC: módulos, opciones de menú, acciones, roles, asignaciones y menú efectivo del usuario.
 * Estado de registros: columna {@code flag_estado VARCHAR(1)} ('1' activo, '0' anulado).
 */
@Service
@RequiredArgsConstructor
public class SeguridadService {

    private final JdbcTemplate jdbcTemplate;

    private static String toFlag(Boolean activo) {
        return Boolean.TRUE.equals(activo) ? "1" : "0";
    }

    private static Boolean fromFlag(String flag) {
        return "1".equals(flag);
    }

    public boolean usuarioTieneEmpresa(long usuarioId, long empresaId) {
        Integer n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.usuario_empresa
                WHERE usuario_id = ? AND empresa_id = ? AND flag_estado = '1'
                """,
                Integer.class, usuarioId, empresaId);
        return n != null && n > 0;
    }

    public boolean usuarioEsAdminEmpresa(long usuarioId, long empresaId) {
        Integer n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.rol_usuario ru
                JOIN auth.rol r ON r.id = ru.rol_id
                WHERE ru.usuario_id = ? AND r.empresa_id = ?
                  AND ru.flag_estado = '1' AND r.flag_estado = '1' AND r.es_admin = TRUE
                """,
                Integer.class, usuarioId, empresaId);
        return n != null && n > 0;
    }

    public void requireUsuarioEmpresa(long usuarioId, long empresaId) {
        if (!usuarioTieneEmpresa(usuarioId, empresaId)) {
            throw new BusinessException("Sin acceso a la empresa indicada.",
                    HttpStatus.FORBIDDEN, "EMPRESA_NO_ASIGNADA");
        }
    }

    public void requireAdmin(long usuarioId, long empresaId) {
        requireUsuarioEmpresa(usuarioId, empresaId);
        if (!usuarioEsAdminEmpresa(usuarioId, empresaId)) {
            throw new BusinessException("Se requiere rol de administrador en la empresa.",
                    HttpStatus.FORBIDDEN, "SEGURIDAD_ADMIN_REQUERIDO");
        }
    }

    public void requireSelfOAdmin(long actorId, long empresaId, long targetUsuarioId) {
        requireUsuarioEmpresa(actorId, empresaId);
        if (actorId == targetUsuarioId) {
            return;
        }
        requireAdmin(actorId, empresaId);
    }

    public boolean isAdminSistema(long usuarioId) {
        Integer n = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario WHERE id = ? AND flag_estado = '1' AND flag_admin_sistema = '1'",
                Integer.class, usuarioId);
        return n != null && n > 0;
    }

    public void requireAdminSistema(long usuarioId) {
        if (!isAdminSistema(usuarioId)) {
            throw new BusinessException("Se requiere privilegios de administrador del sistema.",
                    HttpStatus.FORBIDDEN, "ADMIN_SISTEMA_REQUERIDO");
        }
    }

    @Transactional(readOnly = true)
    public List<EmpresaAdminDto> listarEmpresasAdmin() {
        return jdbcTemplate.query(
                """
                SELECT id, codigo, ruc, razon_social, nombre_comercial,
                       direccion_fiscal, correo_contacto, telefono_contacto,
                       db_name, flag_estado
                FROM master.empresa
                ORDER BY razon_social
                """,
                (rs, i) -> EmpresaAdminDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .ruc(rs.getString("ruc"))
                        .razonSocial(rs.getString("razon_social"))
                        .nombreComercial(rs.getString("nombre_comercial"))
                        .direccionFiscal(rs.getString("direccion_fiscal"))
                        .correoContacto(rs.getString("correo_contacto"))
                        .telefonoContacto(rs.getString("telefono_contacto"))
                        .dbName(rs.getString("db_name"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build());
    }

    @Transactional(readOnly = true)
    public EmpresaAdminDto obtenerEmpresaAdmin(long empresaId) {
        List<EmpresaAdminDto> rows = jdbcTemplate.query(
                """
                SELECT id, codigo, ruc, razon_social, nombre_comercial,
                       direccion_fiscal, correo_contacto, telefono_contacto,
                       db_name, flag_estado
                FROM master.empresa
                WHERE id = ?
                """,
                (rs, i) -> EmpresaAdminDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .ruc(rs.getString("ruc"))
                        .razonSocial(rs.getString("razon_social"))
                        .nombreComercial(rs.getString("nombre_comercial"))
                        .direccionFiscal(rs.getString("direccion_fiscal"))
                        .correoContacto(rs.getString("correo_contacto"))
                        .telefonoContacto(rs.getString("telefono_contacto"))
                        .dbName(rs.getString("db_name"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build(),
                empresaId);
        if (rows.isEmpty()) {
            throw new BusinessException("Empresa no encontrada.", HttpStatus.NOT_FOUND, "EMPRESA_NO_ENCONTRADA");
        }
        return rows.get(0);
    }

    @Transactional
    public EmpresaAdminDto actualizarEmpresaAdmin(long empresaId, EmpresaAdminUpdateRequest req) {
        obtenerEmpresaAdmin(empresaId);
        int n = jdbcTemplate.update(
                """
                UPDATE master.empresa SET
                    razon_social = ?,
                    nombre_comercial = ?,
                    direccion_fiscal = ?,
                    correo_contacto = ?,
                    telefono_contacto = ?,
                    modificado_en = NOW()
                WHERE id = ?
                """,
                req.getRazonSocial(),
                emptyToNull(req.getNombreComercial()),
                emptyToNull(req.getDireccionFiscal()),
                emptyToNull(req.getCorreoContacto()),
                emptyToNull(req.getTelefonoContacto()),
                empresaId);
        if (n == 0) {
            throw new BusinessException("Empresa no encontrada.", HttpStatus.NOT_FOUND, "EMPRESA_NO_ENCONTRADA");
        }
        return obtenerEmpresaAdmin(empresaId);
    }

    @Transactional
    public EmpresaAdminDto actualizarEstadoEmpresaAdmin(long empresaId, boolean activo) {
        obtenerEmpresaAdmin(empresaId);
        int n = jdbcTemplate.update(
                """
                UPDATE master.empresa SET flag_estado = ?, modificado_en = NOW() WHERE id = ?
                """,
                activo ? "1" : "0",
                empresaId);
        if (n == 0) {
            throw new BusinessException("Empresa no encontrada.", HttpStatus.NOT_FOUND, "EMPRESA_NO_ENCONTRADA");
        }
        return obtenerEmpresaAdmin(empresaId);
    }

    private static String emptyToNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        return s.trim();
    }

    // --- Catálogo global (lectura: usuario con empresa; escritura: admin) ---

    public List<ModuloDto> listarModulos() {
        return jdbcTemplate.query(
                "SELECT id, codigo, nombre, flag_estado FROM auth.modulo ORDER BY nombre",
                (rs, i) -> ModuloDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build());
    }

    @Transactional
    public ModuloDto crearModulo(ModuloRequest req) {
        GeneratedKeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO auth.modulo (codigo, nombre, flag_estado) VALUES (?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, req.getCodigo());
            ps.setString(2, req.getNombre());
            ps.setString(3, toFlag(req.getActivo()));
            return ps;
        }, kh);
        Number key = kh.getKey();
        return obtenerModulo(key != null ? key.longValue() : null);
    }

    public ModuloDto obtenerModulo(Long id) {
        if (id == null) {
            return null;
        }
        List<ModuloDto> list = jdbcTemplate.query(
                "SELECT id, codigo, nombre, flag_estado FROM auth.modulo WHERE id = ?",
                (rs, i) -> ModuloDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build(),
                id);
        if (list.isEmpty()) {
            throw new BusinessException("Módulo no encontrado", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return list.get(0);
    }

    @Transactional
    public ModuloDto actualizarModulo(long id, ModuloRequest req) {
        int u = jdbcTemplate.update(
                "UPDATE auth.modulo SET codigo = ?, nombre = ?, flag_estado = ? WHERE id = ?",
                req.getCodigo(), req.getNombre(), toFlag(req.getActivo()), id);
        if (u == 0) {
            throw new BusinessException("Módulo no encontrado", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return obtenerModulo(id);
    }

    public List<OpcionMenuDto> listarOpcionesMenu(Long moduloId) {
        if (moduloId == null) {
            return jdbcTemplate.query(
                    """
                    SELECT id, modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado
                    FROM auth.opcion_menu ORDER BY modulo_id, orden, nombre
                    """,
                    this::mapOpcionMenu);
        }
        return jdbcTemplate.query(
                """
                SELECT id, modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado
                FROM auth.opcion_menu WHERE modulo_id = ? ORDER BY orden, nombre
                """,
                this::mapOpcionMenu,
                moduloId);
    }

    private OpcionMenuDto mapOpcionMenu(java.sql.ResultSet rs, int row) throws java.sql.SQLException {
        return OpcionMenuDto.builder()
                .id(rs.getLong("id"))
                .moduloId(rs.getLong("modulo_id"))
                .codigo(rs.getString("codigo"))
                .nombre(rs.getString("nombre"))
                .rutaFrontend(rs.getString("ruta_frontend"))
                .opcionPadreId(rs.getObject("opcion_padre_id") != null ? rs.getLong("opcion_padre_id") : null)
                .orden(rs.getInt("orden"))
                .activo(fromFlag(rs.getString("flag_estado")))
                .build();
    }

    @Transactional
    public OpcionMenuDto crearOpcionMenu(OpcionMenuRequest req) {
        GeneratedKeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    """
                    INSERT INTO auth.opcion_menu
                    (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)
                    VALUES (?,?,?,?,?,?,?)
                    """,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, req.getModuloId());
            ps.setString(2, req.getCodigo());
            ps.setString(3, req.getNombre());
            ps.setString(4, req.getRutaFrontend());
            if (req.getOpcionPadreId() != null) {
                ps.setLong(5, req.getOpcionPadreId());
            } else {
                ps.setObject(5, null);
            }
            ps.setInt(6, req.getOrden() != null ? req.getOrden() : 0);
            ps.setString(7, toFlag(req.getActivo()));
            return ps;
        }, kh);
        Number key = kh.getKey();
        return obtenerOpcionMenu(key != null ? key.longValue() : null);
    }

    public OpcionMenuDto obtenerOpcionMenu(Long id) {
        List<OpcionMenuDto> list = jdbcTemplate.query(
                """
                SELECT id, modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado
                FROM auth.opcion_menu WHERE id = ?
                """,
                this::mapOpcionMenu,
                id);
        if (list.isEmpty()) {
            throw new BusinessException("Opción de menú no encontrada", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return list.get(0);
    }

    @Transactional
    public OpcionMenuDto actualizarOpcionMenu(long id, OpcionMenuRequest req) {
        int u = jdbcTemplate.update(
                """
                UPDATE auth.opcion_menu SET modulo_id = ?, codigo = ?, nombre = ?, ruta_frontend = ?,
                opcion_padre_id = ?, orden = ?, flag_estado = ? WHERE id = ?
                """,
                req.getModuloId(), req.getCodigo(), req.getNombre(), req.getRutaFrontend(),
                req.getOpcionPadreId(), req.getOrden() != null ? req.getOrden() : 0,
                toFlag(req.getActivo()), id);
        if (u == 0) {
            throw new BusinessException("Opción de menú no encontrada", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return obtenerOpcionMenu(id);
    }

    public List<AccionDto> listarAcciones() {
        return jdbcTemplate.query(
                "SELECT id, codigo, nombre, flag_estado FROM auth.accion ORDER BY nombre",
                (rs, i) -> AccionDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build());
    }

    @Transactional
    public AccionDto crearAccion(AccionRequest req) {
        GeneratedKeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO auth.accion (codigo, nombre, flag_estado) VALUES (?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, req.getCodigo());
            ps.setString(2, req.getNombre());
            ps.setString(3, toFlag(req.getActivo()));
            return ps;
        }, kh);
        Number key = kh.getKey();
        return obtenerAccion(key != null ? key.longValue() : null);
    }

    public AccionDto obtenerAccion(Long id) {
        List<AccionDto> list = jdbcTemplate.query(
                "SELECT id, codigo, nombre, flag_estado FROM auth.accion WHERE id = ?",
                (rs, i) -> AccionDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build(),
                id);
        if (list.isEmpty()) {
            throw new BusinessException("Acción no encontrada", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return list.get(0);
    }

    @Transactional
    public AccionDto actualizarAccion(long id, AccionRequest req) {
        int u = jdbcTemplate.update(
                "UPDATE auth.accion SET codigo = ?, nombre = ?, flag_estado = ? WHERE id = ?",
                req.getCodigo(), req.getNombre(), toFlag(req.getActivo()), id);
        if (u == 0) {
            throw new BusinessException("Acción no encontrada", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return obtenerAccion(id);
    }

    // --- Roles por empresa ---

    public List<RolDto> listarRoles(long empresaId) {
        return jdbcTemplate.query(
                """
                SELECT id, empresa_id, codigo, nombre, es_admin, flag_estado FROM auth.rol
                WHERE empresa_id = ? ORDER BY nombre
                """,
                (rs, i) -> mapRol(rs),
                empresaId);
    }

    private RolDto mapRol(java.sql.ResultSet rs) throws java.sql.SQLException {
        return RolDto.builder()
                .id(rs.getLong("id"))
                .empresaId(rs.getLong("empresa_id"))
                .codigo(rs.getString("codigo"))
                .nombre(rs.getString("nombre"))
                .esAdmin(rs.getBoolean("es_admin"))
                .activo(fromFlag(rs.getString("flag_estado")))
                .build();
    }

    @Transactional
    public RolDto crearRol(long empresaId, RolRequest req) {
        GeneratedKeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    """
                    INSERT INTO auth.rol (empresa_id, codigo, nombre, es_admin, flag_estado)
                    VALUES (?,?,?,?,?)
                    """,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, empresaId);
            ps.setString(2, req.getCodigo());
            ps.setString(3, req.getNombre());
            ps.setBoolean(4, Boolean.TRUE.equals(req.getEsAdmin()));
            ps.setString(5, toFlag(req.getActivo()));
            return ps;
        }, kh);
        Number key = kh.getKey();
        return obtenerRol(empresaId, key != null ? key.longValue() : null);
    }

    public RolDto obtenerRol(long empresaId, long rolId) {
        List<RolDto> list = jdbcTemplate.query(
                """
                SELECT id, empresa_id, codigo, nombre, es_admin, flag_estado FROM auth.rol
                WHERE id = ? AND empresa_id = ?
                """,
                (rs, i) -> mapRol(rs),
                rolId, empresaId);
        if (list.isEmpty()) {
            throw new BusinessException("Rol no encontrado", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return list.get(0);
    }

    @Transactional
    public RolDto actualizarRol(long empresaId, long rolId, RolRequest req) {
        int u = jdbcTemplate.update(
                """
                UPDATE auth.rol SET codigo = ?, nombre = ?, es_admin = ?, flag_estado = ?
                WHERE id = ? AND empresa_id = ?
                """,
                req.getCodigo(), req.getNombre(), Boolean.TRUE.equals(req.getEsAdmin()),
                toFlag(req.getActivo()), rolId, empresaId);
        if (u == 0) {
            throw new BusinessException("Rol no encontrado", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return obtenerRol(empresaId, rolId);
    }

    // --- Rol ↔ opción menú ---

    public List<RolOpcionMenuDto> listarRolOpcionesMenu(long empresaId, long rolId) {
        obtenerRol(empresaId, rolId);
        return jdbcTemplate.query(
                """
                SELECT rom.id, rom.rol_id, rom.opcion_menu_id, rom.flag_estado,
                       om.id omid, om.modulo_id, om.codigo omcod, om.nombre omnom,
                       om.ruta_frontend, om.opcion_padre_id, om.orden, om.flag_estado omfs
                FROM auth.rol_opcion_menu rom
                JOIN auth.opcion_menu om ON om.id = rom.opcion_menu_id
                WHERE rom.rol_id = ?
                ORDER BY om.orden, om.nombre
                """,
                (rs, i) -> RolOpcionMenuDto.builder()
                        .id(rs.getLong("id"))
                        .rolId(rs.getLong("rol_id"))
                        .opcionMenuId(rs.getLong("opcion_menu_id"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .opcionMenu(OpcionMenuDto.builder()
                                .id(rs.getLong("omid"))
                                .moduloId(rs.getLong("modulo_id"))
                                .codigo(rs.getString("omcod"))
                                .nombre(rs.getString("omnom"))
                                .rutaFrontend(rs.getString("ruta_frontend"))
                                .opcionPadreId(rs.getObject("opcion_padre_id") != null
                                        ? rs.getLong("opcion_padre_id") : null)
                                .orden(rs.getInt("orden"))
                                .activo(fromFlag(rs.getString("omfs")))
                                .build())
                        .build(),
                rolId);
    }

    @Transactional
    public RolOpcionMenuDto asignarOpcionARol(long empresaId, long rolId, long opcionMenuId, boolean activo) {
        obtenerRol(empresaId, rolId);
        obtenerOpcionMenu(opcionMenuId);
        String flag = activo ? "1" : "0";
        jdbcTemplate.update(
                """
                INSERT INTO auth.rol_opcion_menu (rol_id, opcion_menu_id, flag_estado)
                VALUES (?,?,?)
                ON CONFLICT (rol_id, opcion_menu_id) DO UPDATE SET flag_estado = EXCLUDED.flag_estado
                """,
                rolId, opcionMenuId, flag);
        return jdbcTemplate.query(
                """
                SELECT rom.id, rom.rol_id, rom.opcion_menu_id, rom.flag_estado,
                       om.id omid, om.modulo_id, om.codigo omcod, om.nombre omnom,
                       om.ruta_frontend, om.opcion_padre_id, om.orden, om.flag_estado omfs
                FROM auth.rol_opcion_menu rom
                JOIN auth.opcion_menu om ON om.id = rom.opcion_menu_id
                WHERE rom.rol_id = ? AND rom.opcion_menu_id = ?
                """,
                (rs, row) -> RolOpcionMenuDto.builder()
                        .id(rs.getLong("id"))
                        .rolId(rs.getLong("rol_id"))
                        .opcionMenuId(rs.getLong("opcion_menu_id"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .opcionMenu(OpcionMenuDto.builder()
                                .id(rs.getLong("omid"))
                                .moduloId(rs.getLong("modulo_id"))
                                .codigo(rs.getString("omcod"))
                                .nombre(rs.getString("omnom"))
                                .rutaFrontend(rs.getString("ruta_frontend"))
                                .opcionPadreId(rs.getObject("opcion_padre_id") != null
                                        ? rs.getLong("opcion_padre_id") : null)
                                .orden(rs.getInt("orden"))
                                .activo(fromFlag(rs.getString("omfs")))
                                .build())
                        .build(),
                rolId, opcionMenuId).get(0);
    }

    @Transactional
    public void quitarOpcionDeRol(long empresaId, long rolId, long opcionMenuId) {
        obtenerRol(empresaId, rolId);
        jdbcTemplate.update(
                "DELETE FROM auth.rol_opcion_menu WHERE rol_id = ? AND opcion_menu_id = ?",
                rolId, opcionMenuId);
    }

    // --- Acciones por rol-opción ---

    public List<RolOpcionAccionDto> listarAccionesRolOpcion(long empresaId, long rolId, long opcionMenuId) {
        obtenerRol(empresaId, rolId);
        Long romId = jdbcTemplate.query(
                "SELECT id FROM auth.rol_opcion_menu WHERE rol_id = ? AND opcion_menu_id = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                rolId, opcionMenuId);
        if (romId == null) {
            return List.of();
        }
        return listarAccionesPorRolOpcionMenuId(romId);
    }

    private List<RolOpcionAccionDto> listarAccionesPorRolOpcionMenuId(long rolOpcionMenuId) {
        return jdbcTemplate.query(
                """
                SELECT roma.id, roma.rol_opcion_menu_id, roma.accion_id, roma.permitido, roma.flag_estado,
                       a.id aid, a.codigo, a.nombre, a.flag_estado afs
                FROM auth.rol_opcion_menu_accion roma
                JOIN auth.accion a ON a.id = roma.accion_id
                WHERE roma.rol_opcion_menu_id = ?
                ORDER BY a.nombre
                """,
                (rs, i) -> RolOpcionAccionDto.builder()
                        .id(rs.getLong("id"))
                        .rolOpcionMenuId(rs.getLong("rol_opcion_menu_id"))
                        .accionId(rs.getLong("accion_id"))
                        .permitido(rs.getBoolean("permitido"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .accion(AccionDto.builder()
                                .id(rs.getLong("aid"))
                                .codigo(rs.getString("codigo"))
                                .nombre(rs.getString("nombre"))
                                .activo(fromFlag(rs.getString("afs")))
                                .build())
                        .build(),
                rolOpcionMenuId);
    }

    @Transactional
    public RolOpcionAccionDto upsertAccionRolOpcion(long empresaId, long rolId, long opcionMenuId,
                                                    long accionId, boolean permitido, boolean activo) {
        obtenerRol(empresaId, rolId);
        obtenerAccion(accionId);
        Long romId = jdbcTemplate.query(
                "SELECT id FROM auth.rol_opcion_menu WHERE rol_id = ? AND opcion_menu_id = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                rolId, opcionMenuId);
        if (romId == null) {
            throw new BusinessException("Primero asigne la opción al rol.",
                    HttpStatus.UNPROCESSABLE_ENTITY, "ROL_OPCION_NO_EXISTE");
        }
        String flag = activo ? "1" : "0";
        jdbcTemplate.update(
                """
                INSERT INTO auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id, permitido, flag_estado)
                VALUES (?,?,?,?)
                ON CONFLICT (rol_opcion_menu_id, accion_id)
                DO UPDATE SET permitido = EXCLUDED.permitido, flag_estado = EXCLUDED.flag_estado
                """,
                romId, accionId, permitido, flag);
        return jdbcTemplate.query(
                """
                SELECT roma.id, roma.rol_opcion_menu_id, roma.accion_id, roma.permitido, roma.flag_estado,
                       a.id aid, a.codigo, a.nombre, a.flag_estado afs
                FROM auth.rol_opcion_menu_accion roma
                JOIN auth.accion a ON a.id = roma.accion_id
                WHERE roma.rol_opcion_menu_id = ? AND roma.accion_id = ?
                """,
                (rs, row) -> RolOpcionAccionDto.builder()
                        .id(rs.getLong("id"))
                        .rolOpcionMenuId(rs.getLong("rol_opcion_menu_id"))
                        .accionId(rs.getLong("accion_id"))
                        .permitido(rs.getBoolean("permitido"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .accion(AccionDto.builder()
                                .id(rs.getLong("aid"))
                                .codigo(rs.getString("codigo"))
                                .nombre(rs.getString("nombre"))
                                .activo(fromFlag(rs.getString("afs")))
                                .build())
                        .build(),
                romId, accionId).get(0);
    }

    // --- Usuario ↔ rol ---

    public List<RolUsuarioDto> listarRolesUsuario(long empresaId, long usuarioId) {
        return jdbcTemplate.query(
                """
                SELECT ru.id, ru.usuario_id, ru.rol_id, ru.flag_estado,
                       r.id rid, r.empresa_id, r.codigo rcod, r.nombre rnom, r.es_admin, r.flag_estado rfs
                FROM auth.rol_usuario ru
                JOIN auth.rol r ON r.id = ru.rol_id AND r.empresa_id = ?
                WHERE ru.usuario_id = ?
                ORDER BY r.nombre
                """,
                (rs, i) -> RolUsuarioDto.builder()
                        .id(rs.getLong("id"))
                        .usuarioId(rs.getLong("usuario_id"))
                        .rolId(rs.getLong("rol_id"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .rol(RolDto.builder()
                                .id(rs.getLong("rid"))
                                .empresaId(rs.getLong("empresa_id"))
                                .codigo(rs.getString("rcod"))
                                .nombre(rs.getString("rnom"))
                                .esAdmin(rs.getBoolean("es_admin"))
                                .activo(fromFlag(rs.getString("rfs")))
                                .build())
                        .build(),
                empresaId, usuarioId);
    }

    @Transactional
    public RolUsuarioDto asignarRolUsuario(long empresaId, long usuarioId, long rolId, boolean activo) {
        obtenerRol(empresaId, rolId);
        Integer ue = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario_empresa WHERE usuario_id = ? AND empresa_id = ? AND flag_estado = '1'",
                Integer.class, usuarioId, empresaId);
        if (ue == null || ue == 0) {
            throw new BusinessException("El usuario no pertenece a la empresa.",
                    HttpStatus.UNPROCESSABLE_ENTITY, "USUARIO_SIN_EMPRESA");
        }
        String flag = activo ? "1" : "0";
        jdbcTemplate.update(
                """
                INSERT INTO auth.rol_usuario (usuario_id, rol_id, flag_estado)
                VALUES (?,?,?)
                ON CONFLICT (usuario_id, rol_id) DO UPDATE SET flag_estado = EXCLUDED.flag_estado
                """,
                usuarioId, rolId, flag);
        return jdbcTemplate.query(
                """
                SELECT ru.id, ru.usuario_id, ru.rol_id, ru.flag_estado,
                       r.id rid, r.empresa_id, r.codigo rcod, r.nombre rnom, r.es_admin, r.flag_estado rfs
                FROM auth.rol_usuario ru
                JOIN auth.rol r ON r.id = ru.rol_id
                WHERE ru.usuario_id = ? AND ru.rol_id = ?
                """,
                (rs, i) -> RolUsuarioDto.builder()
                        .id(rs.getLong("id"))
                        .usuarioId(rs.getLong("usuario_id"))
                        .rolId(rs.getLong("rol_id"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .rol(RolDto.builder()
                                .id(rs.getLong("rid"))
                                .empresaId(rs.getLong("empresa_id"))
                                .codigo(rs.getString("rcod"))
                                .nombre(rs.getString("rnom"))
                                .esAdmin(rs.getBoolean("es_admin"))
                                .activo(fromFlag(rs.getString("rfs")))
                                .build())
                        .build(),
                usuarioId, rolId).get(0);
    }

    @Transactional
    public void quitarRolUsuario(long empresaId, long usuarioId, long rolId) {
        obtenerRol(empresaId, rolId);
        jdbcTemplate.update(
                "DELETE FROM auth.rol_usuario WHERE usuario_id = ? AND rol_id = ?",
                usuarioId, rolId);
    }

    // --- Usuario ↔ sucursal ---

    @Transactional(readOnly = true)
    public List<UsuarioSucursalDto> listarSucursalesUsuario(long empresaId, long usuarioId) {
        requireUsuarioEmpresa(usuarioId, empresaId);
        return jdbcTemplate.query(
                """
                SELECT id, usuario_id, sucursal_id, flag_estado
                FROM auth.usuario_sucursal
                WHERE usuario_id = ?
                ORDER BY sucursal_id
                """,
                (rs, i) -> UsuarioSucursalDto.builder()
                        .id(rs.getLong("id"))
                        .usuarioId(rs.getLong("usuario_id"))
                        .sucursalId(rs.getLong("sucursal_id"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build(),
                usuarioId);
    }

    @Transactional
    public UsuarioSucursalDto asignarSucursalUsuario(long empresaId, long usuarioId, long sucursalId) {
        requireUsuarioEmpresa(usuarioId, empresaId);
        jdbcTemplate.update(
                """
                INSERT INTO auth.usuario_sucursal (usuario_id, sucursal_id, flag_estado)
                VALUES (?,?,?)
                ON CONFLICT (usuario_id, sucursal_id) DO UPDATE SET flag_estado = EXCLUDED.flag_estado
                """,
                usuarioId, sucursalId, "1");
        return jdbcTemplate.query(
                """
                SELECT id, usuario_id, sucursal_id, flag_estado
                FROM auth.usuario_sucursal
                WHERE usuario_id = ? AND sucursal_id = ?
                """,
                (rs, i) -> UsuarioSucursalDto.builder()
                        .id(rs.getLong("id"))
                        .usuarioId(rs.getLong("usuario_id"))
                        .sucursalId(rs.getLong("sucursal_id"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .build(),
                usuarioId, sucursalId).get(0);
    }

    @Transactional
    public void quitarSucursalUsuario(long empresaId, long usuarioId, long sucursalId) {
        requireUsuarioEmpresa(usuarioId, empresaId);
        int n = jdbcTemplate.update(
                "DELETE FROM auth.usuario_sucursal WHERE usuario_id = ? AND sucursal_id = ?",
                usuarioId, sucursalId);
        if (n == 0) {
            throw new BusinessException("El usuario no tiene asignada la sucursal indicada.",
                    HttpStatus.NOT_FOUND, "SUCURSAL_NO_ASIGNADA");
        }
    }

    // --- Opciones libres por usuario ---

    public List<UsuarioOpcionLibreDto> listarOpcionesLibres(long empresaId, long usuarioId) {
        return jdbcTemplate.query(
                """
                SELECT uom.id, uom.usuario_id, uom.empresa_id, uom.opcion_menu_id, uom.habilitado, uom.flag_estado,
                       om.id omid, om.modulo_id, om.codigo omcod, om.nombre omnom,
                       om.ruta_frontend, om.opcion_padre_id, om.orden, om.flag_estado omfs
                FROM auth.usuario_opcion_menu uom
                JOIN auth.opcion_menu om ON om.id = uom.opcion_menu_id
                WHERE uom.usuario_id = ? AND uom.empresa_id = ?
                ORDER BY om.orden, om.nombre
                """,
                (rs, i) -> UsuarioOpcionLibreDto.builder()
                        .id(rs.getLong("id"))
                        .usuarioId(rs.getLong("usuario_id"))
                        .empresaId(rs.getLong("empresa_id"))
                        .opcionMenuId(rs.getLong("opcion_menu_id"))
                        .habilitado(rs.getBoolean("habilitado"))
                        .activo(fromFlag(rs.getString("flag_estado")))
                        .opcionMenu(OpcionMenuDto.builder()
                                .id(rs.getLong("omid"))
                                .moduloId(rs.getLong("modulo_id"))
                                .codigo(rs.getString("omcod"))
                                .nombre(rs.getString("omnom"))
                                .rutaFrontend(rs.getString("ruta_frontend"))
                                .opcionPadreId(rs.getObject("opcion_padre_id") != null
                                        ? rs.getLong("opcion_padre_id") : null)
                                .orden(rs.getInt("orden"))
                                .activo(fromFlag(rs.getString("omfs")))
                                .build())
                        .build(),
                usuarioId, empresaId);
    }

    @Transactional
    public UsuarioOpcionLibreDto upsertOpcionLibre(long empresaId, long usuarioId, long opcionMenuId,
                                                   boolean habilitado, boolean activo) {
        obtenerOpcionMenu(opcionMenuId);
        Integer ue = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario_empresa WHERE usuario_id = ? AND empresa_id = ? AND flag_estado = '1'",
                Integer.class, usuarioId, empresaId);
        if (ue == null || ue == 0) {
            throw new BusinessException("El usuario no pertenece a la empresa.",
                    HttpStatus.UNPROCESSABLE_ENTITY, "USUARIO_SIN_EMPRESA");
        }
        String flag = activo ? "1" : "0";
        jdbcTemplate.update(
                """
                INSERT INTO auth.usuario_opcion_menu (usuario_id, empresa_id, opcion_menu_id, habilitado, flag_estado)
                VALUES (?,?,?,?,?)
                ON CONFLICT (usuario_id, empresa_id, opcion_menu_id)
                DO UPDATE SET habilitado = EXCLUDED.habilitado, flag_estado = EXCLUDED.flag_estado
                """,
                usuarioId, empresaId, opcionMenuId, habilitado, flag);
        return listarOpcionesLibres(empresaId, usuarioId).stream()
                .filter(x -> x.getOpcionMenuId().equals(opcionMenuId))
                .findFirst()
                .orElseThrow();
    }

    @Transactional
    public void eliminarOpcionLibre(long empresaId, long usuarioId, long opcionMenuId) {
        jdbcTemplate.update(
                """
                DELETE FROM auth.usuario_opcion_menu
                WHERE usuario_id = ? AND empresa_id = ? AND opcion_menu_id = ?
                """,
                usuarioId, empresaId, opcionMenuId);
    }

    // --- Menú efectivo ---

    /**
     * Opciones de menú alcanzadas por los roles del usuario ({@code auth.rol_opcion_menu});
     * las acciones se leen de {@code auth.rol_opcion_menu_accion} por cada vínculo rol–opción
     * y se fusionan si hay varios roles para la misma opción.
     */
    public UsuarioPermisosMenuRolesResponse construirPermisosMenuPorRolesUsuario(long usuarioId, long empresaId) {
        requireUsuarioEmpresa(usuarioId, empresaId);
        List<RolDto> rolesActivos = new ArrayList<>();
        LinkedHashMap<Long, RolDto> seen = new LinkedHashMap<>();
        for (RolUsuarioDto ru : listarRolesUsuario(empresaId, usuarioId)) {
            if (!Boolean.TRUE.equals(ru.getActivo()) || ru.getRol() == null
                    || !Boolean.TRUE.equals(ru.getRol().getActivo())) {
                continue;
            }
            RolDto r = ru.getRol();
            if (r.getId() != null && !seen.containsKey(r.getId())) {
                seen.put(r.getId(), r);
            }
        }
        rolesActivos.addAll(seen.values());

        List<RolOpcionRow> filas = consultarFilasRolOpcionMenuUsuario(empresaId, usuarioId);
        List<MiMenuItemDto> opciones = construirItemsMenuDesdeFilasRol(filas);

        return UsuarioPermisosMenuRolesResponse.builder()
                .empresaId(empresaId)
                .usuarioId(usuarioId)
                .roles(rolesActivos)
                .opcionesMenu(opciones)
                .build();
    }

    public MiMenuResponse construirMiMenu(long usuarioId, long empresaId) {
        requireUsuarioEmpresa(usuarioId, empresaId);

        List<RolOpcionRow> desdeRoles = consultarFilasRolOpcionMenuUsuario(empresaId, usuarioId);

        List<MiMenuItemDto> items = construirItemsMenuDesdeFilasRol(desdeRoles);
        Map<Long, OpcionMenuDto> opcionPorId = new LinkedHashMap<>();
        for (MiMenuItemDto it : items) {
            opcionPorId.put(it.getOpcionMenu().getId(), it.getOpcionMenu());
        }

        List<UsuarioOpcionLibreDto> libresRows = listarOpcionesLibres(empresaId, usuarioId).stream()
                .filter(u -> Boolean.TRUE.equals(u.getActivo()) && Boolean.TRUE.equals(u.getHabilitado()))
                .toList();

        for (UsuarioOpcionLibreDto uo : libresRows) {
            Long oid = uo.getOpcionMenuId();
            if (opcionPorId.containsKey(oid)) {
                continue;
            }
            items.add(MiMenuItemDto.builder()
                    .origen("LIBRE")
                    .opcionMenu(uo.getOpcionMenu())
                    .acciones(List.of())
                    .build());
        }

        items.sort(Comparator.comparing(m -> m.getOpcionMenu().getOrden() != null
                ? m.getOpcionMenu().getOrden() : 0));

        return MiMenuResponse.builder()
                .empresaId(empresaId)
                .usuarioId(usuarioId)
                .items(items)
                .build();
    }

    private List<RolOpcionRow> consultarFilasRolOpcionMenuUsuario(long empresaId, long usuarioId) {
        return jdbcTemplate.query(
                """
                SELECT rom.id AS rom_id, om.id AS om_id, om.modulo_id, om.codigo, om.nombre,
                       om.ruta_frontend, om.opcion_padre_id, om.orden, om.flag_estado
                FROM auth.rol_usuario ru
                JOIN auth.rol r ON r.id = ru.rol_id AND r.empresa_id = ? AND r.flag_estado = '1' AND ru.flag_estado = '1'
                JOIN auth.rol_opcion_menu rom ON rom.rol_id = r.id AND rom.flag_estado = '1'
                JOIN auth.opcion_menu om ON om.id = rom.opcion_menu_id AND om.flag_estado = '1'
                WHERE ru.usuario_id = ?
                """,
                (rs, i) -> new RolOpcionRow(
                        rs.getLong("rom_id"),
                        OpcionMenuDto.builder()
                                .id(rs.getLong("om_id"))
                                .moduloId(rs.getLong("modulo_id"))
                                .codigo(rs.getString("codigo"))
                                .nombre(rs.getString("nombre"))
                                .rutaFrontend(rs.getString("ruta_frontend"))
                                .opcionPadreId(rs.getObject("opcion_padre_id") != null
                                        ? rs.getLong("opcion_padre_id") : null)
                                .orden(rs.getInt("orden"))
                                .activo(fromFlag(rs.getString("flag_estado")))
                                .build()),
                empresaId, usuarioId);
    }

    private List<MiMenuItemDto> construirItemsMenuDesdeFilasRol(List<RolOpcionRow> desdeRoles) {
        Map<Long, OpcionMenuDto> opcionPorId = new LinkedHashMap<>();
        Map<Long, Set<Long>> opcionARomIds = new HashMap<>();
        for (RolOpcionRow row : desdeRoles) {
            opcionPorId.put(row.opcion().getId(), row.opcion());
            opcionARomIds.computeIfAbsent(row.opcion().getId(), k -> new LinkedHashSet<>()).add(row.romId());
        }

        Map<Long, List<RolOpcionAccionDto>> accionesPorOpcion = new HashMap<>();
        for (Map.Entry<Long, Set<Long>> e : opcionARomIds.entrySet()) {
            Long opcionId = e.getKey();
            Map<Long, RolOpcionAccionDto> merged = new LinkedHashMap<>();
            for (Long romId : e.getValue()) {
                for (RolOpcionAccionDto ra : listarAccionesPorRolOpcionMenuId(romId)) {
                    if (!Boolean.TRUE.equals(ra.getActivo())) {
                        continue;
                    }
                    if (!Boolean.TRUE.equals(ra.getPermitido())) {
                        continue;
                    }
                    if (ra.getAccion() != null && !Boolean.TRUE.equals(ra.getAccion().getActivo())) {
                        continue;
                    }
                    Long aid = ra.getAccion().getId();
                    merged.merge(aid, ra, (a, b) -> a);
                }
            }
            accionesPorOpcion.put(opcionId, new ArrayList<>(merged.values()));
        }

        List<MiMenuItemDto> items = new ArrayList<>();
        List<Long> ordenRol = opcionPorId.keySet().stream()
                .sorted(Comparator.comparing(id -> {
                    Integer o = opcionPorId.get(id).getOrden();
                    return o != null ? o : 0;
                }))
                .toList();
        for (Long opcionId : ordenRol) {
            items.add(MiMenuItemDto.builder()
                    .origen("ROL")
                    .opcionMenu(opcionPorId.get(opcionId))
                    .acciones(accionesPorOpcion.getOrDefault(opcionId, List.of()))
                    .build());
        }

        items.sort(Comparator.comparing(m -> m.getOpcionMenu().getOrden() != null
                ? m.getOpcionMenu().getOrden() : 0));
        return items;
    }

    private record RolOpcionRow(long romId, OpcionMenuDto opcion) {}
}
