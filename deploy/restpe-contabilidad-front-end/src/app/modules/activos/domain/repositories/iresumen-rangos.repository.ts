import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ResumenRangosEntity } from '../models/resumen-rangos.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Resumen de Activos por Rangos.
 * SRP: solo define el contrato de acceso a datos para el resumen de rangos.
 */
@Injectable()
export abstract class IResumenRangosRepository {
  abstract obtenerTodos(): Observable<ResumenRangosEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<ResumenRangosEntity>;
  abstract guardar(item: ResumenRangosEntity): Observable<ApiResponse>;
  abstract actualizar(item: ResumenRangosEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
