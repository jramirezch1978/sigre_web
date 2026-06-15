package com.sigre.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.repository.TipoSancionRepository;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoSancionValidator — Pruebas Unitarias")
class TipoSancionValidatorTest {

    @Mock
    private TipoSancionRepository repository;

    private TipoSancionValidator validator;

    @BeforeEach
    void setUp() {
        validator = new TipoSancionValidator(repository);
    }

    @Test
    @DisplayName("validarCodigoUnico() cuando no existe -> no lanza excepción")
    void validarCodigoUnico_noExiste_noLanzaExcepcion() {
        when(repository.existsByCodigo("NUEVO")).thenReturn(false);

        assertThatCode(() -> validator.validarCodigoUnico("NUEVO"))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarCodigoUnico() cuando existe -> lanza BusinessException")
    void validarCodigoUnico_existe_lanzaBusinessException() {
        when(repository.existsByCodigo("EXISTENTE")).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnico("EXISTENTE"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("código");
    }

    @Test
    @DisplayName("validarCodigoUnicoParaActualizacion() cuando no existe -> no lanza excepción")
    void validarCodigoUnicoParaActualizacion_noExiste_noLanzaExcepcion() {
        when(repository.existsByCodigoAndIdNot("NUEVO", 1L)).thenReturn(false);

        assertThatCode(() -> validator.validarCodigoUnicoParaActualizacion("NUEVO", 1L))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarCodigoUnicoParaActualizacion() cuando existe -> lanza BusinessException")
    void validarCodigoUnicoParaActualizacion_existe_lanzaBusinessException() {
        when(repository.existsByCodigoAndIdNot("EXISTENTE", 1L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnicoParaActualizacion("EXISTENTE", 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("código");
    }

    @Test
    @DisplayName("validarNoEnUsoEnSanciones() cuando no está en uso -> no lanza excepción")
    void validarNoEnUsoEnSanciones_noEnUso_noLanzaExcepcion() {
        when(repository.existsSancionesActivasByTipoSancionId(1L)).thenReturn(false);

        assertThatCode(() -> validator.validarNoEnUsoEnSanciones(1L))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarNoEnUsoEnSanciones() cuando está en uso -> lanza BusinessException")
    void validarNoEnUsoEnSanciones_enUso_lanzaBusinessException() {
        when(repository.existsSancionesActivasByTipoSancionId(1L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarNoEnUsoEnSanciones(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sanciones");
    }
}
