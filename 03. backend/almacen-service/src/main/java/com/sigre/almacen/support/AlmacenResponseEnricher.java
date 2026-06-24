package com.sigre.almacen.support;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.AlmacenTipo;
import com.sigre.almacen.entity.CentrosCostoRef;
import com.sigre.almacen.entity.EntidadContribuyenteRef;
import com.sigre.almacen.entity.SucursalRef;
import com.sigre.almacen.repository.AlmacenTipoRepository;
import com.sigre.almacen.repository.CentrosCostoRefRepository;
import com.sigre.almacen.repository.EntidadContribuyenteRefRepository;
import com.sigre.almacen.repository.SucursalRefRepository;

import java.util.HashSet;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class AlmacenResponseEnricher {

    private final AlmacenTipoRepository almacenTipoRepository;
    private final CentrosCostoRefRepository centrosCostoRefRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final SucursalRefRepository sucursalRefRepository;
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
        if (dto.getCentrosCostoId() != null) {
            dto.setCentrosCostoNombre(queryNombreCentrosCosto(dto.getCentrosCostoId()));
        } else {
            dto.setCentrosCostoNombre(null);
        }
        if (dto.getProveedorEntidadId() != null) {
            dto.setProveedorNombre(queryNombreProveedor(dto.getProveedorEntidadId()));
        } else {
            dto.setProveedorNombre(null);
        }
    }

    private String queryNombreSucursal(Long sucursalId) {
        return sucursalRefRepository.findById(sucursalId)
                .map(SucursalRef::getNombre)
                .orElse(null);
    }

    private String queryNombreAlmacenTipo(Long tipoId) {
        return almacenTipoRepository.findById(tipoId)
                .map(AlmacenTipo::getNombre)
                .orElse(null);
    }

    private String queryNombreCentrosCosto(Long centrosCostoId) {
        return centrosCostoRefRepository.findById(centrosCostoId)
                .map(cc -> cc.getCencos() + " — " + cc.getDescCencos())
                .orElse(null);
    }

    private String queryNombreProveedor(Long entidadId) {
        return entidadContribuyenteRefRepository.findById(entidadId)
                .map(EntidadContribuyenteRef::getNombreCompleto)
                .orElse(null);
    }
}
