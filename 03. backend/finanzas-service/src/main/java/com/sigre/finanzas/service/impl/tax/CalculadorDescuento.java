package com.sigre.finanzas.service.impl.tax;

import com.sigre.finanzas.dto.request.ImpuestoItemRequest;
import com.sigre.finanzas.dto.request.ItemCalculoRequest;
import com.sigre.finanzas.dto.response.ImpuestoCalculadoResponse;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Calcula los descuentos por ítem y los aplica a los impuestos.
 * El descuento por ítem se calcula como un mini-ítem usando la misma
 * fórmula que el ítem original (mismo valorConIgv).
 */
public class CalculadorDescuento {

    /**
     * Calcula los descuentos por ítem y los aplica a los impuestos.
     *
     * @param descuento             monto del descuento
     * @param impuestosOriginales   impuestos calculados del ítem (sin descuento)
     * @param impuestosRequest      impuestos del request (para tasas)
     * @param valorConIgv flag del ítem
     * @param cantidad              cantidad del ítem
     * @param paisCodigo            código del país
     * @return lista de descuentos (impuestos con valores a restar)
     */
    public static List<ImpuestoCalculadoResponse> calcularDescuentoItem(
            BigDecimal descuento,
            List<ImpuestoCalculadoResponse> impuestosOriginales,
            List<ImpuestoItemRequest> impuestosRequest,
            boolean valorConIgv,
            BigDecimal cantidad,
            String paisCodigo) {

        // If descuento is 0 or null → return empty list
        if (descuento == null || descuento.compareTo(BigDecimal.ZERO) == 0) {
            return Collections.emptyList();
        }

        // Create a "mini item" with the discount amount as valorUnitario
        // The mini-item uses the SAME impuestos and valorConIgv as the original
        ItemCalculoRequest miniItem = new ItemCalculoRequest(
                0,                      // item (unused)
                descuento,              // valorUnitario = descuento monto
                BigDecimal.ONE,         // cantidad = 1
                valorConIgv,            // same flag as original
                BigDecimal.ZERO,        // no descuento on the discount itself
                "$",                    // dsctoTipo
                impuestosRequest,       // same taxes
                null                    // no detraccion
        );

        // Calculate taxes on the mini-item using the standard algorithm
        var itemResult = CalculadorItem.calcular(miniItem, paisCodigo);

        // Return the calculated taxes as "descuentos"
        // These will be subtracted from the original item's taxes
        return itemResult.getImpuestos().stream()
                .map(imp -> ImpuestoCalculadoResponse.builder()
                        .tipoImpuestoId(imp.getTipoImpuestoId())
                        .nombre(imp.getNombre())
                        .tasa(imp.getTasa())
                        .importe(imp.getImporte())
                        .esFiscalizado(imp.isEsFiscalizado())
                        .build())
                .collect(Collectors.toList());
    }
}
