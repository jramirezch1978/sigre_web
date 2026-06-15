package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.EstadoCivilCreateRequest;
import com.sigre.rrhh.dto.request.EstadoCivilUpdateRequest;
import com.sigre.rrhh.dto.response.EstadoCivilResponse;
import com.sigre.rrhh.entity.EstadoCivil;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("EstadoCivilMapper — Pruebas Unitarias")
class EstadoCivilMapperTest {

    private final EstadoCivilMapper mapper = Mappers.getMapper(EstadoCivilMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        EstadoCivil entity = RrhhTestFixtures.estadoCivil(1L, "S");

        EstadoCivilResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("S");
        assertThat(response.getNombre()).isEqualTo("Estado S");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<EstadoCivil> entities = List.of(
                RrhhTestFixtures.estadoCivil(1L, "S"),
                RrhhTestFixtures.estadoCivil(2L, "C")
        );

        List<EstadoCivilResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("S");
        assertThat(responses.get(1).getCodigo()).isEqualTo("C");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        EstadoCivilCreateRequest request = RrhhTestFixtures.estadoCivilCreateRequest("S", "Soltero");

        EstadoCivil entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("S");
        assertThat(entity.getNombre()).isEqualTo("Soltero");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        EstadoCivilUpdateRequest request = RrhhTestFixtures.estadoCivilUpdateRequest("Casado");
        EstadoCivil entity = RrhhTestFixtures.estadoCivil(1L, "S");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("S");
        assertThat(entity.getNombre()).isEqualTo("Casado");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con null -> retorna null")
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toEntity() con null -> retorna null")
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }
}
