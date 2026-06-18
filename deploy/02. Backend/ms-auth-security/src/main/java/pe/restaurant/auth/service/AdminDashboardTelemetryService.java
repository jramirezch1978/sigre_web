package pe.restaurant.auth.service;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.auth.dto.seguridad.AdminDashboardTelemetryResponse;
import pe.restaurant.auth.dto.seguridad.EmpresaTamanoItemDto;
import pe.restaurant.auth.dto.seguridad.SesionHistogramaItemDto;
import pe.restaurant.auth.dto.seguridad.SesionesBloqueoDbItemDto;
import pe.restaurant.auth.dto.seguridad.UsuariosConectadosItemDto;
import pe.restaurant.auth.dto.seguridad.UsuariosPorEmpresaItemDto;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Indicadores de panel administrativo a partir de la BD security (solo lectura).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminDashboardTelemetryService {

    private static final double MB = 1024.0 * 1024.0;

    private final JdbcTemplate jdbcTemplate;

    @Value("${spring.datasource.username}")
    private String provisioningDbUsername;

    @Value("${spring.datasource.password}")
    private String provisioningDbPassword;

    @Value("${app.tenant.jdbc-ssl-mode:require}")
    private String jdbcSslMode;

    @Transactional(readOnly = true)
    public AdminDashboardTelemetryResponse cargar() {
        List<EmpresaTamanoItemDto> empresas = listarEmpresasConTamanoBd();
        long totalUsuarios = contarUsuariosActivos();
        List<UsuariosPorEmpresaItemDto> porEmpresa = listarUsuariosPorEmpresa();
        List<SesionHistogramaItemDto> histograma = histogramaSesiones();
        long fallidas = contarSesionesIncorrectas();
        long bloqueados = contarUsuariosBloqueados();
        long bloqueadosLogin = contarUsuariosBloqueadosPorIntentosLogin();
        long proximosDesbloqueo = contarUsuariosProximosDesbloqueo();
        Long latencia = latenciaPromedioMs();
        List<UsuariosConectadosItemDto> conectados = usuariosConectadosPorEmpresa();
        List<SesionesBloqueoDbItemDto> sesionesBd = listarSesionesBloqueoPorBd();

        return AdminDashboardTelemetryResponse.builder()
                .empresasBd(empresas)
                .totalUsuariosPlataforma(totalUsuarios)
                .usuariosPorEmpresa(porEmpresa)
                .histogramaSesionesPorEmpresa(histograma)
                .sesionesIncorrectasUltimos30Dias(fallidas)
                .usuariosBloqueadosPorSeguridad(bloqueados)
                .usuariosBloqueadosPorIntentosLogin(bloqueadosLogin)
                .usuariosProximosDesbloqueoAutomatico(proximosDesbloqueo)
                .latenciaPromedioMsUltimas24h(latencia)
                .usuariosConectadosPorEmpresa(conectados)
                .sesionesBloqueoPorBaseDatos(sesionesBd)
                .build();
    }

    private List<EmpresaTamanoItemDto> listarEmpresasConTamanoBd() {
        return jdbcTemplate.query(
                """
                SELECT e.id, e.codigo, e.razon_social, e.db_name,
                       COALESCE((
                           SELECT pg_database_size(d.oid)
                           FROM pg_database d
                           WHERE d.datname = e.db_name
                       ), 0) AS bytes
                FROM master.empresa e
                WHERE e.flag_estado = '1'
                ORDER BY e.id
                """,
                (rs, i) -> {
                    long bytes = rs.getLong("bytes");
                    return EmpresaTamanoItemDto.builder()
                            .empresaId(rs.getLong("id"))
                            .codigo(rs.getString("codigo"))
                            .razonSocial(rs.getString("razon_social"))
                            .dbName(rs.getString("db_name"))
                            .tamanoMb(Math.round((bytes / MB) * 100.0) / 100.0)
                            .build();
                });
    }

    private long contarUsuariosActivos() {
        Long n = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario WHERE flag_estado = '1'",
                Long.class);
        return n != null ? n : 0L;
    }

    private List<UsuariosPorEmpresaItemDto> listarUsuariosPorEmpresa() {
        return jdbcTemplate.query(
                """
                SELECT ue.empresa_id, e.razon_social, COUNT(DISTINCT ue.usuario_id) AS c
                FROM auth.usuario_empresa ue
                JOIN master.empresa e ON e.id = ue.empresa_id
                WHERE ue.flag_estado = '1' AND e.flag_estado = '1'
                GROUP BY ue.empresa_id, e.razon_social
                ORDER BY e.razon_social
                """,
                (rs, i) -> UsuariosPorEmpresaItemDto.builder()
                        .empresaId(rs.getLong("empresa_id"))
                        .razonSocial(rs.getString("razon_social"))
                        .usuarios(rs.getLong("c"))
                        .build());
    }

    private List<SesionHistogramaItemDto> histogramaSesiones() {
        return jdbcTemplate.query(
                """
                SELECT DATE_TRUNC('day', la.fecha_login)::date AS dia,
                       la.empresa_id,
                       COALESCE(e.razon_social, '') AS razon_social,
                       COUNT(*) AS sesiones
                FROM auth.log_acceso la
                LEFT JOIN master.empresa e ON e.id = la.empresa_id
                WHERE la.fecha_login >= (CURRENT_TIMESTAMP - INTERVAL '14 days')
                  AND la.exito = TRUE
                  AND la.empresa_id IS NOT NULL
                  AND la.evento IN (
                      'LOGIN',
                      'SELECCION_EMPRESA',
                      'SELECCION_EMPRESA_REUSO_TOKEN',
                      'SELECCION_EMPRESA_LOGIN'
                  )
                GROUP BY 1, 2, e.razon_social
                ORDER BY 1 ASC, 3 ASC
                """,
                (rs, i) -> {
                    LocalDate d = rs.getObject("dia", LocalDate.class);
                    String diaStr = d != null ? d.toString() : "";
                    return SesionHistogramaItemDto.builder()
                            .dia(diaStr)
                            .empresaId(rs.getLong("empresa_id"))
                            .empresaNombre(rs.getString("razon_social"))
                            .sesiones(rs.getLong("sesiones"))
                            .build();
                });
    }

    private long contarSesionesIncorrectas() {
        Long n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.log_acceso
                WHERE exito = FALSE
                  AND fecha_login >= (CURRENT_TIMESTAMP - INTERVAL '30 days')
                """,
                Long.class);
        return n != null ? n : 0L;
    }

    private long contarUsuariosBloqueados() {
        Long n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.usuario
                WHERE flag_estado = '1'
                  AND (
                      bloqueado = TRUE
                      OR (bloqueado_hasta IS NOT NULL AND bloqueado_hasta > CURRENT_TIMESTAMP)
                  )
                """,
                Long.class);
        return n != null ? n : 0L;
    }

    /**
     * Bloqueo automático tras fallos de login: coherente con {@code AuthServiceImpl} (3 intentos, ventana {@code bloqueado_hasta}).
     */
    private long contarUsuariosBloqueadosPorIntentosLogin() {
        Long n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.usuario
                WHERE flag_estado = '1'
                  AND intentos_fallidos >= 3
                  AND bloqueado_hasta IS NOT NULL
                  AND bloqueado_hasta > CURRENT_TIMESTAMP
                """,
                Long.class);
        return n != null ? n : 0L;
    }

    /** Desbloqueo automático al vencer {@code bloqueado_hasta}; ventana próxima 6 h. */
    private long contarUsuariosProximosDesbloqueo() {
        Long n = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.usuario
                WHERE flag_estado = '1'
                  AND intentos_fallidos >= 3
                  AND bloqueado_hasta IS NOT NULL
                  AND bloqueado_hasta > CURRENT_TIMESTAMP
                  AND bloqueado_hasta <= CURRENT_TIMESTAMP + INTERVAL '6 hours'
                """,
                Long.class);
        return n != null ? n : 0L;
    }

    private Long latenciaPromedioMs() {
        return jdbcTemplate.query(
                """
                SELECT ROUND(AVG(duracion_ms))::BIGINT
                FROM auth.token_uso_log
                WHERE fecha >= (CURRENT_TIMESTAMP - INTERVAL '24 hours')
                  AND duracion_ms IS NOT NULL
                """,
                rs -> {
                    if (!rs.next()) {
                        return null;
                    }
                    Object v = rs.getObject(1);
                    if (v == null) {
                        return null;
                    }
                    if (v instanceof Number num) {
                        return num.longValue();
                    }
                    return null;
                });
    }

    private List<UsuariosConectadosItemDto> usuariosConectadosPorEmpresa() {
        return jdbcTemplate.query(
                """
                SELECT ts.empresa_id, e.razon_social, COUNT(DISTINCT ts.usuario_id) AS c
                FROM auth.tokens_session ts
                JOIN master.empresa e ON e.id = ts.empresa_id
                WHERE ts.flag_estado = '1'
                  AND ts.expira_en > CURRENT_TIMESTAMP
                  AND e.flag_estado = '1'
                GROUP BY ts.empresa_id, e.razon_social
                ORDER BY e.razon_social
                """,
                (rs, i) -> UsuariosConectadosItemDto.builder()
                        .empresaId(rs.getLong("empresa_id"))
                        .razonSocial(rs.getString("razon_social"))
                        .usuariosConectados(rs.getLong("c"))
                        .build());
    }

    private List<SesionesBloqueoDbItemDto> listarSesionesBloqueoPorBd() {
        List<SesionesBloqueoDbItemDto> out = new ArrayList<>();
        String secDb = jdbcTemplate.queryForObject("SELECT current_database()", String.class);
        long[] sec = estadisticasPgBackend(jdbcTemplate);
        out.add(SesionesBloqueoDbItemDto.builder()
                .alcance("SECURITY")
                .empresaId(null)
                .etiqueta(secDb != null ? secDb : "security")
                .sesionesEsperandoLock(sec[0])
                .sesionesActivasSinEsperaLock(sec[1])
                .errorMuestreo(null)
                .build());

        for (TenantDato t : listarTenantsActivos()) {
            agregarMuestreoTenant(out, t);
        }
        return out;
    }

    private record TenantDato(long id, String razonSocial, String dbName, String dbHost, int dbPort) {}

    private List<TenantDato> listarTenantsActivos() {
        return jdbcTemplate.query(
                """
                SELECT id, razon_social, db_name, db_host, db_port
                FROM master.empresa
                WHERE flag_estado = '1'
                ORDER BY id
                """,
                (rs, row) -> new TenantDato(
                        rs.getLong("id"),
                        rs.getString("razon_social"),
                        rs.getString("db_name"),
                        rs.getString("db_host"),
                        rs.getInt("db_port")));
    }

    private void agregarMuestreoTenant(List<SesionesBloqueoDbItemDto> out, TenantDato t) {
        String url = String.format(Locale.ROOT, "jdbc:postgresql://%s:%d/%s?sslmode=%s",
                t.dbHost(), t.dbPort(), t.dbName(), jdbcSslMode);
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(provisioningDbUsername);
        cfg.setPassword(provisioningDbPassword);
        cfg.setMaximumPoolSize(1);
        cfg.setPoolName("dash-pg-" + t.id());
        cfg.setConnectionTimeout(12_000);
        try (HikariDataSource ds = new HikariDataSource(cfg)) {
            JdbcTemplate jt = new JdbcTemplate(ds);
            long[] st = estadisticasPgBackend(jt);
            out.add(SesionesBloqueoDbItemDto.builder()
                    .alcance("TENANT")
                    .empresaId(t.id())
                    .etiqueta(t.razonSocial())
                    .sesionesEsperandoLock(st[0])
                    .sesionesActivasSinEsperaLock(st[1])
                    .errorMuestreo(null)
                    .build());
        } catch (Exception e) {
            log.warn("No se pudo muestrear sesiones PG en tenant {}: {}", t.dbName(), e.toString());
            String msg = e.getMessage();
            if (msg != null && msg.length() > 200) {
                msg = msg.substring(0, 197) + "...";
            }
            out.add(SesionesBloqueoDbItemDto.builder()
                    .alcance("TENANT")
                    .empresaId(t.id())
                    .etiqueta(t.razonSocial())
                    .sesionesEsperandoLock(0L)
                    .sesionesActivasSinEsperaLock(0L)
                    .errorMuestreo(msg != null ? msg : e.getClass().getSimpleName())
                    .build());
        }
    }

    /** [0]=backends activos esperando lock; [1]=otros backends activos (sin espera lock). */
    private static long[] estadisticasPgBackend(JdbcTemplate jt) {
        return jt.query(
                """
                SELECT
                  COALESCE(COUNT(*) FILTER (
                    WHERE state = 'active' AND wait_event_type = 'Lock'
                      AND pid <> pg_backend_pid()
                  ), 0)::bigint,
                  COALESCE(COUNT(*) FILTER (
                    WHERE state = 'active'
                      AND (wait_event_type IS DISTINCT FROM 'Lock' OR wait_event_type IS NULL)
                      AND pid <> pg_backend_pid()
                  ), 0)::bigint
                FROM pg_stat_activity
                WHERE datname = current_database()
                """,
                rs -> {
                    if (!rs.next()) {
                        return new long[] {0L, 0L};
                    }
                    return new long[] {rs.getLong(1), rs.getLong(2)};
                });
    }
}
