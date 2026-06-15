package com.sigre.almacen.domain;

import java.util.Map;

/**
 * Valores de {@code almacen.vale_mov.flag_estado} (SIGRE / AL302).
 */
public final class ValeMovFlagEstado {

    public static final String ACTIVO = "1";
    public static final String ANULADO = "0";
    public static final String CERRADO = "2";

    private static final Map<String, String> TO_LABEL = Map.of(
            ACTIVO, "ACTIVO",
            ANULADO, "ANULADO",
            CERRADO, "CERRADO"
    );

    private ValeMovFlagEstado() {
    }

    public static String toLabel(String flagEstado) {
        if (flagEstado == null || flagEstado.isEmpty()) {
            return null;
        }
        return TO_LABEL.getOrDefault(flagEstado, flagEstado);
    }

    /**
     * Filtro por query {@code estado}: acepta ACTIVO/ANULADO/CERRADO, códigos 1/0/2 y legacy REGISTRADO→ACTIVO.
     */
    public static String fromFiltro(String estado) {
        if (estado == null || estado.isBlank()) {
            return null;
        }
        String t = estado.trim();
        if (t.length() == 1 && "012".contains(t)) {
            return t;
        }
        return switch (t.toUpperCase()) {
            case "ACTIVO", "REGISTRADO" -> ACTIVO;
            case "ANULADO" -> ANULADO;
            case "CERRADO" -> CERRADO;
            default -> null;
        };
    }
}
