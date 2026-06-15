package com.sigre.rrhh.constants;

/**
 * Constantes para el módulo de Cargos.
 * Define códigos de error de dominio y mensajes estándar según el contrato API.
 */
public final class CargoConstants {
    
    private CargoConstants() {
        throw new UnsupportedOperationException("Clase de constantes — no instanciable");
    }
    
    // Códigos de error de dominio
    public static final String ERROR_NOMBRE_OBLIGATORIO = "RH-CG-001";
    public static final String ERROR_NOMBRE_DUPLICADO = "RH-CG-002";
    public static final String ERROR_BANDA_SALARIAL_INCOHERENTE = "RH-CG-003";
    public static final String ERROR_ELIMINACION_CON_ASIGNADOS = "RH-CG-004";
    public static final String ERROR_CARGO_NO_ENCONTRADO = "RH-CG-005";
    
    // Mensajes de error
    public static final String MSG_NOMBRE_OBLIGATORIO = "El nombre del cargo es obligatorio.";
    public static final String MSG_NOMBRE_DUPLICADO = "Ya existe un cargo con ese nombre.";
    public static final String MSG_BANDA_SALARIAL_INCOHERENTE = "El sueldo mínimo no puede ser mayor al sueldo máximo.";
    public static final String MSG_ELIMINACION_CON_ASIGNADOS = "No se puede eliminar un cargo con colaboradores asignados.";
    public static final String MSG_CARGO_NO_ENCONTRADO = "Cargo no encontrado.";
    
    // Mensajes de éxito
    public static final String MSG_CARGO_CREADO = "Cargo creado correctamente.";
    public static final String MSG_CARGO_ACTUALIZADO = "Cargo actualizado correctamente.";
    public static final String MSG_CARGO_DESACTIVADO = "Cargo desactivado correctamente.";
    public static final String MSG_CARGO_ACTIVADO = "Cargo activado correctamente.";
    public static final String MSG_CARGO_ELIMINADO = "Cargo eliminado correctamente.";
    public static final String MSG_CARGOS_OBTENIDOS = "Cargos obtenidos correctamente.";
}
