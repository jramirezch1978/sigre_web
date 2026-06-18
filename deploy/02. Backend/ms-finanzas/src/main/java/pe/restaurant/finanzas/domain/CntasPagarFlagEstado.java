package pe.restaurant.finanzas.domain;

import java.util.Map;

/**
 * Valores de {@code finanzas.cntas_pagar.flag_estado}.
 */
public final class CntasPagarFlagEstado {

    public static final String ACTIVO = "1";
    public static final String ANULADO = "0";

    private static final Map<String, String> TO_LABEL = Map.of(
            ACTIVO, "ACTIVO",
            ANULADO, "ANULADO"
    );

    private CntasPagarFlagEstado() {
    }

    public static String toLabel(String flagEstado) {
        if (flagEstado == null || flagEstado.isEmpty()) {
            return null;
        }
        return TO_LABEL.getOrDefault(flagEstado, flagEstado);
    }

    /**
     * Filtro por query {@code estado}: acepta ACTIVO/ANULADO, códigos 1/0.
     */
    public static String fromFiltro(String estado) {
        if (estado == null || estado.isBlank()) {
            return null;
        }
        String t = estado.trim();
        if (t.length() == 1 && "01".contains(t)) {
            return t;
        }
        return switch (t.toUpperCase()) {
            case "ACTIVO", "REGISTRADO" -> ACTIVO;
            case "ANULADO" -> ANULADO;
            default -> null;
        };
    }
}
