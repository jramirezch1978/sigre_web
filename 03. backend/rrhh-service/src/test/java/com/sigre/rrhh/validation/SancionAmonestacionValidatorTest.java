package com.sigre.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.repository.TipoSancionRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("SancionAmonestacionValidator — Pruebas Unitarias")
class SancionAmonestacionValidatorTest {

    @Mock
    private TrabajadorRepository trabajadorRepository;

    @Mock
    private TipoSancionRepository tipoSancionRepository;

    private SancionAmonestacionValidator validator;

    @BeforeEach
    void setUp() {
        validator = new SancionAmonestacionValidator(trabajadorRepository, tipoSancionRepository);
    }

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
                .hasMessageContaining("no existe");
    }

    @Test
    @DisplayName("validarTipoSancion() con ID existente -> no lanza excepción")
    void validarTipoSancion_idExistente_noLanzaExcepcion() {
        when(tipoSancionRepository.existsById(1L)).thenReturn(true);

        assertThatCode(() -> validator.validarTipoSancion(1L))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTipoSancion() con ID inexistente -> lanza BusinessException")
    void validarTipoSancion_idInexistente_lanzaBusinessException() {
        when(tipoSancionRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarTipoSancion(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sanción especificado no existe");
    }

    @Test
    @DisplayName("validarFechaNoFutura() con fecha null -> no lanza excepción")
    void validarFechaNoFutura_fechaNull_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechaNoFutura(null))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechaNoFutura() con fecha pasada -> no lanza excepción")
    void validarFechaNoFutura_fechaPasada_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechaNoFutura(LocalDate.of(2020, 1, 1)))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechaNoFutura() con fecha futura -> lanza BusinessException")
    void validarFechaNoFutura_fechaFutura_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarFechaNoFutura(LocalDate.of(2099, 1, 1)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no puede ser futura");
    }
}
