package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.PeriodoCtsCreateRequest;
import com.sigre.rrhh.dto.request.PeriodoCtsUpdateRequest;
import com.sigre.rrhh.dto.response.PeriodoCtsResponse;
import com.sigre.rrhh.entity.PeriodoCts;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("PeriodoCtsMapper — Pruebas Unitarias")
class PeriodoCtsMapperTest {

    private final PeriodoCtsMapper mapper = Mappers.getMapper(PeriodoCtsMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        PeriodoCts entity = RrhhTestFixtures.periodoCts(1L);

        PeriodoCtsResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("PC-1");
        assertThat(response.getNombre()).isEqualTo("Período CTS 1");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<PeriodoCts> entities = List.of(
                RrhhTestFixtures.periodoCts(1L),
                RrhhTestFixtures.periodoCts(2L)
        );

        List<PeriodoCtsResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("PC-1");
        assertThat(responses.get(1).getCodigo()).isEqualTo("PC-2");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        PeriodoCtsCreateRequest request = RrhhTestFixtures.periodoCtsCreateRequest("PC", "Período CTS");

        PeriodoCts entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("PC");
        assertThat(entity.getNombre()).isEqualTo("Período CTS");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        PeriodoCtsUpdateRequest request = RrhhTestFixtures.periodoCtsUpdateRequest("Período Actualizado");
        PeriodoCts entity = RrhhTestFixtures.periodoCts(1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("PC-1");
        assertThat(entity.getNombre()).isEqualTo("Período Actualizado");
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