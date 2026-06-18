/**
 * Sub-entidades del Maestro Contable.
 * Cada sección del reporte corresponde a una vista del maestro.
 */

export interface PlanCuentaItem {
  codigo: string;
  denominacion: string;
  naturaleza: string;
  nivel: number;
  fechaC: string;
  usuario: string;
  estado: string;
}

export interface CentroCostoItem {
  codigo: string;
  denominacion: string;
  area: string;
  responsable: string;
  fechaC: string;
  usuario: string;
  estado: string;
}

export interface ImpuestoMaestroItem {
  codigo: string;
  denominacion: string;
  tasa: string;
  cuentaC: string;
  fechaC: string;
  usuario: string;
  estado: string;
}

export interface DetraccionMaestroItem {
  codigo: string;
  codigoEntidad: string;
  denominacion: string;
  detraccion: string;
  cuentaC: string;
  fechaC: string;
  usuario: string;
  estado: string;
}

export interface ConfiguracionContableItem {
  moduloO: string;
  cuentaD: string;
  cuentaC: string;
  centroC: string;
  fechaC: string;
  usuario: string;
  estado: string;
}

/**
 * MaestroContableEntity — Entidad raíz del Maestro Contable.
 * Agrupa las 5 secciones del reporte:
 * plan de cuentas, centros de costo, impuestos, detracciones y configuraciones.
 */
export interface MaestroContableEntity {
  planCuentas: PlanCuentaItem[];
  centroCosto: CentroCostoItem[];
  impuestos: ImpuestoMaestroItem[];
  tiposDetraccion: DetraccionMaestroItem[];
  configuraciones: ConfiguracionContableItem[];
}
