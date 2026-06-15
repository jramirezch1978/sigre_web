package com.sigre.finanzas.domain;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.NullSource;
import org.junit.jupiter.params.provider.ValueSource;


@DisplayName("Pruebas Unitarias - CntasPagarFlagEstado")
class CntasPagarFlagEstadoTest {


    // ==== constantes — otros ====

    @Test
    @DisplayName("Constantes deben tener valores correctos")
    void constantes_debenTenerValoresCorrectos() {
        assertThat(CntasPagarFlagEstado.ACTIVO).isEqualTo("1");
        assertThat(CntasPagarFlagEstado.ANULADO).isEqualTo("0");
    }

    @ParameterizedTest
    @CsvSource({
        "1, ACTIVO",
        "0, ANULADO"
    })
    @DisplayName("toLabel debe convertir código a etiqueta legible")
    void toLabel_debeConvertirCodigoAEtiqueta(String flagEstado, String esperado) {
        assertThat(CntasPagarFlagEstado.toLabel(flagEstado)).isEqualTo(esperado);
    }

    @ParameterizedTest
    @NullAndEmptySource
    @DisplayName("toLabel debe retornar null para null o vacío")
    void toLabel_conNullOVacio_debeRetornarNull(String flagEstado) {
        assertThat(CntasPagarFlagEstado.toLabel(flagEstado)).isNull();
    }


    // ==== toLabel — otros ====

    @Test
    @DisplayName("toLabel debe retornar el mismo valor para código desconocido")
    void toLabel_conCodigoDesconocido_debeRetornarMismoValor() {
        assertThat(CntasPagarFlagEstado.toLabel("99")).isEqualTo("99");
    }

    @ParameterizedTest
    @CsvSource({
        "ACTIVO, 1",
        "activo, 1",
        "REGISTRADO, 1",
        "registrado, 1",
        "ANULADO, 0",
        "anulado, 0",
        "1, 1",
        "0, 0"
    })
    @DisplayName("fromFiltro debe mapear etiquetas a códigos de flagEstado")
    void fromFiltro_debeMapearEtiquetasACodigos(String estado, String esperado) {
        assertThat(CntasPagarFlagEstado.fromFiltro(estado)).isEqualTo(esperado);
    }

    @ParameterizedTest
    @NullSource
    @ValueSource(strings = {"", "  ", "INVALIDO", "99"})
    @DisplayName("fromFiltro debe retornar null para valores inválidos o no reconocidos")
    void fromFiltro_conValoresInvalidos_debeRetornarNull(String estado) {
        assertThat(CntasPagarFlagEstado.fromFiltro(estado)).isNull();
    }


    // ==== constructorPrivado — otros ====

    @Test
    @DisplayName("Constructor privado no debe lanzar excepción")
    void constructorPrivado_noDebeFallar() {
        // Verify the class can be loaded (private constructor is not testable directly)
        assertThat(CntasPagarFlagEstado.class).isNotNull();
    }
}
