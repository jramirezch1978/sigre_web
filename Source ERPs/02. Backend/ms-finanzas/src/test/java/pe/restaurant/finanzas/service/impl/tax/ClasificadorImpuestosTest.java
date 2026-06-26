package pe.restaurant.finanzas.service.impl.tax;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import pe.restaurant.finanzas.dto.request.ImpuestoItemRequest;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Pruebas Unitarias - ClasificadorImpuestos")
class ClasificadorImpuestosTest {

    private static final String PAIS_PERU = "PE";
    private static final String PAIS_CHILE = "CL";
    private static final String PAIS_DEFAULT = "DEFAULT";

    // Helper: crea un ImpuestoItemRequest rápido
    private ImpuestoItemRequest impuesto(BigDecimal tasa, boolean esFiscalizado, Integer tipoCalculo) {
        var r = new ImpuestoItemRequest(1L, tipoCalculo);
        r.setTasa(tasa);
        r.setEsFiscalizado(esFiscalizado);
        r.setNombre("Test");
        return r;
    }

    @Nested
    @DisplayName("Perú / Default")
    class PeruTest {

        @Test
        @DisplayName("IGV: tipoCalculo=1, esFiscalizado=true")
        void peru_igv() {
            var igv = impuesto(new BigDecimal("18"), true, 1);
            var baseAff = impuesto(new BigDecimal("13"), false, 3);
            var otros = impuesto(new BigDecimal("5"), false, 1);

            var clasif = ClasificadorImpuestos.clasificar(List.of(igv, baseAff, otros), PAIS_PERU);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(new BigDecimal("18"));
            assertThat(clasif.tasaBaseAffecting).isEqualByComparingTo(new BigDecimal("13"));
            assertThat(clasif.tasaOtros).isEqualByComparingTo(new BigDecimal("5"));
            assertThat(clasif.igvList).hasSize(1);
            assertThat(clasif.baseAffectingList).hasSize(1);
            assertThat(clasif.otrosList).hasSize(1);
        }

        @Test
        @DisplayName("MONTO_FIJO: tipoCalculo=2")
        void peru_montoFijo() {
            var montoFijo = impuesto(new BigDecimal("10"), false, 2);

            var clasif = ClasificadorImpuestos.clasificar(List.of(montoFijo), PAIS_PERU);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(clasif.montoFijoList).hasSize(1);
            assertThat(clasif.montoFijoList.get(0).getTasa()).isEqualByComparingTo(new BigDecimal("10"));
        }

        @Test
        @DisplayName("BASE_AFFECTING: tipoCalculo=3")
        void peru_baseAffecting() {
            var baseAff = impuesto(new BigDecimal("5"), false, 3);

            var clasif = ClasificadorImpuestos.clasificar(List.of(baseAff), PAIS_PERU);

            assertThat(clasif.tasaBaseAffecting).isEqualByComparingTo(new BigDecimal("5"));
            assertThat(clasif.baseAffectingList).hasSize(1);
        }

        @Test
        @DisplayName("IGV no fiscalizado NO se cuenta como IGV")
        void peru_igvNoFiscalizado() {
            var noFiscal = impuesto(new BigDecimal("18"), false, 1);

            var clasif = ClasificadorImpuestos.clasificar(List.of(noFiscal), PAIS_PERU);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(clasif.igvList).isEmpty();
            // Debería caer como OTROS
            assertThat(clasif.tasaOtros).isEqualByComparingTo(new BigDecimal("18"));
            assertThat(clasif.otrosList).hasSize(1);
        }

        @Test
        @DisplayName("Múltiples impuestos del mismo tipo suman tasas")
        void peru_multiplesIgvSumanTasas() {
            var igv1 = impuesto(new BigDecimal("18"), true, 1);
            var igv2 = impuesto(new BigDecimal("2"), true, 1);

            var clasif = ClasificadorImpuestos.clasificar(List.of(igv1, igv2), PAIS_PERU);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(new BigDecimal("20"));
            assertThat(clasif.igvList).hasSize(2);
        }
    }

    @Nested
    @DisplayName("Chile")
    class ChileTest {

