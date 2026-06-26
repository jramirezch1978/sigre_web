package pe.restaurant.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.rrhh.dto.response.GanDescVariableResponse;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;
import pe.restaurant.rrhh.entity.GanDescVariable;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.repository.GanDescVariableRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Mapper manual para convertir la entidad {@link GanDescVariable} a su DTO de respuesta.
 * Resuelve los nombres de trabajador y concepto consultando sus respectivos repositorios.
 */
@Component
@RequiredArgsConstructor
public class GanDescVariableMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository trabajadorRepository;
    private final ConceptoPlanillaRepository conceptoPlanillaRepository;
    private final GanDescVariableRepository ganDescVariableRepository;

    /**
     * Convierte una entidad {@link GanDescVariable} a {@link GanDescVariableResponse},
     * resolviendo trabajadorNombres y conceptoNombre desde sus tablas de referencia.
     *
     * @param entity entidad a convertir
     * @return DTO de respuesta con campos derivados resueltos
     */
    public GanDescVariableResponse toResponse(GanDescVariable entity) {
        return GanDescVariableResponse.builder()
                .id(entity.getId())
                .trabajadorId(entity.getTrabajadorId())
                .trabajadorNombres(resolverTrabajadorNombres(entity.getTrabajadorId()))
                .fecMovim(formatDate(entity.getFecMovim()))
                .conceptoId(entity.getConceptoId())
                .conceptoNombre(resolverConceptoNombre(entity.getConceptoId()))
                .nroDoc(entity.getNroDoc())
                .impVar(entity.getImpVar())
                .centrosCostoId(entity.getCentrosCostoId())
                .cantLabor(entity.getCantLabor())
                .nroDias(entity.getNroDias())
                .nroHoras(entity.getNroHoras())
                .nroCuotas(entity.getNroCuotas())
                .tipoPlanillaId(entity.getTipoPlanillaId())
                .tipoPlanillaNombre(resolverTipoPlanillaNombre(entity.getTipoPlanillaId()))
                .createdBy(entity.getCreatedBy())
                .fecCreacion(formatTimestamp(entity.getFecCreacion()))
                .updatedBy(entity.getUpdatedBy())
                .fecModificacion(formatTimestamp(entity.getFecModificacion()))
                .build();
    }

    private String resolverTrabajadorNombres(Long trabajadorId) {
        if (trabajadorId == null) return null;
        return trabajadorRepository.findById(trabajadorId)
                .map(t -> buildNombreCompleto(t))
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

    private String resolverConceptoNombre(Long conceptoId) {
        if (conceptoId == null) return null;
        return conceptoPlanillaRepository.findById(conceptoId)
                .map(ConceptoPlanilla::getNombre)
                .orElse(null);
    }

    private String resolverTipoPlanillaNombre(Long tipoPlanillaId) {
        if (tipoPlanillaId == null) return null;
        return ganDescVariableRepository.findTipoPlanillaNombreById(tipoPlanillaId);
    }

    private String formatDate(LocalDate d) {
        return d != null ? d.toString() : null;
    }

    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
