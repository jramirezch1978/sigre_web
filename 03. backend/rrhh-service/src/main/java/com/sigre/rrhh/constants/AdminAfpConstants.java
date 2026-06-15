package com.sigre.rrhh.constants;

/**
 * Constantes utilizadas en el módulo de Administradoras de Fondos de Pensiones (AFP).
 * 
 * <p>Contiene códigos de error, mensajes y valores por defecto utilizados
 * en las validaciones y respuestas del sistema.</p>
 * 
 * @author Sistema de RRHH
 * @version 1.0
 */
public final class AdminAfpConstants {
    
    // Códigos de error de dominio
    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-AF-001";
    public static final String ERROR_NOMBRE_DUPLICADO = "RH-AF-002";
    public static final String ERROR_PORCENTAJE_NEGATIVO = "RH-AF-003";
    public static final String ERROR_ELIMINACION_CON_ASIGNADOS = "RH-AF-004";
    public static final String ERROR_NO_ENCONTRADO = "RH-AF-005";
    public static final String ERROR_GENERICO = "RH-AF-000";
    
    // Mensajes de error
    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre de la AFP es obligatorio.";
    public static final String MSG_NOMBRE_DUPLICADO = "Ya existe una AFP con ese nombre.";
    public static final String MSG_PORCENTAJE_NEGATIVO = "Los porcentajes no pueden ser negativos.";
    public static final String MSG_ELIMINACION_CON_ASIGNADOS = "No se puede eliminar una AFP con colaboradores asignados.";
    public static final String MSG_NO_ENCONTRADO = "AFP no encontrada.";
    
    // Mensajes de éxito
    public static final String MSG_AFPS_OBTENIDAS = "AFP obtenidas correctamente.";
    public static final String MSG_AFP_OBTENIDA = "AFP obtenida correctamente.";
    public static final String MSG_AFP_CREADA = "AFP creada correctamente.";
    public static final String MSG_AFP_ACTUALIZADA = "AFP actualizada correctamente.";
    public static final String MSG_AFP_DESACTIVADA = "AFP desactivada correctamente.";
    public static final String MSG_AFP_ACTIVADA = "AFP activada correctamente.";
    public static final String MSG_AFP_ELIMINADA = "AFP eliminada correctamente.";
    
    // Constructor privado para evitar instanciación
    private AdminAfpConstants() {
        throw new UnsupportedOperationException("Clase de constantes - no se puede instanciar");
    }
}
