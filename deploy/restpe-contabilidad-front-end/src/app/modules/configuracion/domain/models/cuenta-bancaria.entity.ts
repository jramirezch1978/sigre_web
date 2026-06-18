/**
 * @summary Entidad de dominio para Cuenta Bancaria
 * @description Representa una cuenta bancaria en el sistema de configuración
 */
export interface CuentaBancariaEntity {
  cuenta_bancaria_id: number;
  /** Campos FK/identificadores reales del backend (para crear/editar). */
  cuenta_bancaria_codigo?: string;
  cuenta_bancaria_banco_id?: number;
  cuenta_bancaria_moneda_id?: number;
  cuenta_bancaria_plan_contable_det_id?: number;
  cuenta_bancaria_saldo_contable?: number;
  /** Sucursal asociada (id numérico real, FK banco_cnta.sucursal_id). */
  cuenta_bancaria_sucursal_id?: number;
  cuenta_bancaria_fecha_creacion: string;
  cuenta_bancaria_entidad: string;
  cuenta_bancaria_tipo_cuenta: string;
  cuenta_bancaria_moneda: string;
  cuenta_bancaria_numero_cuenta: string;
  cuenta_bancaria_cci: string;
  cuenta_bancaria_cuenta_contable: string;
  cuenta_bancaria_titular: string;
  cuenta_bancaria_flujo_caja: string;
  cuenta_bancaria_descripcion: string;
  cuenta_bancaria_estado: string;
  cuenta_bancaria_sucursales: {
    id: string;
    nombre: string;
  };
}
