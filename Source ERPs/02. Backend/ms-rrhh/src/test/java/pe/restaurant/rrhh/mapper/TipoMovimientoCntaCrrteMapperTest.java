package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.TipoMovimientoCntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoMovimientoCntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoMovimientoCntaCrrteResponse;
import pe.restaurant.rrhh.entity.TipoMovimientoCntaCrrte;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoMovimientoCntaCrrteMapper — Pruebas Unitarias")
class TipoMovimientoCntaCrrteMapperTest {

    private final TipoMovimientoCntaCrrteMapper mapper = Mappers.getMapper(TipoMovimientoCntaCrrteMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoMovimientoCntaCrrte entity = RrhhTestFixtures.tipoMovimientoCntaCrrte(1L, "TM");

        TipoMovimientoCntaCrrteResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("TM");
        assertThat(response.getNombre()).isEqualTo("TipoMovimientoCntaCrrte TM");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoMovimientoCntaCrrte> entities = List.of(
                RrhhTestFixtures.tipoMovimientoCntaCrrte(1L, "TM"),
                RrhhTestFixtures.tipoMovimientoCntaCrrte(2L, "TA")
        );

        List<TipoMovimientoCntaCrrteResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("TM");
        assertThat(responses.get(1).getCodigo()).isEqualTo("TA");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoMovimientoCntaCrrteCreateRequest request = RrhhTestFixtures.tipoMovimientoCntaCrrteCreateRequest("TM", "Tipo Movimiento");

        TipoMovimientoCntaCrrte entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("TM");
        assertThat(entity.getNombre()).isEqualTo("Tipo Movimiento");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoMovimientoCntaCrrteUpdateRequest request = RrhhTestFixtures.tipoMovimientoCntaCrrteUpdateRequest("Tipo Actualizado");
        TipoMovimientoCntaCrrte entity = RrhhTestFixtures.tipoMovimientoCntaCrrte(1L, "TM");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("TM");
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