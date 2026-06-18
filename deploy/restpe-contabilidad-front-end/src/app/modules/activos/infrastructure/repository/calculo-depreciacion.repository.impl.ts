import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { ICalculoDepreciacionRepository } from '../../domain/repositories/icalculo-depreciacion.repository';
import { CalculoDepreciacionEntity } from '../../domain/models/calculo-depreciacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

const CD_JSON_PATH = 'assets/data/activo-fijo/tabla/calculo-depreciacion.json';

@Injectable()
export class CalculoDepreciacionRepositoryImpl extends ICalculoDepreciacionRepository {

  private readonly http = inject(HttpClient);
  private memoryItems: CalculoDepreciacionEntity[] = [];

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<CalculoDepreciacionEntity[]> {
    return this.http.get<CalculoDepreciacionEntity[]>(CD_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: CalculoDepreciacionEntity[]) => {
        const codigosMemory = new Set(this.memoryItems.map(a => a.cd_codigo));
        const soloJson = jsonItems.filter(a => !codigosMemory.has(a.cd_codigo));
        return [...soloJson, ...this.memoryItems];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<CalculoDepreciacionEntity> {
    return this.http.get<CalculoDepreciacionEntity[]>(CD_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: CalculoDepreciacionEntity[]) => {
        const todos = [...this.memoryItems, ...jsonItems];
        const encontrado = todos.find(a => a.cd_codigo === codigo);
        if (!encontrado) throw new Error(`Cálculo de depreciación con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: CalculoDepreciacionEntity): Observable<ApiResponse> {
    this.memoryItems.push(item);
    return of({ success: true, message: 'Cálculo de depreciación guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: CalculoDepreciacionEntity): Observable<ApiResponse> {
    const idx = this.memoryItems.findIndex(a => a.cd_codigo === item.cd_codigo);
    if (idx !== -1) {
      this.memoryItems[idx] = item;
    } else {
      this.memoryItems.push(item);
    }
    return of({ success: true, message: 'Cálculo de depreciación actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    this.memoryItems = this.memoryItems.filter(a => a.cd_codigo !== codigo);
    return of({ success: true, message: 'Cálculo de depreciación eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
