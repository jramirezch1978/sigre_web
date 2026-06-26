package pe.restaurant.finanzas.enums;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.NullSource;
import org.junit.jupiter.params.provider.ValueSource;


@DisplayName("Pruebas Unitarias - TipoMovimientoCxP")
class TipoMovimientoCxPTest {


    // ==== debeTenerSieteValores — otros ====

    @Test
    @DisplayName("Debe tener 7 valores")
    void debeTenerSieteValores() {
        assertThat(TipoMovimientoCxP.values().length).isEqualTo(7);
    }

    @ParameterizedTest
    @CsvSource({
        "REGISTRO, REGISTRO",
        "PAGO, PAGO",
        "NOTA_CREDITO, NOTA_CREDITO",
        "AJUSTE, AJUSTE",
        "CANJE_ORIGEN, CANJE_ORIGEN",
        "CANJE_DESTINO, CANJE_DESTINO",
        "LETRA, LETRA",
        "registro, REGISTRO",
        "pago, PAGO"
    })
    @DisplayName("fromString debe encontrar por nombre (case-insensitive)")
    void fromString_debeEncontrar(String tipo, String esperado) {
        assertThat(TipoMovimientoCxP.fromString(tipo)).isEqualTo(TipoMovimientoCxP.valueOf(esperado));
    }

    @ParameterizedTest
    @NullSource
    @DisplayName("fromString con null debe retornar null")
    void fromString_null_debeRetornarNull(String tipo) {
        assertThat(TipoMovimientoCxP.fromString(tipo)).isNull();
    }

    @ParameterizedTest
    @ValueSource(strings = {"INVALIDO", "XYZ"})
    @DisplayName("fromString inválido debe lanzar excepción")
    void fromString_invalido_debeLanzarExcepcion(String tipo) {
        assertThatThrownBy(() -> TipoMovimientoCxP.fromString(tipo)).isInstanceOf(IllegalArgumentException.class);
    }
}
