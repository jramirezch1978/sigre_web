package pe.restaurant.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.rrhh.dto.response.AsistenciaResponse;
import pe.restaurant.rrhh.dto.response.RefResponse;
import pe.restaurant.rrhh.entity.Asistencia;
import pe.restaurant.rrhh.repository.AsistenciaRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Mapper manual para convertir la entidad {@link Asistencia}
 * a su DTO de respuesta. Resuelve el nombre del trabajador
 * consultando directamente al repositorio.
 */
@Component
@RequiredArgsConstructor
public class AsistenciaMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    private static final DateTimeFormatter FMT_TIME = DateTimeFormatter.ofPattern("HH:mm:ss");

    private final AsistenciaRepository repository;

    /**
     * Convierte una entidad {@link Asistencia} a su DTO de respuesta,
     * resolviendo el nombre completo del trabajador.
     */
    public AsistenciaResponse toResponse(Asistencia a) {
        if (a == null) return null;
        return AsistenciaResponse.builder()
                .id(a.getId())
                .trabajadorId(a.getTrabajadorId())
                .trabajadorNombres(repository.findTrabajadorNombresById(a.getTrabajadorId()))
                .fecha(formatDate(a.getFecha()))
                .horaEntrada(formatTime(a.getHoraEntrada()))
                .horaSalida(formatTime(a.getHoraSalida()))
                .tipoMovAsistencia(buildRef(a.getTipoMovAsistenciaId()))
                .horasTrabajadas(a.getHorasTrabajadas())
                .horasExtra(a.getHorasExtra())
                .flagEstado(a.getFlagEstado())
                .createdBy(a.getCreatedBy())
                .fecCreacion(formatTimestamp(a.getFecCreacion()))
                .updatedBy(a.getUpdatedBy())
                .fecModificacion(formatTimestamp(a.getFecModificacion()))
                .build();
    }

    /** Construye un {@link RefResponse} resolviendo el nombre y código del tipo de movimiento. */
    private RefResponse buildRef(Long id) {
        if (id == null) return null;
        return RefResponse.builder().id(id)
                .codigo(repository.findTipoMovAsistenciaCodigoById(id))
                .nombre(repository.findTipoMovAsistenciaNombreById(id))
                .build();
    }

    private String formatDate(LocalDate d) {
        return d != null ? d.toString() : null;
    }

    private String formatTime(LocalTime t) {
        return t != null ? t.format(FMT_TIME) : null;
    }

    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
