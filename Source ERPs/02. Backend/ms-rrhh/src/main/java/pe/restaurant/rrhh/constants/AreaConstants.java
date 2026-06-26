package pe.restaurant.rrhh.constants;

/**
 * Constantes para el módulo de Áreas.
 * Define códigos de error de dominio y mensajes estándar.
 */
public final class AreaConstants {
    
    private AreaConstants() {
        throw new UnsupportedOperationException("Clase de constantes — no instanciable");
    }
    
    // Códigos de error de dominio
    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-AR-001";
    public static final String ERROR_NOMBRE_DUPLICADO = "RH-AR-002";
    public static final String ERROR_CICLO_JERARQUIA = "RH-AR-003";
    public static final String ERROR_ELIMINACION_CON_HIJOS = "RH-AR-004";
    public static final String ERROR_AREA_NO_ENCONTRADA = "RH-AR-005";
    
    // Mensajes de error
    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre del área es obligatorio.";
    public static final String MSG_NOMBRE_DUPLICADO = "Ya existe un área con ese nombre en el mismo nivel.";
    public static final String MSG_CICLO_JERARQUIA = "La asignación de padre genera un ciclo en la jerarquía.";
    public static final String MSG_ELIMINACION_CON_HIJOS = "No se puede eliminar un área que tiene sub-áreas asignadas.";
    public static final String MSG_AREA_NO_ENCONTRADA = "Área no encontrada.";
    public static final String MSG_AREA_NO_PUEDE_SER_PROPIO_PADRE = "Un área no puede ser su propio padre.";
    
    // Mensajes de éxito
    public static final String MSG_AREA_CREADA = "Área creada correctamente.";
    public static final String MSG_AREA_ACTUALIZADA = "Área actualizada correctamente.";
    public static final String MSG_AREA_DESACTIVADA = "Área desactivada correctamente.";
    public static final String MSG_AREA_ACTIVADA = "Área activada correctamente.";
    public static final String MSG_AREA_ELIMINADA = "Área eliminada correctamente.";
    public static final String MSG_AREAS_OBTENIDAS = "Áreas obtenidas correctamente.";
    public static final String MSG_ARBOL_OBTENIDO = "Árbol jerárquico obtenido correctamente.";
}
