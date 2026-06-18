/**
 * Entidad de dominio: Generación de Asientos de Indexación.
 * Representa un registro del proceso de generación de asientos contables por indexación.
 * Convención de nombres: gai_campo (snake_case).
 */
export interface GeneracionAsientosIndexacionEntity {
  id?: string;
  gai_codigo: string;   // Código del proceso (INDEX-2025-10...)
  gai_periodo: string;   // Periodo del cálculo (202510...)
  gai_fecha_ejecucion: string;   // Fecha de ejecución del proceso
  gai_activos: string;   // Activo procesado
  gai_moneda: string;   // Moneda del ajuste (Soles, Dólares, etc.)
  gai_total_ajuste: string;   // Total de ajuste (puede ser negativo)
  gai_nuevo_valor: string;   // Nuevo valor del activo
  gai_fecha_contable: string;   // Fecha contable del asiento a generar
  gai_nro_asiento_cont: string;   // Número de asiento contable generado
  gai_usuarioEject: string;   // Usuario ejecutor del proceso
  gai_estado: string;   // Pendiente | Contabilizado
  gai_prefijo: string;   // Prefijo del asiento (INDEX)
  gai_observaciones: string;   // Observaciones adicionales
  gai_razonSocial: string;   // Razón social de la empresa
  gai_tipoMoneda: string;   // Tipo de moneda (Soles, Dólares)
  gai_libroContable: string;   // Libro contable (Principal, Tributario)
}
