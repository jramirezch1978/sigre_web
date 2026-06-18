/**
 * @summary Entidad de dominio para Canal de Pago/Cobro
 * @description Representa un canal de pago o cobro en el sistema de configuración
 */
export interface CanalPagoCobroEntity {
  canal_pago_cobro_id: number;
  canal_pago_cobro_medio_pago_cobro: string;
  canal_pago_cobro_canal: string;
  canal_pago_cobro_nombre: string;
  canal_pago_cobro_entidad_bancaria: string;
  canal_pago_cobro_cuenta_bancaria: string;
  canal_pago_cobro_moneda: string;
  canal_pago_cobro_cuenta_contable: string;
  canal_pago_cobro_descripcion: string;
  canal_pago_cobro_usuario_responsable: string;
  canal_pago_cobro_fecha_creacion: string;
  canal_pago_cobro_estado: string;
}
