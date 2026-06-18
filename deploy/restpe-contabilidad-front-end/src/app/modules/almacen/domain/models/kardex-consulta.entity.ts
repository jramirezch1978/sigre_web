export interface KardexConsultaEntity {
  almacen_codigo: string;
  kardex_consulta_nombre: string;
  kardex_consulta_categoria: string;
  kardex_consulta_medida: string;
  kardex_consulta_almacen: string;
  stkInicial: number;
  ingresos: number;
  salidas: number;
  stkFinal: number;
  costoProm: number;
  valorTotal: number;
  fMov: string;
  tipoMov: string;
}
