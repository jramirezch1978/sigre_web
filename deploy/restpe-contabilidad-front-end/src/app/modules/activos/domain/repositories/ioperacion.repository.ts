import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { OperacionEntity } from '../models/operacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Operaciones de Activos Fijos.
 * SRP: solo define el contrato de acceso a datos para operaciones.
 */
@Injectable()
export abstract class IOperacionRepository {
  abstract obtenerTodos(): Observable<OperacionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<OperacionEntity>;
  abstract guardar(operacion: OperacionEntity): Observable<ApiResponse>;
  abstract actualizar(operacion: OperacionEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
