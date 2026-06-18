import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ParamOperacionEntity } from '../models/param-operacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Parámetros de Operaciones.
 * SRP: solo define el contrato de acceso a datos para la configuración global.
 */
@Injectable()
export abstract class IParamOperacionRepository {
  abstract obtenerTodos(): Observable<ParamOperacionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<ParamOperacionEntity>;
  abstract guardar(paramOperacion: ParamOperacionEntity): Observable<ApiResponse>;
  abstract actualizar(paramOperacion: ParamOperacionEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
