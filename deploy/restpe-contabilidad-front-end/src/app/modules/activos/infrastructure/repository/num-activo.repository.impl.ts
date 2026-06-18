import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { INumActivoRepository } from '../../domain/repositories/inum-activo.repository';
import { NumActivoEntity } from '../../domain/models/num-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const NUM_ACTIVO_JSON_PATH = 'assets/data/activo-fijo/tabla/num-activos.json';
const NUM_ACTIVO_LS_KEY    = 'numActivo';

/**
 * Implementación del repositorio de Numerador de Activos.
 * SRP: únicamente acceso y persistencia de los numeradores de activos.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class NumActivoRepositoryImpl extends INumActivoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  obtenerTodos(): Observable<NumActivoEntity[]> {
    return this.http.get<NumActivoEntity[]>(NUM_ACTIVO_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: NumActivoEntity[]) => {
        const localItems: NumActivoEntity[] = (this.simulation.list(NUM_ACTIVO_LS_KEY) || [])
          .filter((a: NumActivoEntity) => !!a.num_activo_codigo);
        const codigosLocal = new Set(localItems.map((a: NumActivoEntity) => a.num_activo_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.num_activo_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<NumActivoEntity> {
    return this.http.get<NumActivoEntity[]>(NUM_ACTIVO_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: NumActivoEntity[]) => {
        const localItems: NumActivoEntity[] = this.simulation.list(NUM_ACTIVO_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.num_activo_codigo === codigo);
        if (!encontrado) throw new Error(`Numerador con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(numActivo: NumActivoEntity): Observable<ApiResponse> {
    this.simulation.save(NUM_ACTIVO_LS_KEY, numActivo);
    return of({ success: true, message: 'Numerador de activo guardado correctamente', data: numActivo })
      .pipe(delay(400));
  }

  actualizar(numActivo: NumActivoEntity): Observable<ApiResponse> {
    const todos: NumActivoEntity[] = this.simulation.list(NUM_ACTIVO_LS_KEY) || [];
    const idx = todos.findIndex(a => a.num_activo_codigo === numActivo.num_activo_codigo);

    if (idx !== -1) {
      todos[idx] = numActivo;
      this.simulation.replace(NUM_ACTIVO_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(NUM_ACTIVO_LS_KEY, numActivo);
    }

    return of({ success: true, message: 'Numerador de activo actualizado correctamente', data: numActivo })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: NumActivoEntity[] = this.simulation.list(NUM_ACTIVO_LS_KEY) || [];
    const filtrado = todos.filter(a => a.num_activo_codigo !== codigo);
    this.simulation.replace(NUM_ACTIVO_LS_KEY, filtrado);
    return of({ success: true, message: 'Numerador de activo eliminado correctamente', data: true })
      .pipe(delay(300));
  }
}
