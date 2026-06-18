/**
 * Entidad de dominio: Resumen de Activos Fijos.
 * Representa el resumen general de activos fijos con valores contables y ubicación.
 * Convención de nombres: raf_campo (snake_case).
 */
export interface ResumenActivoFijoEntity {
  id?: string;
  raf_codigo:       string;   // Código del activo (AF-001...)
  raf_descripcion:  string;   // Descripción del activo
  raf_clase:        string;   // Clase / subclase del activo
  raf_ubicacion:    string;   // Ubicación física del activo
  raf_fecha_adqui:  string;   // Fecha de adquisición
  raf_inicio_dep:   string;   // Fecha de inicio de depreciación
  raf_valor_adqui:  number;   // Valor de adquisición
  raf_depre_ac:     number;   // Depreciación acumulada
  raf_valor_net:    number;   // Valor neto contable
  raf_moneda:       string;   // Soles | Dólares
  raf_centro_costo: string;   // Centro de costo asignado
  raf_estado:       string;   // Activo | Inactivo
}
