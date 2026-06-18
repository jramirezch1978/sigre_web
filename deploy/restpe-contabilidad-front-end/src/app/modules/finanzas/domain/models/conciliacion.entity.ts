export interface ConciliacionEntity {
  con_banco: string;
  con_cuenta: string;
  con_moneda: string;
  con_ult_conciliacion: string;
  con_saldo_contable: number;
  con_saldo_bancario: number;
  con_diferencia: number;
  con_mov_conciliados: number;
  con_mov_pendientes: number;
  con_usuario: string;
  con_estado: 'Cerrado' | 'En proceso';
}
