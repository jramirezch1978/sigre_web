package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.ProgramVacacionCreateRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionUpdateRequest;
import com.sigre.rrhh.dto.response.ProgramVacacionResponse;
import com.sigre.rrhh.entity.ProgramVacacion;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ProgramVacacionMapper — Pruebas Unitarias")
class ProgramVacacionMapperTest {

    private final ProgramVacacionMapper mapper = Mappers.getMapper(ProgramVacacionMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        ProgramVacacion entity = RrhhTestFixtures.programVacacion(1L);

        ProgramVacacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getAnio()).isEqualTo(2026);
        assertThat(response.getMes()).isEqualTo(3);
        assertThat(response.getDiasProgramados()).isEqualTo(15);
        assertThat(response.getObservacion()).isEqualTo("Vacaciones programadas");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<ProgramVacacion> entities = List.of(
                RrhhTestFixtures.programVacacion(1L),
                RrhhTestFixtures.programVacacion(2L)
        );

        List<ProgramVacacionResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toEntity() -> convierte CreateRequest a entidad ignorando auditoría")
    void toEntity_convierteCreateRequestAIgnorandoAuditoria() {
        ProgramVacacionCreateRequest request = RrhhTestFixtures.programVacacionCreateRequest();

        ProgramVacacion entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getAnio()).isEqualTo(2026);
        assertThat(entity.getMes()).isEqualTo(3);
        assertThat(entity.getDiasProgramados()).isEqualTo(15);
        assertThat(entity.getObservacion()).isEqualTo("Vacaciones nuevas");
        assertThat(entity.getFlagEstado()).isEqualTo("1"); // default from BaseEntity
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente ignorando campos clave")
    void updateEntity_actualizaEntidadExistente() {
        ProgramVacacion entity = RrhhTestFixtures.programVacacion(1L);
        ProgramVacacionUpdateRequest request = RrhhTestFixtures.programVacacionUpdateRequest();

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getAnio()).isEqualTo(2026);
        assertThat(entity.getMes()).isEqualTo(3);
        assertThat(entity.getDiasProgramados()).isEqualTo(10);
        assertThat(entity.getObservacion()).isEqualTo("Actualizado");
    }

    @Test
    @DisplayName("toResponse() -> mapea createdBy como String")
    void toResponse_mapeaCreatedByComoString() {
        ProgramVacacion entity = RrhhTestFixtures.programVacacion(1L);

        ProgramVacacionResponse response = mapper.toResponse(entity);

        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierteInstantAOffsetDateTime() {
        java.time.Instant instant = java.time.Instant.parse("2023-01-01T12:00:00Z");

        java.time.OffsetDateTime result = mapper.instantToOffsetDateTime(instant);

        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(java.time.ZoneOffset.UTC);
    }

    @Test
    @DisplayName("instantToOffsetDateTime() con null -> retorna null")
    void instantToOffsetDateTime_conNull_retornaNull() {
        assertThat(mapper.instantToOffsetDateTime(null)).isNull();
    }
}
