package com.sigre.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.rrhh.dto.response.VacacionResponse;
import com.sigre.rrhh.entity.Vacacion;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

@Component
@RequiredArgsConstructor
public class VacacionMapper {

    private static final DateTimeFormatter FMT_DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public VacacionResponse toResponse(Vacacion v) {
        if (v == null) return null;
        VacacionResponse r = new VacacionResponse();
        r.setId(v.getId());
        r.setTrabajadorId(v.getTrabajadorId());
        r.setPeriodoAnio(v.getPeriodoAnio());
        r.setDiasDerecho(v.getDiasDerecho());
        r.setDiasGozados(v.getDiasGozados());
        r.setDiasPendientes(v.getDiasPendientes());
        r.setFechaInicio(formatDate(v.getFechaInicio()));
        r.setFechaFin(formatDate(v.getFechaFin()));
        r.setFlagEstado(v.getFlagEstado());
        r.setCreatedBy(v.getCreatedBy());
        r.setFecCreacion(toOffsetDateTime(v.getFecCreacion()));
        r.setUpdatedBy(v.getUpdatedBy());
        r.setFecModificacion(toOffsetDateTime(v.getFecModificacion()));
        return r;
    }

    private String formatDate(LocalDate d) {
        return d != null ? d.format(FMT_DATE) : null;
    }

    private java.time.OffsetDateTime toOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
