/**
 * Entidad de dominio: Numerador de Activos Fijos.
 * Representa la configuración de secuencias numéricas por sucursal.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface NumActivoEntity {
  id?: string;
  num_activo_codigo:       string;  // Código de configuración (CFG-001...)
  num_activo_sucursal:     string;  // Sucursal asignada
  num_activo_prefijo:      string;  // Prefijo de la secuencia
  num_activo_longitud:     string;  // Longitud total del número
  num_activo_formato:      string;  // Formato: "Ceros a la izquierda" | "Ninguno"
  num_activo_reinicio:     string;  // Anual | Mensual | Manual | No reiniciar
  num_activo_estado:       string;  // Activo | Inactivo
  num_activo_ninicial:     string;  // Número inicial de la secuencia
  num_activo_nactual:      string;  // Número actual
  num_activo_incremento:   string;  // Incremento por registro
  num_activo_rango:        string;  // Rango permitido (ej. "1-9999")
  num_activo_relleno:      string;  // Carácter de relleno
  num_activo_observaciones?: string;
}
