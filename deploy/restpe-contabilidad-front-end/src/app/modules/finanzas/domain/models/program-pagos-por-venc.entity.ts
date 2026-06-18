export interface ProgramPagosPorVencEntity {
  ppv_codigo: string;
  ppv_fechaRegistro: string;
  ppv_fechaPagoProg: string;
  ppv_prioridad: string;
  ppv_proveedor: string;
  ppv_tipoDoc: string;
  ppv_nDocumento: string;
  ppv_montoTotal: number;
  ppv_entidad: string;
  ppv_ctaPago: any;
  ppv_numeroPreAsiento?: string;
  ppv_numeroAsiento?: string;
  ppv_estado: 'Programado' | 'Pagado' | 'Anulado';
  ppv_observaciones: string;
}

