package pe.restaurant.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.repository.PermisoLicenciaDetRepository;
import pe.restaurant.rrhh.repository.TipoSuspensionLaboralRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PermisoLicenciaValidator — Pruebas Unitarias")
class PermisoLicenciaValidatorTest {

    @Mock
    private PermisoLicenciaDetRepository detRepository;

    @Mock
    private TrabajadorRepository trabajadorRepository;

    @Mock
    private TipoSuspensionLaboralRepository tipoSuspensionRepository;

    private PermisoLicenciaValidator validator;

    @BeforeEach
    void setUp() {
        validator = new PermisoLicenciaValidator(detRepository, trabajadorRepository, tipoSuspensionRepository);
    }

    // ══════════════════════════════════════════════════════════════
    // validarTrabajador - RH-PL-002
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
    // validarTipoSuspension - RH-PL-007
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarTipoSuspension() con ID existente -> no lanza excepción")
    void validarTipoSuspension_idExistente_noLanzaExcepcion() {
        when(tipoSuspensionRepository.existsById(1L)).thenReturn(true);

        assertThatCode(() -> validator.validarTipoSuspension(1L))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTipoSuspension() con ID inexistente -> lanza BusinessException")
    void validarTipoSuspension_idInexistente_lanzaBusinessException() {
        when(tipoSuspensionRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarTipoSuspension(999L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("suspensión");
    }

    @Test
    @DisplayName("validarTipoSuspension() con null -> no lanza excepción")
    void validarTipoSuspension_conNull_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarTipoSuspension(null))
            .doesNotThrowAnyException();
    }

    // ══════════════════════════════════════════════════════════════
    // validarFechas - RH-PL-003
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarFechas() con fechas válidas -> no lanza excepción")
    void validarFechas_fechasValidas_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechas(
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 20)))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechas() con fecha fin null -> no lanza excepción")
    void validarFechas_fechaFinNull_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechas(
                LocalDate.of(2026, 1, 15), null))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechas() con fecha fin anterior a inicio -> lanza BusinessException")
    void validarFechas_fechaFinAnterior_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarFechas(
                LocalDate.of(2026, 1, 20), LocalDate.of(2026, 1, 15)))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("fecha fin");
    }

    // ══════════════════════════════════════════════════════════════
    // validarSinSolapamiento - RH-PL-004
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarSinSolapamiento() sin solapamiento -> no lanza excepción")
    void validarSinSolapamiento_sinSolapamiento_noLanzaExcepcion() {
        when(detRepository.existsSolapamiento(1L,
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 20), null))
            .thenReturn(false);

        assertThatCode(() -> validator.validarSinSolapamiento(1L,
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 20), null))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarSinSolapamiento() con solapamiento -> lanza BusinessException")
    void validarSinSolapamiento_conSolapamiento_lanzaBusinessException() {
        when(detRepository.existsSolapamiento(1L,
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 20), null))
            .thenReturn(true);

        assertThatThrownBy(() -> validator.validarSinSolapamiento(1L,
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 20), null))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("activo");
    }

    @Test
    @DisplayName("validarSinSolapamiento() excluyendo ID -> pasa excluirId al repository")
    void validarSinSolapamiento_excluyendoId_pasaExcluirId() {
        when(detRepository.existsSolapamiento(1L,
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 15), 5L))
            .thenReturn(false);

        validator.validarSinSolapamiento(1L,
                LocalDate.of(2026, 1, 15), null, 5L);

        verify(detRepository).existsSolapamiento(1L,
                LocalDate.of(2026, 1, 15), LocalDate.of(2026, 1, 15), 5L);
    }
}
