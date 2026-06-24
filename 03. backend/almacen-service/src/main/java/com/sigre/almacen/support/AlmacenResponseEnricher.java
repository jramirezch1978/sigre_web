package com.sigre.almacen.support;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.AlmacenTipo;
import com.sigre.almacen.entity.CentrosCostoRef;
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
            sucursalRefRepository.findById(dto.getSucursalId()).ifPresentOrElse(sucursal -> {
                dto.setSucursalCodigo(sucursal.getCodigo());
                dto.setSucursalNombre(FkDisplayFormatter.codigoDescripcion(sucursal.getCodigo(), sucursal.getNombre()));
            }, () -> {
                dto.setSucursalCodigo(null);
                dto.setSucursalNombre(null);
            });
        } else {
            dto.setSucursalCodigo(null);
            dto.setSucursalNombre(null);
        }

        if (dto.getAlmacenTipoId() != null) {
            almacenTipoRepository.findById(dto.getAlmacenTipoId()).ifPresentOrElse(tipo -> {
                dto.setAlmacenTipoCodigo(tipo.getCodigo());
                dto.setAlmacenTipoNombre(FkDisplayFormatter.codigoDescripcion(tipo.getCodigo(), tipo.getNombre()));
            }, () -> {
                dto.setAlmacenTipoCodigo(null);
                dto.setAlmacenTipoNombre(null);
            });
        } else {
            dto.setAlmacenTipoCodigo(null);
            dto.setAlmacenTipoNombre(null);
        }

        if (dto.getCentrosCostoId() != null) {
            centrosCostoRefRepository.findById(dto.getCentrosCostoId()).ifPresentOrElse(cc -> {
                dto.setCentrosCostoCodigo(cc.getCencos());
                dto.setCentrosCostoNombre(FkDisplayFormatter.codigoDescripcion(cc.getCencos(), cc.getDescCencos()));
            }, () -> {
                dto.setCentrosCostoCodigo(null);
                dto.setCentrosCostoNombre(null);
            });
        } else {
            dto.setCentrosCostoCodigo(null);
            dto.setCentrosCostoNombre(null);
        }

        if (dto.getProveedorEntidadId() != null) {
            entidadContribuyenteRefRepository.findById(dto.getProveedorEntidadId()).ifPresentOrElse(proveedor -> {
                dto.setProveedorDocumento(proveedor.getNroDocumento());
                dto.setProveedorNombre(FkDisplayFormatter.codigoDescripcion(
                        proveedor.getNroDocumento(),
                        proveedor.getNombreCompleto()));
            }, () -> {
                dto.setProveedorDocumento(null);
                dto.setProveedorNombre(null);
            });
        } else {
            dto.setProveedorDocumento(null);
            dto.setProveedorNombre(null);
        }
    }
}
