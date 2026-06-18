/**
 * Entidad de dominio: Depreciación Anual de Activos Fijos.
 * Representa el registro de depreciación anual con métodos, tasas y valores contables.
 * Convención de nombres: dep_campo (snake_case).
 */
export interface DepreciacionAnualEntity {
  id?: string;
  dep_codigo:        string;   // Código del activo (AF-001...)
  dep_descripcion:   string;   // Descripción del activo
  dep_clase:         string;   // Clase / categoría del activo
  dep_subclase:      string;   // Subclase / subcategoría del activo
  dep_fecha_dep:     string;   // Fecha de inicio de depreciación
  dep_valor_orig:    number;   // Valor original de adquisición
  dep_base_dep:      number;   // Base de depreciación
  dep_metodo_dep:    string;   // Lineal | Saldo Decreciente | Unidades Producidas
  dep_tasa_anual:    string;   // Tasa anual (ej. "20%")
  dep_meses_dep:     string;   // Meses de depreciación en el período
  dep_deprec_mens:   number;   // Depreciación mensual
  dep_deprec_anual:  number;   // Depreciación anual
  dep_deprec_acum:   number;   // Depreciación acumulada
  dep_valor_neto:    number;   // Valor neto contable
  dep_proyeccion_dep: number;  // Proyección de depreciación futura
  dep_moneda:        string;   // Soles | Dolares
  dep_tipo_calculo:  string;   // Contable | Tributaria
  dep_centro_costo:  string;   // Centro de costo asignado
  dep_estado:        string;   // Activo | Inactivo
}
