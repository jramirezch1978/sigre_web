package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.TipoContratoCreateRequest;
import com.sigre.rrhh.dto.request.TipoContratoUpdateRequest;
import com.sigre.rrhh.dto.response.TipoContratoResponse;
import com.sigre.rrhh.entity.TipoContrato;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoContratoMapper — Pruebas Unitarias")
class TipoContratoMapperTest {

    private final TipoContratoMapper mapper = Mappers.getMapper(TipoContratoMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoContrato entity = RrhhTestFixtures.tipoContrato(1L, "TC");

        TipoContratoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("TC");
        assertThat(response.getNombre()).isEqualTo("TipoContrato TC");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoContrato> entities = List.of(
                RrhhTestFixtures.tipoContrato(1L, "TC"),
                RrhhTestFixtures.tipoContrato(2L, "TP")
        );

        List<TipoContratoResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("TC");
        assertThat(responses.get(1).getCodigo()).isEqualTo("TP");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoContratoCreateRequest request = RrhhTestFixtures.tipoContratoCreateRequest("TC", "Tipo Contrato");

        TipoContrato entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("TC");
        assertThat(entity.getNombre()).isEqualTo("Tipo Contrato");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoContratoUpdateRequest request = RrhhTestFixtures.tipoContratoUpdateRequest("Tipo Actualizado");
        TipoContrato entity = RrhhTestFixtures.tipoContrato(1L, "TC");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("TC");
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