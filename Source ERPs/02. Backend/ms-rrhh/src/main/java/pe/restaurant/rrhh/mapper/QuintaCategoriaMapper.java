package pe.restaurant.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.rrhh.dto.response.QuintaCategoriaResponse;
import pe.restaurant.rrhh.entity.QuintaCategoria;
import pe.restaurant.rrhh.repository.TipoPlanillaRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Mapper manual para {@link QuintaCategoria}.
 */
@Component
@RequiredArgsConstructor
public class QuintaCategoriaMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository trabajadorRepo;
    private final TipoPlanillaRepository tipoPlanillaRepo;

    public QuintaCategoriaResponse toResponse(QuintaCategoria q) {
        return QuintaCategoriaResponse.builder()
                .id(q.getId())
                .trabajadorId(q.getTrabajadorId())
                .trabajadorNombres(resolveTrabajadorNombres(q.getTrabajadorId()))
                .fecProceso(q.getFecProceso() != null ? q.getFecProceso().format(FMT_DATE) : null)
                .tipoPlanillaId(q.getTipoPlanillaId())
                .tipoPlanillaCodigo(resolveTipoPlanillaCodigo(q.getTipoPlanillaId()))
                .remProyectable(q.getRemProyectable())
                .remImprecisa(q.getRemImprecisa())
                .remRetencion(q.getRemRetencion())
                .remGratif(q.getRemGratif())
                .sueldo(q.getSueldo())
                .gratifProyect(q.getGratifProyect())
                .remExterna(q.getRemExterna())
                .nroDias(q.getNroDias())
                .flagAutomatico(q.getFlagAutomatico())
                .flagReplicacion(q.getFlagReplicacion())
                .createdBy(q.getCreatedBy())
                .fecCreacion(formatTimestamp(q.getFecCreacion()))
                .updatedBy(q.getUpdatedBy())
                .fecModificacion(formatTimestamp(q.getFecModificacion()))
                .build();
    }

    private String resolveTrabajadorNombres(Long trabajadorId) {
        if (trabajadorId == null) {
            return null;
        }
        return trabajadorRepo.findById(trabajadorId)
                .map(t -> {
                    String full = t.getNombres();
                    if (t.getApellidoPaterno() != null) {
                        full = t.getApellidoPaterno() + " " + full;
                    }
                    if (t.getApellidoMaterno() != null) {
                        full = full + " " + t.getApellidoMaterno();
                    }
                    return full.trim();
                })
                .orElse(null);
    }

    private String resolveTipoPlanillaCodigo(Long tipoPlanillaId) {
        if (tipoPlanillaId == null) {
            return null;
        }
        return tipoPlanillaRepo.findById(tipoPlanillaId)
                .map(tp -> tp.getCodigo())
                .orElse(null);
    }

    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
