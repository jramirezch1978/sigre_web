package pe.restaurant.finanzas.service.impl.tax;

import pe.restaurant.finanzas.dto.response.ConsolidadoResponse;
import pe.restaurant.finanzas.dto.response.ImpuestoCalculadoResponse;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Consolida los impuestos de todos los ítems y calcula totales.
 * Pura función matemática — sin estado ni dependencias.
 */
public class ConsolidadorImpuestos {

    private static final int SCALE = 4;
    private static final RoundingMode RM = RoundingMode.HALF_UP;

    /**
     * Consolida los impuestos de todos los ítems y calcula totales.
     *
     * @param items                          resultados por ítem
     * @param descuentoGlobal                descuento global
     * @param dsctoGlobalConIgv true = el monto incluye impuestos, false = es base
     * @return ConsolidadoResponse con impuestos sumados y totales
     */
    public static ConsolidadoResponse consolidar(
            List<ItemCalculoResponse> items,
            BigDecimal descuentoGlobal,
            boolean dsctoGlobalConIgv) {

        // 1. Sum all impuestos by tipoImpuestoId
        Map<Long, ImpuestoCalculadoResponse> impuestosMap = new LinkedHashMap<>();
        BigDecimal subtotal = BigDecimal.ZERO;
        BigDecimal totalIgv = BigDecimal.ZERO;

        for (ItemCalculoResponse item : items) {
            subtotal = subtotal.add(item.getBaseImponible());

            if (item.getImpuestos() != null) {
                for (ImpuestoCalculadoResponse imp : item.getImpuestos()) {
                    totalIgv = totalIgv.add(imp.isEsFiscalizado() ? imp.getImporte() : BigDecimal.ZERO);

                    ImpuestoCalculadoResponse existing = impuestosMap.get(imp.getTipoImpuestoId());
                    if (existing != null) {
                        BigDecimal sumImporte = existing.getImporte().add(imp.getImporte());
                        impuestosMap.put(imp.getTipoImpuestoId(), ImpuestoCalculadoResponse.builder()
                                .tipoImpuestoId(existing.getTipoImpuestoId())
                                .nombre(existing.getNombre())
                                .tasa(existing.getTasa())
                                .importe(sumImporte)
                                .esFiscalizado(existing.isEsFiscalizado())
                                .build());
                    } else {
                        impuestosMap.put(imp.getTipoImpuestoId(), imp);
                    }
                }
            }
        }

        // 2. totalConImpuestos = sum of each item's montoTotal (authoritative per-item total)
        BigDecimal totalConImpuestos = items.stream()
                .map(ItemCalculoResponse::getMontoTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(SCALE, RM);

        List<ImpuestoCalculadoResponse> impuestosList = new ArrayList<>(impuestosMap.values());

        // 3. Descuento global
        BigDecimal descuentoGlobalSinImpuestos = null;
        BigDecimal descuentoGlobalConImpuestos = null;

        if (descuentoGlobal != null && descuentoGlobal.compareTo(BigDecimal.ZERO) > 0) {
            if (totalConImpuestos.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal proportion = subtotal.divide(totalConImpuestos, SCALE_INTERNAL, RM);

                if (dsctoGlobalConIgv) {
                    descuentoGlobalConImpuestos = descuentoGlobal.setScale(SCALE, RM);
                    descuentoGlobalSinImpuestos = descuentoGlobal.multiply(proportion).setScale(SCALE, RM);
                } else {
                    descuentoGlobalSinImpuestos = descuentoGlobal.setScale(SCALE, RM);
                    descuentoGlobalConImpuestos = proportion.compareTo(BigDecimal.ZERO) > 0
                            ? descuentoGlobal.divide(proportion, SCALE, RM)
                            : BigDecimal.ZERO.setScale(SCALE, RM);
                }
            } else {
                descuentoGlobalSinImpuestos = BigDecimal.ZERO.setScale(SCALE, RM);
                descuentoGlobalConImpuestos = BigDecimal.ZERO.setScale(SCALE, RM);
            }
        }

        return ConsolidadoResponse.builder()
                .impuestos(impuestosList)
                .subtotal(subtotal.setScale(SCALE, RM))
                .totalIgv(totalIgv.setScale(SCALE, RM))
                .totalConImpuestos(totalConImpuestos)
                .descuentoGlobalSinImpuestos(descuentoGlobalSinImpuestos)
                .descuentoGlobalConImpuestos(descuentoGlobalConImpuestos)
                .build();
    }

    private static final int SCALE_INTERNAL = 10;
}
