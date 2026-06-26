package pe.restaurant.core.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.tenant.EmpresaTenantConnectionService;
import pe.restaurant.common.tenant.TenantConnectionInfo;
import pe.restaurant.core.dto.request.ProvisionSucursalRequest;
import pe.restaurant.core.dto.response.ProvisionSucursalResponse;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD provisionado de sucursales ({@code auth.sucursal}) en la BD tenant.
 * <p>Usa {@link DriverManager} por conexión dinámica (mismo patrón que {@link SucursalMaestroService}).
 * No depende de {@code TenantContext} ni de repositorios JPA. Protegido por {@code X-Provision-Secret}.</p>
 */
@Slf4j
@Service
public class ProvisionSucursalService {

    private final EmpresaTenantConnectionService tenantConnectionService;

    public ProvisionSucursalService(EmpresaTenantConnectionService tenantConnectionService) {
        this.tenantConnectionService = tenantConnectionService;
    }

    public ProvisionSucursalResponse crear(Long empresaId, ProvisionSucursalRequest request) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = """
                INSERT INTO auth.sucursal
                    (codigo, nombre, direccion, ciudad, moneda_defult_id,
                     pais_id, departamento_id, provincia_id, distrito_id, ubigeo,
                     flag_estado, created_by, fec_creacion)
                VALUES (?, ?, ?, ?, ?,
                        ?, ?, ?, ?, ?,
                        '1', 0, NOW())
                RETURNING id, codigo, nombre, direccion, ciudad, moneda_defult_id,
                          pais_id, departamento_id, provincia_id, distrito_id, ubigeo,
                          flag_estado, fec_creacion, fec_modificacion
                """;

        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, request.getCodigo().trim());
            ps.setString(2, request.getNombre().trim());
            ps.setString(3, trimOrNull(request.getDireccion()));
            ps.setString(4, trimOrNull(request.getCiudad()));
            setLongOrNull(ps, 5, request.getMonedaDefultId());
            setLongOrNull(ps, 6, request.getPaisId());
            setLongOrNull(ps, 7, request.getDepartamentoId());
            setLongOrNull(ps, 8, request.getProvinciaId());
            setLongOrNull(ps, 9, request.getDistritoId());
            ps.setString(10, trimOrNull(request.getUbigeo()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs, empresaId);
                }
                throw new BusinessException(
                        "No se pudo crear la sucursal (sin ID de retorno)",
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "SUCURSAL_CREAR_ERROR");
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Error creando sucursal en tenant empresa {}: {}", empresaId, e.getMessage());
            String msg = mensajeRaiz(e);
            if (esErrorUniqueConstraint(msg)) {
                throw new BusinessException(
                        "Ya existe una sucursal con el código '" + request.getCodigo() + "'",
                        HttpStatus.CONFLICT,
                        "SUCURSAL_CODIGO_DUPLICADO");
            }
            throw new BusinessException(
                    "No se pudo crear la sucursal: " + msg,
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSAL_CREAR_ERROR");
        }
    }

    public ProvisionSucursalResponse actualizar(Long empresaId, Long sucursalId, ProvisionSucursalRequest request) {
        requireSucursalExiste(empresaId, sucursalId);

        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = """
                UPDATE auth.sucursal SET
                    codigo = ?, nombre = ?, direccion = ?, ciudad = ?,
                    moneda_defult_id = ?, pais_id = ?, departamento_id = ?,
                    provincia_id = ?, distrito_id = ?, ubigeo = ?,
                    updated_by = 0, fec_modificacion = NOW()
                WHERE id = ?
                """;

        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, request.getCodigo().trim());
            ps.setString(2, request.getNombre().trim());
            ps.setString(3, trimOrNull(request.getDireccion()));
            ps.setString(4, trimOrNull(request.getCiudad()));
            setLongOrNull(ps, 5, request.getMonedaDefultId());
            setLongOrNull(ps, 6, request.getPaisId());
            setLongOrNull(ps, 7, request.getDepartamentoId());
            setLongOrNull(ps, 8, request.getProvinciaId());
            setLongOrNull(ps, 9, request.getDistritoId());
            ps.setString(10, trimOrNull(request.getUbigeo()));
            ps.setLong(11, sucursalId);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new BusinessException(
                        "No se pudo actualizar la sucursal",
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "SUCURSAL_ACTUALIZAR_ERROR");
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Error actualizando sucursal {} en tenant empresa {}: {}", sucursalId, empresaId, e.getMessage());
            String msg = mensajeRaiz(e);
            if (esErrorUniqueConstraint(msg)) {
                throw new BusinessException(
                        "Ya existe otra sucursal con el código '" + request.getCodigo() + "'",
                        HttpStatus.CONFLICT,
                        "SUCURSAL_CODIGO_DUPLICADO");
            }
            throw new BusinessException(
                    "No se pudo actualizar la sucursal: " + msg,
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSAL_ACTUALIZAR_ERROR");
        }

        return obtener(empresaId, sucursalId);
    }

    public void eliminar(Long empresaId, Long sucursalId) {
        requireSucursalExiste(empresaId, sucursalId);

        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = "UPDATE auth.sucursal SET flag_estado = '0', updated_by = 0, fec_modificacion = NOW() WHERE id = ?";

        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, sucursalId);
            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new BusinessException(
                        "No se pudo eliminar la sucursal",
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "SUCURSAL_ELIMINAR_ERROR");
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Error eliminando sucursal {} en tenant empresa {}: {}", sucursalId, empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo eliminar la sucursal: " + mensajeRaiz(e),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSAL_ELIMINAR_ERROR");
        }
    }

    public List<ProvisionSucursalResponse> listar(Long empresaId) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = """
                SELECT id, codigo, nombre, direccion, ciudad, moneda_defult_id,
                       pais_id, departamento_id, provincia_id, distrito_id, ubigeo,
                       flag_estado, fec_creacion, fec_modificacion
                FROM auth.sucursal
                WHERE flag_estado = '1'
                ORDER BY nombre
                """;

        List<ProvisionSucursalResponse> result = new ArrayList<>();
        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(mapRow(rs, empresaId));
            }
        } catch (Exception e) {
            log.warn("Error listando sucursales del tenant empresa {}: {}", empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudieron listar las sucursales: " + mensajeRaiz(e),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSALES_LISTAR_ERROR");
        }
        return result;
    }

    public ProvisionSucursalResponse obtener(Long empresaId, Long sucursalId) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = """
                SELECT id, codigo, nombre, direccion, ciudad, moneda_defult_id,
                       pais_id, departamento_id, provincia_id, distrito_id, ubigeo,
                       flag_estado, fec_creacion, fec_modificacion
                FROM auth.sucursal
                WHERE id = ?
                """;

        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, sucursalId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs, empresaId);
                }
                throw new BusinessException(
                        "Sucursal no encontrada con id " + sucursalId,
                        HttpStatus.NOT_FOUND,
                        "SUCURSAL_NO_ENCONTRADA");
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Error obteniendo sucursal {} del tenant empresa {}: {}", sucursalId, empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo obtener la sucursal: " + mensajeRaiz(e),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSAL_OBTENER_ERROR");
        }
    }

    private void requireSucursalExiste(Long empresaId, Long sucursalId) {
        TenantConnectionInfo conn = tenantConnectionService.getTenantConnection(empresaId);
        String sql = "SELECT COUNT(*) FROM auth.sucursal WHERE id = ?";
        try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, sucursalId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getLong(1) == 0) {
                    throw new BusinessException(
                            "Sucursal no encontrada con id " + sucursalId,
                            HttpStatus.NOT_FOUND,
                            "SUCURSAL_NO_ENCONTRADA");
                }
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Error validando sucursal {} en tenant empresa {}: {}", sucursalId, empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo validar la sucursal en el tenant",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "SUCURSAL_VALIDAR_ERROR");
        }
    }

    private static ProvisionSucursalResponse mapRow(ResultSet rs, Long empresaId) throws java.sql.SQLException {
        Timestamp fecCreacionTs = rs.getTimestamp("fec_creacion");
        Timestamp fecModificacionTs = rs.getTimestamp("fec_modificacion");

        return ProvisionSucursalResponse.builder()
                .id(rs.getLong("id"))
                .empresaId(empresaId)
                .codigo(rs.getString("codigo"))
                .nombre(rs.getString("nombre"))
                .direccion(rs.getString("direccion"))
                .ciudad(rs.getString("ciudad"))
                .monedaDefultId(getLongOrNull(rs, "moneda_defult_id"))
                .paisId(getLongOrNull(rs, "pais_id"))
                .departamentoId(getLongOrNull(rs, "departamento_id"))
                .provinciaId(getLongOrNull(rs, "provincia_id"))
                .distritoId(getLongOrNull(rs, "distrito_id"))
                .ubigeo(rs.getString("ubigeo"))
                .flagEstado(rs.getString("flag_estado"))
                .fecCreacion(fecCreacionTs != null ? fecCreacionTs.toInstant() : null)
                .fecModificacion(fecModificacionTs != null ? fecModificacionTs.toInstant() : null)
                .build();
    }

    private static void setLongOrNull(PreparedStatement ps, int index, Long value) throws java.sql.SQLException {
        if (value != null) {
            ps.setLong(index, value);
        } else {
            ps.setNull(index, java.sql.Types.BIGINT);
        }
    }

    private static Long getLongOrNull(ResultSet rs, String column) throws java.sql.SQLException {
        long val = rs.getLong(column);
        return rs.wasNull() ? null : val;
    }

    private static String trimOrNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        return s.trim();
    }

    private static String mensajeRaiz(Throwable e) {
        Throwable t = e;
        while (t.getCause() != null) {
            t = t.getCause();
        }
        return t.getMessage();
    }

    /**
     * Detecta violación de {@code UNIQUE (codigo)} en {@code auth.sucursal}.
     * PostgreSQL nombra la constraint como {@code sucursal_codigo_key} por defecto.
     */
    private static boolean esErrorUniqueConstraint(String msg) {
        return msg != null && msg.contains("sucursal_codigo_key");
    }
}
