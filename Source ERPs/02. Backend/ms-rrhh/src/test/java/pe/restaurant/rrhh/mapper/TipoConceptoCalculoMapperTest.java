package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.TipoConceptoCalculoCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoConceptoCalculoUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoConceptoCalculoResponse;
import pe.restaurant.rrhh.entity.TipoConceptoCalculo;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoConceptoCalculoMapper — Pruebas Unitarias")
class TipoConceptoCalculoMapperTest {

    private final TipoConceptoCalculoMapper mapper = Mappers.getMapper(TipoConceptoCalculoMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoConceptoCalculo entity = RrhhTestFixtures.tipoConceptoCalculo(1L, "TCC");

        TipoConceptoCalculoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("TCC");
        assertThat(response.getNombre()).isEqualTo("TipoConceptoCalculo TCC");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoConceptoCalculo> entities = List.of(
                RrhhTestFixtures.tipoConceptoCalculo(1L, "TCC"),
                RrhhTestFixtures.tipoConceptoCalculo(2L, "TCP")
        );

        List<TipoConceptoCalculoResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("TCC");
        assertThat(responses.get(1).getCodigo()).isEqualTo("TCP");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoConceptoCalculoCreateRequest request = RrhhTestFixtures.tipoConceptoCalculoCreateRequest("TCC", "Tipo Concepto Calculo");

        TipoConceptoCalculo entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("TCC");
        assertThat(entity.getNombre()).isEqualTo("Tipo Concepto Calculo");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoConceptoCalculoUpdateRequest request = RrhhTestFixtures.tipoConceptoCalculoUpdateRequest("Tipo Actualizado");
        TipoConceptoCalculo entity = RrhhTestFixtures.tipoConceptoCalculo(1L, "TCC");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("TCC");
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