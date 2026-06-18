import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ResumenActivoFijoEntity } from '../models/resumen-activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Resumen de Activos Fijos.
 * SRP: solo define el contrato de acceso a datos para el resumen de activos fijos.
 */
@Injectable()
export abstract class IResumenActivoFijoRepository {
  abstract obtenerTodos(): Observable<ResumenActivoFijoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<ResumenActivoFijoEntity>;
  abstract guardar(item: ResumenActivoFijoEntity): Observable<ApiResponse>;
  abstract actualizar(item: ResumenActivoFijoEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
