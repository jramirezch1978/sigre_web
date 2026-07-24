package pe.com.hermes.appmobile.util;

/**
 * Catálogo virtual {@code flag_estado} (VARCHAR 1), fuente:
 * {@code 04. Base de datos/ddl/00-convenciones-generales.sql}.
 * <pre>
 * 0 Anulado · 1 Activo · 2 Cerrado · 3 Pendiente · 4 Pagado parcial
 * 5 Pagado total · 6 En proceso · 7 Devuelto · 8 Suspendido · 9 Observado
 * </pre>
 * Dominios pueden usar alias (maestros: 0=Inactivo; control calidad: 1=Aprobado).
 */
public final class FlagEstadoLabels {

    private FlagEstadoLabels() {}

    /** Etiqueta canónica del catálogo global (listados / detalle). */
    public static String listado(String flagEstado) {
        return etiqueta(flagEstado);
    }

    /**
     * Switch binario de formularios maestros: 1 = Activo, resto no-activo = Anulado.
     * No usar para documentos con máquina de estados 2–9.
     */
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

    public static String campoListado(String flagEstado) {
        return "Estado: " + etiqueta(flagEstado);
    }

    /** Alias de {@link #etiqueta(String)} (compatibilidad). */
    public static String etiquetaORaw(String flagEstado) {
        return etiqueta(flagEstado);
    }

    /**
     * Resuelve etiqueta; si no está en el catálogo (p. ej. letras legacy), deja el valor crudo.
     */
    public static String etiqueta(String flagEstado) {
        if (flagEstado == null || flagEstado.isBlank()) {
            return "—";
        }
        String v = flagEstado.trim();
        if ("true".equalsIgnoreCase(v)) {
            return "Activo";
        }
        if ("false".equalsIgnoreCase(v)) {
            return "Anulado";
        }
        return switch (v) {
            case "0" -> "Anulado";
            case "1" -> "Activo";
            case "2" -> "Cerrado";
            case "3" -> "Pendiente";
            case "4" -> "Pagado parcial";
            case "5" -> "Pagado total";
            case "6" -> "En proceso";
            case "7" -> "Devuelto";
            case "8" -> "Suspendido";
            case "9" -> "Observado";
            default -> v;
        };
    }
}
