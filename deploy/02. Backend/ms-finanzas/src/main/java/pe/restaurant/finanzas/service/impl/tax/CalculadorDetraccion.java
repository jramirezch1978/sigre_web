package pe.restaurant.finanzas.service.impl.tax;

import pe.restaurant.finanzas.dto.request.DetraccionItemRequest;
import pe.restaurant.finanzas.dto.request.ItemCalculoRequest;
import pe.restaurant.finanzas.dto.response.DetraccionCalculadaResponse;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * Calcula la detracción para un conjunto de ítems (Perú).
 * Pura función matemática — sin estado ni dependencias.
 */
public class CalculadorDetraccion {

    private static final int SCALE = 4;
    private static final RoundingMode RM = RoundingMode.HALF_UP;

    /**
     * Calcula la detracción para un conjunto de ítems (Perú).
     *
     * @param requestItems       ítems del request (contienen config de detracción)
     * @param itemsCalc          ítems calculados (contienen montoTotal real)
     * @param totalConImpuestos  suma de todos los montoTotal del documento
     * @return DetraccionCalculadaResponse con si aplica y montos
     */
    public static DetraccionCalculadaResponse calcular(
            List<ItemCalculoRequest> requestItems,
            List<ItemCalculoResponse> itemsCalc,
            BigDecimal totalConImpuestos) {

        if (requestItems == null || requestItems.isEmpty()) {
            return DetraccionCalculadaResponse.builder()
                    .aplica(false)
                    .build();
        }

        // Find applicable detraction: max percentage among items with detraccion AND montoItem >= montoMinimo
        BigDecimal maxPorcentaje = BigDecimal.ZERO;
        String codigoServicio = null;

        for (int i = 0; i < requestItems.size(); i++) {
            ItemCalculoRequest reqItem = requestItems.get(i);
            if (reqItem.getDetraccion() == null) continue;

            BigDecimal montoItem = i < itemsCalc.size()
                    ? itemsCalc.get(i).getMontoTotal()
                    : reqItem.getValorUnitario().multiply(reqItem.getCantidad());

            DetraccionItemRequest det = reqItem.getDetraccion();

            if (montoItem.compareTo(det.getMontoMinimo()) >= 0) {
                if (det.getPorcentaje().compareTo(maxPorcentaje) > 0) {
                    maxPorcentaje = det.getPorcentaje();
                    codigoServicio = det.getCodigoServicio();
                }
            }
        }

        if (maxPorcentaje.compareTo(BigDecimal.ZERO) == 0) {
            return DetraccionCalculadaResponse.builder()
                    .aplica(false)
                    .build();
        }

        // Calculate monto = totalConImpuestos × (porcentajeMax / 100)
        BigDecimal monto = totalConImpuestos.multiply(maxPorcentaje)
                .divide(BigDecimal.valueOf(100), SCALE, RM);

        return DetraccionCalculadaResponse.builder()
                .aplica(true)
                .porcentaje(maxPorcentaje)
                .monto(monto)
                .codigoServicio(codigoServicio)
                .build();
    }
}
