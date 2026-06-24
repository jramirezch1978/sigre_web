package com.sigre.rrhh.validation;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.GrupoConceptosPlanillaRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.mockito.Mockito.when;
import static com.sigre.rrhh.constants.ConceptoPlanillaConstants.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ConceptoPlanillaValidator")
class ConceptoPlanillaValidatorTest {

    @Mock
    private ConceptoPlanillaRepository repository;

    @Mock
    private GrupoConceptosPlanillaRepository grupoConceptosPlanillaRepository;

    @InjectMocks
    private ConceptoPlanillaValidator validator;

    @Test
    @DisplayName("validarCodigoUnico() con c?digo existente -> lanza BusinessException")
    void validarCodigoUnico_conCodigoExistente_lanzaBusinessException() {
        when(repository.existsByCodigo("1013")).thenReturn(true);

        assertThatThrownBy(() -> validator.validarCodigoUnico("1013"))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe")
            .hasFieldOrPropertyWithValue("errorCode", ERROR_CODIGO_DUPLICADO);
    }

    @Test
    @DisplayName("validarCodigoUnico() con c?digo nuevo -> no lanza excepci?n")
    void validarCodigoUnico_conCodigoNuevo_noLanzaExcepcion() {
        when(repository.existsByCodigo("9999")).thenReturn(false);

        assertThatCode(() -> validator.validarCodigoUnico("9999"))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarGrupoCalculo() con grupo v?lido -> no lanza excepci?n")
    void validarGrupoCalculo_conGrupoValido_noLanzaExcepcion() {
        when(grupoConceptosPlanillaRepository.findByCodigo("10")).thenReturn(Optional.of(new com.sigre.rrhh.entity.GrupoConceptosPlanilla()));

        assertThatCode(() -> validator.validarGrupoCalculo("10"))
            .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("validarGrupoCalculo() con grupo inv?lido -> lanza BusinessException")
    void validarGrupoCalculo_conGrupoInvalido_lanzaBusinessException() {
        assertThatThrownBy(() -> validator.validarGrupoCalculo(""))
            .isInstanceOf(BusinessException.class)
            .hasFieldOrPropertyWithValue("errorCode", ERROR_GRUPO_CALCULO_INVALIDO);
    }

    @Test
    @DisplayName("validarNoEnUso() no lanza excepci?n (implementaci?n pendiente)")
    void validarNoEnUso_noLanzaExcepcion() {
        assertThatCode(() -> validator.validarNoEnUso(1L))
            .doesNotThrowAnyException();
    }
}
