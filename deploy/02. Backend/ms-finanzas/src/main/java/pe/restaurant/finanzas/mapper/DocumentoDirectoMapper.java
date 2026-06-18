package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.dto.request.DocumentoDirectoRequest;
import pe.restaurant.finanzas.dto.response.DocumentoDirectoResponse;
import pe.restaurant.finanzas.entity.CntasPagar;

import java.util.List;

@Component
public class DocumentoDirectoMapper {

    public DocumentoDirectoResponse toResponse(CntasPagar entity) {
        if (entity == null) {
            return null;
        }

        DocumentoDirectoResponse response = new DocumentoDirectoResponse();
        response.setId(entity.getId());
        response.setSucursalId(entity.getSucursalId());
        response.setProveedorId(entity.getProveedorId());
        response.setDocTipoId(entity.getDocTipoId());
        response.setSerie(entity.getSerie());
        response.setNumero(entity.getNumero());
        response.setFechaEmision(entity.getFechaEmision());
        response.setFechaVencimiento(entity.getFechaVencimiento());
        response.setMonedaId(entity.getMonedaId());
        response.setTotal(entity.getTotal());
        response.setSaldo(entity.getSaldo());
        response.setCntblAsientoId(entity.getCntblAsientoId());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion() != null ? 
            entity.getFecCreacion().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime() : null);
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion() != null ? 
            entity.getFecModificacion().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime() : null);

        // Mapear detalles si es necesario
        if (entity.getDetalles() != null && !entity.getDetalles().isEmpty()) {
            response.setDetalles(new DocumentoDirectoDetalleMapper().toResponseList(entity.getDetalles()));
        }

        return response;
    }

    public List<DocumentoDirectoResponse> toResponseList(List<CntasPagar> entities) {
        return entities.stream()
                .map(this::toResponse)
                .toList();
    }

    public CntasPagar toEntity(DocumentoDirectoRequest request, Long sucursalId) {
        if (request == null) {
            return null;
        }

        Long usuarioId = TenantContext.getUsuarioId();

        CntasPagar entity = new CntasPagar();
        entity.setSucursalId(sucursalId);
        entity.setProveedorId(request.getProveedorId());
        entity.setDocTipoId(request.getDocTipoId());
        entity.setSerie(request.getSerie());
        entity.setNumero(request.getNumero());
        entity.setFechaEmision(request.getFechaEmision());
        entity.setFechaVencimiento(request.getFechaVencimiento());
        entity.setMonedaId(request.getMonedaId());
        entity.setTotal(request.getTotal());
        entity.setSaldo(request.getTotal()); // Inicializar saldo con el total
        entity.setAno(request.getAno());
        entity.setMes(request.getMes());
        entity.setCntblLibroId(request.getCntblLibroId());
        entity.setCntblAsientoId(null); // Sin asiento contable para documentos directos
        entity.setFlagEstado("1");
        entity.setCreatedBy(usuarioId);


        return entity;
    }
}
