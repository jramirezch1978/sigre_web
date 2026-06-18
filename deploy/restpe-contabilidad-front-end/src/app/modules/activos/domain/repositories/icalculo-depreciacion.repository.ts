import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { CalculoDepreciacionEntity } from '../models/calculo-depreciacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Cálculo de Depreciación.
 * SRP: solo define el contrato de acceso a datos para los cálculos de depreciación.
 */
@Injectable()
export abstract class ICalculoDepreciacionRepository {
  abstract obtenerTodos(): Observable<CalculoDepreciacionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<CalculoDepreciacionEntity>;
  abstract guardar(item: CalculoDepreciacionEntity): Observable<ApiResponse>;
  abstract actualizar(item: CalculoDepreciacionEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
