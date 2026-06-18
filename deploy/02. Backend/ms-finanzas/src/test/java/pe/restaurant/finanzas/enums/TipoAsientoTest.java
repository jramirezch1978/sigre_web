package pe.restaurant.finanzas.enums;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.NullSource;
import org.junit.jupiter.params.provider.ValueSource;


@DisplayName("Pruebas Unitarias - TipoAsiento")
class TipoAsientoTest {


    // ==== debeTenerCuatroValores — otros ====

    @Test
    @DisplayName("Debe tener exactamente 4 valores del enum")
    void debeTenerCuatroValores() {
        assertThat(TipoAsiento.values().length).isEqualTo(4);
    }

    @ParameterizedTest
    @CsvSource({
        "PROVISION_CXP, Provisión de Cuenta por Pagar",
        "PAGO_CXP, Pago de Cuenta por Pagar",
        "NOTA_CREDITO_CXP, Nota de Crédito de Cuenta por Pagar",
        "AJUSTE_CXP, Ajuste de Cuenta por Pagar"
    })
    @DisplayName("getDescripcion debe retornar la descripción correcta")
    void getDescripcion_debeRetornarDescripcionCorrecta(String codigo, String descripcionEsperada) {
        TipoAsiento tipo = TipoAsiento.valueOf(codigo);
        assertThat(tipo.getDescripcion()).isEqualTo(descripcionEsperada);
    }

    @ParameterizedTest
    @CsvSource({
        "PROVISION_CXP, PROVISION_CXP",
        "PAGO_CXP, PAGO_CXP",
        "provision_cxp, PROVISION_CXP",
        "pago_cxp, PAGO_CXP"
    })
    @DisplayName("obtenerPorCodigo debe encontrar por nombre exacto o case-insensitive")
    void obtenerPorCodigo_debeEncontrarPorNombre(String codigo, String esperado) {
        TipoAsiento resultado = TipoAsiento.obtenerPorCodigo(codigo);
        assertThat(resultado).isNotNull();
        assertThat(resultado).isEqualTo(TipoAsiento.valueOf(esperado));
    }

    @ParameterizedTest
    @NullSource
    @DisplayName("obtenerPorCodigo debe retornar null para código null")
    void obtenerPorCodigo_conNull_debeRetornarNull(String codigo) {
        assertThat(TipoAsiento.obtenerPorCodigo(codigo)).isNull();
    }

    @ParameterizedTest
    @ValueSource(strings = {"INVALIDO", "XYZ", "", "  "})
    @DisplayName("obtenerPorCodigo debe lanzar excepción para código inválido")
    void obtenerPorCodigo_conCodigoInvalido_debeLanzarExcepcion(String codigo) {
        assertThatThrownBy(() -> TipoAsiento.obtenerPorCodigo(codigo)).isInstanceOf(IllegalArgumentException.class);
    }
}
