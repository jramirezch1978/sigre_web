package pe.restaurant.rrhh.constants;

/**
 * Constantes para el módulo de Turnos.
 * Define códigos de error de dominio y mensajes estándar según HU_TURNO.md y CONTRATO_TURNO.md.
 */
public final class TurnoConstants {
    
    private TurnoConstants() {
        throw new UnsupportedOperationException("Clase de constantes — no instanciable");
    }
    
    // Códigos de error de dominio (según CONTRATO_TURNO.md)
    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-TU-001";
    public static final String ERROR_NOMBRE_DUPLICADO = "RH-TU-002";
    public static final String ERROR_SIN_DIAS_ACTIVOS = "RH-TU-003";
    public static final String ERROR_ELIMINACION_CON_ASIGNADOS = "RH-TU-004";
    public static final String ERROR_TURNO_NO_ENCONTRADO = "RH-TU-005";
    
    // Mensajes de error
    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre del turno es obligatorio.";
    public static final String MSG_NOMBRE_DUPLICADO = "Ya existe un turno con ese nombre.";
    public static final String MSG_SIN_DIAS_ACTIVOS = "El turno debe aplicar al menos a un día de la semana.";
    public static final String MSG_ELIMINACION_CON_ASIGNADOS = "No se puede eliminar un turno con colaboradores asignados.";
    public static final String MSG_TURNO_NO_ENCONTRADO = "Turno no encontrado.";
    public static final String MSG_TOLERANCIA_NEGATIVA = "Los minutos de tolerancia deben ser mayores o iguales a 0.";
    
    // Mensajes de éxito
    public static final String MSG_TURNO_CREADO = "Turno creado correctamente.";
    public static final String MSG_TURNO_ACTUALIZADO = "Turno actualizado correctamente.";
    public static final String MSG_TURNO_DESACTIVADO = "Turno desactivado correctamente.";
    public static final String MSG_TURNO_ACTIVADO = "Turno activado correctamente.";
    public static final String MSG_TURNO_ELIMINADO = "Turno eliminado correctamente.";
    public static final String MSG_TURNOS_OBTENIDOS = "Turnos obtenidos correctamente.";
    public static final String MSG_TURNO_OBTENIDO = "Turno obtenido correctamente.";
}
