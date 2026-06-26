package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.response.AsistenciaResponse;
import pe.restaurant.rrhh.entity.Asistencia;
import pe.restaurant.rrhh.repository.AsistenciaRepository;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("AsistenciaMapper — Pruebas Unitarias")
class AsistenciaMapperTest {

    @Mock
    private AsistenciaRepository repository;

    @InjectMocks
    private AsistenciaMapper mapper;

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        when(repository.findTrabajadorNombresById(1L)).thenReturn("Paterno Materno, Nombre 1");
        when(repository.findTipoMovAsistenciaCodigoById(1L)).thenReturn("I");
        when(repository.findTipoMovAsistenciaNombreById(1L)).thenReturn("Ingreso");

        AsistenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTrabajadorNombres()).isEqualTo("Paterno Materno, Nombre 1");
        assertThat(response.getFecha()).isEqualTo("2026-01-15");
        assertThat(response.getHoraEntrada()).isEqualTo("08:00:00");
        assertThat(response.getHoraSalida()).isEqualTo("17:00:00");
        assertThat(response.getTipoMovAsistencia()).isNotNull();
        assertThat(response.getTipoMovAsistencia().getId()).isEqualTo(1L);
        assertThat(response.getTipoMovAsistencia().getCodigo()).isEqualTo("I");
        assertThat(response.getTipoMovAsistencia().getNombre()).isEqualTo("Ingreso");
        assertThat(response.getHorasTrabajadas()).isEqualByComparingTo("9.00");
        assertThat(response.getHorasExtra()).isEqualByComparingTo("1.00");
    }

    @Test
    @DisplayName("toResponse() con tipoMovAsistenciaId null -> retorna RefResponse null")
    void toResponse_tipoMovNull_retornaRefNull() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        entity.setTipoMovAsistenciaId(null);
        when(repository.findTrabajadorNombresById(1L)).thenReturn("Paterno Materno, Nombre 1");

        AsistenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getTipoMovAsistencia()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        AsistenciaResponse response = mapper.toResponse(null);

        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponse() con campos null -> maneja nulls correctamente")
    void toResponse_camposNull_manejaNulls() {
        Asistencia entity = new Asistencia();
        entity.setId(1L);
        entity.setTrabajadorId(2L);
        entity.setFlagEstado(null);
        when(repository.findTrabajadorNombresById(2L)).thenReturn("Trabajador Test");

        AsistenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(2L);
        assertThat(response.getFecha()).isNull();
        assertThat(response.getHoraEntrada()).isNull();
        assertThat(response.getHoraSalida()).isNull();
        assertThat(response.getTipoMovAsistencia()).isNull();
        assertThat(response.getHorasTrabajadas()).isNull();
        assertThat(response.getHorasExtra()).isNull();
        assertThat(response.getFlagEstado()).isNull();
    }
}
