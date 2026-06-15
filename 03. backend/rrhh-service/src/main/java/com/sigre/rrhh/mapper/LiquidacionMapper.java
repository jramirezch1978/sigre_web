package com.sigre.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.rrhh.dto.response.LiquidacionResponse;
import com.sigre.rrhh.entity.Liquidacion;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Mapper manual para convertir entidades {@link Liquidacion} a DTOs de respuesta.
 * Resuelve el nombre completo del trabajador consultando al repositorio.
 */
@Component
@RequiredArgsConstructor
public class LiquidacionMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository trabajadorRepository;

    /**
     * Convierte una {@link Liquidacion} a su DTO de respuesta, resolviendo
     * el nombre completo del trabajador (nombres + apellidos).
     *
     * @param l liquidación a convertir
     * @return DTO de respuesta
     */
    public LiquidacionResponse toResponse(Liquidacion l) {
        return LiquidacionResponse.builder()
                .id(l.getId())
                .trabajadorId(l.getTrabajadorId())
                .trabajadorNombres(resolverNombres(l.getTrabajadorId()))
                .fechaCese(formatDate(l.getFechaCese()))
                .ctsPendiente(l.getCtsPendiente())
                .vacacionesTruncas(l.getVacacionesTruncas())
                .gratificacionTrunca(l.getGratificacionTrunca())
                .indemnizacion(l.getIndemnizacion())
                .totalBeneficios(l.getTotalBeneficios())
                .totalDescuentos(l.getTotalDescuentos())
                .netoPagar(l.getNetoPagar())
                .flagEstado(l.getFlagEstado())
                .createdBy(l.getCreatedBy())
                .fecCreacion(formatTimestamp(l.getFecCreacion()))
                .updatedBy(l.getUpdatedBy())
                .fecModificacion(formatTimestamp(l.getFecModificacion()))
                .build();
    }

    // ── helpers ──────────────────────────────────────────────────

    /** Resuelve el nombre completo del trabajador; retorna {@code null} si no existe. */
    private String resolverNombres(Long trabajadorId) {
        if (trabajadorId == null) return null;
        return trabajadorRepository.findById(trabajadorId)
                .map(this::nombreCompleto)
                .orElse(null);
    }

    /** Concatena nombres y apellidos del trabajador omitiendo los nulos. */
    private String nombreCompleto(Trabajador t) {
        StringBuilder sb = new StringBuilder();
        if (t.getNombres() != null) sb.append(t.getNombres());
        if (t.getApellidoPaterno() != null) sb.append(" ").append(t.getApellidoPaterno());
        if (t.getApellidoMaterno() != null) sb.append(" ").append(t.getApellidoMaterno());
        return sb.toString().trim();
    }

    /** Formatea {@link LocalDate} a {@code yyyy-MM-dd}; retorna {@code null} si es nulo. */
    private String formatDate(LocalDate d) {
        return d != null ? d.toString() : null;
    }

    /** Formatea {@link Instant} a {@code dd/MM/yyyy HH:mm:ss} en zona Lima; retorna {@code null} si es nulo. */
    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
