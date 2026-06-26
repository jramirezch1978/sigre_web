package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoMovAsistenciaResponse;
import pe.restaurant.rrhh.entity.TipoMovAsistencia;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoMovAsistenciaMapper — Pruebas Unitarias")
class TipoMovAsistenciaMapperTest {

    private final TipoMovAsistenciaMapper mapper = Mappers.getMapper(TipoMovAsistenciaMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        TipoMovAsistencia entity = RrhhTestFixtures.tipoMovAsistencia(1L, "I");

        TipoMovAsistenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("I");
        assertThat(response.getNombre()).isEqualTo("TipoMovAsistencia I");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<TipoMovAsistencia> entities = List.of(
                RrhhTestFixtures.tipoMovAsistencia(1L, "I"),
                RrhhTestFixtures.tipoMovAsistencia(2L, "S")
        );

        List<TipoMovAsistenciaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("I");
        assertThat(responses.get(1).getCodigo()).isEqualTo("S");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        TipoMovAsistenciaCreateRequest request = RrhhTestFixtures.tipoMovAsistenciaCreateRequest("I", "Ingreso");

        TipoMovAsistencia entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("I");
        assertThat(entity.getNombre()).isEqualTo("Ingreso");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        TipoMovAsistenciaUpdateRequest request = RrhhTestFixtures.tipoMovAsistenciaUpdateRequest("Salida");
        TipoMovAsistencia entity = RrhhTestFixtures.tipoMovAsistencia(1L, "I");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("I");
        assertThat(entity.getNombre()).isEqualTo("Salida");
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
