package pe.restaurant.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.rrhh.dto.response.GanDescFijoResponse;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;
import pe.restaurant.rrhh.entity.GanDescFijo;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Component
@RequiredArgsConstructor
public class GanDescFijoMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository trabajadorRepository;
    private final ConceptoPlanillaRepository conceptoPlanillaRepository;

    public GanDescFijoResponse toResponse(GanDescFijo entity) {
        return GanDescFijoResponse.builder()
                .id(entity.getId())
                .trabajadorId(entity.getTrabajadorId())
                .trabajadorNombres(resolverTrabajadorNombres(entity.getTrabajadorId()))
                .conceptoId(entity.getConceptoId())
                .conceptoDescripcion(resolverConceptoDescripcion(entity.getConceptoId()))
                .impGanDesc(entity.getImpGanDesc())
                .porcentaje(entity.getPorcentaje())
                .impMaxGanDesc(entity.getImpMaxGanDesc())
                .flagEstado(entity.getFlagEstado())
                .createdBy(entity.getCreatedBy())
                .fecCreacion(formatTimestamp(entity.getFecCreacion()))
                .updatedBy(entity.getUpdatedBy())
                .fecModificacion(formatTimestamp(entity.getFecModificacion()))
                .build();
    }

    private String resolverTrabajadorNombres(Long trabajadorId) {
        if (trabajadorId == null) return null;
        return trabajadorRepository.findById(trabajadorId)
                .map(this::buildNombreCompleto)
                .orElse(null);
    }

    private String buildNombreCompleto(Trabajador t) {
        StringBuilder sb = new StringBuilder();
        if (t.getApellidoPaterno() != null) sb.append(t.getApellidoPaterno());
        if (t.getApellidoMaterno() != null) {
            if (!sb.isEmpty()) sb.append(" ");
            sb.append(t.getApellidoMaterno());
        }
        if (t.getNombres() != null) {
            if (!sb.isEmpty()) sb.append(", ");
            sb.append(t.getNombres());
        }
        return sb.toString();
    }

    private String resolverConceptoDescripcion(Long conceptoId) {
        if (conceptoId == null) return null;
        return conceptoPlanillaRepository.findById(conceptoId)
                .map(ConceptoPlanilla::getNombre)
                .orElse(null);
    }

    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
