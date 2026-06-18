package pe.restaurant.almacen.support;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import pe.restaurant.almacen.dto.UsuarioResumenDto;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class UsuarioResumenLoader {

    private final JdbcTemplate jdbcTemplate;

    public Map<Long, UsuarioResumenDto> loadByIds(Set<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Map.of();
        }
        Set<Long> clean = new HashSet<>();
        for (Long id : ids) {
            if (id != null) {
                clean.add(id);
            }
        }
        if (clean.isEmpty()) {
            return Map.of();
        }
        String placeholders = String.join(",", Collections.nCopies(clean.size(), "?"));
        String sql = "SELECT id, nombre_completo, username FROM auth.usuario WHERE id IN (" + placeholders + ")";
        Object[] args = clean.toArray();
        List<UsuarioResumenDto> rows = jdbcTemplate.query(
                sql,
                args,
                (rs, rowNum) -> UsuarioResumenDto.builder()
                        .id(rs.getLong("id"))
                        .nombreCompleto(rs.getString("nombre_completo"))
                        .numeroDocumento(rs.getString("username"))
                        .build());
        Map<Long, UsuarioResumenDto> map = new HashMap<>();
        for (UsuarioResumenDto u : rows) {
            map.put(u.getId(), u);
        }
        return map;
    }

    public UsuarioResumenDto loadOne(Long id) {
        if (id == null) {
            return null;
        }
        return loadByIds(Set.of(id)).get(id);
    }

    /** Añade ids no nulos al conjunto acumulador. */
    public static void addId(Set<Long> target, Long id) {
        if (id != null) {
            target.add(id);
        }
    }

    public static UsuarioResumenDto copyOf(UsuarioResumenDto src) {
        if (src == null) {
            return null;
        }
        return UsuarioResumenDto.builder()
                .id(src.getId())
                .nombreCompleto(src.getNombreCompleto())
                .numeroDocumento(src.getNumeroDocumento())
                .build();
    }

    public static UsuarioResumenDto fromMap(Map<Long, UsuarioResumenDto> map, Long id) {
        if (id == null || map == null) {
            return null;
        }
        UsuarioResumenDto u = map.get(id);
        return u == null ? null : copyOf(u);
    }
}
