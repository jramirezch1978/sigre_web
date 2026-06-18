import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map, catchError } from 'rxjs';
import { ICuentaVsSubcategoriaRepository } from '../../domain/repositories/icuenta-vs-subcategoria.repository';
import { CuentaVsSubcategoriaEntity } from '../../domain/models/cuenta-vs-subcategoria.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { CUENTA_VS_SUBCATEGORIA_MENSAJES_FALLBACK } from '@modules/contabilidad/constants/cuenta-vs-subcategoria.constants';

/**
 * Repositorio de Cuentas vs Subcategorías — Infrastructure Layer.
 * Responsabilidad única: acceso y persistencia de la relación entre
 * subcategorías de artículos y sus cuentas contables.
 * El JSON local actúa como fuente de verdad de lectura inicial (simulación de API REST).
 */
@Injectable()
export class CuentaVsSubcategoriasRepositoryImpl implements ICuentaVsSubcategoriaRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/tablas/cuentas-vs-subcategorias.json';

  // ─── READ ────────────────────────────────────────────────────────────────

  /**
   * Obtiene todas las relaciones cuentas-vs-subcategorías desde el JSON
   * (simulación de GET /api/cuentas-vs-subcategorias).
   */
  obtenerTodos(): Observable<CuentaVsSubcategoriaEntity[]> {
    return this.http.get<CuentaVsSubcategoriaEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  /**
   * Obtiene una relación por su código.
   */
  obtenerPorCodigo(codigo: string): Observable<CuentaVsSubcategoriaEntity | null> {
    return this.http.get<CuentaVsSubcategoriaEntity[]>(this.JSON_PATH).pipe(
      delay(200),
      map(items => items.find(i => i.cuenta_sub_codigo === codigo) ?? null),
      catchError(() => of(null))
    );
  }

  // ─── WRITE (simulados — listos para conectar con API real) ───────────────

  /**
   * Actualiza una relación existente (simulación de PUT /api/cuentas-vs-subcategorias/:codigo).
   */
  actualizar(item: CuentaVsSubcategoriaEntity): Observable<ApiResponse<CuentaVsSubcategoriaEntity>> {
    return of({
      success: true,
      data: item,
      message: CUENTA_VS_SUBCATEGORIA_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION,
    } as ApiResponse<CuentaVsSubcategoriaEntity>).pipe(delay(300));
  }
}
