export interface MovimientoCruceEntity {
  mc_fecha: string;
  mc_banco?: string;
  mc_tipo: string;
  mc_descripcion: string;
  mc_monto: number;
  mc_estado: 'Pendiente' | 'Conciliado';
  mc_observacion?: string;
}
