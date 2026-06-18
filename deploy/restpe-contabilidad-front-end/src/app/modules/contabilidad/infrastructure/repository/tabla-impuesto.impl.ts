import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, catchError } from 'rxjs';
import { ITablaImpuestoRepository } from '../../domain/repositories/itable-impuesto.repository';
import { TablaImpuestoEntity } from '../../domain/models/tabla-impuesto.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * TablaImpuestoRepositoryImpl — Infrastructure Layer.
 * Responsabilidad única: acceso y persistencia de registros de impuestos.
 * El JSON local simula una API REST de lectura inicial.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class TablaImpuestoRepositoryImpl implements ITablaImpuestoRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/tabla-impuesto.json';

  // ─── READ ────────────────────────────────────────────────────────────────

  /**
   * Obtiene todos los impuestos desde el JSON
   * (simulación de GET /api/contabilidad/impuestos).
   */
  obtenerTodos(): Observable<TablaImpuestoEntity[]> {
    return this.http.get<TablaImpuestoEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  // ─── WRITE (simulados — listos para conectar con API real) ───────────────

  /**
   * Guarda un nuevo impuesto (simulación de POST /api/contabilidad/impuestos).
   */
  guardar(item: TablaImpuestoEntity): Observable<ApiResponse<TablaImpuestoEntity>> {
    return of({
      success: true,
      data: item,
      message: `¡Impuesto registrado exitosamente!`,
    } as ApiResponse<TablaImpuestoEntity>).pipe(delay(300));
  }

  /**
   * Actualiza un impuesto existente (simulación de PUT /api/contabilidad/impuestos/:codigo).
   */
  actualizar(item: TablaImpuestoEntity): Observable<ApiResponse<TablaImpuestoEntity>> {
    return of({
      success: true,
      data: item,
      message: `¡Impuesto actualizado exitosamente!`,
    } as ApiResponse<TablaImpuestoEntity>).pipe(delay(300));
  }
}
