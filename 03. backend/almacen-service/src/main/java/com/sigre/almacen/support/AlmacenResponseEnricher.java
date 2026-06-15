package com.sigre.almacen.support;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.entity.Almacen;

import java.util.HashSet;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class AlmacenResponseEnricher {

    private final JdbcTemplate jdbcTemplate;
    private final UsuarioResumenLoader usuarioResumenLoader;

    public void enrich(Almacen entity, AlmacenResponse dto) {
        if (dto == null || entity == null) {
            return;
        }
        Set<Long> userIds = new HashSet<>();
        UsuarioResumenLoader.addId(userIds, dto.getCreatedBy());
        UsuarioResumenLoader.addId(userIds, dto.getUpdatedBy());
        var users = usuarioResumenLoader.loadByIds(userIds);
        dto.setCreatedByUsuario(UsuarioResumenLoader.fromMap(users, dto.getCreatedBy()));
        dto.setUpdatedByUsuario(UsuarioResumenLoader.fromMap(users, dto.getUpdatedBy()));

        if (dto.getSucursalId() != null) {
            dto.setSucursalNombre(queryNombreSucursal(dto.getSucursalId()));
        }
        if (dto.getAlmacenTipoId() != null) {
            dto.setAlmacenTipoNombre(queryNombreAlmacenTipo(dto.getAlmacenTipoId()));
        } else {
            dto.setAlmacenTipoNombre(null);
        }
    }

    private String queryNombreSucursal(Long sucursalId) {
        try {
            return jdbcTemplate.queryForObject(
                    "SELECT nombre FROM auth.sucursal WHERE id = ?",
                    String.class,
                    sucursalId);
        } catch (Exception ignored) {
            return null;
        }
    }

    private String queryNombreAlmacenTipo(Long tipoId) {
        try {
            return jdbcTemplate.queryForObject(
                    "SELECT nombre FROM almacen.almacen_tipo WHERE id = ?",
                    String.class,
                    tipoId);
        } catch (Exception ignored) {
            return null;
        }
    }
}
