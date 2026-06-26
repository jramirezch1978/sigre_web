package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.PrestamoCreateRequest;
import pe.restaurant.rrhh.dto.request.PrestamoUpdateRequest;
import pe.restaurant.rrhh.dto.response.PrestamoResponse;
import pe.restaurant.rrhh.entity.Prestamo;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("PrestamoMapper — Pruebas Unitarias")
class PrestamoMapperTest {

    private final PrestamoMapper mapper = Mappers.getMapper(PrestamoMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        Prestamo entity = RrhhTestFixtures.prestamo(1L);

        PrestamoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getMontoTotal()).isEqualByComparingTo("5000.0000");
        assertThat(response.getCuotas()).isEqualTo(12);
        assertThat(response.getCuotaMensual()).isEqualByComparingTo("450.0000");
        assertThat(response.getSaldo()).isEqualByComparingTo("3000.0000");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteLista() {
        List<Prestamo> entities = List.of(
                RrhhTestFixtures.prestamo(1L),
                RrhhTestFixtures.prestamo(2L)
        );

        List<PrestamoResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando campos calculados y auditoría")
    void toEntity_convierteDTORequestAEntidad() {
        PrestamoCreateRequest request = RrhhTestFixtures.prestamoCreateRequest();

        Prestamo entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getMontoTotal()).isEqualByComparingTo("6000.0000");
        assertThat(entity.getCuotas()).isEqualTo(12);
        assertThat(entity.getCuotaMensual()).isNull();
        assertThat(entity.getSaldo()).isNull();
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza solo campos editables")
    void updateEntity_actualizaCamposEditables() {
        PrestamoUpdateRequest request = RrhhTestFixtures.prestamoUpdateRequest();
        Prestamo entity = RrhhTestFixtures.prestamo(1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getMontoTotal()).isEqualByComparingTo("6000.0000");
        assertThat(entity.getCuotas()).isEqualTo(12);
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("métodos con null -> retornan null")
    void metodosConNull_retornanNull() {
        assertThat(mapper.toResponse(null)).isNull();
        assertThat(mapper.toResponseList(null)).isNull();
        assertThat(mapper.toEntity(null)).isNull();
    }
}
