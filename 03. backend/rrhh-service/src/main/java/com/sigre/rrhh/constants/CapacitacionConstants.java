package com.sigre.rrhh.constants;

public final class CapacitacionConstants {
    private CapacitacionConstants() { throw new UnsupportedOperationException("Clase de constantes — no instanciable"); }

    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-CA-001";
    public static final String ERROR_FECHAS_INVALIDAS = "RH-CA-002";
    public static final String ERROR_ELIMINACION_CON_PARTICIPANTES = "RH-CA-003";
    public static final String ERROR_NO_ENCONTRADO = "RH-CA-004";
    public static final String ERROR_PARTICIPANTE_DUPLICADO = "RH-CA-005";
    public static final String ERROR_TRABAJADOR_INEXISTENTE = "RH-CA-006";

    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre de la capacitación es obligatorio.";
    public static final String MSG_FECHAS_INVALIDAS = "La fecha fin no puede ser anterior a la fecha inicio.";
    public static final String MSG_ELIMINACION_CON_PARTICIPANTES = "No se puede eliminar una capacitación con participantes asignados.";
    public static final String MSG_NO_ENCONTRADO = "Capacitación no encontrada.";
    public static final String MSG_PARTICIPANTE_DUPLICADO = "El trabajador ya está registrado como participante.";
    public static final String MSG_TRABAJADOR_INEXISTENTE = "El trabajador especificado no existe.";

    public static final String MSG_CREADO = "Capacitación creada correctamente.";
    public static final String MSG_ACTUALIZADO = "Capacitación actualizada correctamente.";
    public static final String MSG_ELIMINADO = "Capacitación desactivada correctamente.";
    public static final String MSG_OBTENIDOS = "Capacitaciones obtenidas correctamente.";
    public static final String MSG_DESACTIVADO = "Capacitación desactivada correctamente.";
    public static final String MSG_PARTICIPANTE_AGREGADO = "Participante agregado correctamente.";
    public static final String MSG_PARTICIPANTE_ELIMINADO = "Participante eliminado correctamente.";
}
