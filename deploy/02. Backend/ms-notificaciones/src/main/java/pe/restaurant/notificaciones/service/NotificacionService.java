package pe.restaurant.notificaciones.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.notificaciones.dto.NotificacionDto;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificacionService {

    private final JdbcTemplate jdbcTemplate;

    public List<NotificacionDto> listarPorUsuarioYEmpresa(Long usuarioId, Long empresaId) {
        try {
            return jdbcTemplate.query(
                    """
                    SELECT n.id,
                           n.empresa_id,
                           n.titulo,
                           n.descripcion,
                           n.tipo,
                           n.leido,
                           COALESCE(n.enviado_en, n.creado_en) AS creado_en
                    FROM auth.notificacion n
                    WHERE n.usuario_id = ?
                      AND n.empresa_id = ?
                      AND n.flag_estado = '1'
                    ORDER BY COALESCE(n.enviado_en, n.creado_en) DESC
                    """,
                    (rs, rowNum) -> NotificacionDto.builder()
                            .id(rs.getLong("id"))
                            .empresaId(rs.getLong("empresa_id"))
                            .titulo(rs.getString("titulo"))
                            .descripcion(rs.getString("descripcion"))
                            .tipo(rs.getString("tipo"))
                            .leido(rs.getBoolean("leido"))
                            .creadoEn(rs.getObject("creado_en", java.time.OffsetDateTime.class))
                            .build(),
                    usuarioId, empresaId
            );
        } catch (Exception e) {
            log.error("Error listando notificaciones usuario={} empresa={}", usuarioId, empresaId, e);
            throw new BusinessException("Error al listar notificaciones",
                    HttpStatus.INTERNAL_SERVER_ERROR, "NOTIFICACIONES_LISTAR_ERROR");
        }
    }

    public boolean marcarComoLeida(Long notificacionId, Long usuarioId, Long empresaId) {
        try {
            int updated = jdbcTemplate.update(
                    """
                    UPDATE auth.notificacion
                    SET leido = TRUE,
                        leido_en = COALESCE(leido_en, NOW())
                    WHERE id = ?
                      AND usuario_id = ?
                      AND empresa_id = ?
                      AND flag_estado = '1'
                      AND leido = FALSE
                    """,
                    notificacionId, usuarioId, empresaId
            );
            return updated > 0;
        } catch (Exception e) {
            log.error("Error marcando notificacion={} como leida usuario={} empresa={}",
                    notificacionId, usuarioId, empresaId, e);
            throw new BusinessException("Error al actualizar notificación",
                    HttpStatus.INTERNAL_SERVER_ERROR, "NOTIFICACION_ACTUALIZAR_ERROR");
        }
    }
}
