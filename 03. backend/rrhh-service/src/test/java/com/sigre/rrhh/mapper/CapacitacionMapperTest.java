package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.dto.request.CapacitacionCreateRequest;
import com.sigre.rrhh.dto.request.CapacitacionUpdateRequest;
import com.sigre.rrhh.dto.response.CapacitacionResponse;
import com.sigre.rrhh.entity.Capacitacion;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CapacitacionMapper — Pruebas Unitarias")
class CapacitacionMapperTest {

    private final CapacitacionMapper mapper = Mappers.getMapper(CapacitacionMapper.class);

    @Test
    @DisplayName("toResponse() convierte entidad a DTO")
    void toResponse_convierteEntidadADTO() {
        Capacitacion entity = new Capacitacion();
        entity.setId(1L);
        entity.setNombre("Capacitación Test");
        entity.setDescripcion("Descripción");
        entity.setFechaInicio(LocalDate.of(2026, 2, 1));
        entity.setFechaFin(LocalDate.of(2026, 2, 5));
        entity.setHoras(20);
        entity.setProveedor("Proveedor");
        entity.setCosto(new BigDecimal("500"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        CapacitacionResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Capacitación Test");
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse((Capacitacion) null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() convierte lista de entidades a DTOs")
    void toResponseList_convierteListaADTOs() {
        Capacitacion e1 = new Capacitacion();
        e1.setId(1L);
        Capacitacion e2 = new Capacitacion();
        e2.setId(2L);

        List<CapacitacionResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toEntity() convierte request a entidad")
    void toEntity_convierteRequestAEntidad() {
        CapacitacionCreateRequest request = new CapacitacionCreateRequest();
        request.setNombre("Capacitación Nueva");
        request.setDescripcion("Descripción");
        request.setFechaInicio(LocalDate.of(2026, 3, 1));
        request.setFechaFin(LocalDate.of(2026, 3, 5));
        request.setHoras(20);
        request.setProveedor("Proveedor");
        request.setCosto(new BigDecimal("1000"));

        Capacitacion entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull();
        assertThat(entity.getNombre()).isEqualTo("Capacitación Nueva");
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("updateEntity() con request null -> no lanza excepción")
    void updateEntity_conRequestNull_noLanzaExcepcion() {
        Capacitacion entity = new Capacitacion();
        entity.setNombre("Original");
        mapper.updateEntity(entity, null);
        assertThat(entity.getNombre()).isEqualTo("Original");
    }

    @Test
    @DisplayName("updateEntity() actualiza entidad con datos del request")
    void updateEntity_actualizaEntidad() {
        Capacitacion entity = new Capacitacion();
        entity.setNombre("Original");
        entity.setFlagEstado("0");

        CapacitacionUpdateRequest request = new CapacitacionUpdateRequest();
        request.setNombre("Actualizado");
        request.setHoras(30);
        request.setFlagEstado("1");

        mapper.updateEntity(entity, request);

        assertThat(entity.getNombre()).isEqualTo("Actualizado");
        assertThat(entity.getHoras()).isEqualTo(30);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }
}
