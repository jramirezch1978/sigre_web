package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.response.EvaluacionDesempenoResponse;
import pe.restaurant.rrhh.entity.EvaluacionDesempeno;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("EvaluacionDesempenoMapper — Pruebas Unitarias")
class EvaluacionDesempenoMapperTest {

    private final EvaluacionDesempenoMapper mapper = new EvaluacionDesempenoMapper();

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        EvaluacionDesempeno entity = RrhhTestFixtures.evaluacionDesempeno(1L);

        EvaluacionDesempenoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getPeriodoAnio()).isEqualTo(2026);
        assertThat(response.getCalificacion()).isEqualByComparingTo("15.50");
        assertThat(response.getObservaciones()).isEqualTo("Buen desempeño");
        assertThat(response.getFechaEvaluacion()).isEqualTo("2026-06-15");
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con campos nulos -> no lanza excepción")
    void toResponse_camposNulos_noLanzaExcepcion() {
        EvaluacionDesempeno entity = new EvaluacionDesempeno();
        entity.setId(1L);
        entity.setTrabajadorId(1L);
        entity.setPeriodoAnio(2026);

        EvaluacionDesempenoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCalificacion()).isNull();
        assertThat(response.getFechaEvaluacion()).isNull();
    }
}
