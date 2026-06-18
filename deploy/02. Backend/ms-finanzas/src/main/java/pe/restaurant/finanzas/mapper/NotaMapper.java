package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.dto.request.NotaRequest;
import pe.restaurant.finanzas.dto.response.NotaResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.enums.TipoNota;

import java.util.List;

@Component
public class NotaMapper {

    public NotaResponse toResponse(CntasPagar entity) {
        if (entity == null) {
            return null;
        }

        NotaResponse response = new NotaResponse();
        response.setId(entity.getId());
        response.setSucursalId(entity.getSucursalId());
        response.setProveedorId(entity.getProveedorId());
        response.setDocTipoId(entity.getDocTipoId());
        response.setSerie(entity.getSerie());
        response.setNumero(entity.getNumero());
        response.setFechaEmision(entity.getFechaEmision() != null ? 
            entity.getFechaEmision().atStartOfDay() : null);
        response.setFechaVencimiento(entity.getFechaVencimiento() != null ? 
            entity.getFechaVencimiento().atStartOfDay() : null);
        response.setMonedaId(entity.getMonedaId());
        response.setTotal(entity.getTotal());
        response.setSaldo(entity.getSaldo());
        response.setAno(entity.getAno());
        response.setMes(entity.getMes());
        response.setCntblLibroId(entity.getCntblLibroId());
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
            response.setDetalles(new NotaDetalleMapper().toResponseList(entity.getDetalles()));
        }

        return response;
    }

    public List<NotaResponse> toResponseList(List<CntasPagar> entities) {
        return entities.stream()
                .map(this::toResponse)
                .toList();
    }

    public CntasPagar toEntity(NotaRequest request, Long sucursalId, Long cntblAsientoId) {
        if (request == null) {
            return null;
        }

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
        entity.setCntblAsientoId(cntblAsientoId); // Asiento contable generado
        entity.setFlagEstado("1");
        entity.setDescripcion(request.getDescripcion());
        entity.setFormaPagoId(request.getFormaPagoId());
        entity.setAno(request.getAno());
        entity.setMes(request.getMes());
        entity.setCntblLibroId(request.getCntblLibroId());
        entity.setCodOrigen(request.getCodOrigen());
        entity.setOperDetr(request.getOperDetr());
        entity.setDetrBienServId(request.getDetrBienServId());
        entity.setNroDetraccion(request.getNroDetraccion());
        entity.setFlagDetraccion(request.getFlagDetraccion());
        entity.setImporteDetraccion(request.getImporteDetraccion());
        entity.setFlagRetencion(request.getFlagRetencion());
        entity.setPorcRetIgv(request.getPorcRetIgv());

        return entity;
    }
}
