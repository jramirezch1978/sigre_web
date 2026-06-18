export interface CentroCosto {
  id: number;
  codigo: string;
  nombre: string;
  tipo: 'PRODUCCION' | 'ADMINISTRATIVO' | 'VENTAS';
  responsableNombre: string;
  presupuestoMensual: number;
  gastoAcumulado: number;
  activo: boolean;
}

export interface DistribucionGasto {
  id: number;
  centroCostoId: number;
  centroCostoNombre: string;
  concepto: string;
  monto: number;
  fecha: string;
  periodo: string;
}

export interface AnalisisRentabilidad {
  centroCostoId: number;
  centroCostoNombre: string;
  ingresos: number;
  costos: number;
  utilidad: number;
  margen: number;
}
