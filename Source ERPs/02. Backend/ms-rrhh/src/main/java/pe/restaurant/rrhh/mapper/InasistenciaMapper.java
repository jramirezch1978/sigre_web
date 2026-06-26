package pe.restaurant.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.rrhh.dto.request.InasistenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.InasistenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.InasistenciaResponse;
import pe.restaurant.rrhh.entity.Inasistencia;
import pe.restaurant.rrhh.repository.InasistenciaRepository;

import java.math.BigDecimal;
import java.time.ZoneId;

@Component
@RequiredArgsConstructor
public class InasistenciaMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");

    private final InasistenciaRepository repository;

    public InasistenciaResponse toResponse(Inasistencia entity) {
        if (entity == null) {
            return null;
        }
        Long conceptoId = entity.getConceptoPlanillaId();
        return InasistenciaResponse.builder()
                .id(entity.getId())
                .trabajadorId(entity.getTrabajadorId())
                .trabajadorNombres(repository.findTrabajadorNombresById(entity.getTrabajadorId()))
                .conceptoPlanillaId(conceptoId)
                .conceptoPlanillaCodigo(conceptoId != null
                        ? repository.findConceptoPlanillaCodigoById(conceptoId) : null)
                .conceptoPlanillaNombre(conceptoId != null
                        ? repository.findConceptoPlanillaNombreById(conceptoId) : null)
                .fechaDesde(entity.getFechaDesde())
                .fechaHasta(entity.getFechaHasta())
                .fechaMovimiento(entity.getFechaMovimiento())
                .diasInasistencia(entity.getDiasInasistencia())
                .flagVacacionesAdelantadas(entity.getFlagVacacionesAdelantadas())
                .importe(entity.getImporte())
                .flagEstado(entity.getFlagEstado())
                .createdBy(entity.getCreatedBy())
                .createdByLogin(entity.getCreatedBy() != null
                        ? repository.findUsuarioLoginById(entity.getCreatedBy()) : null)
                .fecCreacion(entity.getFecCreacion() != null
                        ? entity.getFecCreacion().atZone(ZONA_LIMA).toOffsetDateTime() : null)
                .build();
    }

    public Inasistencia toEntity(InasistenciaCreateRequest request) {
        Inasistencia entity = new Inasistencia();
        entity.setTrabajadorId(request.getTrabajadorId());
        entity.setConceptoPlanillaId(request.getConceptoPlanillaId());
        entity.setFechaDesde(request.getFechaDesde());
        entity.setFechaHasta(request.getFechaHasta() != null ? request.getFechaHasta() : request.getFechaDesde());
        entity.setFechaMovimiento(request.getFechaMovimiento() != null ? request.getFechaMovimiento() : request.getFechaDesde());
        entity.setDiasInasistencia(calcularDias(request.getDiasInasistencia(), entity.getFechaDesde(), entity.getFechaHasta()));
        entity.setFlagVacacionesAdelantadas(request.getFlagVacacionesAdelantadas() != null
                ? request.getFlagVacacionesAdelantadas() : "0");
        entity.setImporte(request.getImporte() != null ? request.getImporte() : BigDecimal.ZERO);
        entity.setFlagEstado(request.getFlagEstado());
        return entity;
    }

    public void updateEntity(Inasistencia entity, InasistenciaUpdateRequest request) {
        if (request.getConceptoPlanillaId() != null) {
            entity.setConceptoPlanillaId(request.getConceptoPlanillaId());
        }
        if (request.getFechaDesde() != null) {
            entity.setFechaDesde(request.getFechaDesde());
        }
        if (request.getFechaHasta() != null) {
            entity.setFechaHasta(request.getFechaHasta());
        }
        if (request.getFechaMovimiento() != null) {
            entity.setFechaMovimiento(request.getFechaMovimiento());
        }
        if (request.getDiasInasistencia() != null) {
            entity.setDiasInasistencia(request.getDiasInasistencia());
        } else if (request.getFechaDesde() != null || request.getFechaHasta() != null) {
            entity.setDiasInasistencia(calcularDias(null, entity.getFechaDesde(), entity.getFechaHasta()));
        }
        if (request.getFlagVacacionesAdelantadas() != null) {
            entity.setFlagVacacionesAdelantadas(request.getFlagVacacionesAdelantadas());
        }
        if (request.getImporte() != null) {
            entity.setImporte(request.getImporte());
        }
        if (request.getFlagEstado() != null) {
            entity.setFlagEstado(request.getFlagEstado());
        }
    }

    private BigDecimal calcularDias(BigDecimal dias, java.time.LocalDate desde, java.time.LocalDate hasta) {
        if (dias != null) {
            return dias;
        }
        if (desde == null) {
            return BigDecimal.ONE;
        }
        java.time.LocalDate fin = hasta != null ? hasta : desde;
        long diff = java.time.temporal.ChronoUnit.DAYS.between(desde, fin) + 1;
        return BigDecimal.valueOf(Math.max(diff, 1));
    }
}
