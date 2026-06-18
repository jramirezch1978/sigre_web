export interface OrdenGiroEntity {
  /** Id real del backend (finanzas.solicitud_giro). Necesario para PUT/anular. */
  og_id?: number;
  og_num_orden_giro: string;        // numero
  og_fecha_emision: string;         // fecha
  og_monto: number;                 // monto
  og_estado: string;                // flagEstado mapeado (Pendiente/Aprobada/Anulada)
  // Campos reales del backend (solicitud_giro).
  og_sucursal_id?: number;
  og_solicitante_id?: number;
  og_motivo?: string;
  og_tipo_solicitud?: string;       // O = Orden de Giro, F = Fondo Fijo
  og_centro_costo_id?: number;
  // SOBRA: campos sin respaldo en el backend (UI rica comentada). Se conservan opcionales.
  og_fecha_deposito?: string;
  og_beneficiario?: string;
  og_banco?: string;
  og_moneda?: string;
  og_doc_asociado?: string;
  og_tipo_beneficiario?: string;
  og_fecha_programada_pago?: string;
  og_ruc?: string;
}
