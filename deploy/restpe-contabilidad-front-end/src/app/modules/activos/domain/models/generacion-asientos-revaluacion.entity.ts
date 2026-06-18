/**
 * Entidad de dominio: Generación de Asientos de Revaluación.
 * Representa un registro del proceso de generación de asientos contables por revaluación.
 * Convención de nombres: gar_campo (snake_case).
 */
export interface GeneracionAsientosRevaluacionEntity {
  id?: string;
  gar_codigo:           string;   // Código del proceso (RVAP-2025-10...)
  gar_fecha_revaluacion: string;  // Fecha de revaluación
  gar_activo:           string;   // Activo procesado
  gar_moneda:           string;   // Moneda del ajuste (Soles, Dólares, etc.)
  gar_total_ajuste:     number;   // Total ajuste (puede ser negativo)
  gar_nuevo_valor:      number;   // Nuevo valor del activo
  gar_fecha_contable:   string;   // Fecha contable
  gar_nro_asiento_cont: string;   // Número de asiento contable generado
  gar_usuarioResp:      string;   // Usuario que registró el proceso
  gar_estado:           string;   // Pendiente | Contabilizado
  gar_show_eye:         boolean;  // Controla visibilidad del ícono ojo
  gar_razonSocial:      string;   // Razón social de la empresa
  gar_fechaRegistro:    string;   // Fecha de registro
  gar_periodoContable:  string;   // Periodo contable (202601...)
  gar_tipoRevaluacion:  string;   // Tipo de revaluación (Comercial, Técnica)
  gar_origenDatos:      string;   // Origen de datos (RV-0001...)
  gar_fechaContabilizacion: string; // Fecha de contabilización
  gar_libroContable:    string;   // Libro contable (Principal, Tributario)
  gar_prefijoDocumento: string;   // Prefijo del documento
  gar_centroCosto:      string;   // Centro de costo
  gar_observaciones:    string;   // Observaciones adicionales
}
