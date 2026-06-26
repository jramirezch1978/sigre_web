package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.PeriodoGratificacionCreateRequest;
import pe.restaurant.rrhh.dto.request.PeriodoGratificacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.PeriodoGratificacionResponse;
import pe.restaurant.rrhh.entity.PeriodoGratificacion;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("PeriodoGratificacionMapper — Pruebas Unitarias")
class PeriodoGratificacionMapperTest {

    private final PeriodoGratificacionMapper mapper = Mappers.getMapper(PeriodoGratificacionMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        PeriodoGratificacion entity = RrhhTestFixtures.periodoGratificacion(1L);

        PeriodoGratificacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("PG-1");
        assertThat(response.getNombre()).isEqualTo("Período Gratificación 1");
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<PeriodoGratificacion> entities = List.of(
                RrhhTestFixtures.periodoGratificacion(1L),
                RrhhTestFixtures.periodoGratificacion(2L)
        );

        List<PeriodoGratificacionResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("PG-1");
        assertThat(responses.get(1).getCodigo()).isEqualTo("PG-2");
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        PeriodoGratificacionCreateRequest request = RrhhTestFixtures.periodoGratificacionCreateRequest("PG01", "Periodo 1");

        PeriodoGratificacion entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("PG01");
        assertThat(entity.getNombre()).isEqualTo("Periodo 1");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar id ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        PeriodoGratificacionUpdateRequest request = RrhhTestFixtures.periodoGratificacionUpdateRequest("Periodo Actualizado");
        PeriodoGratificacion entity = RrhhTestFixtures.periodoGratificacion(1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("PG-1");
        assertThat(entity.getNombre()).isEqualTo("Periodo Actualizado");
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
