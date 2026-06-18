import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of, map } from 'rxjs';
import { IGestionAsientosManualesRepository } from '../../domain/repositories/igestion-asientos-manuales.repository';
import { AsientoManualItem, GestionAsientosManualesEntity } from '../../domain/models/gestion-asientos-manual.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * GestionAsientosManualesRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso y persistencia de asientos manuales.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class GestionAsientosManualesRepositoryImpl implements IGestionAsientosManualesRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/operaciones/gestion-asientos-manual.json';

  // ─── READ ────────────────────────────────────────────────────────────────

  /**
   * Obtiene los asientos manuales desde el JSON
   * (simulación de GET /api/contabilidad/operaciones/asientos-manuales).
   */
  obtenerTodos(): Observable<AsientoManualItem[]> {
    return this.http.get<GestionAsientosManualesEntity>(this.JSON_PATH).pipe(
      delay(300),
      map(entity => entity.items ?? []),
      catchError(() => of([]))
    );
  }

  // ─── WRITE (simulados — listos para conectar con API real) ───────────────

  /**
   * Guarda un nuevo asiento manual (simulación de POST /api/contabilidad/asientos-manuales).
   */
  guardar(asiento: AsientoManualItem): Observable<ApiResponse<AsientoManualItem>> {
    return of({
      success: true,
      data: asiento,
      message: `Asiento ${asiento.asiento_manual_numero_asiento} registrado exitosamente.`,
    } as ApiResponse<AsientoManualItem>).pipe(delay(300));
  }

  /**
   * Actualiza un asiento manual existente (simulación de PUT /api/contabilidad/asientos-manuales/:nro).
   */
  actualizar(asiento: AsientoManualItem): Observable<ApiResponse<AsientoManualItem>> {
    return of({
      success: true,
      data: asiento,
      message: `Asiento ${asiento.asiento_manual_numero_asiento} actualizado exitosamente.`,
    } as ApiResponse<AsientoManualItem>).pipe(delay(300));
  }

  /**
   * Anula (inactiva) un asiento manual (simulación de PATCH /api/contabilidad/asientos-manuales/:nro/anular).
   */
  anular(nroAsiento: string): Observable<ApiResponse<boolean>> {
    return of({
      success: true,
      data: true,
      message: `Asiento ${nroAsiento} inactivado exitosamente.`,
    } as ApiResponse<boolean>).pipe(delay(300));
  }
}

