package pe.com.hermes.appmobile.util;

/**
 * Etiquetas de {@code flag_estado} alineadas a sigre_web
 * ({@code format: 'estado'} → Activo / Inactivo; formularios → Activo / Anulado).
 */
public final class FlagEstadoLabels {

    private FlagEstadoLabels() {}

    /** Listados: 1 = Activo, 0 u otro = Inactivo. */
    public static String listado(String flagEstado) {
        return esActivo(flagEstado) ? "Activo" : "Inactivo";
    }

    /** Formularios / detalle: 1 = Activo, 0 u otro = Anulado. */
    public static String formulario(String flagEstado) {
        return esActivo(flagEstado) ? "Activo" : "Anulado";
    }

    public static boolean esActivo(String flagEstado) {
        if (flagEstado == null) {
            return false;
        }
        String v = flagEstado.trim();
        return "1".equals(v) || "true".equalsIgnoreCase(v);
    }

    /** Prefijo "Estado: Activo|Inactivo" para subtítulos de lista. */
    public static String campoListado(String flagEstado) {
        return "Estado: " + etiquetaORaw(flagEstado);
    }

    /**
     * Si es binario 0/1, etiqueta Activo/Inactivo; si es otro código (P, A, etc.), lo deja tal cual.
     */
    public static String etiquetaORaw(String flagEstado) {
        if (flagEstado == null || flagEstado.isBlank()) {
            return "—";
        }
        String v = flagEstado.trim();
        if ("0".equals(v) || "1".equals(v)
                || "true".equalsIgnoreCase(v) || "false".equalsIgnoreCase(v)) {
            return listado(v);
        }
        return v;
    }
}
