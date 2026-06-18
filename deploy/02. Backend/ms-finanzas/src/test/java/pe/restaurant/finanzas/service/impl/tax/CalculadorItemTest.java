package pe.restaurant.finanzas.service.impl.tax;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import pe.restaurant.finanzas.dto.request.ImpuestoItemRequest;
import pe.restaurant.finanzas.dto.request.ItemCalculoRequest;
import pe.restaurant.finanzas.dto.response.ImpuestoCalculadoResponse;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Pruebas Unitarias - CalculadorItem")
class CalculadorItemTest {

    private static final String PAIS_PERU = "PE";
    private static final String PAIS_CHILE = "CL";

    private ImpuestoItemRequest igv(BigDecimal tasa) {
        var r = new ImpuestoItemRequest(1L, 1);
        r.setTasa(tasa);
        r.setEsFiscalizado(true);
        r.setNombre("IGV");
        return r;
    }

    private ImpuestoItemRequest baseAffecting(BigDecimal tasa) {
        var r = new ImpuestoItemRequest(5L, 3);
        r.setTasa(tasa);
        r.setEsFiscalizado(false);
        r.setNombre("BASE_AFF");
        return r;
    }

    private ImpuestoItemRequest otros(BigDecimal tasa) {
        var r = new ImpuestoItemRequest(3L, 1);
        r.setTasa(tasa);
        r.setEsFiscalizado(false);
        r.setNombre("OTROS");
        return r;
    }

    private ImpuestoItemRequest montoFijoReq(BigDecimal tasa) {
        var r = new ImpuestoItemRequest(4L, 2);
        r.setTasa(tasa);
        r.setEsFiscalizado(false);
        r.setNombre("MONTO_FIJO");
        return r;
    }

    @Nested
    @DisplayName("Sin impuestos → INAFECTO")
    class SinImpuestos {

        @Test
        @DisplayName("Impuestos null → esInafecto=true, base=precioTotal")
        void impuestosNull() {
            var item = new ItemCalculoRequest(1, new BigDecimal("100"), new BigDecimal("2"),
                    true, BigDecimal.ZERO, "$", null, null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.isEsInafecto()).isTrue();
            assertThat(result.isEsGravado()).isFalse();
            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("200.0000"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("200.0000"));
            assertThat(result.getImpuestos()).isEmpty();
        }

        @Test
        @DisplayName("Impuestos vacío → esInafecto=true")
        void impuestosVacio() {
            var item = new ItemCalculoRequest(1, new BigDecimal("50"), new BigDecimal("3"),
                    false, BigDecimal.ZERO, "$", List.of(), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.isEsInafecto()).isTrue();
            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("150.0000"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("150.0000"));
        }
    }

    @Nested
    @DisplayName("Perú: IGV solamente")
    class PeruSoloIGV {

