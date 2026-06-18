import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map, catchError } from 'rxjs';
import { DetraccionEntity } from 'src/app/modules/contabilidad/domain/models/detraccion.entity';
import { IDetraccionRepository } from 'src/app/modules/contabilidad/domain/repositories/idetraccion.repository';
import { ApiResponse } from 'src/app/shared/models/api-response.model';

/**
 * Repositorio de Detracciones.
 * Responsabilidad única: acceso y persistencia de datos de detracciones/retenciones.
 * El JSON local actúa como fuente de verdad de lectura inicial (simulación de API REST).
 */
@Injectable()
export class DetraccionesRepositoryImpl implements IDetraccionRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/detracciones.json';

  // ─── READ ────────────────────────────────────────────────────────────────

  /**
   * Obtiene todas las detracciones desde el JSON (simulación de GET /api/detracciones).
   */
  obtenerTodos(): Observable<DetraccionEntity[]> {
    return this.http.get<DetraccionEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  /**
   * Obtiene una detracción por su código.
   */
  obtenerPorCodigo(codigo: string): Observable<DetraccionEntity | null> {
    return this.obtenerTodos().pipe(
      map(detracciones => detracciones.find(d => d.detraccion_codigo === codigo) ?? null)
    );
  }

  // ─── WRITE (simulados – preparados para conectar a API real) ───────────────

  /**
   * Simula la creación de una nueva detracción (POST /api/detracciones).
   */
  guardar(detraccion: DetraccionEntity): Observable<ApiResponse<DetraccionEntity>> {
    const payload: DetraccionEntity = {
      ...detraccion,
      detraccion_fecha_creacion: detraccion.detraccion_fecha_creacion || new Date().toISOString().substring(0, 10)
    };

    return of({
      success: true,
      message: '¡Detracción creada exitosamente!',
      data: payload,
      statusCode: 201,
      timestamp: new Date().toISOString()
    } as ApiResponse<DetraccionEntity>).pipe(delay(500));
  }

  /**
   * Simula la actualización de una detracción existente (PUT /api/detracciones/:codigo).
   */
  actualizar(detraccion: DetraccionEntity): Observable<ApiResponse<DetraccionEntity>> {
    return of({
      success: true,
      message: '¡Detracción actualizada exitosamente!',
      data: detraccion,
      statusCode: 200,
      timestamp: new Date().toISOString()
    } as ApiResponse<DetraccionEntity>).pipe(delay(500));
  }

  /**
   * Simula la eliminación de una detracción (DELETE /api/detracciones/:codigo).
   */
  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    return of({
      success: true,
      message: `¡Detracción ${codigo} eliminada exitosamente!`,
      data: true,
      statusCode: 200,
      timestamp: new Date().toISOString()
    } as ApiResponse<boolean>).pipe(delay(400));
  }
}
