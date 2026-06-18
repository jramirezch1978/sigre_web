import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IAprobacionTrasladoRepository } from '../../domain/repositories/iaprobacion-traslado.repository';
import { AprobacionTrasladoEntity } from '../../domain/models/aprobacion-traslado.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const ATR_JSON_PATH = 'assets/data/activo-fijo/tabla/aprobacion-traslado.json';
const ATR_LS_KEY    = 'aprobacionTraslado';

@Injectable()
export class AprobacionTrasladoRepositoryImpl extends IAprobacionTrasladoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<AprobacionTrasladoEntity[]> {
    return this.http.get<AprobacionTrasladoEntity[]>(ATR_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: AprobacionTrasladoEntity[]) => {
        const localItems: AprobacionTrasladoEntity[] = (this.simulation.list(ATR_LS_KEY) || [])
          .filter((a: AprobacionTrasladoEntity) => !!a.id);
        const idsLocal = new Set(localItems.map((a: AprobacionTrasladoEntity) => a.id));
        const soloJson = jsonItems.filter(a => !idsLocal.has(a.id));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(id: string): Observable<AprobacionTrasladoEntity> {
    return this.http.get<AprobacionTrasladoEntity[]>(ATR_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: AprobacionTrasladoEntity[]) => {
        const localItems: AprobacionTrasladoEntity[] = this.simulation.list(ATR_LS_KEY) || [];
        const todos      = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.id === id);
        if (!encontrado) throw new Error(`Traslado con id ${id} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: AprobacionTrasladoEntity): Observable<ApiResponse> {
    this.simulation.save(ATR_LS_KEY, item);
    return of({ success: true, message: 'Traslado guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: AprobacionTrasladoEntity): Observable<ApiResponse> {
    const todos: AprobacionTrasladoEntity[] = this.simulation.list(ATR_LS_KEY) || [];
    const idx = todos.findIndex(a => a.id === item.id);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(ATR_LS_KEY, todos);
    } else {
      this.simulation.save(ATR_LS_KEY, item);
    }
    return of({ success: true, message: 'Traslado actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(id: string): Observable<ApiResponse> {
    const todos: AprobacionTrasladoEntity[] = this.simulation.list(ATR_LS_KEY) || [];
    const filtrados = todos.filter(a => a.id !== id);
    this.simulation.replace(ATR_LS_KEY, filtrados);
    return of({ success: true, message: 'Traslado eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
