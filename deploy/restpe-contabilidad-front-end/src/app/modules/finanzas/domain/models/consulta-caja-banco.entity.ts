export interface ConsultaCajaBancoEntity {
  ccb_razon_social: string;
  ccb_entidad_financiera: string;
  ccb_tipo_cuenta: string;
  ccb_numero_cuenta: string;
  ccb_moneda: string;
  ccb_saldo_contable: number;
  ccb_saldo_disponible: number;
  ccb_sucursal: string;
  ccb_estado: string;
}
