import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map, tap } from 'rxjs';
import { IGeneracionAsientosSiniestroRepository } from '../../domain/repositories/igeneracion-asientos-siniestro.repository';
import { GeneracionAsientosSiniestroEntity } from '../../domain/models/generacion-asientos-siniestro.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

const GAS_JSON_PATH = 'assets/data/activo-fijo/tabla/generacion-asientos-siniestro.json';

@Injectable()
export class GeneracionAsientosSiniestroRepositoryImpl extends IGeneracionAsientosSiniestroRepository {

  private readonly http = inject(HttpClient);
  private memoryItems: GeneracionAsientosSiniestroEntity[] = [];

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<GeneracionAsientosSiniestroEntity[]> {
    return this.http.get<GeneracionAsientosSiniestroEntity[]>(GAS_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: GeneracionAsientosSiniestroEntity[]) => {
        const codigosMemory = new Set(this.memoryItems.map(a => a.gas_cod_siniestro));
        const soloJson = jsonItems.filter(a => !codigosMemory.has(a.gas_cod_siniestro));
        return [...this.memoryItems.slice().reverse(), ...soloJson.slice().reverse()];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosSiniestroEntity> {
    return this.http.get<GeneracionAsientosSiniestroEntity[]>(GAS_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: GeneracionAsientosSiniestroEntity[]) => {
        const todos = [...this.memoryItems, ...jsonItems];
        const encontrado = todos.find(a => a.gas_cod_siniestro === codigo);
        if (!encontrado) throw new Error(`Siniestro con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: GeneracionAsientosSiniestroEntity): Observable<ApiResponse> {
    this.memoryItems.push(item);
    return of({ success: true, message: 'Siniestro guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: GeneracionAsientosSiniestroEntity): Observable<ApiResponse> {
    const idx = this.memoryItems.findIndex(a => a.gas_cod_siniestro === item.gas_cod_siniestro);
    if (idx !== -1) {
      this.memoryItems[idx] = item;
    } else {
      this.memoryItems.push(item);
    }
    return of({ success: true, message: 'Siniestro actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    this.memoryItems = this.memoryItems.filter(a => a.gas_cod_siniestro !== codigo);
    return of({ success: true, message: 'Siniestro eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
