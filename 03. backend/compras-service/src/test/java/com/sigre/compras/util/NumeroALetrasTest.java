package com.sigre.compras.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("NumeroALetras — Pruebas Unitarias")
class NumeroALetrasTest {

    @Test
    @DisplayName("convertir() monto null -> retorna cero")
    void convertir_montoNull_retornaCero() {
        String result = NumeroALetras.convertir(null, "SOLES");
        assertThat(result).startsWith("CERO Y 00/100");
    }

    @Test
    @DisplayName("convertir() monto cero -> retorna cero")
    void convertir_montoCero_retornaCero() {
        String result = NumeroALetras.convertir(BigDecimal.ZERO, "SOLES");
        assertThat(result).isEqualTo("CERO Y 00/100 SOLES");
    }

    @Test
    @DisplayName("convertir() moneda null -> no falla")
    void convertir_monedaNull_noFalla() {
        String result = NumeroALetras.convertir(new BigDecimal("1.00"), null);
        assertThat(result).isEqualTo("UNO Y 00/100 ");
    }

    @Test
    @DisplayName("convertir() monto negativo -> usa absoluto")
    void convertir_montoNegativo_usaAbsoluto() {
        String result = NumeroALetras.convertir(new BigDecimal("-5.50"), "SOLES");
        assertThat(result).isEqualTo("CINCO Y 50/100 SOLES");
    }

    @ParameterizedTest
    @CsvSource({
            "1.00, UNO",
            "5.00, CINCO",
            "10.00, DIEZ",
            "11.00, ONCE",
            "15.00, QUINCE",
            "20.00, VEINTE",
            "21.00, VEINTIUNO",
            "29.00, VEINTINUEVE"
    })
    void convertir_unidades_0a29(String monto, String esperado) {
        String result = NumeroALetras.convertir(new BigDecimal(monto), "SOLES");
        assertThat(result).startsWith(esperado + " Y 00/100");
    }

    @ParameterizedTest
    @CsvSource({
            "30.00, TREINTA",
            "40.00, CUARENTA",
            "50.00, CINCUENTA",
            "90.00, NOVENTA",
            "35.00, TREINTA Y CINCO",
            "99.00, NOVENTA Y NUEVE"
    })
    void convertir_decenas_30a99(String monto, String esperado) {
        String result = NumeroALetras.convertir(new BigDecimal(monto), "SOLES");
        assertThat(result).startsWith(esperado + " Y 00/100");
    }

    @ParameterizedTest
    @CsvSource({
            "100.00, CIEN",
            "101.00, CIENTO UNO",
            "200.00, DOSCIENTOS",
            "500.00, QUINIENTOS",
            "999.00, NOVECIENTOS NOVENTA Y NUEVE",
            "150.00, CIENTO CINCUENTA",
            "310.00, TRESCIENTOS DIEZ"
    })
    void convertir_centenas_100a999(String monto, String esperado) {
        String result = NumeroALetras.convertir(new BigDecimal(monto), "SOLES");
        assertThat(result).startsWith(esperado + " Y 00/100");
    }

    @ParameterizedTest
    @CsvSource({
            "1000.00, MIL",
            "1001.00, MIL UNO",
            "2000.00, DOS MIL",
            "5500.00, CINCO MIL QUINIENTOS",
            "10000.00, DIEZ MIL",
            "999999.00, NOVECIENTOS NOVENTA Y NUEVE MIL NOVECIENTOS NOVENTA Y NUEVE"
    })
    void convertir_miles(String monto, String esperado) {
        String result = NumeroALetras.convertir(new BigDecimal(monto), "SOLES");
        assertThat(result).startsWith(esperado + " Y 00/100");
    }

    @ParameterizedTest
    @CsvSource({
            "1000000.00, UN MILLON",
            "1000001.00, UN MILLON UNO",
            "2000000.00, DOS MILLONES",
            "5500000.00, CINCO MILLONES QUINIENTOS MIL",
            "999999999.00, NOVECIENTOS NOVENTA Y NUEVE MILLONES NOVECIENTOS NOVENTA Y NUEVE MIL NOVECIENTOS NOVENTA Y NUEVE"
    })
    void convertir_millones(String monto, String esperado) {
        String result = NumeroALetras.convertir(new BigDecimal(monto), "SOLES");
        assertThat(result).startsWith(esperado + " Y 00/100");
    }

    @Test
    @DisplayName("convertir() mayor a billon -> retorna número como string")
    void convertir_mayorABillon_retornaNumeroComoString() {
        String result = NumeroALetras.convertir(new BigDecimal("1000000000000.00"), "SOLES");
        assertThat(result).startsWith("1000000000000 Y 00/100");
    }

    @Test
    @DisplayName("convertir() con decimales")
    void convertir_conDecimales() {
        String result = NumeroALetras.convertir(new BigDecimal("1234.56"), "SOLES");
        assertThat(result).isEqualTo("MIL DOSCIENTOS TREINTA Y CUATRO Y 56/100 SOLES");
    }

    @Test
    @DisplayName("convertir() decimales redondeados")
    void convertir_decimalesRedondeados() {
        String result = NumeroALetras.convertir(new BigDecimal("100.999"), "DOLARES");
        assertThat(result).isEqualTo("CIENTO UNO Y 00/100 DOLARES");
    }

    @Test
    @DisplayName("convertir() monto tipico factura")
    void convertir_montoTipicoFactura() {
        String result = NumeroALetras.convertir(new BigDecimal("1180.00"), "SOLES");
        assertThat(result).isEqualTo("MIL CIENTO OCHENTA Y 00/100 SOLES");
    }
}
