export interface PrestamoConsultaEntity {
  prestamo_codigo: string;
  prestamo_producto: string;
  prestamo_fecha_entrega: string;
  prestamo_almacen_origen: string;
  prestamo_almacen_destino: string;
  prestamo_medida: string;
  prestamo_cantidad_entregada: number;
  prestamo_cantidad_devuelta: number;
  prestamo_saldo_pendiente: number;
  prestamo_usuario_responsable: string;
  usuarioResp: string;
  prestamo_estado: string;
}
