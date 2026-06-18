package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.response.VacacionResponse;
import pe.restaurant.rrhh.entity.Vacacion;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("VacacionMapper — Pruebas Unitarias")
class VacacionMapperTest {

    private final VacacionMapper mapper = new VacacionMapper();

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L);

        VacacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getPeriodoAnio()).isEqualTo(2026);
        assertThat(response.getDiasDerecho()).isEqualTo(30);
        assertThat(response.getDiasPendientes()).isEqualTo(30);
        assertThat(response.getFechaInicio()).isEqualTo("15/01/2026");
        assertThat(response.getFechaFin()).isEqualTo("13/02/2026");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con campos nulos -> no lanza excepción")
    void toResponse_camposNulos_noLanzaExcepcion() {
        Vacacion entity = new Vacacion();
        entity.setId(1L);
        entity.setTrabajadorId(1L);
        entity.setPeriodoAnio(2026);

        VacacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getFechaInicio()).isNull();
        assertThat(response.getFechaFin()).isNull();
    }
}
