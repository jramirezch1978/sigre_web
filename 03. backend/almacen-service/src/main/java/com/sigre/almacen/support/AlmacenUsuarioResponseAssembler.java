package com.sigre.almacen.support;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.almacen.dto.AlmacenUsuarioResponse;
import com.sigre.almacen.entity.AlmacenUser;

import com.sigre.almacen.dto.UsuarioResumenDto;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class AlmacenUsuarioResponseAssembler {

    private final UsuarioResumenLoader usuarioResumenLoader;

    public AlmacenUsuarioResponse toResponse(AlmacenUser e) {
        if (e == null) {
            return null;
        }
        Set<Long> ids = new HashSet<>();
        UsuarioResumenLoader.addId(ids, e.getUsuarioId());
        UsuarioResumenLoader.addId(ids, e.getCreatedBy());
        UsuarioResumenLoader.addId(ids, e.getUpdatedBy());
        return build(e, usuarioResumenLoader.loadByIds(ids));
    }

    public List<AlmacenUsuarioResponse> toResponseList(List<AlmacenUser> entities) {
        if (entities == null || entities.isEmpty()) {
            return List.of();
        }
        Set<Long> ids = new HashSet<>();
        for (AlmacenUser e : entities) {
            UsuarioResumenLoader.addId(ids, e.getUsuarioId());
            UsuarioResumenLoader.addId(ids, e.getCreatedBy());
            UsuarioResumenLoader.addId(ids, e.getUpdatedBy());
        }
        Map<Long, UsuarioResumenDto> users = usuarioResumenLoader.loadByIds(ids);
        List<AlmacenUsuarioResponse> out = new ArrayList<>(entities.size());
        for (AlmacenUser e : entities) {
            out.add(build(e, users));
        }
        return out;
    }

    private static AlmacenUsuarioResponse build(AlmacenUser e, Map<Long, UsuarioResumenDto> users) {
        return AlmacenUsuarioResponse.builder()
                .id(e.getId())
                .almacenId(e.getAlmacenId())
                .usuarioId(e.getUsuarioId())
                .usuario(UsuarioResumenLoader.fromMap(users, e.getUsuarioId()))
                .flagEstado(e.getFlagEstado())
                .createdBy(e.getCreatedBy())
                .createdByUsuario(UsuarioResumenLoader.fromMap(users, e.getCreatedBy()))
                .fecCreacion(e.getFecCreacion())
                .updatedBy(e.getUpdatedBy())
                .updatedByUsuario(UsuarioResumenLoader.fromMap(users, e.getUpdatedBy()))
                .fecModificacion(e.getFecModificacion())
                .build();
    }
}
