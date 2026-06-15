package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.TipoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.TipoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoPlanillaResponse;
import com.sigre.rrhh.entity.TipoPlanilla;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoPlanillaMapper — Pruebas Unitarias")
class TipoPlanillaMapperTest {

    private final TipoPlanillaMapper mapper = Mappers.getMapper(TipoPlanillaMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoPlanilla entity = RrhhTestFixtures.tipoPlanilla(1L, "TP");

        TipoPlanillaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("TP");
        assertThat(response.getNombre()).isEqualTo("TipoPlanilla TP");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoPlanilla> entities = List.of(
                RrhhTestFixtures.tipoPlanilla(1L, "TP"),
                RrhhTestFixtures.tipoPlanilla(2L, "TS")
        );

        List<TipoPlanillaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("TP");
        assertThat(responses.get(1).getCodigo()).isEqualTo("TS");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoPlanillaCreateRequest request = RrhhTestFixtures.tipoPlanillaCreateRequest("TP", "Tipo Planilla");

        TipoPlanilla entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("TP");
        assertThat(entity.getNombre()).isEqualTo("Tipo Planilla");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoPlanillaUpdateRequest request = RrhhTestFixtures.tipoPlanillaUpdateRequest("Tipo Actualizado");
        TipoPlanilla entity = RrhhTestFixtures.tipoPlanilla(1L, "TP");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("TP");
        assertThat(entity.getNombre()).isEqualTo("Tipo Actualizado");
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