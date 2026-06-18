export interface MovimientoCaja {
  id: number;
  tipo: 'INGRESO' | 'EGRESO';
  concepto: string;
  monto: number;
  medioPago: 'EFECTIVO' | 'TARJETA' | 'TRANSFERENCIA' | 'CHEQUE';
  referencia: string;
  fecha: string;
  cajaId: number;
  usuarioId: number;
  usuarioNombre: string;
}

export interface CajaDiaria {
  id: number;
  fecha: string;
  saldoInicial: number;
  totalIngresos: number;
  totalEgresos: number;
  saldoFinal: number;
  estado: 'ABIERTA' | 'CERRADA';
  responsableNombre: string;
}

export interface CuentaBancaria {
  id: number;
  banco: string;
  numeroCuenta: string;
  tipo: 'CORRIENTE' | 'AHORROS';
  moneda: string;
  saldoActual: number;
  activa: boolean;
}
