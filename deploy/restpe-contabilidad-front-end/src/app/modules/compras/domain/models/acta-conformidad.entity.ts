/**
 * Entidades de dominio para Actas de Conformidad de Orden de Servicio (OS).
 */
export interface ActaConformidadLineaEntity {
  id?: number;
  secuencia: number;
  descripcion: string;
  cantidad: number;
  precioUnitario: number;
  subtotal?: number;
}

export interface OrdenServicioPendienteConformidadEntity {
  ordenServicioId: number;
  nroOs: string;
  proveedorId?: number;
  proveedorRazonSocial: string;
  fecRegistro: string;
  montoTotal: number;
  flagEstado: string;
}

export interface ActaConformidadEntity {
  id?: number;
  acta_orden_servicio_id: number;
  acta_nro_os?: string;
  acta_proveedor?: string;
  acta_proveedor_id?: number;
  acta_fecha: string;
  acta_observacion?: string;
  acta_aprobado: boolean;
  acta_estado: string;
  acta_monto_total?: number;
  acta_lineas: ActaConformidadLineaEntity[];
  [key: string]: any;
}
