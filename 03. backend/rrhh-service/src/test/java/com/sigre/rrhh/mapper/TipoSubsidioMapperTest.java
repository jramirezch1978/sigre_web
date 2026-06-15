package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.TipoSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.TipoSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSubsidioResponse;
import com.sigre.rrhh.entity.TipoSubsidio;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoSubsidioMapper — Pruebas Unitarias")
class TipoSubsidioMapperTest {

    private final TipoSubsidioMapper mapper = Mappers.getMapper(TipoSubsidioMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoSubsidio entity = RrhhTestFixtures.tipoSubsidio(1L, "SUB");

        TipoSubsidioResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("SUB");
        assertThat(response.getNombre()).isEqualTo("TipoSubsidio SUB");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoSubsidio> entities = List.of(
                RrhhTestFixtures.tipoSubsidio(1L, "SUB1"),
                RrhhTestFixtures.tipoSubsidio(2L, "SUB2")
        );

        List<TipoSubsidioResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("SUB1");
        assertThat(responses.get(1).getCodigo()).isEqualTo("SUB2");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoSubsidioCreateRequest request = RrhhTestFixtures.tipoSubsidioCreateRequest("SUB", "Subsidio");

        TipoSubsidio entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("SUB");
        assertThat(entity.getNombre()).isEqualTo("Subsidio");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoSubsidioUpdateRequest request = RrhhTestFixtures.tipoSubsidioUpdateRequest("Subsidio Actualizado");
        TipoSubsidio entity = RrhhTestFixtures.tipoSubsidio(1L, "SUB");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("SUB");
        assertThat(entity.getNombre()).isEqualTo("Subsidio Actualizado");
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
