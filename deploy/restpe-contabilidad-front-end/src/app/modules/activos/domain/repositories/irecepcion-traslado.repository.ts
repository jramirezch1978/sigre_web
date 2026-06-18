import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RecepcionTrasladoEntity } from '../models/recepcion-traslado.entity';

/**
 * Contrato (puerto) del repositorio de Recepción de Traslados.
 * SRP: solo define el contrato de acceso a datos para traslados de activos fijos.
 */
@Injectable()
export abstract class IRecepcionTrasladoRepository {
  abstract obtenerTodos(): Observable<RecepcionTrasladoEntity[]>;
}
