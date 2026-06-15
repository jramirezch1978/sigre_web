package com.sigre.seguridad.service;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.dto.UsuarioEmpresaSyncResponse;
import com.sigre.seguridad.entity.Usuario;
import com.sigre.seguridad.entity.master.EmpresaMaster;
import com.sigre.seguridad.repository.EmpresaMasterRepository;
import com.sigre.seguridad.repository.UsuarioRepository;
import com.sigre.common.exception.BusinessException;

import javax.sql.DataSource;
import java.util.Locale;

@Slf4j
@Service
public class UsuarioEmpresaAdminService {

    private final UsuarioRepository usuarioRepository;
    private final EmpresaMasterRepository empresaMasterRepository;
    private final JdbcTemplate securityJdbcTemplate;

    @Value("${spring.datasource.username}")
    private String provisioningDbUsername;

    @Value("${spring.datasource.password}")
    private String provisioningDbPassword;

    @Value("${app.tenant.jdbc-ssl-mode:require}")
    private String jdbcSslMode;

    public UsuarioEmpresaAdminService(
            UsuarioRepository usuarioRepository,
            EmpresaMasterRepository empresaMasterRepository,
            DataSource dataSource) {
        this.usuarioRepository = usuarioRepository;
        this.empresaMasterRepository = empresaMasterRepository;
        this.securityJdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Transactional
    public UsuarioEmpresaSyncResponse asociarUsuarioAEmpresa(Long empresaId, Long usuarioId) {
        Usuario usuario = resolveUsuario(usuarioId);
        EmpresaMaster empresa = resolveEmpresa(empresaId);

        upsertUsuarioEmpresa(usuarioId, empresaId);
        syncUsuarioTenant(usuario, empresa, true);

        String mensaje = String.format(
                "Usuario %s asociado correctamente a la empresa %s",
                usuario.getUsername(),
                empresa.getCodigo()
        );
        return buildResponse(usuario, empresa, true, mensaje);
    }

    /**
     * Replica el usuario de security en {@code auth.usuario} del tenant al confirmar empresa en el login
     * (misma lógica que al asociar usuario–empresa desde administración).
     */
    public void sincronizarUsuarioEnTenantPorSeleccionEmpresa(Long usuarioId, Long empresaId) {
        Usuario usuario = resolveUsuario(usuarioId);
        EmpresaMaster empresa = resolveEmpresa(empresaId);
        syncUsuarioTenant(usuario, empresa, true);
    }

    @Transactional
    public UsuarioEmpresaSyncResponse retirarUsuarioDeEmpresa(Long empresaId, Long usuarioId) {
        Usuario usuario = resolveUsuario(usuarioId);
        EmpresaMaster empresa = resolveEmpresa(empresaId);

        int actualizados = securityJdbcTemplate.update(
                """
                UPDATE auth.usuario_empresa
                SET flag_estado = '0'
                WHERE usuario_id = ?
                  AND empresa_id = ?
                """,
                usuarioId,
                empresaId
        );
        if (actualizados == 0) {
            throw new BusinessException(
                    "El usuario " + usuarioId + " no está asociado a la empresa " + empresaId,
                    HttpStatus.NOT_FOUND,
                    "USUARIO_EMPRESA_NO_ENCONTRADO"
            );
        }

        syncUsuarioTenant(usuario, empresa, false);

        String mensaje = String.format(
                "Usuario %s retirado correctamente de la empresa %s",
                usuario.getUsername(),
                empresa.getCodigo()
        );
        return buildResponse(usuario, empresa, false, mensaje);
    }

    private void upsertUsuarioEmpresa(Long usuarioId, Long empresaId) {
        int actualizados = securityJdbcTemplate.update(
                """
                UPDATE auth.usuario_empresa
                SET flag_estado = '1'
                WHERE usuario_id = ?
                  AND empresa_id = ?
                """,
                usuarioId,
                empresaId
        );

        if (actualizados == 0) {
            securityJdbcTemplate.update(
                    """
                    INSERT INTO auth.usuario_empresa (usuario_id, empresa_id, flag_estado)
                    VALUES (?, ?, '1')
                    """,
                    usuarioId,
                    empresaId
            );
        }
    }

    private void syncUsuarioTenant(Usuario usuario, EmpresaMaster empresa, boolean activo) {
        String url = buildTenantJdbcUrl(empresa);
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(provisioningDbUsername);
        cfg.setPassword(provisioningDbPassword);
        cfg.setMaximumPoolSize(1);
        cfg.setPoolName("tenant-user-sync");

        try (HikariDataSource ds = new HikariDataSource(cfg)) {
            JdbcTemplate tenantJdbc = new JdbcTemplate(ds);
            ensureTenantUsuarioTable(tenantJdbc);
            boolean dos2fa = Boolean.TRUE.equals(usuario.getDosFactorHabilitado());
            boolean bloqueado = Boolean.TRUE.equals(usuario.getBloqueado());
            String flagEstado = activo ? "1" : "0";
            tenantJdbc.update(
                    """
                    INSERT INTO auth.usuario (
                        id, username, email, password, nombres, apellidos, nombre_completo,
                        dos_factor_habilitado, bloqueado, ultimo_login_en, flag_estado,
                        created_by, fec_creacion, updated_by, fec_modificacion
                    ) VALUES (
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, 1, NOW()
                    )
                    ON CONFLICT (id) DO UPDATE
                    SET username = EXCLUDED.username,
                        email = EXCLUDED.email,
                        password = EXCLUDED.password,
                        nombres = EXCLUDED.nombres,
                        apellidos = EXCLUDED.apellidos,
                        nombre_completo = EXCLUDED.nombre_completo,
                        dos_factor_habilitado = EXCLUDED.dos_factor_habilitado,
                        bloqueado = EXCLUDED.bloqueado,
                        ultimo_login_en = EXCLUDED.ultimo_login_en,
                        flag_estado = EXCLUDED.flag_estado,
                        updated_by = COALESCE((SELECT id FROM auth.usuario WHERE username = 'work' LIMIT 1), 1),
                        fec_modificacion = NOW()
                    """,
                    usuario.getId(),
                    usuario.getUsername(),
                    usuario.getEmail(),
                    usuario.getPassword(),
                    usuario.getNombres(),
                    usuario.getApellidos(),
                    usuario.getNombreCompleto(),
                    dos2fa,
                    bloqueado,
                    usuario.getUltimoLoginEn(),
                    flagEstado,
                    usuario.getFecCreacion() != null ? usuario.getFecCreacion() : java.time.OffsetDateTime.now()
            );
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("No se pudo sincronizar el usuario {} en tenant {}", usuario.getId(), empresa.getDbName(), e);
            Throwable root = e;
            while (root.getCause() != null) {
                root = root.getCause();
            }
            String detalle = root.getMessage();
            if (detalle == null || detalle.isBlank()) {
                detalle = e.getClass().getSimpleName();
            }
            if (detalle.length() > 500) {
                detalle = detalle.substring(0, 500) + "…";
            }
            throw new BusinessException(
                    "Sincronización usuario→tenant falló: " + detalle,
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "TENANT_USER_SYNC_ERROR"
            );
        }
    }

    private void ensureTenantUsuarioTable(JdbcTemplate tenantJdbc) {
        tenantJdbc.execute("CREATE SCHEMA IF NOT EXISTS auth");
        tenantJdbc.execute(
                """
                CREATE TABLE IF NOT EXISTS auth.usuario (
                    id BIGINT PRIMARY KEY,
                    username VARCHAR(80) NOT NULL UNIQUE,
                    email VARCHAR(150) UNIQUE,
                    password TEXT NOT NULL,
                    nombres VARCHAR(120) NOT NULL,
                    apellidos VARCHAR(120),
                    nombre_completo VARCHAR(200) NOT NULL,
                    dos_factor_habilitado BOOLEAN NOT NULL DEFAULT FALSE,
                    bloqueado BOOLEAN NOT NULL DEFAULT FALSE,
                    ultimo_login_en TIMESTAMPTZ,
                    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
                    created_by BIGINT NOT NULL DEFAULT 1,
                    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                    updated_by BIGINT DEFAULT 1,
                    fec_modificacion TIMESTAMPTZ
                )
                """
        );
        /*
         * Bases tenant antiguas: CREATE IF NOT EXISTS no agrega columnas nuevas.
         * El UPSERT usa flag_estado/created_by/updated_by/fec_modificacion; deben existir.
         */
        tenantJdbc.execute(
                "ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1'");
        tenantJdbc.execute(
                "ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS created_by BIGINT NOT NULL DEFAULT 1");
        tenantJdbc.execute(
                "ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW()");
        tenantJdbc.execute(
                "ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS updated_by BIGINT DEFAULT 1");
        tenantJdbc.execute(
                "ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS fec_modificacion TIMESTAMPTZ");
    }

    private Usuario resolveUsuario(Long usuarioId) {
        return usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new BusinessException(
                        "No existe usuario con id " + usuarioId,
                        HttpStatus.NOT_FOUND,
                        "USUARIO_NO_ENCONTRADO"
                ));
    }

    private EmpresaMaster resolveEmpresa(Long empresaId) {
        return empresaMasterRepository.findById(empresaId)
                .orElseThrow(() -> new BusinessException(
                        "No existe empresa con id " + empresaId,
                        HttpStatus.NOT_FOUND,
                        "EMPRESA_NO_ENCONTRADA"
                ));
    }

    private String buildTenantJdbcUrl(EmpresaMaster empresa) {
        return String.format(
                Locale.ROOT,
                "jdbc:postgresql://%s:%d/%s?sslmode=%s",
                empresa.getDbHost(),
                empresa.getDbPort(),
                empresa.getDbName(),
                jdbcSslMode
        );
    }

    private UsuarioEmpresaSyncResponse buildResponse(
            Usuario usuario,
            EmpresaMaster empresa,
            boolean activo,
            String mensaje) {
        return UsuarioEmpresaSyncResponse.builder()
                .usuarioId(usuario.getId())
                .username(usuario.getUsername())
                .email(usuario.getEmail())
                .empresaId(empresa.getId())
                .empresaCodigo(empresa.getCodigo())
                .dbName(empresa.getDbName())
                .activo(activo)
                .mensaje(mensaje)
                .build();
    }
}
