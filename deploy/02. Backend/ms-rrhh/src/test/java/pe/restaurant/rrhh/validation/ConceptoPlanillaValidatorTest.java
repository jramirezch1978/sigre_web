package pe.restaurant.rrhh.validation;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.mockito.Mockito.when;
import static pe.restaurant.rrhh.constants.ConceptoPlanillaConstants.*;

/**
 * Tests unitarios para ConceptoPlanillaValidator.
 * Valida las reglas de negocio personalizadas.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ConceptoPlanillaValidator")
class ConceptoPlanillaValidatorTest {

    @Mock
    private ConceptoPlanillaRepository repository;

    @InjectMocks
    private ConceptoPlanillaValidator validator;

    // ==== validarCodigoUnico ====

    @Test
    @DisplayName("validarCodigoUnico() con código existente -> lanza BusinessException")
    void validarCodigoUnico_conCodigoExistente_lanzaBusinessException() {
        when(repository.existsByCodigo("ING-001")).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnico("ING-001"))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe")
            .hasFieldOrPropertyWithValue("errorCode", ERROR_CODIGO_DUPLICADO);
    }

    @Test
    @DisplayName("validarCodigoUnico() con código nuevo -> no lanza excepción")
    void validarCodigoUnico_conCodigoNuevo_noLanzaExcepcion() {
        when(repository.existsByCodigo("ING-999")).thenReturn(false);

        assertThatCode(() -> validator.validarCodigoUnico("ING-999"))
            .doesNotThrowAnyException();
    }

    // ==== validarCodigoUnicoParaActualizacion ====

    @Test
    @DisplayName("validarCodigoUnicoParaActualizacion() con código en otro registro -> lanza BusinessException")
    void validarCodigoUnicoParaActualizacion_conCodigoEnOtroRegistro_lanzaBusinessException() {
        when(repository.existsByCodigoAndIdNot("ING-001", 2L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnicoParaActualizacion("ING-001", 2L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe");
    }

    @Test
    @DisplayName("validarCodigoUnicoParaActualizacion() con código del mismo registro -> no lanza excepción")
    void validarCodigoUnicoParaActualizacion_conCodigoDelMismoRegistro_noLanzaExcepcion() {
        when(repository.existsByCodigoAndIdNot("ING-001", 1L)).thenReturn(false);

        assertThatCode(() -> validator.validarCodigoUnicoParaActualizacion("ING-001", 1L))
            .doesNotThrowAnyException();
    }

    // ==== validarTipo ====

    @Test
    @DisplayName("validarTipo() con INGRESO -> no lanza excepción")
    void validarTipo_conIngreso_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarTipo(TIPO_INGRESO))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTipo() con DESCUENTO -> no lanza excepción")
    void validarTipo_conDescuento_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarTipo(TIPO_DESCUENTO))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTipo() con APORTE -> no lanza excepción")
    void validarTipo_conAporte_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarTipo(TIPO_APORTE))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarTipo() con tipo inválido -> lanza BusinessException")
    void validarTipo_conTipoInvalido_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarTipo("INVALIDO"))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("tipo debe ser")
            .hasFieldOrPropertyWithValue("errorCode", ERROR_TIPO_INVALIDO);
    }

    @Test
    @DisplayName("validarTipo() con null -> lanza BusinessException")
    void validarTipo_conNull_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarTipo(null))
            .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("validarTipo() con cadena vacía -> lanza BusinessException")
    void validarTipo_conCadenaVacia_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarTipo(""))
            .isInstanceOf(BusinessException.class);
    }

    // ==== validarNoEnUso ====

    @Test
    @DisplayName("validarNoEnUso() no lanza excepción (implementación pendiente)")
    void validarNoEnUso_noLanzaExcepcion() {
        // TODO: Implementar cuando exista la tabla calculo_det
        assertThatCode(() -> validator.validarNoEnUso(1L))
            .doesNotThrowAnyException();
    }
}
