package pe.restaurant.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.repository.TipoNovedadRrhhRepository;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoNovedadRrhhValidator — Pruebas Unitarias")
class TipoNovedadRrhhValidatorTest {

    @Mock
    private TipoNovedadRrhhRepository repository;

    private TipoNovedadRrhhValidator validator;

    @BeforeEach
    void setUp() {
        validator = new TipoNovedadRrhhValidator(repository);
    }

    // ══════════════════════════════════════════════════════════════
    // validarCodigoUnico - RH-TN-002
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarCodigoUnico() con código duplicado -> lanza BusinessException")
    void validarCodigoUnico_codigoDuplicado_lanzaBusinessException() {
        when(repository.existsByCodigo("PER")).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnico("PER"))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe un tipo de novedad");
    }

    @Test
    @DisplayName("validarCodigoUnico() con código único -> no lanza excepción")
    void validarCodigoUnico_codigoUnico_noLanzaExcepcion() {
        when(repository.existsByCodigo("PER")).thenReturn(false);

        validator.validarCodigoUnico("PER");
    }

    // ══════════════════════════════════════════════════════════════
    // validarCodigoUnicoParaActualizacion - RH-TN-002
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarCodigoUnicoParaActualizacion() con código duplicado -> lanza BusinessException")
    void validarCodigoUnicoParaActualizacion_codigoDuplicado_lanzaBusinessException() {
        when(repository.existsByCodigoAndIdNot("PER", 2L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnicoParaActualizacion("PER", 2L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe un tipo de novedad");
    }

    @Test
    @DisplayName("validarCodigoUnicoParaActualizacion() con código único -> no lanza excepción")
    void validarCodigoUnicoParaActualizacion_codigoUnico_noLanzaExcepcion() {
        when(repository.existsByCodigoAndIdNot("PER", 2L)).thenReturn(false);

        validator.validarCodigoUnicoParaActualizacion("PER", 2L);
    }

    // ══════════════════════════════════════════════════════════════
    // validarNoEnUsoEnNovedadesActivas - RH-TN-004
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("validarNoEnUsoEnNovedadesActivas() con novedades activas -> lanza BusinessException")
    void validarNoEnUsoEnNovedadesActivas_conNovedadesActivas_lanzaBusinessException() {
        when(repository.existsNovedadesActivasByTipoNovedadId(1L)).thenReturn(true);

        assertThatThrownBy(() -> validator.validarNoEnUsoEnNovedadesActivas(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede desactivar");
    }

    @Test
    @DisplayName("validarNoEnUsoEnNovedadesActivas() sin novedades activas -> no lanza excepción")
    void validarNoEnUsoEnNovedadesActivas_sinNovedadesActivas_noLanzaExcepcion() {
        when(repository.existsNovedadesActivasByTipoNovedadId(1L)).thenReturn(false);

        validator.validarNoEnUsoEnNovedadesActivas(1L);
    }
}
