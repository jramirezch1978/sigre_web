import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IParamOperacionRepository } from '../../domain/repositories/iparam-operacion.repository';
import { ParamOperacionEntity } from '../../domain/models/param-operacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const PARAM_OPERACION_JSON_PATH = 'assets/data/activo-fijo/tabla/param-operaciones.json';
const PARAM_OPERACION_LS_KEY    = 'paramOperacion';

/**
 * Implementación del repositorio de Parámetros de Operaciones de Activos Fijos.
 * SRP: únicamente acceso y persistencia de la configuración global del módulo.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class ParamOperacionRepositoryImpl extends IParamOperacionRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  obtenerTodos(): Observable<ParamOperacionEntity[]> {
    return this.http.get<ParamOperacionEntity[]>(PARAM_OPERACION_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: ParamOperacionEntity[]) => {
        const localItems: ParamOperacionEntity[] = (this.simulation.list(PARAM_OPERACION_LS_KEY) || [])
          .filter((a: ParamOperacionEntity) => !!a.param_op_codigo);
        const codigosLocal = new Set(localItems.map((a: ParamOperacionEntity) => a.param_op_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.param_op_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<ParamOperacionEntity> {
    return this.http.get<ParamOperacionEntity[]>(PARAM_OPERACION_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: ParamOperacionEntity[]) => {
        const localItems: ParamOperacionEntity[] = this.simulation.list(PARAM_OPERACION_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.param_op_codigo === codigo);
        if (!encontrado) throw new Error(`Parámetro con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(paramOperacion: ParamOperacionEntity): Observable<ApiResponse> {
    this.simulation.save(PARAM_OPERACION_LS_KEY, paramOperacion);
    return of({ success: true, message: 'Parámetros de operaciones guardados correctamente', data: paramOperacion })
      .pipe(delay(400));
  }

  actualizar(paramOperacion: ParamOperacionEntity): Observable<ApiResponse> {
    const todos: ParamOperacionEntity[] = this.simulation.list(PARAM_OPERACION_LS_KEY) || [];
    const idx = todos.findIndex(a => a.param_op_codigo === paramOperacion.param_op_codigo);

    if (idx !== -1) {
      todos[idx] = paramOperacion;
      this.simulation.replace(PARAM_OPERACION_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(PARAM_OPERACION_LS_KEY, paramOperacion);
    }

    return of({ success: true, message: 'Parámetros de operaciones actualizados correctamente', data: paramOperacion })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: ParamOperacionEntity[] = this.simulation.list(PARAM_OPERACION_LS_KEY) || [];
    const filtrados = todos.filter(a => a.param_op_codigo !== codigo);
    this.simulation.replace(PARAM_OPERACION_LS_KEY, filtrados);

    return of({ success: true, message: 'Parámetros de operaciones eliminados correctamente', data: null })
      .pipe(delay(400));
  }
}
