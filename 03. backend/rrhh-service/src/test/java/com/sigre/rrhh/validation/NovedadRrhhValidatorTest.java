package com.sigre.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.repository.NovedadRrhhRepository;
import com.sigre.rrhh.repository.TipoNovedadRrhhRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("NovedadRrhhValidator — Pruebas Unitarias")
class NovedadRrhhValidatorTest {

    @Mock
    private TrabajadorRepository trabajadorRepository;

    @Mock
    private TipoNovedadRrhhRepository tipoNovedadRepository;

    @Mock
    private NovedadRrhhRepository repository;

    private NovedadRrhhValidator validator;

    @BeforeEach
    void setUp() {
        validator = new NovedadRrhhValidator(trabajadorRepository, tipoNovedadRepository, repository);
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
    @DisplayName("validarTipoNovedad() con ID existente -> no lanza excepción")
    void validarTipoNovedad_idExistente_noLanzaExcepcion() {
        when(tipoNovedadRepository.existsById(1L)).thenReturn(true);

        assertThatCode(() -> validator.validarTipoNovedad(1L))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTipoNovedad() con ID inexistente -> lanza BusinessException")
    void validarTipoNovedad_idInexistente_lanzaBusinessException() {
        when(tipoNovedadRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarTipoNovedad(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de novedad no existe");
    }

    @Test
    @DisplayName("validarFechas() con fechas válidas -> no lanza excepción")
    void validarFechas_fechasValidas_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarFechas(
                        LocalDate.of(2026, 2, 1), LocalDate.of(2026, 2, 5)))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarFechas() con fecha fin anterior a inicio -> lanza BusinessException")
    void validarFechas_fechaFinAnterior_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarFechas(
                        LocalDate.of(2026, 2, 5), LocalDate.of(2026, 2, 1)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha fin no puede ser anterior");
    }

    @Test
    @DisplayName("validarSinDuplicado() sin duplicado -> no lanza excepción")
    void validarSinDuplicado_sinDuplicado_noLanzaExcepcion() {
        when(repository.existsDuplicadoPeriodo(1L, 1L, LocalDate.of(2026, 2, 1), LocalDate.of(2026, 2, 15), null))
                .thenReturn(false);

        assertThatCode(() -> validator.validarSinDuplicado(1L, 1L, LocalDate.of(2026, 2, 1), LocalDate.of(2026, 2, 15), null))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarSinDuplicado() con duplicado -> lanza BusinessException")
    void validarSinDuplicado_conDuplicado_lanzaBusinessException() {
        when(repository.existsDuplicadoPeriodo(1L, 1L, LocalDate.of(2026, 2, 1), LocalDate.of(2026, 2, 15), null))
                .thenReturn(true);

        assertThatThrownBy(() -> validator.validarSinDuplicado(1L, 1L, LocalDate.of(2026, 2, 1), LocalDate.of(2026, 2, 15), null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mismo tipo en ese per\u00edodo");
    }
}
