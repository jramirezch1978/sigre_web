package com.sigre.almacen.support;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.almacen.dto.AlmacenTipoResponse;
import com.sigre.almacen.repository.CntblLibroRefRepository;

import java.util.HashSet;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class AlmacenTipoResponseEnricher {

    private final UsuarioResumenLoader usuarioResumenLoader;
    private final CntblLibroRefRepository cntblLibroRefRepository;

    public void enrich(AlmacenTipoResponse dto) {
        if (dto == null) {
            return;
        }
        Set<Long> userIds = new HashSet<>();
        UsuarioResumenLoader.addId(userIds, dto.getCreatedBy());
        UsuarioResumenLoader.addId(userIds, dto.getUpdatedBy());
        var users = usuarioResumenLoader.loadByIds(userIds);
        dto.setCreatedByUsuario(UsuarioResumenLoader.fromMap(users, dto.getCreatedBy()));
        dto.setUpdatedByUsuario(UsuarioResumenLoader.fromMap(users, dto.getUpdatedBy()));

        if (dto.getCntblLibroId() != null) {
            cntblLibroRefRepository.findById(dto.getCntblLibroId()).ifPresent(libro -> {
                dto.setLibroCodigo(libro.getCodigo());
                dto.setLibroNombre(libro.getNombre());
            });
        }
    }
}
