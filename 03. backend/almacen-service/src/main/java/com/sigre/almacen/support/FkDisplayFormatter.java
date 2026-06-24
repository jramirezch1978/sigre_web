package com.sigre.almacen.support;

final class FkDisplayFormatter {

    private FkDisplayFormatter() {
    }

    static String codigoDescripcion(String codigo, String descripcion) {
        String c = trimToNull(codigo);
        String d = trimToNull(descripcion);
        if (c != null && d != null) {
            return c + " — " + d;
        }
        if (d != null) {
            return d;
        }
        return c;
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
