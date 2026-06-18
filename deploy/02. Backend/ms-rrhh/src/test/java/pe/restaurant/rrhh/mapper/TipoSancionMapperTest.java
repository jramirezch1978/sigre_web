package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.TipoSancionCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSancionUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSancionResponse;
import pe.restaurant.rrhh.entity.TipoSancion;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoSancionMapper — Pruebas Unitarias")
class TipoSancionMapperTest {

    private final TipoSancionMapper mapper = Mappers.getMapper(TipoSancionMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");

        TipoSancionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("LEVE");
        assertThat(response.getNombre()).isEqualTo("Sanción LEVE");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoSancion> entities = List.of(
                RrhhTestFixtures.tipoSancion(1L, "LEVE"),
                RrhhTestFixtures.tipoSancion(2L, "GRAVE")
        );

        List<TipoSancionResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("LEVE");
        assertThat(responses.get(1).getCodigo()).isEqualTo("GRAVE");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoSancionCreateRequest request = RrhhTestFixtures.tipoSancionCreateRequest("LEVE", "Leve");

        TipoSancion entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("LEVE");
        assertThat(entity.getNombre()).isEqualTo("Leve");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoSancionUpdateRequest request = RrhhTestFixtures.tipoSancionUpdateRequest("Grave");
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("LEVE");
        assertThat(entity.getNombre()).isEqualTo("Grave");
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
