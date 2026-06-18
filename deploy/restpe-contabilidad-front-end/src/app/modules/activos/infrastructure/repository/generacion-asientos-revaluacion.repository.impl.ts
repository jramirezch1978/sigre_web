import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IGeneracionAsientosRevaluacionRepository } from '../../domain/repositories/igeneracion-asientos-revaluacion.repository';
import { GeneracionAsientosRevaluacionEntity } from '../../domain/models/generacion-asientos-revaluacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const GAR_JSON_PATH = 'assets/data/activo-fijo/tabla/generacion-asientos-revaluacion.json';
const GAR_LS_KEY    = 'generacionAsientosRevaluacion';

@Injectable()
export class GeneracionAsientosRevaluacionRepositoryImpl extends IGeneracionAsientosRevaluacionRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<GeneracionAsientosRevaluacionEntity[]> {
    return this.http.get<GeneracionAsientosRevaluacionEntity[]>(GAR_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: GeneracionAsientosRevaluacionEntity[]) => {
        const localItems: GeneracionAsientosRevaluacionEntity[] = (this.simulation.list(GAR_LS_KEY) || [])
          .filter((a: GeneracionAsientosRevaluacionEntity) => !!a.gar_codigo);
        const codigosLocal = new Set(localItems.map((a: GeneracionAsientosRevaluacionEntity) => a.gar_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.gar_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosRevaluacionEntity> {
    return this.http.get<GeneracionAsientosRevaluacionEntity[]>(GAR_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: GeneracionAsientosRevaluacionEntity[]) => {
        const localItems: GeneracionAsientosRevaluacionEntity[] = this.simulation.list(GAR_LS_KEY) || [];
        const todos      = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.gar_codigo === codigo);
        if (!encontrado) throw new Error(`Asiento de revaluación con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: GeneracionAsientosRevaluacionEntity): Observable<ApiResponse> {
    this.simulation.save(GAR_LS_KEY, item);
    return of({ success: true, message: 'Asiento de revaluación guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: GeneracionAsientosRevaluacionEntity): Observable<ApiResponse> {
    const todos: GeneracionAsientosRevaluacionEntity[] = this.simulation.list(GAR_LS_KEY) || [];
    const idx = todos.findIndex(a => a.gar_codigo === item.gar_codigo);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(GAR_LS_KEY, todos);
    } else {
      this.simulation.save(GAR_LS_KEY, item);
    }
    return of({ success: true, message: 'Asiento de revaluación actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: GeneracionAsientosRevaluacionEntity[] = this.simulation.list(GAR_LS_KEY) || [];
    const filtrados = todos.filter(a => a.gar_codigo !== codigo);
    this.simulation.replace(GAR_LS_KEY, filtrados);
    return of({ success: true, message: 'Asiento de revaluación eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
