/**
 * Entidad de dominio: Tipos de Seguro de Activos Fijos.
 * Representa la configuración de tipos de seguro con cobertura y modalidad de pago.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface SeguroEntity {
  id?: string;
  seguro_codigo:               string;   // Código único (TS-001...)
  seguro_nombre:               string;   // Nombre del tipo de seguro
  seguro_cat_riesgo:           string;   // Bajo | Medio | Alto
  seguro_cobertura_base:       string;   // Porcentaje de cobertura base (ej. "100%")
  seguro_modalidad_pago:       string;   // Mensual | Trimestral | Anual
  seguro_estado:               string;   // Activo | Inactivo
  seguro_descripcion?:         string;   // Descripción del seguro
  seguro_condiciones_generales?: string; // Condiciones generales
  seguro_deducible_estandar?:  string;   // Deducible estándar
  seguro_vigencia_estandar?:   string;   // Vigencia estándar
  seguro_observaciones?:       string;   // Observaciones adicionales
}
