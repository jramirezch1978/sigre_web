/**
 * @summary Entidad de dominio para Condición de Pago/Cobro
 * @description Representa una condición de pago o cobro en el sistema de configuración
 */
export interface CondicionPagoCobroEntity {
  condicion_pago_cobro_codigo: string;
  condicion_pago_cobro_nombre: string;
  condicion_pago_cobro_aplicacion: string;
  condicion_pago_cobro_modalidad: string;
  condicion_pago_cobro_dias_credito: string;
  condicion_pago_cobro_num_cuotas: string;
  condicion_pago_cobro_periodicidad: string;
  condicion_pago_cobro_cuenta_contable: string;
  condicion_pago_cobro_estado: string;
}
