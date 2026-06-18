/**
 * Entidad de dominio: Póliza de Seguro de Activos Fijos.
 * Representa el registro de una póliza asociada a un activo fijo.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface PolizaSeguroEntity {
  poliza_codigo:            string;   // Código único (POL-001…)
  poliza_activo:            string;   // Nombre del activo fijo asegurado
  poliza_aseguradora:       string;   // Nombre de la compañía aseguradora
  poliza_tipo_seguro:       string;   // todo-riesgo | robo | incendio | maquinaria
  poliza_fecha_inicio:      string;   // ISO 8601 (YYYY-MM-DD)
  poliza_fecha_vencimiento: string;   // ISO 8601 (YYYY-MM-DD)
  poliza_suma_asegurada:    number;   // Monto total asegurado
  poliza_moneda:            string;   // PEN | USD
  poliza_prima_total:       number;   // Prima total de la póliza
  poliza_deducible:         number;   // Valor del deducible
  poliza_tipo_deducible:    string;   // porcentaje | monto
  poliza_beneficiario:      string;   // Razón social del beneficiario
  poliza_documento_soporte: string;   // Nombre del archivo adjunto
  poliza_estado:            string;   // Vigente | Vence en 30 días | Vigente en 7 días | Vencida | Anulada | En siniestro
  poliza_observaciones?:    string;   // Notas adicionales
}
