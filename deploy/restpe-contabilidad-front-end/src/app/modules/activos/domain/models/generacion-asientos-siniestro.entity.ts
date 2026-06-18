/**
 * Entidad de dominio: Generación de Asientos de Siniestro.
 * Representa un registro del proceso de siniestros de activos fijos.
 * Convención de nombres: gas_campo (snake_case).
 */
export interface GeneracionAsientosSiniestroEntity {
  id?: string;
  gas_cod_siniestro:      string;  // Código del siniestro (SIN-2024-001...)
  gas_fecha_incidente:    string;  // Fecha del incidente
  gas_causa_siniestro:    string;  // Causa del siniestro (robo, incendio, etc.)
  gas_descripcion_evento: string;  // Descripción del evento
  gas_poliza:             string;  // Número de póliza
  gas_aseguradora:        string;  // Nombre de la aseguradora
  gas_usuario_ejecutor:   string;  // Usuario que ejecutó el registro
  gas_estado_reclamo:     string;  // Estado del reclamo
  gas_asiento:            string;  // N° de asiento contable (solo Reparado)  // Pendiente | Reparado | Rechazado
  // Evaluación de daños
  gas_fecha_evaluacion?:       string;
  gas_evaluador_responsable?:  string;
  gas_porcentaje_dano?:        string;
  gas_tipo_costo?:             string;
  gas_monto_costo?:            string;
  gas_moneda_costo?:           string;
  // Reclamo a la aseguradora
  gas_fecha_comunicacion?:     string;
  gas_fecha_respuesta?:        string;
  gas_monto_solicitado?:       string;
  gas_moneda_solicitado?:      string;
  // Gestión del Recupero
  gas_fecha_recupero?:         string;
  gas_monto_indemnizado?:      string;
  gas_moneda_indemnizado?:     string;
  gas_estado_final_activo?:    string;
  gas_tipo_recupero?:          string;
  gas_cuenta_contable_ingreso?: string;
  gas_activos: ActivoSiniestroEntity[];
}

export interface  ActivoSiniestroEntity {
  codigo: string;
  descripcion: string;
  sucursal: string;
  valor: string;
  depreacumulada: string;
  vidautil: string;
}