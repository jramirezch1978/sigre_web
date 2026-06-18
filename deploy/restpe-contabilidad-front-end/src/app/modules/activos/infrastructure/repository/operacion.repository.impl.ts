import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IOperacionRepository } from '../../domain/repositories/ioperacion.repository';
import { OperacionEntity } from '../../domain/models/operacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const OPERACION_JSON_PATH = 'assets/data/activo-fijo/tabla/operaciones.json';
const OPERACION_LS_KEY    = 'operacion';

/**
 * Implementación del repositorio de Operaciones de Activos Fijos.
 * SRP: únicamente acceso y persistencia de los tipos de operación.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class OperacionRepositoryImpl extends IOperacionRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  obtenerTodos(): Observable<OperacionEntity[]> {
    return this.http.get<OperacionEntity[]>(OPERACION_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: OperacionEntity[]) => {
        const localItems: OperacionEntity[] = (this.simulation.list(OPERACION_LS_KEY) || [])
          .filter((a: OperacionEntity) => !!a.operacion_codigo);
        const codigosLocal = new Set(localItems.map((a: OperacionEntity) => a.operacion_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.operacion_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<OperacionEntity> {
    return this.http.get<OperacionEntity[]>(OPERACION_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: OperacionEntity[]) => {
        const localItems: OperacionEntity[] = this.simulation.list(OPERACION_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.operacion_codigo === codigo);
        if (!encontrado) throw new Error(`Operación con código ${codigo} no encontrada`);
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(operacion: OperacionEntity): Observable<ApiResponse> {
    this.simulation.save(OPERACION_LS_KEY, operacion);
    return of({ success: true, message: 'Operación guardada correctamente', data: operacion })
      .pipe(delay(400));
  }

  actualizar(operacion: OperacionEntity): Observable<ApiResponse> {
    const todos: OperacionEntity[] = this.simulation.list(OPERACION_LS_KEY) || [];
    const idx = todos.findIndex(a => a.operacion_codigo === operacion.operacion_codigo);

    if (idx !== -1) {
      todos[idx] = operacion;
      this.simulation.replace(OPERACION_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(OPERACION_LS_KEY, operacion);
    }

    return of({ success: true, message: 'Operación actualizada correctamente', data: operacion })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: OperacionEntity[] = this.simulation.list(OPERACION_LS_KEY) || [];
    const filtrados = todos.filter(a => a.operacion_codigo !== codigo);
    this.simulation.replace(OPERACION_LS_KEY, filtrados);

    return of({ success: true, message: 'Operación eliminada correctamente', data: null })
      .pipe(delay(400));
  }
}
