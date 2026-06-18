import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { CerrarLiqAdelantosEntity } from '../models/cerrar-liq-adelantos.entity';

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

/** Opción id/nombre para selectores y resolución de catálogos. */
export interface OpcionCatalogo { id: number; nombre: string; }

@Injectable()
export abstract class ICerrarLiqAdelantosRepository {
  abstract obtenerTodos(): Observable<CerrarLiqAdelantosEntity[]>;
  abstract actualizar(entity: CerrarLiqAdelantosEntity): Observable<CerrarLiqAdelantosEntity>;
  /** Valida que la liquidación puede cerrarse (antes de cerrar). */
  abstract validarCierre(id: number): Observable<ValidacionCierre>;
  /** Monedas (ms-core-maestros) para resolver el nombre por id en la tabla. */
  abstract listarMonedas(): Observable<OpcionCatalogo[]>;
}
