package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.RegimenLaboralCreateRequest;
import com.sigre.rrhh.dto.request.RegimenLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.RegimenLaboralResponse;
import com.sigre.rrhh.entity.RegimenLaboral;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("RegimenLaboralMapper — Pruebas Unitarias")
class RegimenLaboralMapperTest {

    private final RegimenLaboralMapper mapper = Mappers.getMapper(RegimenLaboralMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");

        RegimenLaboralResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("RL");
        assertThat(response.getNombre()).isEqualTo("Regimen RL");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<RegimenLaboral> entities = List.of(
                RrhhTestFixtures.regimenLaboral(1L, "RL"),
                RrhhTestFixtures.regimenLaboral(2L, "RC")
        );

        List<RegimenLaboralResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("RL");
        assertThat(responses.get(1).getCodigo()).isEqualTo("RC");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        RegimenLaboralCreateRequest request = RrhhTestFixtures.regimenLaboralCreateRequest("RL", "Regimen Laboral");

        RegimenLaboral entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("RL");
        assertThat(entity.getNombre()).isEqualTo("Regimen Laboral");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        RegimenLaboralUpdateRequest request = RrhhTestFixtures.regimenLaboralUpdateRequest("Regimen Actualizado");
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("RL");
        assertThat(entity.getNombre()).isEqualTo("Regimen Actualizado");
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