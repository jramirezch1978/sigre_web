package pe.restaurant.rrhh.constants;

public final class CntaCrrteConstants {
    private CntaCrrteConstants() { throw new UnsupportedOperationException(); }

    // ── Estados detalle (flag_estado de cnta_crrte_det) ──────────
    // Respeta catálogo global de 00-convenciones-generales.sql
    public static final String DET_ESTADO_ANULADO      = "0";
    public static final String DET_ESTADO_ACTIVO       = "1";
    public static final String DET_ESTADO_CERRADO      = "2";
    public static final String DET_ESTADO_PENDIENTE    = "3";
    public static final String DET_ESTADO_EN_PLANILLA  = "6";
    public static final String DET_ESTADO_APLICADO     = "5";

    // ── Códigos de error ─────────────────────────────────────────
    public static final String ERROR_DATOS_INCOMPLETOS = "RH-CC-001";
    public static final String ERROR_CUENTA_DUPLICADA = "RH-CC-002";
    public static final String ERROR_CIERRE_CON_SALDO = "RH-CC-003";
    public static final String ERROR_MOVIMIENTO_INACTIVA = "RH-CC-004";
    public static final String ERROR_NO_ENCONTRADO = "RH-CC-005";
    public static final String ERROR_TRANSICION_INVALIDA = "RH-CC-006";

    // ── Mensajes ─────────────────────────────────────────────────
    public static final String MSG_CUENTA_DUPLICADA = "Ya existe un documento de cuenta corriente con el mismo tipo y número para el trabajador.";
    public static final String MSG_CIERRE_CON_SALDO = "No se puede cerrar una cuenta con saldo distinto de cero.";
    public static final String MSG_MOVIMIENTO_INACTIVA = "No se pueden registrar movimientos en una cuenta cerrada.";
    public static final String MSG_NO_ENCONTRADO = "Cuenta corriente no encontrada.";

    public static final String MSG_CREADO = "Cuenta corriente aperturada correctamente.";
    public static final String MSG_ACTUALIZADO = "Cuenta corriente actualizada correctamente.";
    public static final String MSG_ESTADO_CAMBIADO = "Estado de cuenta corriente cambiado correctamente.";
    public static final String MSG_OBTENIDOS = "Cuentas corrientes obtenidas correctamente.";
    public static final String MSG_MOVIMIENTO_CREADO = "Movimiento registrado correctamente.";
    public static final String MSG_MOVIMIENTO_APROBADO = "Retención aprobada correctamente.";
    public static final String MSG_MOVIMIENTO_EN_PLANILLA = "Retención enviada a planilla.";
    public static final String MSG_MOVIMIENTO_APLICADO = "Retención aplicada en boleta.";
    public static final String MSG_MOVIMIENTO_ANULADO = "Retención anulada correctamente.";
}
