package pe.restaurant.finanzas.service.impl.tax;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import pe.restaurant.finanzas.dto.response.ImpuestoCalculadoResponse;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Pruebas Unitarias - ConsolidadorImpuestos")
class ConsolidadorImpuestosTest {

    private ImpuestoCalculadoResponse impuesto(Long id, String nombre, BigDecimal tasa, BigDecimal importe,
                                                boolean fiscalizado) {
        return ImpuestoCalculadoResponse.builder()
                .tipoImpuestoId(id)
                .nombre(nombre)
                .tasa(tasa)
                .importe(importe)
                .esFiscalizado(fiscalizado)
                .build();
    }

    @Nested
    @DisplayName("Consolidación básica")
    class ConsolidacionBasica {

        @Test
        @DisplayName("Item único → consolidado coincide con item")
        void itemUnico() {
            var item = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("100.0000"))
                    .montoTotal(new BigDecimal("118.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("18.0000"), true)
                    ))
                    .descuentos(List.of())
                    .build();

            var result = ConsolidadorImpuestos.consolidar(List.of(item), BigDecimal.ZERO, true);

            assertThat(result.getSubtotal()).isEqualByComparingTo(new BigDecimal("100.0000"));
            assertThat(result.getTotalIgv()).isEqualByComparingTo(new BigDecimal("18.0000"));
            assertThat(result.getTotalConImpuestos()).isEqualByComparingTo(new BigDecimal("118.0000"));
            assertThat(result.getImpuestos()).hasSize(1);
            assertThat(result.getImpuestos().get(0).getImporte()).isEqualByComparingTo(new BigDecimal("18.0000"));
        }

        @Test
        @DisplayName("Múltiples items → impuestos sumados")
        void multiplesItems() {
            var item1 = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("100.0000"))
                    .montoTotal(new BigDecimal("118.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("18.0000"), true)
                    ))
                    .descuentos(List.of())
                    .build();
            var item2 = ItemCalculoResponse.builder()
                    .item(2)
                    .baseImponible(new BigDecimal("200.0000"))
                    .montoTotal(new BigDecimal("236.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("36.0000"), true)
                    ))
                    .descuentos(List.of())
                    .build();

            var result = ConsolidadorImpuestos.consolidar(List.of(item1, item2), BigDecimal.ZERO, true);

            assertThat(result.getSubtotal()).isEqualByComparingTo(new BigDecimal("300.0000"));
            assertThat(result.getTotalIgv()).isEqualByComparingTo(new BigDecimal("54.0000"));
            assertThat(result.getTotalConImpuestos()).isEqualByComparingTo(new BigDecimal("354.0000"));
            assertThat(result.getImpuestos()).hasSize(1);
            assertThat(result.getImpuestos().get(0).getImporte()).isEqualByComparingTo(new BigDecimal("54.0000"));
        }

        @Test
        @DisplayName("Múltiples tipos de impuestos se agrupan por tipoImpuestoId")
        void agrupaPorTipoImpuestoId() {
            var item = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("112.4944"))
                    .montoTotal(new BigDecimal("150.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("22.8814"), true),
                            impuesto(2L, "ISC", new BigDecimal("13"), new BigDecimal("14.6243"), false)
                    ))
                    .descuentos(List.of())
                    .build();

            var result = ConsolidadorImpuestos.consolidar(List.of(item), BigDecimal.ZERO, true);

            assertThat(result.getImpuestos()).hasSize(2);
            assertThat(result.getTotalConImpuestos()).isEqualByComparingTo(new BigDecimal("150.0000"));
        }
    }

    @Nested
    @DisplayName("totalIgV = solo fiscalizados")
    class TotalIgv {

        @Test
        @DisplayName("Solo impuestos fiscalizados cuentan para totalIgv")
        void soloFiscalizados() {
            var item = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("100.0000"))
                    .montoTotal(new BigDecimal("130.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("18.0000"), true),
                            impuesto(2L, "ISC", new BigDecimal("12"), new BigDecimal("12.0000"), false)
                    ))
                    .descuentos(List.of())
                    .build();

            var result = ConsolidadorImpuestos.consolidar(List.of(item), BigDecimal.ZERO, true);

            assertThat(result.getTotalIgv()).isEqualByComparingTo(new BigDecimal("18.0000"));
            assertThat(result.getTotalConImpuestos()).isEqualByComparingTo(new BigDecimal("130.0000"));
        }
    }

    @Nested
    @DisplayName("Descuento global")
    class DescuentoGlobal {

        @Test
        @DisplayName("Sin descuento global → campos null/cero")
        void sinDescuento() {
            var item = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("100.0000"))
                    .montoTotal(new BigDecimal("118.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("18.0000"), true)
                    ))
                    .descuentos(List.of())
                    .build();

            var result = ConsolidadorImpuestos.consolidar(List.of(item), BigDecimal.ZERO, true);

            assertThat(result.getDescuentoGlobalSinImpuestos()).isNull();
            assertThat(result.getDescuentoGlobalConImpuestos()).isNull();
        }

        @Test
        @DisplayName("Con descuento global → calcula valores con/sin impuestos")
        void conDescuento() {
            var item = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("100.0000"))
                    .montoTotal(new BigDecimal("118.0000"))
                    .esGravado(true)
                    .impuestos(List.of(
                            impuesto(1L, "IGV", new BigDecimal("18"), new BigDecimal("18.0000"), true)
                    ))
                    .descuentos(List.of())
                    .build();

            // descuentoGlobal = 10
            // descuentoGlobalSinImpuestos = 10 (base portion)
            // proportion: base/total = 100/118 = 0.8474576...
            // descuentoSin = 10 × (100/118) = 8.4746
            // descuentoCon = 10
            var result = ConsolidadorImpuestos.consolidar(List.of(item), new BigDecimal("10"), true);

            assertThat(result.getDescuentoGlobalSinImpuestos()).isNotNull();
            assertThat(result.getDescuentoGlobalSinImpuestos()).isEqualByComparingTo(new BigDecimal("8.4746"));
            assertThat(result.getDescuentoGlobalConImpuestos()).isEqualByComparingTo(new BigDecimal("10.0000"));
        }
    }

    @Nested
    @DisplayName("Items sin impuestos")
    class ItemsSinImpuestos {

        @Test
        @DisplayName("Todo inafecto → consolidado refleja")
        void todoInafecto() {
            var item = ItemCalculoResponse.builder()
                    .item(1)
                    .baseImponible(new BigDecimal("200.0000"))
                    .montoTotal(new BigDecimal("200.0000"))
                    .esGravado(false)
                    .esInafecto(true)
                    .impuestos(List.of())
                    .descuentos(List.of())
                    .build();

            var result = ConsolidadorImpuestos.consolidar(List.of(item), BigDecimal.ZERO, true);

            assertThat(result.getSubtotal()).isEqualByComparingTo(new BigDecimal("200.0000"));
            assertThat(result.getTotalIgv()).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(result.getTotalConImpuestos()).isEqualByComparingTo(new BigDecimal("200.0000"));
            assertThat(result.getImpuestos()).isEmpty();
        }
    }
}
