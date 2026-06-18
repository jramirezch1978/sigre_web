import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IActivoFijoRepository } from '../../domain/repositories/iactivo-fijo.repository';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';
import { ACTIVO_FIJO_JSON_PATH } from '../../constants/activo-fijo.constants';

/**
 * Implementación del repositorio de Activos Fijos.
 *
 * Responsabilidad única (SRP): acceso y persistencia de activos fijos.
 *
 * Estrategia de datos:
 * - Lectura: combina el JSON seed (assets) con los registros guardados en localStorage.
 * - Escritura: persiste en localStorage a través de SimulationService.
 */
@Injectable()
export class ActivoFijoRepositoryImpl extends IActivoFijoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  /**
   * Devuelve todos los activos fijos:
   * 1. Datos semilla del JSON (assets).
   * 2. Registros guardados por el usuario en localStorage.
   * Los duplicados (mismo `codigo`) del JSON son ignorados si ya existen en localStorage.
   * El resultado se ordena por código descendente (más recientes primero).
   */
  obtenerTodos(): Observable<ActivoFijoEntity[]> {
    return this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH).pipe(
      delay(800),
      map((jsonActivos: ActivoFijoEntity[]) => {
        const localActivos: ActivoFijoEntity[] = (this.simulation.list('activoFijo') || [])
          .filter((a: ActivoFijoEntity) => !!a.activo_fijo_codigo);
        const codigosLocal = new Set(localActivos.map((a: ActivoFijoEntity) => a.activo_fijo_codigo));
        const soloJson     = jsonActivos.filter(a => !codigosLocal.has(a.activo_fijo_codigo));
        const combinados   = [...localActivos, ...soloJson];

        return combinados.sort((a, b) => {
          const numA = parseInt(a.activo_fijo_codigo?.split('-')[1] ?? '0', 10) || 0;
          const numB = parseInt(b.activo_fijo_codigo?.split('-')[1] ?? '0', 10) || 0;
          return numB - numA;
        });
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<ActivoFijoEntity> {
    return this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH).pipe(
      delay(200),
      map((jsonActivos: ActivoFijoEntity[]) => {
        const localActivos: ActivoFijoEntity[] = this.simulation.list('activoFijo') || [];
        const todos = [...localActivos, ...jsonActivos];
        const encontrado = todos.find(a => a.activo_fijo_codigo === codigo);
        if (!encontrado) {
          throw new Error(`Activo fijo con código "${codigo}" no encontrado`);
        }
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura (localStorage via SimulationService)
  // ─────────────────────────────────────────────

  guardar(activo: ActivoFijoEntity): Observable<ApiResponse<ActivoFijoEntity>> {
    this.simulation.save('activoFijo', activo);
    return of({
      success: true,
      message: 'Activo fijo guardado exitosamente',
      data: activo,
    }).pipe(delay(400));
  }

  actualizar(activo: ActivoFijoEntity): Observable<ApiResponse<ActivoFijoEntity>> {
    const todos: ActivoFijoEntity[] = this.simulation.list('activoFijo') || [];
    const actualizados = todos.map((a: ActivoFijoEntity) =>
      a.activo_fijo_codigo === activo.activo_fijo_codigo ? { ...a, ...activo } : a
    );
    this.simulation.replace('activoFijo', actualizados);
    return of({
      success: true,
      message: 'Activo fijo actualizado exitosamente',
      data: activo,
    }).pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    const todos: ActivoFijoEntity[] = this.simulation.list('activoFijo') || [];
    const filtrados = todos.filter((a: ActivoFijoEntity) => a.activo_fijo_codigo !== codigo);
    this.simulation.replace('activoFijo', filtrados);
    return of({
      success: true,
      message: 'Activo fijo eliminado exitosamente',
      data: true,
    }).pipe(delay(400));
  }
}
