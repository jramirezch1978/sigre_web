package pe.restaurant.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.repository.CapacitacionRepository;
import pe.restaurant.rrhh.repository.CapacitacionTrabajadorRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("CapacitacionValidator — Pruebas Unitarias")
class CapacitacionValidatorTest {

    @Mock
    private CapacitacionRepository repository;

    @Mock
    private CapacitacionTrabajadorRepository ctRepository;

    @Mock
    private TrabajadorRepository trabajadorRepository;

    private CapacitacionValidator validator;

    @BeforeEach
    void setUp() {
        validator = new CapacitacionValidator(repository, ctRepository, trabajadorRepository);
    }

    // ══════════════════════════════════════════════════════════════
    // validarFechas - RH-CA-002
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarFechas() con fechas válidas -> no lanza excepción")
    void validarFechas_fechasValidas_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechas(
                LocalDate.of(2026, 2, 1), LocalDate.of(2026, 2, 5)))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechas() con fecha fin null -> no lanza excepción")
    void validarFechas_fechaFinNull_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechas(
                LocalDate.of(2026, 2, 1), null))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechas() con fecha inicio null -> no lanza excepción")
    void validarFechas_fechaInicioNull_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechas(
                null, LocalDate.of(2026, 2, 5)))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechas() con fecha fin anterior a inicio -> lanza BusinessException")
    void validarFechas_fechaFinAnterior_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarFechas(
                LocalDate.of(2026, 2, 5), LocalDate.of(2026, 2, 1)))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("fecha fin");
    }

    // ══════════════════════════════════════════════════════════════
    // validarSinParticipantes - RH-CA-003
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarSinParticipantes() sin participantes -> no lanza excepción")
    void validarSinParticipantes_sinParticipantes_noLanzaExcepcion() {
        when(repository.existsParticipantesByCapacitacionId(1L)).thenReturn(false);

        assertThatCode(() -> validator.validarSinParticipantes(1L))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarSinParticipantes() con participantes -> lanza BusinessException")
    void validarSinParticipantes_conParticipantes_lanzaBusinessException() {
        when(repository.existsParticipantesByCapacitacionId(1L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarSinParticipantes(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("participantes");
    }

    // ══════════════════════════════════════════════════════════════
    // validarTrabajador - RH-CA-006
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarTrabajador() con ID existente -> no lanza excepción")
    void validarTrabajador_idExistente_noLanzaExcepcion() {
        when(trabajadorRepository.existsById(1L)).thenReturn(true);

        assertThatCode(() -> validator.validarTrabajador(1L))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTrabajador() con ID inexistente -> lanza BusinessException")
    void validarTrabajador_idInexistente_lanzaBusinessException() {
        when(trabajadorRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarTrabajador(999L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("trabajador");
    }

    // ══════════════════════════════════════════════════════════════
    // validarParticipanteNoDuplicado - RH-CA-005
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarParticipanteNoDuplicado() sin duplicado -> no lanza excepción")
    void validarParticipanteNoDuplicado_sinDuplicado_noLanzaExcepcion() {
        when(ctRepository.existsByCapacitacionIdAndTrabajadorId(1L, 1L)).thenReturn(false);

        assertThatCode(() -> validator.validarParticipanteNoDuplicado(1L, 1L))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarParticipanteNoDuplicado() con duplicado -> lanza BusinessException")
    void validarParticipanteNoDuplicado_conDuplicado_lanzaBusinessException() {
        when(ctRepository.existsByCapacitacionIdAndTrabajadorId(1L, 1L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarParticipanteNoDuplicado(1L, 1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("ya está registrado");
    }
}