        @Test
        @DisplayName("valorConIgv=true → extraer base correctamente")
        void incluyeImpuestos() {
            // precioTotal=118.00, IGV=18%
            // baseSinBaseAffecting = 118/1.18 = 100.0000, IGV = 100 × 0.18 = 18.0000
            var item = new ItemCalculoRequest(1, new BigDecimal("118"), BigDecimal.ONE,
                    true, BigDecimal.ZERO, "$", List.of(igv(new BigDecimal("18"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.isEsGravado()).isTrue();
            assertThat(result.isEsInafecto()).isFalse();
            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("100.0000"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("118.0000"));
            assertThat(result.getImpuestos()).hasSize(1);
            assertThat(result.getImpuestos().get(0).getImporte()).isEqualByComparingTo(new BigDecimal("18.0000"));
            assertThat(result.getImpuestos().get(0).getTasa()).isEqualByComparingTo(new BigDecimal("18"));
            assertThat(result.getImpuestos().get(0).isEsFiscalizado()).isTrue();
        }

        @Test
        @DisplayName("valorConIgv=false → sumar impuesto a base")
        void noIncluyeImpuestos() {
            // precioTotal=100.00, IGV=18%
            // baseImponible=100, IGV = 100 × 0.18 = 18, montoTotal = 118
            var item = new ItemCalculoRequest(1, new BigDecimal("100"), BigDecimal.ONE,
                    false, BigDecimal.ZERO, "$", List.of(igv(new BigDecimal("18"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("100.0000"));
            assertThat(result.getImpuestos()).hasSize(1);
            assertThat(result.getImpuestos().get(0).getImporte()).isEqualByComparingTo(new BigDecimal("18.0000"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("118.0000"));
        }

        @Test
        @DisplayName("Múltiples cantidades con IGV")
        void multiplesCantidades() {
            // precioTotal = 118 × 5 = 590, IGV=18%
            var item = new ItemCalculoRequest(1, new BigDecimal("118"), new BigDecimal("5"),
                    true, BigDecimal.ZERO, "$", List.of(igv(new BigDecimal("18"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            // baseSinBaseAffecting = 590 / 1.18 = 500.0000
            // base = 500.0000
            // IGV = 500 × 0.18 = 90.0000
            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("500.0000"));
            assertThat(result.getImpuestos().get(0).getImporte()).isEqualByComparingTo(new BigDecimal("90.0000"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("590.0000"));
        }
    }

    @Nested
    @DisplayName("Perú: IGV + BASE_AFFECTING (formerly ISC)")
    class PeruIGVyBaseAffecting {

        @Test
        @DisplayName("valorConIgv=true → extraer base con IGV+BASE_AFFECTING")
        void incluyeImpuestos() {
            // precioTotal=150.00, IGV=18%, BASE_AFFECTING=13%
            // sumPercent = 18, tasaBaseAffecting = 13
            // baseSinBaseAffecting = 150 / 1.18 = 127.11864406779661
            // base = 127.11864406779661 / 1.13 = 112.49437501574833
            // baseImponible = 112.4944
            // IGV = 127.11864406779661 × 0.18 = 22.881356 → 22.8814
            // BASE_AFFECTING = 112.49437501574833 × 0.13 = 14.624269 → 14.6243
            // montoTotal = 112.49437501574833 × 1.13 × 1.18 = 150.000000 → 150.0000
            var item = new ItemCalculoRequest(1, new BigDecimal("150"), BigDecimal.ONE,
                    true, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(igv(new BigDecimal("18")), baseAffecting(new BigDecimal("13"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("112.4944"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("150.0000"));

            var igvResult = result.getImpuestos().stream()
                    .filter(ImpuestoCalculadoResponse::isEsFiscalizado)
                    .findFirst().orElseThrow();
            var baseAffResult = result.getImpuestos().stream()
                    .filter(i -> !i.isEsFiscalizado())
                    .filter(i -> i.getNombre().equals("BASE_AFF"))
                    .findFirst().orElseThrow();

            assertThat(igvResult.getImporte()).isEqualByComparingTo(new BigDecimal("22.8814"));
            assertThat(baseAffResult.getImporte()).isEqualByComparingTo(new BigDecimal("14.6243"));
        }

        @Test
        @DisplayName("valorConIgv=false → IGV sobre base+BASE_AFFECTING")
        void noIncluyeImpuestos() {
            // precioTotal=100.00, IGV=18%, BASE_AFFECTING=13%
            // baseImponible = 100
            // BASE_AFFECTING = 100 × 0.13 = 13
            // baseConBaseAffecting = 100 × (1 + 0.13) = 113
            // IGV = 113 × 0.18 = 20.34
            // montoTotal = 100 + 13 + 20.34 = 133.34
            var item = new ItemCalculoRequest(1, new BigDecimal("100"), BigDecimal.ONE,
                    false, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(igv(new BigDecimal("18")), baseAffecting(new BigDecimal("13"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("100.0000"));

            var igvResult = result.getImpuestos().stream()
                    .filter(ImpuestoCalculadoResponse::isEsFiscalizado)
                    .findFirst().orElseThrow();
            var baseAffResult = result.getImpuestos().stream()
                    .filter(i -> !i.isEsFiscalizado())
                    .filter(i -> i.getNombre().equals("BASE_AFF"))
                    .findFirst().orElseThrow();

            assertThat(baseAffResult.getImporte()).isEqualByComparingTo(new BigDecimal("13.0000"));
            assertThat(igvResult.getImporte()).isEqualByComparingTo(new BigDecimal("20.3400"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("133.3400"));
        }
    }

    @Nested
    @DisplayName("Perú: MONTO_FIJO")
    class PeruMontoFijo {

        @Test
        @DisplayName("MONTO_FIJO = cantidad × tasa, no afecta base")
        void montoFijo() {
            // precioTotal = 100 × 2 = 200, IGV=18%, MONTO_FIJO=5
            // baseSinBaseAffecting = 200/1.18 = 169.4915
            // base = 169.4915 (no baseAffecting)
            // IGV = 169.4915 × 0.18 = 30.5085
            // MONTO_FIJO = 2 × 5 = 10.0000
            // montoTotal = 169.4915 × 1.18 + 10 = 200.0000 + 10 = 210.0000
            var item = new ItemCalculoRequest(1, new BigDecimal("100"), new BigDecimal("2"),
                    true, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(igv(new BigDecimal("18")), montoFijoReq(new BigDecimal("5"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("169.4915"));

            var montoFijoResult = result.getImpuestos().stream()
                    .filter(i -> "MONTO_FIJO".equals(i.getNombre()))
                    .findFirst().orElseThrow();
            assertThat(montoFijoResult.getImporte()).isEqualByComparingTo(new BigDecimal("10.0000"));

            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("210.0000"));
        }

        @Test
        @DisplayName("MONTO_FIJO con valorConIgv=false")
        void montoFijoNoIncluye() {
            // precioTotal = 200, IGV=18%, MONTO_FIJO=5, cantidad=2
            // baseImponible = 200
            // IGV = 200 × 0.18 = 36
            // MONTO_FIJO = 2 × 5 = 10
            // montoTotal = 200 + 36 + 10 = 246
            var item = new ItemCalculoRequest(1, new BigDecimal("100"), new BigDecimal("2"),
                    false, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(igv(new BigDecimal("18")), montoFijoReq(new BigDecimal("5"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("200.0000"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("246.0000"));

            var montoFijoResult2 = result.getImpuestos().stream()
                    .filter(i -> "MONTO_FIJO".equals(i.getNombre()))
                    .findFirst().orElseThrow();
            assertThat(montoFijoResult2.getImporte()).isEqualByComparingTo(new BigDecimal("10.0000"));
        }
    }

    @Nested
    @DisplayName("Chile Factura")
    class ChileFactura {

        @Test
        @DisplayName("Redondeo a scale=0 (entero)")
        void redondeoEntero() {
            // precioTotal=1190, IGV=19%, Chile
            // baseSinBaseAffecting = 1190 / 1.19 = 1000
            // IGV = 1000 × 0.19 = 190
            // All values scale=0
            var igvReq = new ImpuestoItemRequest(1L, 1);
            igvReq.setTasa(new BigDecimal("19"));
            igvReq.setEsFiscalizado(true);
            igvReq.setNombre("IVA");

            var item = new ItemCalculoRequest(1, new BigDecimal("1190"), BigDecimal.ONE,
                    true, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(igvReq), null);

            var result = CalculadorItem.calcular(item, PAIS_CHILE);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("1000"));
            assertThat(result.getImpuestos().get(0).getImporte()).isEqualByComparingTo(new BigDecimal("190"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("1190"));
        }

        @Test
        @DisplayName("BASE_AFFECTING modifica base antes de IGV")
        void baseAffectingModificaBase() {
            // precioTotal=1000, IGV=19%, BASE_AFFECTING=10%
            // Chile: IGV = fiscalizado=true AND (tipoCalc=1 OR 3)
            // BASE_AFFECTING = tipoCalc=3 AND NOT fiscalizado
            //
            // valorConIgv=false:
            // base = 1000
            // BASE_AFF = 1000 × 0.10 = 100
            // modified base = 1000 + 100 = 1100
            // IGV = 1100 × 0.19 = 209
            // montoTotal = 1000 + 100 + 209 = 1309
            var ivaReq = new ImpuestoItemRequest(1L, 1);
            ivaReq.setTasa(new BigDecimal("19"));
            ivaReq.setEsFiscalizado(true);
            ivaReq.setNombre("IVA");

            var item = new ItemCalculoRequest(1, new BigDecimal("1000"), BigDecimal.ONE,
                    false, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(ivaReq, baseAffecting(new BigDecimal("10"))), null);

            var result = CalculadorItem.calcular(item, PAIS_CHILE);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("1000"));

            var ivaResult = result.getImpuestos().stream()
                    .filter(ImpuestoCalculadoResponse::isEsFiscalizado)
                    .findFirst().orElseThrow();
            assertThat(ivaResult.getImporte()).isEqualByComparingTo(new BigDecimal("209"));

            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("1309"));
        }
    }

    @Nested
    @DisplayName("OTROS impuestos")
    class OtrosImpuestos {

        @Test
        @DisplayName("OTROS con valorConIgv=true")
        void otrosIncluye() {
            // precioTotal=126, IGV=18%, OTROS=5%
            // sumPercent = 18 + 5 = 23
            // baseSinBaseAffecting = 126 / 1.23 = 102.4390...
            // IGV = 102.4390 × 0.18 = 18.4390
            // OTROS = 102.4390 × 0.05 = 5.1220
            // montoTotal = 102.4390 × 1.23 = 126.0000
            var item = new ItemCalculoRequest(1, new BigDecimal("126"), BigDecimal.ONE,
                    true, BigDecimal.ZERO, "$", // dsctoTipo
                    List.of(igv(new BigDecimal("18")), otros(new BigDecimal("5"))), null);

            var result = CalculadorItem.calcular(item, PAIS_PERU);

            assertThat(result.getBaseImponible()).isEqualByComparingTo(new BigDecimal("102.4390"));

            var igvR = result.getImpuestos().stream()
                    .filter(ImpuestoCalculadoResponse::isEsFiscalizado)
                    .findFirst().orElseThrow();
            var otrosR = result.getImpuestos().stream()
                    .filter(i -> !i.isEsFiscalizado())
                    .findFirst().orElseThrow();

            assertThat(igvR.getImporte()).isEqualByComparingTo(new BigDecimal("18.4390"));
            assertThat(otrosR.getImporte()).isEqualByComparingTo(new BigDecimal("5.1220"));
            assertThat(result.getMontoTotal()).isEqualByComparingTo(new BigDecimal("126.0000"));
        }
    }
}
