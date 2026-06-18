export interface EjecucionPagoEntity {
  ep_codigo: string;
  ep_enteTributario: string;
  ep_fecha: string;
  ep_tipoTributo: string;
  ep_monto: number;
  ep_entidad: string;
  ep_cuentaBancaria: string;
  ep_numeroOperacion: string;
  ep_periodopago: string;
  ep_usuario: string;
  ep_asientoContable: string;
  ep_moneda: string;
  ep_documentoSoporte: string;
  ep_observaciones: string;
  ep_estado: 'Pendiente' | 'Pagado' | 'Anulado';
}
