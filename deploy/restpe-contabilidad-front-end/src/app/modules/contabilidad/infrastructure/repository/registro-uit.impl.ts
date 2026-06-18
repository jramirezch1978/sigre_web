import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, catchError } from 'rxjs';
import { IRegistroUitRepository } from '../../domain/repositories/iregistro-uit.repository';
import { RegistroUitEntity } from '../../domain/models/registro-uit.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * RegistroUitRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso y persistencia de registros UIT.
 * El JSON local simula una API REST de lectura inicial.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class RegistroUitRepositoryImpl implements IRegistroUitRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/registro-uit.json';

  // ─── READ ────────────────────────────────────────────────────────────────

  /**
   * Obtiene todos los registros UIT desde el JSON
   * (simulación de GET /api/contabilidad/uit).
   */
  obtenerTodos(): Observable<RegistroUitEntity[]> {
    return this.http.get<RegistroUitEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  // ─── WRITE (simulados — listos para conectar con API real) ───────────────

  /**
   * Guarda un nuevo registro UIT (simulación de POST /api/contabilidad/uit).
   */
  guardar(item: RegistroUitEntity): Observable<ApiResponse<RegistroUitEntity>> {
    return of({
      success: true,
      data: item,
      message: `UIT ${item.registro_uit_anio_fiscal} (S/ ${item.registro_uit_valor_uit.toLocaleString('es-PE', { minimumFractionDigits: 2 })}) registrada exitosamente.`,
    } as ApiResponse<RegistroUitEntity>).pipe(delay(300));
  }

  /**
   * Actualiza un registro UIT existente (simulación de PUT /api/contabilidad/uit/:anioFiscal).
   */
  actualizar(item: RegistroUitEntity): Observable<ApiResponse<RegistroUitEntity>> {
    return of({
      success: true,
      data: item,
      message: `UIT ${item.registro_uit_anio_fiscal} actualizada exitosamente.`,
    } as ApiResponse<RegistroUitEntity>).pipe(delay(300));
  }
}
