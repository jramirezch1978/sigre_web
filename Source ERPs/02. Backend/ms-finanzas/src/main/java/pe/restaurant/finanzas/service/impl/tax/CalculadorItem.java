package pe.restaurant.finanzas.service.impl.tax;

import pe.restaurant.finanzas.dto.request.ImpuestoItemRequest;
import pe.restaurant.finanzas.dto.request.ItemCalculoRequest;
import pe.restaurant.finanzas.dto.response.ImpuestoCalculadoResponse;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/**
 * Calcula los impuestos de un ítem individual.
 * Pura función matemática — sin estado ni dependencias.
 */
public class CalculadorItem {

    private static final int SCALE_DEFAULT = 4;
    private static final RoundingMode RM = RoundingMode.HALF_UP;
    private static final int SCALE_INTERNAL = 10;

    /**
     * Calcula los impuestos para un ítem.
     *
     * @param item       datos del ítem
     * @param paisCodigo código del país
     * @return ItemCalculoResponse con base imponible, impuestos y totales
     */
    public static ItemCalculoResponse calcular(ItemCalculoRequest item, String paisCodigo) {
        BigDecimal precioTotal = item.getValorUnitario().multiply(item.getCantidad());
        int scale = determinarScale(paisCodigo);

        // 1. If impuestos is null or empty → INAFECTO
        if (item.getImpuestos() == null || item.getImpuestos().isEmpty()) {
            BigDecimal total = precioTotal.setScale(scale, RM);
            return ItemCalculoResponse.builder()
                    .item(item.getItem())
                    .baseImponible(total)
                    .montoTotal(total)
                    .esGravado(false)
                    .esInafecto(true)
                    .impuestos(List.of())
                    .descuentos(List.of())
                    .build();
        }

        // 2. Classify taxes
        ClasificadorImpuestos.Clasificacion clasif = ClasificadorImpuestos.clasificar(item.getImpuestos(), paisCodigo);

        // 3. Calculate based on valorConIgv
        boolean incluyeImpuestos = Boolean.TRUE.equals(item.getValorConIgv());

        List<ImpuestoCalculadoResponse> impuestosCalc;
        BigDecimal baseImponible;
        BigDecimal montoTotal;

        if (incluyeImpuestos) {
            var result = calcularConImpuestosIncluidos(precioTotal, clasif, item.getCantidad(), scale);
            baseImponible = result.baseImponible;
            impuestosCalc = result.impuestos;
            montoTotal = result.montoTotal;
        } else {
            var result = calcularSinImpuestosIncluidos(precioTotal, clasif, item.getCantidad(), scale);
            baseImponible = result.baseImponible;
            impuestosCalc = result.impuestos;
            montoTotal = result.montoTotal;
        }

        boolean esGravado = impuestosCalc.stream().anyMatch(ImpuestoCalculadoResponse::isEsFiscalizado);
        boolean esInafecto = impuestosCalc.isEmpty();

        return ItemCalculoResponse.builder()
                .item(item.getItem())
                .baseImponible(baseImponible)
                .montoTotal(montoTotal)
                .esGravado(esGravado)
                .esInafecto(esInafecto)
                .impuestos(impuestosCalc)
                .descuentos(List.of())
                .build();
    }

    private static int determinarScale(String paisCodigo) {
        return "CL".equals(paisCodigo) ? 0 : SCALE_DEFAULT;
    }

