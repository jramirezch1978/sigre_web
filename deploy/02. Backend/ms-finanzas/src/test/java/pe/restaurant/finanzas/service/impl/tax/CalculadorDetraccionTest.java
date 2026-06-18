package pe.restaurant.finanzas.service.impl.tax;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import pe.restaurant.finanzas.dto.request.DetraccionItemRequest;
import pe.restaurant.finanzas.dto.request.ItemCalculoRequest;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Pruebas Unitarias - CalculadorDetraccion")
class CalculadorDetraccionTest {

    @Nested
    @DisplayName("No aplica detracción")
    class NoAplica {

        @Test
        @DisplayName("Items sin detracción → aplica=false")
        void sinDetraccion() {
            var items = List.of(
                    new ItemCalculoRequest(1, new BigDecimal("1000"), BigDecimal.ONE, false, BigDecimal.ZERO, "$", List.of(), null)
            );
            var itemsCalc = items.stream().map(CalculadorDetraccionTest::toCalculoResponse).toList();
            var totalConImpuestos = itemsCalc.stream().map(ItemCalculoResponse::getMontoTotal).reduce(BigDecimal.ZERO, BigDecimal::add);

            var result = CalculadorDetraccion.calcular(items, itemsCalc, totalConImpuestos);

            assertThat(result.isAplica()).isFalse();
            assertThat(result.getPorcentaje()).isNull();
            assertThat(result.getMonto()).isNull();
            assertThat(result.getCodigoServicio()).isNull();
        }

        @Test
        @DisplayName("Precio menor que monto mínimo → no aplica")
        void precioMenorQueMinimo() {
            var detraccion = new DetraccionItemRequest(new BigDecimal("10"), new BigDecimal("1000"), "001");
            var item = new ItemCalculoRequest(1, new BigDecimal("500"), BigDecimal.ONE, false, BigDecimal.ZERO, "$", List.of(), detraccion);
            var itemsCalc = List.of(toCalculoResponse(item));
            var totalConImpuestos = new BigDecimal("500");

            var result = CalculadorDetraccion.calcular(List.of(item), itemsCalc, totalConImpuestos);

            assertThat(result.isAplica()).isFalse();
        }

        @Test
        @DisplayName("Lista vacía → aplica=false")
        void listaVacia() {
            var result = CalculadorDetraccion.calcular(List.of(), List.of(), BigDecimal.ZERO);

            assertThat(result.isAplica()).isFalse();
        }
    }

    @Nested
    @DisplayName("Aplica detracción")
    class Aplica {

        @Test
        @DisplayName("Un item con detracción y precio suficiente")
        void unItem() {
            var detraccion = new DetraccionItemRequest(new BigDecimal("10"), new BigDecimal("500"), "001");
            var item = new ItemCalculoRequest(1, new BigDecimal("1000"), BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), detraccion);
            var itemsCalc = List.of(toCalculoResponse(item));
            var totalConImpuestos = new BigDecimal("1000");

            var result = CalculadorDetraccion.calcular(List.of(item), itemsCalc, totalConImpuestos);

            assertThat(result.isAplica()).isTrue();
            assertThat(result.getPorcentaje()).isEqualByComparingTo(new BigDecimal("10"));
            // monto = totalVenta × porcentaje / 100
            // totalVenta = 1000 (valorConIgv, no hay impuestos → montoTotal = 1000)
            // monto = 1000 × 0.10 = 100
            assertThat(result.getMonto()).isEqualByComparingTo(new BigDecimal("100.0000"));
            assertThat(result.getCodigoServicio()).isEqualTo("001");
        }

        @Test
        @DisplayName("Múltiples items → usa porcentaje máximo")
        void multipleItemsUsaMaxPorcentaje() {
            var det1 = new DetraccionItemRequest(new BigDecimal("10"), new BigDecimal("500"), "001");
            var det2 = new DetraccionItemRequest(new BigDecimal("12"), new BigDecimal("500"), "002");
            var item1 = new ItemCalculoRequest(1, new BigDecimal("1000"), BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), det1);
            var item2 = new ItemCalculoRequest(2, new BigDecimal("2000"), BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), det2);
            var itemsCalc = List.of(toCalculoResponse(item1), toCalculoResponse(item2));
            var totalConImpuestos = new BigDecimal("3000");

            var result = CalculadorDetraccion.calcular(List.of(item1, item2), itemsCalc, totalConImpuestos);

            assertThat(result.isAplica()).isTrue();
            assertThat(result.getPorcentaje()).isEqualByComparingTo(new BigDecimal("12"));
            // totalVenta = 1000 + 2000 = 3000
            // monto = 3000 × 0.12 = 360
            assertThat(result.getMonto()).isEqualByComparingTo(new BigDecimal("360.0000"));
            assertThat(result.getCodigoServicio()).isEqualTo("002");
        }

        @Test
        @DisplayName("Solo items que cumplen mínimo participan")
        void soloItemsQueCumplenMinimo() {
            var det1 = new DetraccionItemRequest(new BigDecimal("15"), new BigDecimal("2000"), "001");
            var det2 = new DetraccionItemRequest(new BigDecimal("10"), new BigDecimal("500"), "002");
            // item1: precio=1500 < montoMinimo=2000 → no aplica
            // item2: precio=3000 >= montoMinimo=500 → aplica
            var item1 = new ItemCalculoRequest(1, new BigDecimal("1500"), BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), det1);
            var item2 = new ItemCalculoRequest(2, new BigDecimal("3000"), BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), det2);
            var itemsCalc = List.of(toCalculoResponse(item1), toCalculoResponse(item2));
            var totalConImpuestos = new BigDecimal("4500");

            var result = CalculadorDetraccion.calcular(List.of(item1, item2), itemsCalc, totalConImpuestos);

            assertThat(result.isAplica()).isTrue();
            assertThat(result.getPorcentaje()).isEqualByComparingTo(new BigDecimal("10"));
            assertThat(result.getCodigoServicio()).isEqualTo("002");
        }

        @Test
        @DisplayName("Precio exactamente igual al mínimo → aplica")
        void precioIgualAlMinimo() {
            var detraccion = new DetraccionItemRequest(new BigDecimal("10"), new BigDecimal("1000"), "001");
            var item = new ItemCalculoRequest(1, new BigDecimal("1000"), BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), detraccion);
            var itemsCalc = List.of(toCalculoResponse(item));
            var totalConImpuestos = new BigDecimal("1000");

            var result = CalculadorDetraccion.calcular(List.of(item), itemsCalc, totalConImpuestos);

            assertThat(result.isAplica()).isTrue();
        }
    }

    private static ItemCalculoResponse toCalculoResponse(ItemCalculoRequest req) {
        var baseImponible = req.getValorUnitario().multiply(req.getCantidad());
        return ItemCalculoResponse.builder()
                .item(req.getItem())
                .baseImponible(baseImponible)
                .montoTotal(baseImponible)
                .esGravado(Boolean.TRUE.equals(req.getValorConIgv()))
                .impuestos(List.of())
                .build();
    }
}
