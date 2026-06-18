import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { UbicacionActivoEntity } from '../models/ubicacion-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Ubicaciones de Activos Fijos.
 * SRP: solo define el contrato de acceso a datos para ubicaciones.
 */
@Injectable()
export abstract class IUbicacionActivoRepository {
  abstract obtenerTodos(): Observable<UbicacionActivoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<UbicacionActivoEntity>;
  abstract guardar(ubicacion: UbicacionActivoEntity): Observable<ApiResponse>;
  abstract actualizar(ubicacion: UbicacionActivoEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
