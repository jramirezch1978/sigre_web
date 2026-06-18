package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.dto.request.TurnoRequest;
import pe.restaurant.rrhh.dto.response.TurnoResponse;
import pe.restaurant.rrhh.entity.Turno;

import java.time.Instant;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TurnoMapper — Pruebas Unitarias")
class TurnoMapperTest {

    private final TurnoMapper mapper = Mappers.getMapper(TurnoMapper.class);

    @Test
    @DisplayName("toResponse() convierte entidad a DTO")
    void toResponse_convierteEntidadADTO() {
        Turno entity = new Turno();
        entity.setId(1L);
        entity.setNombre("Turno Mañana");
        entity.setHoraEntrada(LocalTime.of(8, 0));
        entity.setHoraSalida(LocalTime.of(17, 0));
        entity.setMinutosTolerancia(15);
        entity.setAplicaLunes(true);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        TurnoResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Turno Mañana");
        assertThat(response.getHoraEntrada()).isEqualTo(LocalTime.of(8, 0));
        assertThat(response.getAplicaLunes()).isTrue();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse((Turno) null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() convierte lista de entidades a DTOs")
    void toResponseList_convierteListaADTOs() {
        Turno e1 = new Turno();
        e1.setId(1L);
        Turno e2 = new Turno();
        e2.setId(2L);

        List<TurnoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toEntity() convierte request a entidad")
    void toEntity_convierteRequestAEntidad() {
        TurnoRequest request = new TurnoRequest();
        request.setNombre("Turno Tarde");
        request.setHoraEntrada(LocalTime.of(14, 0));
        request.setHoraSalida(LocalTime.of(22, 0));
        request.setMinutosTolerancia(10);
        request.setAplicaLunes(true);
        request.setAplicaSabado(false);

        Turno entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull();
        assertThat(entity.getNombre()).isEqualTo("Turno Tarde");
        assertThat(entity.getHoraEntrada()).isEqualTo(LocalTime.of(14, 0));
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("updateEntity() con request null -> no lanza excepción")
    void updateEntity_conRequestNull_noLanzaExcepcion() {
        Turno entity = new Turno();
        entity.setNombre("Original");
        mapper.updateEntity(null, entity);
        assertThat(entity.getNombre()).isEqualTo("Original");
    }

    @Test
    @DisplayName("updateEntity() actualiza entidad con datos del request")
    void updateEntity_actualizaEntidad() {
        Turno entity = new Turno();
        entity.setNombre("Original");
        entity.setMinutosTolerancia(5);

        TurnoRequest request = new TurnoRequest();
        request.setNombre("Actualizado");
        request.setHoraEntrada(LocalTime.of(9, 0));
        request.setHoraSalida(LocalTime.of(18, 0));
        request.setMinutosTolerancia(20);
        request.setAplicaLunes(true);
        request.setAplicaSabado(true);

        mapper.updateEntity(request, entity);

        assertThat(entity.getNombre()).isEqualTo("Actualizado");
        assertThat(entity.getHoraEntrada()).isEqualTo(LocalTime.of(9, 0));
        assertThat(entity.getMinutosTolerancia()).isEqualTo(20);
    }
}
