import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IGeneracionAsientosIndexacionRepository } from '../../domain/repositories/igeneracion-asientos-indexacion.repository';
import { GeneracionAsientosIndexacionEntity } from '../../domain/models/generacion-asientos-indexacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const GAI_JSON_PATH = 'assets/data/activo-fijo/tabla/generacion-asientos-indexacion.json';
const GAI_LS_KEY    = 'generacionAsientosIndexacion';

@Injectable()
export class GeneracionAsientosIndexacionRepositoryImpl extends IGeneracionAsientosIndexacionRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<GeneracionAsientosIndexacionEntity[]> {
    return this.http.get<GeneracionAsientosIndexacionEntity[]>(GAI_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: GeneracionAsientosIndexacionEntity[]) => {
        const localItems: GeneracionAsientosIndexacionEntity[] = (this.simulation.list(GAI_LS_KEY) || [])
          .filter((a: GeneracionAsientosIndexacionEntity) => !!a.gai_codigo);
        const codigosLocal = new Set(localItems.map((a: GeneracionAsientosIndexacionEntity) => a.gai_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.gai_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosIndexacionEntity> {
    return this.http.get<GeneracionAsientosIndexacionEntity[]>(GAI_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: GeneracionAsientosIndexacionEntity[]) => {
        const localItems: GeneracionAsientosIndexacionEntity[] = this.simulation.list(GAI_LS_KEY) || [];
        const todos      = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.gai_codigo === codigo);
        if (!encontrado) throw new Error(`Asiento de indexación con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: GeneracionAsientosIndexacionEntity): Observable<ApiResponse> {
    this.simulation.save(GAI_LS_KEY, item);
    return of({ success: true, message: 'Asiento de indexación guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: GeneracionAsientosIndexacionEntity): Observable<ApiResponse> {
    const todos: GeneracionAsientosIndexacionEntity[] = this.simulation.list(GAI_LS_KEY) || [];
    const idx = todos.findIndex(a => a.gai_codigo === item.gai_codigo);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(GAI_LS_KEY, todos);
    } else {
      this.simulation.save(GAI_LS_KEY, item);
    }
    return of({ success: true, message: 'Asiento de indexación actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: GeneracionAsientosIndexacionEntity[] = this.simulation.list(GAI_LS_KEY) || [];
    const filtrados = todos.filter(a => a.gai_codigo !== codigo);
    this.simulation.replace(GAI_LS_KEY, filtrados);
    return of({ success: true, message: 'Asiento de indexación eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
