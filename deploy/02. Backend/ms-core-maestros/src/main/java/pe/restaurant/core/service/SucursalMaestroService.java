package pe.restaurant.core.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.core.dto.SucursalDto;
import pe.restaurant.common.tenant.EmpresaTenantConnectionService;
import pe.restaurant.common.tenant.TenantConnectionInfo;
import pe.restaurant.core.dto.UsuarioSucursalSyncResponse;
import pe.restaurant.common.exception.BusinessException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Sucursales ({@code auth.sucursal}) y asignación {@code auth.usuario_sucursal} en BD tenant.
 * <p>Las lecturas/escrituras al tenant usan {@link DriverManager} por conexión dinámica; no comparten
 * una sola conexión JDBC con el {@code PlatformTransactionManager} de Spring. Los métodos mutadores
 * validan primero en BD security y luego escriben en el tenant; si la escritura falla, no queda fila
 * nueva (más allá de un posible upsert parcial si el motor confirma antes de error — mitigado con un solo {@code executeUpdate}).
 */
@Slf4j
@Service
public class SucursalMaestroService {

    private final EmpresaTenantConnectionService tenantConnectionService;
    private final JdbcTemplate securityJdbcTemplate;

    public SucursalMaestroService(
            EmpresaTenantConnectionService tenantConnectionService,
            @Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate) {
        this.tenantConnectionService = tenantConnectionService;
        this.securityJdbcTemplate = securityJdbcTemplate;
    }

