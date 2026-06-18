/**
 * Entidad de dominio: Generación de Devengo de Aseguradores.
 * Representa un registro del proceso de devengo mensual de seguros.
 * Convención de nombres: gda_campo (snake_case).
 */
export interface GeneracionDevengoAseguradoresEntity {
  id?: string;
  gda_codigo:          string;  // Código del proceso (DEVP-2025-10...)
  gda_periodo:         string;  // Periodo contable (202511)
  gda_fecha_ejecucion: string;  // Fecha de ejecución
  gda_usuario:         string;  // Usuario que ejecutó
  gda_tipo_poliza:     string;  // todo-riesgo | incendio | robo | responsabilidad | otro
  gda_fuente_datos:    string;  // vigente | todas
  gda_tipo_calculo:    string;  // lineal | proporcional
  gda_libro_contable:  string;  // principal | tributario
  gda_centro_costo?:   string;  // Centro de costos
  gda_periodo_devengo: string;  // Periodo a devengar (202511)
  gda_prefijo?:        string;  // Prefijo de documento
  gda_observaciones?:  string;  // Observaciones
  gda_seguros:         number;  // Cantidad de seguros procesados
  gda_devengado_mes:   string;  // Devengo total del mes
  gda_asiento:         string;  // Número de asiento contable
  gda_estado:          string;  // Pendiente | Contabilizado
  gda_polizas?:        any[];   // Lista de pólizas del proceso (tabla secundaria)
}
