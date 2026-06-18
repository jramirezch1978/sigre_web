/**
 * TablaImpuestoEntity — Domain Model
 * Representa un impuesto registrado en la tabla de impuestos del módulo contabilidad.
 * Campos derivados de los ColDefs del componente contabilidad-tabla-impuestos.
 */
export interface TablaImpuestoEntity {
  /** Código único del impuesto. Ej: IMP-001 */
  impuesto_codigo: string;
  /** Tipo de impuesto. Ej: IGV, IVA, ISRL, ICBPER, OTROS */
  impuesto_tipo: string;
  /** Código SUN del impuesto (generalmente igual al tipo) */
  impuesto_codigo_sun: string;
  /** Descripción completa del impuesto */
  impuesto_descripcion: string;
  /** Porcentaje aplicable con símbolo %. Ej: "18%" */
  impuesto_porcentaje: string;
  /** Ámbito de aplicación: "compras", "ventas" o "compras, ventas" */
  impuesto_aplicable: string;
  /** Código o nombre de la cuenta contable asociada */
  impuesto_cuenta_c: string;
  /** Fecha de inicio de vigencia en formato DD/MM/YYYY */
  impuesto_vigente: string;
  /** Fecha de fin de vigencia en formato DD/MM/YYYY */
  impuesto_vigencia_h?: string;
  /** Observaciones adicionales */
  impuesto_observacion?: string;
  /** Usuario responsable del registro */
  impuesto_usuario_r?: string;
  /** Fecha de creación del registro en formato DD/MM/YYYY */
  impuesto_fecha_creacion?: string;
  /** Estado del impuesto: "Activo" | "Inactivo" */
  impuesto_estado: string;
}
