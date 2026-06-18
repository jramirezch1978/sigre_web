import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SeguroEntity } from '../models/seguro.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Tipos de Seguro de Activos Fijos.
 * SRP: solo define el contrato de acceso a datos para tipos de seguro.
 */
@Injectable()
export abstract class ISeguroRepository {
  abstract obtenerTodos(): Observable<SeguroEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<SeguroEntity>;
  abstract guardar(seguro: SeguroEntity): Observable<ApiResponse>;
  abstract actualizar(seguro: SeguroEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
