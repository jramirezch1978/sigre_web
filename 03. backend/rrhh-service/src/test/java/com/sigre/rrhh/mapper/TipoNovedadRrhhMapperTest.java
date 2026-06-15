package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;
import com.sigre.rrhh.entity.TipoNovedadRrhh;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoNovedadRrhhMapper — Pruebas Unitarias")
class TipoNovedadRrhhMapperTest {

    private final TipoNovedadRrhhMapper mapper = Mappers.getMapper(TipoNovedadRrhhMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoNovedadRrhh entity = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso");

        TipoNovedadRrhhResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("PER");
        assertThat(response.getNombre()).isEqualTo("Permiso");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoNovedadRrhh> entities = List.of(
            RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso"),
            RrhhTestFixtures.tipoNovedadRrhh(2L, "FAL", "Falta")
        );

        List<TipoNovedadRrhhResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("PER");
        assertThat(responses.get(1).getCodigo()).isEqualTo("FAL");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad")
    void toEntity_convierteDTORequestAEntidad() {
        TipoNovedadRrhhCreateRequest request = RrhhTestFixtures.tipoNovedadRrhhCreateRequest("PER", "Permiso");

        TipoNovedadRrhh entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("PER");
        assertThat(entity.getNombre()).isEqualTo("Permiso");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar código")
    void updateEntity_actualizaEntidadExistente() {
        TipoNovedadRrhhUpdateRequest request = RrhhTestFixtures.tipoNovedadRrhhUpdateRequest("Permiso Personal", "1");
        TipoNovedadRrhh entity = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("PER");
        assertThat(entity.getNombre()).isEqualTo("Permiso Personal");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("map() -> convierte Instant a OffsetDateTime")
    void map_convierteInstantAOffsetDateTime() {
        Instant instant = Instant.parse("2026-06-01T10:00:00Z");

        OffsetDateTime result = mapper.map(instant);

        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(ZoneOffset.UTC);
    }

    @Test
    @DisplayName("map() con null -> retorna null")
    void map_conNull_retornaNull() {
        OffsetDateTime result = mapper.map(null);

        assertThat(result).isNull();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        TipoNovedadRrhhResponse response = mapper.toResponse(null);

        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        List<TipoNovedadRrhhResponse> responses = mapper.toResponseList(null);

        assertThat(responses).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        TipoNovedadRrhh entity = mapper.toEntity(null);

        assertThat(entity).isNull();
    }
}
