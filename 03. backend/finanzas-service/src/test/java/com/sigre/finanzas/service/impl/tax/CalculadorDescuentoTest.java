package com.sigre.finanzas.service.impl.tax;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import com.sigre.finanzas.dto.request.ImpuestoItemRequest;
import com.sigre.finanzas.dto.response.ImpuestoCalculadoResponse;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Pruebas Unitarias - CalculadorDescuento")
class CalculadorDescuentoTest {

    private static final String PAIS_PERU = "PE";

    private ImpuestoItemRequest igvReq(BigDecimal tasa) {
        var r = new ImpuestoItemRequest(1L, 1);
        r.setTasa(tasa);
        r.setEsFiscalizado(true);
        r.setNombre("IGV");
        return r;
    }

    private ImpuestoCalculadoResponse igvCalc(BigDecimal importe) {
        return ImpuestoCalculadoResponse.builder()
                .tipoImpuestoId(1L)
                .nombre("IGV")
                .tasa(new BigDecimal("18"))
                .importe(importe)
                .esFiscalizado(true)
                .build();
    }

    @Nested
    @DisplayName("Sin descuento")
    class SinDescuento {

        @Test
        @DisplayName("Descuento null → lista vacía")
        void descuentoNull() {
            var result = CalculadorDescuento.calcularDescuentoItem(
                    null,
                    List.of(igvCalc(new BigDecimal("18.0000"))),
                    List.of(igvReq(new BigDecimal("18"))),
                    true,
                    BigDecimal.ONE,
                    PAIS_PERU
            );

            assertThat(result).isEmpty();
        }

        @Test
        @DisplayName("Descuento cero → lista vacía")
        void descuentoCero() {
            var result = CalculadorDescuento.calcularDescuentoItem(
                    BigDecimal.ZERO,
                    List.of(igvCalc(new BigDecimal("18.0000"))),
                    List.of(igvReq(new BigDecimal("18"))),
                    true,
                    BigDecimal.ONE,
                    PAIS_PERU
            );

            assertThat(result).isEmpty();
        }
    }

    @Nested
    @DisplayName("Con descuento")
    class ConDescuento {

        @Test
        @DisplayName("valorConIgv=true → descuento incluye impuestos")
        void descuentoIncluyeImpuestos() {
            // Original item: precioUnitario=118, IGV=18%, descuento=10
            // The discount of 10 is treated as a mini-item with valorUnitario=10
            // valorConIgv=true, so we extract taxes from the discount
            // baseSinBaseAffecting = 10 / 1.18 = 8.4746
            // IGV discount = 8.4746 × 0.18 = 1.5254
            // The discount tax amounts are returned as "descuentos" (positive values to subtract)
            var result = CalculadorDescuento.calcularDescuentoItem(
                    new BigDecimal("10"),
                    List.of(igvCalc(new BigDecimal("18.0000"))),
                    List.of(igvReq(new BigDecimal("18"))),
                    true,
                    BigDecimal.ONE,
                    PAIS_PERU
            );

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getImporte()).isEqualByComparingTo(new BigDecimal("1.5254"));
        }

        @Test
        @DisplayName("valorConIgv=false → descuento no incluye impuestos")
        void descuentoNoIncluyeImpuestos() {
            // Original item: precioUnitario=100, IGV=18%, descuento=10
            // valorConIgv=false
            // mini-item: valorUnitario=10, valorConIgv=false
            // base = 10, IGV on base = 10 × 0.18 = 1.80
            var result = CalculadorDescuento.calcularDescuentoItem(
                    new BigDecimal("10"),
                    List.of(igvCalc(new BigDecimal("18.0000"))),
                    List.of(igvReq(new BigDecimal("18"))),
                    false,
                    BigDecimal.ONE,
                    PAIS_PERU
            );

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getImporte()).isEqualByComparingTo(new BigDecimal("1.8000"));
        }

        @Test
        @DisplayName("Múltiples impuestos en el descuento")
        void descuentoMultiplesImpuestos() {
            // Item: IGV=18%, ISC=13%, descuento=20, valorConIgv=true
            // mini-item: valorUnitario=20
            var igvReq = new ImpuestoItemRequest(1L, 1);
            igvReq.setTasa(new BigDecimal("18"));
            igvReq.setEsFiscalizado(true);
            igvReq.setNombre("IGV");

            var iscReq = new ImpuestoItemRequest(2L, 3);
            iscReq.setTasa(new BigDecimal("13"));
            iscReq.setEsFiscalizado(false);
            iscReq.setNombre("ISC");

            var igvCalc = ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(1L).nombre("IGV").tasa(new BigDecimal("18"))
                    .importe(new BigDecimal("22.8814")).esFiscalizado(true)
                    .build();
            var iscCalc = ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(2L).nombre("ISC").tasa(new BigDecimal("13"))
                    .importe(new BigDecimal("14.6243")).esFiscalizado(false)
                    .build();

            var result = CalculadorDescuento.calcularDescuentoItem(
                    new BigDecimal("20"),
                    List.of(igvCalc, iscCalc),
                    List.of(igvReq, iscReq),
                    true,
                    BigDecimal.ONE,
                    PAIS_PERU
            );

            // discount = 20, IGV=18%, ISC=13%
            // baseSinBaseAffecting = 20/1.18 = 16.9492
            // IGV desc = 16.9492 × 0.18 = 3.0508
            // base = 16.9492/1.13 = 14.9993
            // ISC desc = 14.9993 × 0.13 = 1.9499
            assertThat(result).hasSize(2);

            var igvDesc = result.stream().filter(ImpuestoCalculadoResponse::isEsFiscalizado).findFirst().orElseThrow();
            var iscDesc = result.stream().filter(i -> !i.isEsFiscalizado()).findFirst().orElseThrow();

            assertThat(igvDesc.getImporte()).isEqualByComparingTo(new BigDecimal("3.0508"));
            assertThat(iscDesc.getImporte()).isEqualByComparingTo(new BigDecimal("1.9499"));
        }
    }
}
