import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { DepreciacionAnualEntity } from '../models/depreciacion-anual.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Depreciación Anual de Activos Fijos.
 * SRP: solo define el contrato de acceso a datos para depreciación anual.
 */
@Injectable()
export abstract class IDepreciacionAnualRepository {
  abstract obtenerTodos(): Observable<DepreciacionAnualEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<DepreciacionAnualEntity>;
  abstract guardar(item: DepreciacionAnualEntity): Observable<ApiResponse>;
  abstract actualizar(item: DepreciacionAnualEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
