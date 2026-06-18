import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AplicacionPagosEntity } from '../models/aplicacion-pagos.entity';
import { AplicacionPagosPlanillaEntity } from '../models/aplicacion-pagos-planilla.entity';
import { AplicacionPagosTrabajadorEntity } from '../models/aplicacion-pagos-trabajador.entity';

/** Opción genérica id/nombre para selectores. (Bancos: incluye su moneda.) */
export interface OpcionPago { id: number; nombre: string; monedaId?: number | null; }

/** Cabecera del pago consolidado (caja_bancos, flag_tipo_transaccion='P'). */
export interface PagoConsolidado {
  bancoCntaId: number;
  conceptoFinancieroId: number;
  fechaEmision: string;
  observacion?: string;
  medioPagoId?: number | null;
  /** Moneda del pago (la de la cuenta bancaria). El backend la exige al generar el asiento. */
  monedaId?: number | null;
  documentos: AplicacionPagosEntity[];
}

@Injectable()
export abstract class IAplicacionPagosRepository {
  /** Lista los documentos por pagar (finanzas.cuentas_pagar). */
  abstract obtenerTodos(): Observable<AplicacionPagosEntity[]>;
  abstract guardar(entity: AplicacionPagosEntity): Observable<AplicacionPagosEntity>;
  abstract actualizar(entity: AplicacionPagosEntity): Observable<AplicacionPagosEntity>;
  abstract obtenerPlanillas(): Observable<AplicacionPagosPlanillaEntity[]>;
  abstract obtenerTrabajadores(): Observable<AplicacionPagosTrabajadorEntity[]>;
  /** Registra un pago consolidado (POST /caja-bancos, P) → id del movimiento. */
  abstract pagarDocumentos(pago: PagoConsolidado): Observable<number>;
  /** Ejecuta el pago (afecta saldos + asiento). */
  abstract ejecutar(id: number): Observable<boolean>;
  /** Anula el pago. */
  abstract anular(id: number): Observable<boolean>;
  /** Catálogo de cuentas bancarias. */
  abstract listarBancos(): Observable<OpcionPago[]>;
  /** Catálogo de conceptos financieros. */
  abstract listarConceptos(): Observable<OpcionPago[]>;
}
