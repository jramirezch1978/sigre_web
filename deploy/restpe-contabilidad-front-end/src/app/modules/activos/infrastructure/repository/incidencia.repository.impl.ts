import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IIncidenciaRepository } from '../../domain/repositories/iincidencia.repository';
import { IncidenciaEntity } from '../../domain/models/incidencia.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const INCIDENCIA_JSON_PATH = 'assets/data/activo-fijo/tabla/incidencias.json';
const INCIDENCIA_LS_KEY    = 'incidencias';

/**
 * Implementación del repositorio de Incidencias.
 * SRP: únicamente acceso y persistencia de incidencias.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class IncidenciaRepositoryImpl extends IIncidenciaRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  /**
   * Devuelve todas las incidencias:
   * 1. Datos semilla del JSON (assets).
   * 2. Registros nuevos del usuario en localStorage.
   * Los duplicados (mismo código) del JSON son ignorados si ya existen en localStorage.
   * Ordenados por número de código descendente (más reciente primero).
   */
  obtenerTodos(): Observable<IncidenciaEntity[]> {
    return this.http.get<IncidenciaEntity[]>(INCIDENCIA_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: IncidenciaEntity[]) => {
        const localItems: IncidenciaEntity[] = (this.simulation.list(INCIDENCIA_LS_KEY) || [])
          .filter((a: IncidenciaEntity) => !!a.incidencia_codigo);
        const codigosLocal = new Set(localItems.map((a: IncidenciaEntity) => a.incidencia_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.incidencia_codigo));
        const todos        = [...localItems, ...soloJson];

        // Ordenar por número de código descendente (IN-AF-016 primero)
        return todos.sort((a, b) => {
          const numA = parseInt((a.incidencia_codigo.match(/IN-AF-(\d+)/) ?? ['', '0'])[1], 10);
          const numB = parseInt((b.incidencia_codigo.match(/IN-AF-(\d+)/) ?? ['', '0'])[1], 10);
          return numB - numA;
        });
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<IncidenciaEntity> {
    return this.http.get<IncidenciaEntity[]>(INCIDENCIA_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: IncidenciaEntity[]) => {
        const localItems: IncidenciaEntity[] = this.simulation.list(INCIDENCIA_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.incidencia_codigo === codigo);
        if (!encontrado) throw new Error(`Incidencia con código ${codigo} no encontrada`);
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(incidencia: IncidenciaEntity): Observable<ApiResponse> {
    this.simulation.save(INCIDENCIA_LS_KEY, incidencia);
    return of({ success: true, message: 'Incidencia guardada correctamente', data: incidencia })
      .pipe(delay(400));
  }

  actualizar(incidencia: IncidenciaEntity): Observable<ApiResponse> {
    const todos: IncidenciaEntity[] = this.simulation.list(INCIDENCIA_LS_KEY) || [];
    const idx = todos.findIndex(a => a.incidencia_codigo === incidencia.incidencia_codigo);

    if (idx !== -1) {
      todos[idx] = incidencia;
      this.simulation.replace(INCIDENCIA_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(INCIDENCIA_LS_KEY, incidencia);
    }

    return of({ success: true, message: 'Incidencia actualizada correctamente', data: incidencia })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: IncidenciaEntity[] = this.simulation.list(INCIDENCIA_LS_KEY) || [];
    const filtrado = todos.filter(a => a.incidencia_codigo !== codigo);
    this.simulation.replace(INCIDENCIA_LS_KEY, filtrado);
    return of({ success: true, message: 'Incidencia eliminada correctamente', data: true })
      .pipe(delay(300));
  }
}
