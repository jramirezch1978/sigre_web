import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IAsignacionRatiosRepository } from '../../domain/repositories/iasignacion-ratios.repository';
import { AsignacionRatiosEntity } from '../../domain/models/asignacion-ratios.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const ARS_JSON_PATH = 'assets/data/activo-fijo/tabla/asignacion-ratios.json';
const ARS_LS_KEY    = 'asignacionRatios';

@Injectable()
export class AsignacionRatiosRepositoryImpl extends IAsignacionRatiosRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<AsignacionRatiosEntity[]> {
    return this.http.get<AsignacionRatiosEntity[]>(ARS_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: AsignacionRatiosEntity[]) => {
        const localItems: AsignacionRatiosEntity[] = (this.simulation.list(ARS_LS_KEY) || [])
          .filter((a: AsignacionRatiosEntity) => !!a.id);
        const idsLocal = new Set(localItems.map((a: AsignacionRatiosEntity) => a.id));
        const soloJson = jsonItems.filter(a => !idsLocal.has(a.id));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(id: string): Observable<AsignacionRatiosEntity> {
    return this.http.get<AsignacionRatiosEntity[]>(ARS_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: AsignacionRatiosEntity[]) => {
        const localItems: AsignacionRatiosEntity[] = this.simulation.list(ARS_LS_KEY) || [];
        const todos      = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.id === id);
        if (!encontrado) throw new Error(`Asignación con id ${id} no encontrada`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: AsignacionRatiosEntity): Observable<ApiResponse> {
    this.simulation.save(ARS_LS_KEY, item);
    return of({ success: true, message: 'Asignación guardada correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: AsignacionRatiosEntity): Observable<ApiResponse> {
    const todos: AsignacionRatiosEntity[] = this.simulation.list(ARS_LS_KEY) || [];
    const idx = todos.findIndex(a => a.id === item.id);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(ARS_LS_KEY, todos);
    } else {
      this.simulation.save(ARS_LS_KEY, item);
    }
    return of({ success: true, message: 'Asignación actualizada correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(id: string): Observable<ApiResponse> {
    const todos: AsignacionRatiosEntity[] = this.simulation.list(ARS_LS_KEY) || [];
    const filtrados = todos.filter(a => a.id !== id);
    this.simulation.replace(ARS_LS_KEY, filtrados);
    return of({ success: true, message: 'Asignación eliminada correctamente', data: null })
      .pipe(delay(400));
  }
}
