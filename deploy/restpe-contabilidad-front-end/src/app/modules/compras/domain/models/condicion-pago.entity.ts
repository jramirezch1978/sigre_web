/**
 * Entidad de dominio: Condición de Pago.
 * Convención: condicion_pago_campo
 */
export interface CondicionPagoEntity {
  condicion_pago_codigo:                 string;
  condicion_pago_nombre:                 string;
  condicion_pago_tipo:                   string;
  condicion_pago_plazo:                  string;
  condicion_pago_estado:                 string;
  condicion_pago_periodicidad_cuotas?:   string;
  condicion_pago_cuotas?:                string;
  condicion_pago_descripcion?:           string;
}
