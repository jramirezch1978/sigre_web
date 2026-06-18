package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.EjercicioPeriodoRequest;
import pe.restaurant.core.dto.EjercicioPeriodoResponse;
import pe.restaurant.core.entity.EjercicioPeriodo;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class EjercicioPeriodoMapperTest {

    private final EjercicioPeriodoMapper mapper = Mappers.getMapper(EjercicioPeriodoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        EjercicioPeriodo entity = new EjercicioPeriodo();
        entity.setId(1L);
        entity.setAnio(2025);
        entity.setFechaInicio(LocalDate.of(2025, 1, 1));
        entity.setFechaFin(LocalDate.of(2025, 12, 31));
        entity.setFlagEstado("1");

        EjercicioPeriodoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAnio()).isEqualTo(2025);
        assertThat(response.getFechaInicio()).isEqualTo(LocalDate.of(2025, 1, 1));
        assertThat(response.getFechaFin()).isEqualTo(LocalDate.of(2025, 12, 31));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        EjercicioPeriodo e1 = new EjercicioPeriodo();
        e1.setId(1L);
        e1.setAnio(2024);
        e1.setFlagEstado("1");

        EjercicioPeriodo e2 = new EjercicioPeriodo();
        e2.setId(2L);
        e2.setAnio(2025);
        e2.setFlagEstado("1");

        List<EjercicioPeriodoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getAnio()).isEqualTo(2024);
        assertThat(responses.get(1).getAnio()).isEqualTo(2025);
    }

    @Test
    void toEntity_mapsAllFields() {
        EjercicioPeriodoRequest request = new EjercicioPeriodoRequest();
        request.setAnio(2025);
        request.setFechaInicio(LocalDate.of(2025, 1, 1));
        request.setFechaFin(LocalDate.of(2025, 12, 31));
        request.setFlagEstado("1");

        EjercicioPeriodo entity = mapper.toEntity(request);

        assertThat(entity.getAnio()).isEqualTo(2025);
        assertThat(entity.getFechaInicio()).isEqualTo(LocalDate.of(2025, 1, 1));
        assertThat(entity.getFechaFin()).isEqualTo(LocalDate.of(2025, 12, 31));
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        EjercicioPeriodo entity = new EjercicioPeriodo();
        entity.setId(1L);
        entity.setAnio(2024);
        entity.setFlagEstado("1");

        EjercicioPeriodoRequest request = new EjercicioPeriodoRequest();
        request.setAnio(2025);
        request.setFechaInicio(LocalDate.of(2025, 1, 1));
        request.setFechaFin(LocalDate.of(2025, 12, 31));
        request.setFlagEstado("0");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getAnio()).isEqualTo(2025);
        assertThat(entity.getFechaInicio()).isEqualTo(LocalDate.of(2025, 1, 1));
        assertThat(entity.getFechaFin()).isEqualTo(LocalDate.of(2025, 12, 31));
        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }
}
