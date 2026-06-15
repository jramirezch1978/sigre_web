package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSuspensionLaboralResponse;
import com.sigre.rrhh.entity.TipoSuspensionLaboral;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoSuspensionLaboralMapper — Pruebas Unitarias")
class TipoSuspensionLaboralMapperTest {

    private final TipoSuspensionLaboralMapper mapper = Mappers.getMapper(TipoSuspensionLaboralMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");

        TipoSuspensionLaboralResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("VAC");
        assertThat(response.getNombre()).isEqualTo("Tipo VAC");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getFlagTipoSusp()).isEqualTo("1");
        assertThat(response.getFlagCitt()).isEqualTo("0");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoSuspensionLaboral> entities = List.of(
                RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC"),
                RrhhTestFixtures.tipoSuspensionLaboral(2L, "ENF")
        );

        List<TipoSuspensionLaboralResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("VAC");
        assertThat(responses.get(1).getCodigo()).isEqualTo("ENF");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoSuspensionLaboralCreateRequest request = RrhhTestFixtures.tipoSuspensionLaboralCreateRequest("VAC", "Vacaciones");

        TipoSuspensionLaboral entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("VAC");
        assertThat(entity.getNombre()).isEqualTo("Vacaciones");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoSuspensionLaboralUpdateRequest request = RrhhTestFixtures.tipoSuspensionLaboralUpdateRequest("Vacaciones Actualizado");
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("VAC");
        assertThat(entity.getNombre()).isEqualTo("Vacaciones Actualizado");
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
