export interface CruceExtractoEntity {
  ce_codigo: string;
  ce_banco: string;
  ce_numero_de_banco: string;
  ce_estado: 'En proceso' | 'Cerrado';
}
