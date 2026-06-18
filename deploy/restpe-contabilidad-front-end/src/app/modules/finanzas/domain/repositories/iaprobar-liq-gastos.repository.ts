import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { LiqRendicionEntity } from '../models/liq-rendicion.entity';

/** Resultado de `GET /liquidaciones/{id}/validacion-cierre` (FI324). */
export interface ValidacionCierre {
  id: number;
  nroLiquidacion?: string;
  importeNeto?: number;
  sumaDetalles?: number;
  cuadrado?: boolean;
  solicitudGiroId?: number;
  solicitudGiroNumero?: string;
  puedeCerrar?: boolean;
}

@Injectable()
export abstract class IAprobarLiqGastosRepository {
  abstract obtenerTodos(): Observable<LiqRendicionEntity[]>;
  abstract actualizar(entity: LiqRendicionEntity): Observable<LiqRendicionEntity>;
  /** Valida que la liquidación puede cerrarse (antes de aprobar). */
  abstract validarCierre(id: number): Observable<ValidacionCierre>;
}
