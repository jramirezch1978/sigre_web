package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.dto.request.SancionAmonestacionCreateRequest;
import com.sigre.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import com.sigre.rrhh.dto.response.SancionAmonestacionResponse;
import com.sigre.rrhh.entity.SancionAmonestacion;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("SancionAmonestacionMapper — Pruebas Unitarias")
class SancionAmonestacionMapperTest {

    private final SancionAmonestacionMapper mapper = Mappers.getMapper(SancionAmonestacionMapper.class);

    @Test
    @DisplayName("toResponse() convierte entidad a DTO")
    void toResponse_convierteEntidadADTO() {
        SancionAmonestacion entity = new SancionAmonestacion();
        entity.setId(1L);
        entity.setTrabajadorId(100L);
        entity.setTipoSancionId(10L);
        entity.setFecha(LocalDate.of(2026, 1, 15));
        entity.setMotivo("Amonestación de prueba");
        entity.setDocumento("DOC-001");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        SancionAmonestacionResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(100L);
        assertThat(response.getMotivo()).isEqualTo("Amonestación de prueba");
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse((SancionAmonestacion) null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con createdBy y updatedBy no nulos -> mapea correctamente")
    void toResponse_conCreatedByYUpdatedByNoNulos_mapeaCorrectamente() {
        SancionAmonestacion entity = new SancionAmonestacion();
        entity.setId(1L);
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(2L);
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        SancionAmonestacionResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getCreatedBy()).isEqualTo("1");
        assertThat(response.getUpdatedBy()).isEqualTo("2");
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() convierte lista de entidades a DTOs")
    void toResponseList_convierteListaADTOs() {
        SancionAmonestacion e1 = new SancionAmonestacion();
        e1.setId(1L);
        SancionAmonestacion e2 = new SancionAmonestacion();
        e2.setId(2L);

        List<SancionAmonestacionResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toEntity() convierte request a entidad")
    void toEntity_convierteRequestAEntidad() {
        SancionAmonestacionCreateRequest request = new SancionAmonestacionCreateRequest();
        request.setTrabajadorId(200L);
        request.setTipoSancionId(20L);
        request.setFecha(LocalDate.of(2026, 2, 1));
        request.setMotivo("Motivo de prueba");
        request.setDocumento("DOC-002");

        SancionAmonestacion entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(200L);
        assertThat(entity.getMotivo()).isEqualTo("Motivo de prueba");
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("updateEntity() con request null -> no lanza excepción")
    void updateEntity_conRequestNull_noLanzaExcepcion() {
        SancionAmonestacion entity = new SancionAmonestacion();
        entity.setMotivo("Original");
        mapper.updateEntity(entity, null);
        assertThat(entity.getMotivo()).isEqualTo("Original");
    }

    @Test
    @DisplayName("updateEntity() actualiza entidad con datos del request")
    void updateEntity_actualizaEntidad() {
        SancionAmonestacion entity = new SancionAmonestacion();
        entity.setMotivo("Original");
        entity.setFlagEstado("0");

        SancionAmonestacionUpdateRequest request = new SancionAmonestacionUpdateRequest();
        request.setMotivo("Actualizado");
        request.setDocumento("DOC-NEW");
        request.setFlagEstado("1");

        mapper.updateEntity(entity, request);

        assertThat(entity.getMotivo()).isEqualTo("Actualizado");
        assertThat(entity.getDocumento()).isEqualTo("DOC-NEW");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponse() con createdBy null -> no lanza excepción")
    void toResponse_conCreatedByNull_noLanzaExcepcion() {
        SancionAmonestacion entity = new SancionAmonestacion();
        entity.setId(1L);
        entity.setCreatedBy(null);
        entity.setUpdatedBy(null);
        entity.setFecCreacion(Instant.now());

        SancionAmonestacionResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getCreatedBy()).isNull();
        assertThat(response.getUpdatedBy()).isNull();
    }
}
