import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { GeneracionAsientosDepreciacionEntity } from '../models/generacion-asientos-depreciacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Generación de Asientos de Depreciación.
 * SRP: solo define el contrato de acceso a datos para la generación de asientos.
 */
@Injectable()
export abstract class IGeneracionAsientosDepreciacionRepository {
  abstract obtenerTodos(): Observable<GeneracionAsientosDepreciacionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosDepreciacionEntity>;
  abstract guardar(item: GeneracionAsientosDepreciacionEntity): Observable<ApiResponse>;
  abstract actualizar(item: GeneracionAsientosDepreciacionEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
