package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Lectura de notificaciones del usuario (destinatario directo o por grupo) para el dashboard.
 * El ENVÍO/creación de notificaciones es responsabilidad del microservicio de notificaciones;
 * aquí solo se consultan y se marcan como leídas.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class NotificacionService {

    private final JdbcTemplate jdbcTemplate;

    /** Notificaciones dirigidas al usuario: destino directo (U) o por alguno de sus grupos (G). */
    private static final String FILTRO_DESTINO = """
            n.flag_estado = '1' AND n.empresa_id = ?
            AND ( (n.destino_tipo = 'U' AND n.usuario_destino_id = ?)
                  OR (n.destino_tipo = 'G' AND n.grupo_usuario_destino_id IN (
                        SELECT gd.grupo_usuario_id FROM auth.grupo_usuario_det gd
                        WHERE gd.usuario_id = ? AND gd.flag_estado = '1')) )
            """;

    public int contarNoLeidas(long usuarioId, long empresaId) {
        Integer n = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.notificacion n WHERE " + FILTRO_DESTINO + " AND n.leido = FALSE",
                Integer.class, empresaId, usuarioId, usuarioId);
        return n != null ? n : 0;
    }

    /** Todas las notificaciones del usuario (leídas y no leídas), más recientes primero. */
    public List<Map<String, Object>> listar(long usuarioId, long empresaId) {
        return jdbcTemplate.queryForList("""
                SELECT n.id, n.titulo, n.descripcion, n.tipo, n.destino_tipo, n.leido, n.enviado_en,
                       o.nombre_completo AS origen
                FROM auth.notificacion n
                JOIN auth.usuario o ON o.id = n.usuario_id
                WHERE """ + FILTRO_DESTINO + """
                ORDER BY n.enviado_en DESC
                LIMIT 100
                """, empresaId, usuarioId, usuarioId);
    }

    @Transactional
    public void marcarLeida(long usuarioId, long empresaId, long notificacionId) {
        jdbcTemplate.update(
                "UPDATE auth.notificacion n SET leido = TRUE, leido_en = NOW() WHERE n.id = ? AND n.leido = FALSE AND "
                        + FILTRO_DESTINO,
                notificacionId, empresaId, usuarioId, usuarioId);
    }

    @Transactional
    public int marcarTodasLeidas(long usuarioId, long empresaId) {
        return jdbcTemplate.update(
                "UPDATE auth.notificacion n SET leido = TRUE, leido_en = NOW() WHERE n.leido = FALSE AND "
                        + FILTRO_DESTINO,
                empresaId, usuarioId, usuarioId);
    }
}
