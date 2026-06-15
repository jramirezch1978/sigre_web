package com.sigre.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.rrhh.dto.response.QuintaCategoriaResponse;
import com.sigre.rrhh.entity.QuintaCategoria;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Mapper manual para convertir entidades {@link QuintaCategoria} a DTOs de respuesta.
 * Resuelve el nombre del trabajador consultando el repositorio.
 */
@Component
@RequiredArgsConstructor
public class QuintaCategoriaMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository trabajadorRepo;

    /**
     * Convierte una {@link QuintaCategoria} a su DTO de respuesta,
     * resolviendo el nombre completo del trabajador.
     *
     * @param q entidad a convertir
     * @return DTO de respuesta
     */
    public QuintaCategoriaResponse toResponse(QuintaCategoria q) {
        return QuintaCategoriaResponse.builder()
                .id(q.getId())
                .trabajadorId(q.getTrabajadorId())
                .trabajadorNombres(resolveTrabajadorNombres(q.getTrabajadorId()))
                .anio(q.getAnio())
                .mes(q.getMes())
                .rentaBrutaAcumulada(q.getRentaBrutaAcumulada())
                .rentaBrutaProyectada(q.getRentaBrutaProyectada())
                .deduccion7uit(q.getDeduccion7uit())
                .rentaNeta(q.getRentaNeta())
                .impuestoAnualProyectado(q.getImpuestoAnualProyectado())
                .retencionMensual(q.getRetencionMensual())
                .retencionAcumulada(q.getRetencionAcumulada())
                .createdBy(q.getCreatedBy())
                .fecCreacion(formatTimestamp(q.getFecCreacion()))
                .updatedBy(q.getUpdatedBy())
                .fecModificacion(formatTimestamp(q.getFecModificacion()))
                .build();
    }

    private String resolveTrabajadorNombres(Long trabajadorId) {
        if (trabajadorId == null) return null;
        return trabajadorRepo.findById(trabajadorId)
                .map(t -> {
                    String full = t.getNombres();
                    if (t.getApellidoPaterno() != null) full = t.getApellidoPaterno() + " " + full;
                    if (t.getApellidoMaterno() != null) full = full + " " + t.getApellidoMaterno();
                    return full.trim();
                })
                .orElse(null);
    }

    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
