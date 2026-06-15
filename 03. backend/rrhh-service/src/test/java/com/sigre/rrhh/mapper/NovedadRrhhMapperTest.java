package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.NovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhResponse;
import com.sigre.rrhh.entity.NovedadRrhh;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("NovedadRrhhMapper — Pruebas Unitarias")
class NovedadRrhhMapperTest {

    private final NovedadRrhhMapper mapper = Mappers.getMapper(NovedadRrhhMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        NovedadRrhh entity = RrhhTestFixtures.novedadRrhh(1L);
        NovedadRrhhResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTipoNovedadRrhhId()).isEqualTo(1L);
        assertThat(response.getCitt()).isEqualTo("CITT-001");
        assertThat(response.getFechaIni()).isEqualTo("2026-01-01");
        assertThat(response.getFechaFin()).isEqualTo("2026-01-15");
        assertThat(response.getDiasTeoricos()).isEqualTo(15);
        assertThat(response.getDiasReales()).isEqualTo(15);
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<NovedadRrhh> entities = List.of(
            RrhhTestFixtures.novedadRrhh(1L),
            RrhhTestFixtures.novedadRrhh(2L)
        );

        List<NovedadRrhhResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando campos de auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        NovedadRrhhCreateRequest request = RrhhTestFixtures.novedadRrhhCreateRequest();

        NovedadRrhh entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getTipoNovedadRrhhId()).isEqualTo(1L);
        assertThat(entity.getFechaIni()).isEqualTo("2026-02-01");
        assertThat(entity.getFechaFin()).isEqualTo("2026-02-15");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar campos de auditoría")
    void updateEntity_actualizaEntidadExistente() {
        NovedadRrhhUpdateRequest request = RrhhTestFixtures.novedadRrhhUpdateRequest();
        NovedadRrhh entity = RrhhTestFixtures.novedadRrhh(1L);

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCitt()).isEqualTo("CITT-UPD");
        assertThat(entity.getDiasReales()).isEqualTo(10);
        assertThat(entity.getCreatedBy()).isNotNull();
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierte() {
        Instant instant = Instant.parse("2026-06-01T10:00:00Z");
        OffsetDateTime result = mapper.instantToOffsetDateTime(instant);

        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(ZoneOffset.UTC);
    }

    @Test
    @DisplayName("instantToOffsetDateTime() con null -> retorna null")
    void instantToOffsetDateTime_conNull_retornaNull() {
        OffsetDateTime result = mapper.instantToOffsetDateTime(null);
        assertThat(result).isNull();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        NovedadRrhhResponse response = mapper.toResponse(null);
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        List<NovedadRrhhResponse> responses = mapper.toResponseList(null);
        assertThat(responses).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        NovedadRrhh entity = mapper.toEntity(null);
        assertThat(entity).isNull();
    }
}
