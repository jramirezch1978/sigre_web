package pe.restaurant.ventas.support;

/**
 * Convención de trazabilidad en {@code cntas_cobrar_det.referencia} sin cambios de DDL.
 */
public final class CuentaCobrarReferencias {

    public static final String PREFIJO_DIRECTO = "ORIGEN=DIRECTO";
    public static final String PREFIJO_DETRACCION = "ORIGEN=DETRACCION";
    public static final String PREFIJO_NC = "ORIGEN=NC";

    private CuentaCobrarReferencias() {
    }

    public static String directo(Long servicioCxcId, String descripcion) {
        String desc = descripcion != null ? descripcion.trim() : "";
        if (servicioCxcId != null) {
            return PREFIJO_DIRECTO + "|servicioId=" + servicioCxcId + "|desc=" + desc;
        }
        return PREFIJO_DIRECTO + "|desc=" + desc;
    }

    public static String detraccion(Long origenId, String tasa) {
        return PREFIJO_DETRACCION + "|origenId=" + origenId + "|tasa=" + tasa;
    }

    public static String notaCredito(Long origenId, String motivo) {
        String m = motivo != null ? motivo.trim() : "";
        return PREFIJO_NC + "|origenId=" + origenId + "|motivo=" + m;
    }

    public static boolean esDirecto(String referencia) {
        return referencia != null && referencia.startsWith(PREFIJO_DIRECTO);
    }

    public static boolean esDetraccion(String referencia) {
        return referencia != null && referencia.startsWith(PREFIJO_DETRACCION);
    }

    public static boolean esNotaCredito(String referencia) {
        return referencia != null && referencia.startsWith(PREFIJO_NC);
    }
}
