import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { INumTrasladoRepository } from '../../domain/repositories/inum-traslado.repository';
import { NumTrasladoEntity } from '../../domain/models/num-traslado.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const NUM_TRASLADO_JSON_PATH = 'assets/data/activo-fijo/tabla/num-traslados.json';
const NUM_TRASLADO_LS_KEY    = 'numTraslado';

/**
 * Implementación del repositorio de Numerador de Traslados.
 * SRP: únicamente acceso y persistencia de los numeradores de traslados.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class NumTrasladoRepositoryImpl extends INumTrasladoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  obtenerTodos(): Observable<NumTrasladoEntity[]> {
    return this.http.get<NumTrasladoEntity[]>(NUM_TRASLADO_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: NumTrasladoEntity[]) => {
        const localItems: NumTrasladoEntity[] = (this.simulation.list(NUM_TRASLADO_LS_KEY) || [])
          .filter((a: NumTrasladoEntity) => !!a.num_traslado_codigo);
        const codigosLocal = new Set(localItems.map((a: NumTrasladoEntity) => a.num_traslado_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.num_traslado_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<NumTrasladoEntity> {
    return this.http.get<NumTrasladoEntity[]>(NUM_TRASLADO_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: NumTrasladoEntity[]) => {
        const localItems: NumTrasladoEntity[] = this.simulation.list(NUM_TRASLADO_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.num_traslado_codigo === codigo);
        if (!encontrado) throw new Error(`Numerador de traslado con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(numTraslado: NumTrasladoEntity): Observable<ApiResponse> {
    this.simulation.save(NUM_TRASLADO_LS_KEY, numTraslado);
    return of({ success: true, message: 'Numerador de traslado guardado correctamente', data: numTraslado })
      .pipe(delay(400));
  }

  actualizar(numTraslado: NumTrasladoEntity): Observable<ApiResponse> {
    const todos: NumTrasladoEntity[] = this.simulation.list(NUM_TRASLADO_LS_KEY) || [];
    const idx = todos.findIndex(a => a.num_traslado_codigo === numTraslado.num_traslado_codigo);

    if (idx !== -1) {
      todos[idx] = numTraslado;
      this.simulation.replace(NUM_TRASLADO_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(NUM_TRASLADO_LS_KEY, numTraslado);
    }

    return of({ success: true, message: 'Numerador de traslado actualizado correctamente', data: numTraslado })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: NumTrasladoEntity[] = this.simulation.list(NUM_TRASLADO_LS_KEY) || [];
    const filtrado = todos.filter(a => a.num_traslado_codigo !== codigo);
    this.simulation.replace(NUM_TRASLADO_LS_KEY, filtrado);
    return of({ success: true, message: 'Numerador de traslado eliminado correctamente', data: true })
      .pipe(delay(300));
  }
}