    /**
     * Catálogo completo de sucursales activas del tenant (todas las columnas maestras útiles).
     */
    public List<SucursalDto> listarSucursalesCompletasPorEmpresa(Long empresaId) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        List<SucursalDto> out = new ArrayList<>();
        String sql = """
                SELECT s.id,
                       s.codigo,
                       s.nombre,
                       s.direccion,
                       s.ciudad,
                       pa.nombre AS pais,
                       d.nombre AS departamento,
                       p.nombre AS provincia,
                       di.nombre AS distrito
                FROM auth.sucursal s
                LEFT JOIN core.pais pa ON pa.id = s.pais_id
                LEFT JOIN core.departamento d ON d.id = s.departamento_id
                LEFT JOIN core.provincia p ON p.id = s.provincia_id
                LEFT JOIN core.distrito di ON di.id = s.distrito_id
                WHERE s.flag_estado = '1'
                ORDER BY s.nombre
                """;
        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(SucursalDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .direccion(rs.getString("direccion"))
                        .ciudad(rs.getString("ciudad"))
                        .pais(rs.getString("pais"))
                        .departamento(rs.getString("departamento"))
                        .provincia(rs.getString("provincia"))
                        .distrito(rs.getString("distrito"))
                        .build());
            }
        } catch (Exception e) {
            log.warn("Error listando sucursales completas empresa {}: {}", empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo listar sucursales del tenant: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSALES_ERROR");
        }
        return out;
    }

    /**
     * Sucursales asignadas al usuario en {@code auth.usuario_sucursal} (BD tenant), con datos de catálogo.
     */
    public List<SucursalDto> listarSucursalesPorUsuario(Long usuarioId, Long empresaId) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        List<Long> permitidas = new ArrayList<>();
        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(
                     """
                     SELECT sucursal_id FROM auth.usuario_sucursal
                     WHERE usuario_id = ? AND flag_estado = '1'
                     ORDER BY sucursal_id
                     """)) {
            ps.setLong(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permitidas.add(rs.getLong("sucursal_id"));
                }
            }
        } catch (Exception e) {
            log.warn("Error listando usuario_sucursal tenant empresa {}: {}", empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo listar sucursales del usuario en el tenant: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSALES_ERROR");
        }

        if (permitidas.isEmpty()) {
            return List.of();
        }

        List<SucursalDto> sucursales = new ArrayList<>();
        String inSql = String.join(",", Collections.nCopies(permitidas.size(), "?"));
        String query = """
                SELECT s.id,
                       s.codigo,
                       s.nombre,
                       s.direccion,
                       s.ciudad,
                       pa.nombre AS pais,
                       d.nombre AS departamento,
                       p.nombre AS provincia,
                       di.nombre AS distrito
                FROM auth.sucursal s
                LEFT JOIN core.pais pa ON pa.id = s.pais_id
                LEFT JOIN core.departamento d ON d.id = s.departamento_id
                LEFT JOIN core.provincia p ON p.id = s.provincia_id
                LEFT JOIN core.distrito di ON di.id = s.distrito_id
                WHERE s.flag_estado = '1' AND s.id IN (%s)
                ORDER BY s.nombre
                """.formatted(inSql);

        try (Connection tenantConn = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = tenantConn.prepareStatement(query)) {
            for (int i = 0; i < permitidas.size(); i++) {
                ps.setLong(i + 1, permitidas.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sucursales.add(SucursalDto.builder()
                            .id(rs.getLong("id"))
                            .codigo(rs.getString("codigo"))
                            .nombre(rs.getString("nombre"))
                            .direccion(rs.getString("direccion"))
                            .ciudad(rs.getString("ciudad"))
                            .pais(rs.getString("pais"))
                            .departamento(rs.getString("departamento"))
                            .provincia(rs.getString("provincia"))
                            .distrito(rs.getString("distrito"))
                            .build());
                }
            }
        } catch (Exception e) {
            log.warn("Error al consultar sucursales de empresa {}: {}", empresaId, e.getMessage(), e);
            String detalle = mensajeRaiz(e);
            throw new BusinessException(
                    "Error al consultar sucursales" + (detalle != null ? ": " + detalle : ""),
                    HttpStatus.INTERNAL_SERVER_ERROR, "SUCURSALES_ERROR");
        }

        return sucursales;
    }

    @Transactional(rollbackFor = Exception.class)
    public UsuarioSucursalSyncResponse asociarUsuarioASucursal(Long empresaId, Long usuarioId, Long sucursalId) {
        String username = requireUsuarioUsername(usuarioId);
        EmpresaRow empresa = requireEmpresa(empresaId);

        requireUsuarioEnEmpresa(usuarioId, empresaId);
        requireSucursalEnTenant(empresaId, sucursalId);

        TenantConnectionInfo tconn = tenantConnectionService.getTenantConnection(empresaId);
        try (Connection c = DriverManager.getConnection(tconn.getJdbcUrl(), tconn.getUsername(), tconn.getPassword());
             PreparedStatement ps = c.prepareStatement(
                     """
                     INSERT INTO auth.usuario_sucursal (usuario_id, sucursal_id, flag_estado)
                     VALUES (?, ?, '1')
                     ON CONFLICT (usuario_id, sucursal_id) DO UPDATE SET flag_estado = '1'
                     """)) {
            ps.setLong(1, usuarioId);
            ps.setLong(2, sucursalId);
            ps.executeUpdate();
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("asociarUsuarioASucursal tenant empresaId={}: {}", empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo registrar asignación en el tenant",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "USUARIO_SUCURSAL_ERROR");
        }

        String mensaje = String.format(
                "Sucursal %d asignada al usuario %s en empresa %s",
                sucursalId, username, empresa.codigo());
        return buildResponse(usuarioId, username, empresaId, empresa.codigo(), sucursalId, "1", mensaje);
    }

    @Transactional(rollbackFor = Exception.class)
    public UsuarioSucursalSyncResponse retirarUsuarioDeSucursal(Long empresaId, Long usuarioId, Long sucursalId) {
        String username = requireUsuarioUsername(usuarioId);
        EmpresaRow empresa = requireEmpresa(empresaId);

        TenantConnectionInfo tconn = tenantConnectionService.getTenantConnection(empresaId);
        int n;
        try (Connection c = DriverManager.getConnection(tconn.getJdbcUrl(), tconn.getUsername(), tconn.getPassword());
             PreparedStatement ps = c.prepareStatement(
                     """
                     UPDATE auth.usuario_sucursal
                     SET flag_estado = '0'
                     WHERE usuario_id = ? AND sucursal_id = ?
                     """)) {
            ps.setLong(1, usuarioId);
            ps.setLong(2, sucursalId);
            n = ps.executeUpdate();
        } catch (Exception e) {
            log.warn("retirarUsuarioDeSucursal tenant empresaId={}: {}", empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo actualizar asignación en el tenant",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "USUARIO_SUCURSAL_ERROR");
        }
        if (n == 0) {
            throw new BusinessException(
                    "No existe asignación usuario–sucursal para los ids indicados",
                    HttpStatus.NOT_FOUND,
                    "USUARIO_SUCURSAL_NO_ENCONTRADO");
        }

        String mensaje = String.format(
                "Sucursal %d retirada del usuario %s en empresa %s",
                sucursalId, username, empresa.codigo());
        return buildResponse(usuarioId, username, empresaId, empresa.codigo(), sucursalId, "0", mensaje);
    }

    private void requireUsuarioEnEmpresa(Long usuarioId, Long empresaId) {
        Integer cnt = securityJdbcTemplate.queryForObject(
                """
                SELECT COUNT(*)::int FROM auth.usuario_empresa
                WHERE usuario_id = ? AND empresa_id = ? AND flag_estado = '1'
                """,
                Integer.class,
                usuarioId, empresaId);
        if (cnt == null || cnt == 0) {
            throw new BusinessException(
                    "El usuario debe estar asociado a la empresa primero (usuario_empresa)",
                    HttpStatus.BAD_REQUEST,
                    "EMPRESA_NO_ASIGNADA");
        }
    }

    public boolean isAdminSistema(Long usuarioId) {
        Integer n = securityJdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM auth.usuario WHERE id = ? AND flag_estado = '1' AND flag_admin_sistema = '1'",
                Integer.class, usuarioId);
        return n != null && n > 0;
    }

    /**
     * Misma regla que {@code SeguridadService.requireAdmin}: usuario en empresa y rol con {@code es_admin}.
     */
    public void requireUsuarioEsAdminEmpresa(Long usuarioId, Long empresaId) {
        requireUsuarioEnEmpresa(usuarioId, empresaId);
        Integer n = securityJdbcTemplate.queryForObject(
                """
                SELECT COUNT(*)::int FROM auth.rol_usuario ru
                JOIN auth.rol r ON r.id = ru.rol_id
                WHERE ru.usuario_id = ? AND r.empresa_id = ?
                  AND ru.flag_estado = '1' AND r.flag_estado = '1' AND r.es_admin = TRUE
                """,
                Integer.class,
                usuarioId,
                empresaId);
        if (n == null || n == 0) {
            throw new BusinessException(
                    "Se requiere rol de administrador en la empresa.",
                    HttpStatus.FORBIDDEN,
                    "SEGURIDAD_ADMIN_REQUERIDO");
        }
    }

    private void requireSucursalEnTenant(Long empresaId, Long sucursalId) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = "SELECT COUNT(*) FROM auth.sucursal WHERE id = ? AND flag_estado = '1'";
        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, sucursalId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getLong(1) == 0) {
                    throw new BusinessException(
                            "Sucursal no existe o está inactiva en el tenant",
                            HttpStatus.BAD_REQUEST,
                            "SUCURSAL_NO_EXISTE");
                }
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Validando sucursal {} en tenant empresa {}: {}", sucursalId, empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo validar la sucursal en el tenant",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSALES_ERROR");
        }
    }

    private String requireUsuarioUsername(Long usuarioId) {
        List<String> rows = securityJdbcTemplate.query(
                "SELECT username FROM auth.usuario WHERE id = ?",
                (rs, rowNum) -> rs.getString("username"),
                usuarioId);
        if (rows.isEmpty()) {
            throw new BusinessException(
                    "No existe usuario con id " + usuarioId,
                    HttpStatus.NOT_FOUND,
                    "USUARIO_NO_ENCONTRADO");
        }
        return rows.get(0);
    }

    private EmpresaRow requireEmpresa(Long empresaId) {
        List<EmpresaRow> rows = securityJdbcTemplate.query(
                "SELECT id, codigo FROM master.empresa WHERE id = ?",
                (rs, rowNum) -> new EmpresaRow(rs.getLong("id"), rs.getString("codigo")),
                empresaId);
        if (rows.isEmpty()) {
            throw new BusinessException(
                    "No existe empresa con id " + empresaId,
                    HttpStatus.NOT_FOUND,
                    "EMPRESA_NO_ENCONTRADA");
        }
        return rows.get(0);
    }

    private static UsuarioSucursalSyncResponse buildResponse(
            Long usuarioId,
            String username,
            Long empresaId,
            String empresaCodigo,
            Long sucursalId,
            String flagEstado,
            String mensaje) {
        return UsuarioSucursalSyncResponse.builder()
                .usuarioId(usuarioId)
                .username(username)
                .empresaId(empresaId)
                .empresaCodigo(empresaCodigo)
                .sucursalId(sucursalId)
                .flagEstado(flagEstado)
                .mensaje(mensaje)
                .build();
    }

    private static String mensajeRaiz(Throwable e) {
        Throwable t = e;
        while (t.getCause() != null) {
            t = t.getCause();
        }
        return t.getMessage();
    }

    private record EmpresaRow(long id, String codigo) {}
}