    private static CalculoResult calcularConImpuestosIncluidos(
            BigDecimal precioTotal, ClasificadorImpuestos.Clasificacion clasif,
            BigDecimal cantidad, int scale) {

        BigDecimal sumPercent = clasif.tasaIgv.add(clasif.tasaOtros);
        BigDecimal tasaBaseAffecting = clasif.tasaBaseAffecting;

        boolean isChile = scale == 0; // Chile rounds to 0, others to scale 4

        // Use HIGH internal precision (SCALE_INTERNAL) for all intermediate values
        // Only round final outputs to the target scale

        // sumPercent / 100 computed at high precision
        BigDecimal sumPercentFactor = BigDecimal.ONE.add(
                sumPercent.divide(BigDecimal.valueOf(100), SCALE_INTERNAL, RM));
        BigDecimal baseAffectingFactor = BigDecimal.ONE.add(
                tasaBaseAffecting.divide(BigDecimal.valueOf(100), SCALE_INTERNAL, RM));

        // baseSinBaseAffecting = precioTotal / (1 + sumPercent/100)
        BigDecimal baseSinBaseAffecting = precioTotal.divide(sumPercentFactor, SCALE_INTERNAL, RM);

        // base = baseSinBaseAffecting / (1 + tasaBaseAffecting/100)
        BigDecimal base;
        if (tasaBaseAffecting.compareTo(BigDecimal.ZERO) > 0) {
            base = baseSinBaseAffecting.divide(baseAffectingFactor, SCALE_INTERNAL, RM);
        } else {
            base = baseSinBaseAffecting;
        }

        // Final rounded base value
        BigDecimal baseImponible = base.setScale(scale, RM);

        List<ImpuestoCalculadoResponse> impuestosCalc = new ArrayList<>();
        BigDecimal sumMontoFijo = BigDecimal.ZERO;

        // Chile: BASE_AFFECTING taxes modify base before IGV
        if (isChile && !clasif.baseAffectingList.isEmpty()) {
            BigDecimal baseAjustada = baseImponible;
            for (ImpuestoItemRequest imp : clasif.baseAffectingList) {
                BigDecimal importe = baseImponible.multiply(imp.getTasa())
                        .divide(BigDecimal.valueOf(100), scale, RM);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
                baseAjustada = baseAjustada.add(importe);
            }

            for (ImpuestoItemRequest imp : clasif.igvList) {
                BigDecimal importe = baseAjustada.multiply(imp.getTasa())
                        .divide(BigDecimal.valueOf(100), scale, RM);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
            }

            // MONTO_FIJO
            for (ImpuestoItemRequest imp : clasif.montoFijoList) {
                BigDecimal importe = cantidad.multiply(imp.getTasa()).setScale(scale, RM);
                sumMontoFijo = sumMontoFijo.add(importe);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
            }

            // montoTotal for Chile = baseAjustada + IGV importes + montoFijo
            BigDecimal sumIgvImportes = impuestosCalc.stream()
                    .filter(ImpuestoCalculadoResponse::isEsFiscalizado)
                    .map(ImpuestoCalculadoResponse::getImporte)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal montoTotal = baseAjustada.add(sumIgvImportes).add(sumMontoFijo).setScale(scale, RM);

            return new CalculoResult(baseImponible, montoTotal, impuestosCalc);
        }

        // Standard flow: Peru / Default
        // IGV and OTROS on baseSinBaseAffecting
        for (ImpuestoItemRequest imp : clasif.igvList) {
            BigDecimal importe = baseSinBaseAffecting.multiply(imp.getTasa())
                    .divide(BigDecimal.valueOf(100), SCALE_INTERNAL, RM)
                    .setScale(scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        for (ImpuestoItemRequest imp : clasif.otrosList) {
            BigDecimal importe = baseSinBaseAffecting.multiply(imp.getTasa())
                    .divide(BigDecimal.valueOf(100), SCALE_INTERNAL, RM)
                    .setScale(scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // MONTO_FIJO uses cantidad × tasa (not affected by includes/excludes)
        for (ImpuestoItemRequest imp : clasif.montoFijoList) {
            BigDecimal importe = cantidad.multiply(imp.getTasa()).setScale(scale, RM);
            sumMontoFijo = sumMontoFijo.add(importe);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // BASE_AFFECTING on baseImponible
        for (ImpuestoItemRequest imp : clasif.baseAffectingList) {
            BigDecimal importe = baseImponible.multiply(imp.getTasa())
                    .divide(BigDecimal.valueOf(100), scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // montoTotal = base × (1 + tasaBaseAffecting/100) × (1 + sumPercent/100) + sum of MONTO_FIJO
        BigDecimal montoTotal = base;
        if (tasaBaseAffecting.compareTo(BigDecimal.ZERO) > 0) {
            montoTotal = montoTotal.multiply(baseAffectingFactor);
        }
        if (sumPercent.compareTo(BigDecimal.ZERO) > 0) {
            montoTotal = montoTotal.multiply(sumPercentFactor);
        }
        montoTotal = montoTotal.add(sumMontoFijo).setScale(scale, RM);

        return new CalculoResult(baseImponible, montoTotal, impuestosCalc);
    }

    private static CalculoResult calcularSinImpuestosIncluidos(
            BigDecimal precioTotal, ClasificadorImpuestos.Clasificacion clasif,
            BigDecimal cantidad, int scale) {

        BigDecimal baseImponible = precioTotal.setScale(scale, RM);
        boolean isChile = scale == 0;

        BigDecimal tasaBaseAffecting = clasif.tasaBaseAffecting;

        // baseConBaseAffecting at high internal precision for IGV/OTROS calculation
        BigDecimal baseConBaseAffecting;
        if (tasaBaseAffecting.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal baseAffectingRateFactor = BigDecimal.ONE.add(
                    tasaBaseAffecting.divide(BigDecimal.valueOf(100), SCALE_INTERNAL, RM));
            baseConBaseAffecting = precioTotal.multiply(baseAffectingRateFactor);
        } else {
            baseConBaseAffecting = precioTotal;
        }
        BigDecimal baseConBaseAffectingRounded = baseConBaseAffecting.setScale(scale, RM);

        List<ImpuestoCalculadoResponse> impuestosCalc = new ArrayList<>();

        // Chile: BASE_AFFECTING taxes first, modify base before IGV
        if (isChile && !clasif.baseAffectingList.isEmpty()) {
            BigDecimal baseAfectada = baseImponible;
            for (ImpuestoItemRequest imp : clasif.baseAffectingList) {
                BigDecimal importe = baseImponible.multiply(imp.getTasa())
                        .divide(BigDecimal.valueOf(100), scale, RM);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
                baseAfectada = baseAfectada.add(importe);
            }

            for (ImpuestoItemRequest imp : clasif.igvList) {
                BigDecimal importe = baseAfectada.multiply(imp.getTasa())
                        .divide(BigDecimal.valueOf(100), scale, RM);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
            }

            for (ImpuestoItemRequest imp : clasif.otrosList) {
                BigDecimal importe = baseConBaseAffectingRounded.multiply(imp.getTasa())
                        .divide(BigDecimal.valueOf(100), scale, RM);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
            }

            for (ImpuestoItemRequest imp : clasif.montoFijoList) {
                BigDecimal importe = cantidad.multiply(imp.getTasa()).setScale(scale, RM);
                impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(importe)
                        .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                        .build());
            }

            BigDecimal sumTaxes = impuestosCalc.stream()
                    .map(ImpuestoCalculadoResponse::getImporte)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal montoTotal = baseImponible.add(sumTaxes).setScale(scale, RM);
            return new CalculoResult(baseImponible, montoTotal, impuestosCalc);
        }

        // IGV on baseConBaseAffecting
        for (ImpuestoItemRequest imp : clasif.igvList) {
            BigDecimal importe = baseConBaseAffectingRounded.multiply(imp.getTasa())
                    .divide(BigDecimal.valueOf(100), scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // OTROS on baseConBaseAffecting
        for (ImpuestoItemRequest imp : clasif.otrosList) {
            BigDecimal importe = baseConBaseAffectingRounded.multiply(imp.getTasa())
                    .divide(BigDecimal.valueOf(100), scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // MONTO_FIJO
        for (ImpuestoItemRequest imp : clasif.montoFijoList) {
            BigDecimal importe = cantidad.multiply(imp.getTasa()).setScale(scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // BASE_AFFECTING on baseImponible
        for (ImpuestoItemRequest imp : clasif.baseAffectingList) {
            BigDecimal importe = baseImponible.multiply(imp.getTasa())
                    .divide(BigDecimal.valueOf(100), scale, RM);
            impuestosCalc.add(ImpuestoCalculadoResponse.builder()
                    .tipoImpuestoId(imp.getTipoImpuestoId())
                    .nombre(imp.getNombre())
                    .tasa(imp.getTasa())
                    .importe(importe)
                    .esFiscalizado(Boolean.TRUE.equals(imp.getEsFiscalizado()))
                    .build());
        }

        // montoTotal = base + sum of all taxes
        BigDecimal sumTaxes = impuestosCalc.stream()
                .map(ImpuestoCalculadoResponse::getImporte)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal montoTotal = baseImponible.add(sumTaxes).setScale(scale, RM);

        return new CalculoResult(baseImponible, montoTotal, impuestosCalc);
    }

    private static class CalculoResult {
        final BigDecimal baseImponible;
        final BigDecimal montoTotal;
        final List<ImpuestoCalculadoResponse> impuestos;

        CalculoResult(BigDecimal baseImponible, BigDecimal montoTotal, List<ImpuestoCalculadoResponse> impuestos) {
            this.baseImponible = baseImponible;
            this.montoTotal = montoTotal;
            this.impuestos = impuestos;
        }
    }
}
