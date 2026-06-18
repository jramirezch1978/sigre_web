import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map, catchError } from 'rxjs';
import { CentroCostoEntity } from '../../domain/models/centro-costo.entity';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { ICentroCostoRepository } from '../../domain/repositories/icentro-costo.repository';

/**
 * Repositorio de Plan de Centros de Costos.
 * Responsabilidad única: acceso y persistencia de datos de centros de costo.
 * El JSON local actúa como fuente de verdad de lectura inicial (simulación de API REST).
 */
@Injectable()
export class PlanCentroCostosRepositoryImpl implements ICentroCostoRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/centro-de-costos.json';

  // ─── READ ────────────────────────────────────────────────────────────────

  /**
   * Obtiene todos los centros de costo desde el JSON (simulación de GET /api/centros-costo).
   */
  obtenerTodos(): Observable<CentroCostoEntity[]> {
    return this.http.get<CentroCostoEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  /**
   * Obtiene un centro de costo por su código.
   */
  obtenerPorCodigo(codigo: string): Observable<CentroCostoEntity | null> {
    return this.obtenerTodos().pipe(
      map(centros => centros.find(c => c.centro_costo_codigo === codigo) ?? null)
    );
  }

  // ─── WRITE (simulados – preparados para conectar a API real) ───────────────

  /**
   * Simula la creación de un nuevo centro de costo (POST /api/centros-costo).
   */
  guardar(centro: CentroCostoEntity): Observable<ApiResponse<CentroCostoEntity>> {
    const payload: CentroCostoEntity = {
      ...centro,
      centro_costo_fecha_creacion: centro.centro_costo_fecha_creacion || new Date().toISOString().substring(0, 10),
      centro_costo_fecha_modificacion: new Date().toISOString().substring(0, 10)
    };

    return of({
      success: true,
      message: '¡Centro de costo registrado exitosamente!',
      data: payload,
      statusCode: 201,
      timestamp: new Date().toISOString()
    } as ApiResponse<CentroCostoEntity>).pipe(delay(500));
  }

  /**
   * Simula la actualización de un centro de costo existente (PUT /api/centros-costo/:codigo).
   */
  actualizar(centro: CentroCostoEntity): Observable<ApiResponse<CentroCostoEntity>> {
    const payload: CentroCostoEntity = {
      ...centro,
      centro_costo_fecha_modificacion: new Date().toISOString().substring(0, 10)
    };

    return of({
      success: true,
      message: '¡Cambios guardados exitosamente!',
      data: payload,
      statusCode: 200,
      timestamp: new Date().toISOString()
    } as ApiResponse<CentroCostoEntity>).pipe(delay(500));
  }

  /**
   * Simula la eliminación lógica de un centro de costo (DELETE /api/centros-costo/:codigo).
   */
  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    return of({
      success: true,
      message: `¡Centro de costo ${codigo} eliminado exitosamente!`,
      data: true,
      statusCode: 200,
      timestamp: new Date().toISOString()
    } as ApiResponse<boolean>).pipe(delay(400));
  }
}
