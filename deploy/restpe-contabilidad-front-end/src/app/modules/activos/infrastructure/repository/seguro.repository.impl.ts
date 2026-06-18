import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { ISeguroRepository } from '../../domain/repositories/iseguro.repository';
import { SeguroEntity } from '../../domain/models/seguro.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const SEGURO_JSON_PATH = 'assets/data/activo-fijo/tabla/seguros.json';
const SEGURO_LS_KEY    = 'seguro';

@Injectable()
export class SeguroRepositoryImpl extends ISeguroRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<SeguroEntity[]> {
    return this.http.get<SeguroEntity[]>(SEGURO_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: SeguroEntity[]) => {
        const localItems: SeguroEntity[] = (this.simulation.list(SEGURO_LS_KEY) || [])
          .filter((a: SeguroEntity) => !!a.seguro_codigo);
        const codigosLocal = new Set(localItems.map((a: SeguroEntity) => a.seguro_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.seguro_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<SeguroEntity> {
    return this.http.get<SeguroEntity[]>(SEGURO_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: SeguroEntity[]) => {
        const localItems: SeguroEntity[] = this.simulation.list(SEGURO_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.seguro_codigo === codigo);
        if (!encontrado) throw new Error(`Tipo de seguro con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(seguro: SeguroEntity): Observable<ApiResponse> {
    this.simulation.save(SEGURO_LS_KEY, seguro);
    return of({ success: true, message: 'Tipo de seguro guardado correctamente', data: seguro })
      .pipe(delay(400));
  }

  actualizar(seguro: SeguroEntity): Observable<ApiResponse> {
    const todos: SeguroEntity[] = this.simulation.list(SEGURO_LS_KEY) || [];
    const idx = todos.findIndex(a => a.seguro_codigo === seguro.seguro_codigo);

    if (idx !== -1) {
      todos[idx] = seguro;
      this.simulation.replace(SEGURO_LS_KEY, todos);
    } else {
      this.simulation.save(SEGURO_LS_KEY, seguro);
    }

    return of({ success: true, message: 'Tipo de seguro actualizado correctamente', data: seguro })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: SeguroEntity[] = this.simulation.list(SEGURO_LS_KEY) || [];
    const filtrados = todos.filter(a => a.seguro_codigo !== codigo);
    this.simulation.replace(SEGURO_LS_KEY, filtrados);

    return of({ success: true, message: 'Tipo de seguro eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}

