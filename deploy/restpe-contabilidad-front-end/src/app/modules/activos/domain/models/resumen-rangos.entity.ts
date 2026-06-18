/**
 * Entidad de dominio: Resumen de Activos Fijos por Rangos.
 * Representa el listado de activos filtrado por rangos de valor o fecha.
 * Convención de nombres: rr_campo (snake_case).
 */
export interface ResumenRangosEntity {
  id?: string;
  rr_codigo:       string;   // Código del activo (AF-001...)
  rr_descripcion:  string;   // Descripción del activo
  rr_clase:        string;   // Clase / subclase del activo
  rr_fecha_adqui:  string;   // Fecha de adquisición
  rr_costo_ac:     number;   // Costo de adquisición
  rr_depre_ac:     number;   // Depreciación acumulada
  rr_valor_net:    number;   // Valor neto contable
  rr_ubicacion:    string;   // Ubicación física del activo
  rr_responsable:  string;   // Responsable del activo
  rr_moneda:       string;   // Soles | Dólares
  rr_centro_costo: string;   // Centro de costo asignado
  rr_estado:       string;   // Activo | Dado de baja
}