        @Test
        @DisplayName("IGV: esFiscalizado=true AND tipoCalculo=1")
        void chile_igv_fiscalizado() {
            var fiscalizado1 = impuesto(new BigDecimal("19"), true, 1);

            var clasif = ClasificadorImpuestos.clasificar(List.of(fiscalizado1), PAIS_CHILE);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(new BigDecimal("19"));
            assertThat(clasif.igvList).hasSize(1);
        }

        @Test
        @DisplayName("Fiscalizado con tipoCalculo=3 va a BASE_AFFECTING")
        void chile_fiscalizadoTipo3() {
            var fiscalizado3 = impuesto(new BigDecimal("5"), true, 3);

            var clasif = ClasificadorImpuestos.clasificar(List.of(fiscalizado3), PAIS_CHILE);

            assertThat(clasif.tasaBaseAffecting).isEqualByComparingTo(new BigDecimal("5"));
            assertThat(clasif.baseAffectingList).hasSize(1);
            assertThat(clasif.igvList).isEmpty();
        }

        @Test
        @DisplayName("BASE_AFFECTING: tipoCalculo=3 AND NOT esFiscalizado")
        void chile_baseAffecting() {
            var baseAff = impuesto(new BigDecimal("10"), false, 3);

            var clasif = ClasificadorImpuestos.clasificar(List.of(baseAff), PAIS_CHILE);

            assertThat(clasif.tasaBaseAffecting).isEqualByComparingTo(new BigDecimal("10"));
            assertThat(clasif.baseAffectingList).hasSize(1);
            assertThat(clasif.igvList).isEmpty();
        }

        @Test
        @DisplayName("OTROS: todo lo que no es IGV ni BASE_AFFECTING")
        void chile_otros() {
            var noFiscal = impuesto(new BigDecimal("5"), false, 1);
            var montoFijo = impuesto(new BigDecimal("10"), false, 2);

            var clasif = ClasificadorImpuestos.clasificar(List.of(noFiscal, montoFijo), PAIS_CHILE);

            assertThat(clasif.tasaOtros).isEqualByComparingTo(new BigDecimal("5"));
            assertThat(clasif.otrosList).hasSize(1);
            assertThat(clasif.montoFijoList).hasSize(1);
        }

        @Test
        @DisplayName("No fiscalizado tipoCalculo=1 se marca como OTROS")
        void chile_noFiscalizado() {
            var noFiscal = impuesto(new BigDecimal("8"), false, 1);

            var clasif = ClasificadorImpuestos.clasificar(List.of(noFiscal), PAIS_CHILE);

            assertThat(clasif.tasaOtros).isEqualByComparingTo(new BigDecimal("8"));
            assertThat(clasif.otrosList).hasSize(1);
        }
    }

    @Nested
    @DisplayName("Casos borde")
    class EdgeCases {

        @Test
        @DisplayName("Lista vacía → clasificación vacía")
        void listaVacia() {
            var clasif = ClasificadorImpuestos.clasificar(Collections.emptyList(), PAIS_PERU);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(clasif.tasaBaseAffecting).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(clasif.tasaOtros).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(clasif.igvList).isEmpty();
            assertThat(clasif.baseAffectingList).isEmpty();
            assertThat(clasif.otrosList).isEmpty();
            assertThat(clasif.montoFijoList).isEmpty();
        }

        @Test
        @DisplayName("Lista null → clasificación vacía")
        void listaNull() {
            var clasif = ClasificadorImpuestos.clasificar(null, PAIS_PERU);

            assertThat(clasif.tasaIgv).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(clasif.igvList).isEmpty();
        }

        @Test
        @DisplayName("Default funciona igual que Perú")
        void defaultEsIgualAPeru() {
            var igv = impuesto(new BigDecimal("18"), true, 1);
            var baseAff = impuesto(new BigDecimal("13"), false, 3);

            var clasifDefault = ClasificadorImpuestos.clasificar(List.of(igv, baseAff), PAIS_DEFAULT);
            var clasifPeru = ClasificadorImpuestos.clasificar(List.of(igv, baseAff), PAIS_PERU);

            assertThat(clasifDefault.tasaIgv).isEqualByComparingTo(clasifPeru.tasaIgv);
            assertThat(clasifDefault.tasaBaseAffecting).isEqualByComparingTo(clasifPeru.tasaBaseAffecting);
        }
    }
}
