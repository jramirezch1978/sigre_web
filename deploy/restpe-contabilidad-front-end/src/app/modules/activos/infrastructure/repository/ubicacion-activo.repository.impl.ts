import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IUbicacionActivoRepository } from '../../domain/repositories/iubicacion-activo.repository';
import { UbicacionActivoEntity } from '../../domain/models/ubicacion-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const UBICACION_JSON_PATH = 'assets/data/activo-fijo/tabla/ubicacion-activos.json';
const UBICACION_LS_KEY    = 'ubicacionActivo';

/**
 * Implementación del repositorio de Ubicaciones de Activos Fijos.
 * SRP: únicamente acceso y persistencia de las ubicaciones.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class UbicacionActivoRepositoryImpl extends IUbicacionActivoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<UbicacionActivoEntity[]> {
    return this.http.get<UbicacionActivoEntity[]>(UBICACION_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: UbicacionActivoEntity[]) => {
        const localItems: UbicacionActivoEntity[] = (this.simulation.list(UBICACION_LS_KEY) || [])
          .filter((a: UbicacionActivoEntity) => !!a.ubic_codigo);
        const codigosLocal = new Set(localItems.map((a: UbicacionActivoEntity) => a.ubic_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.ubic_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<UbicacionActivoEntity> {
    return this.http.get<UbicacionActivoEntity[]>(UBICACION_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: UbicacionActivoEntity[]) => {
        const localItems: UbicacionActivoEntity[] = this.simulation.list(UBICACION_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.ubic_codigo === codigo);
        if (!encontrado) throw new Error(`Ubicación con código ${codigo} no encontrada`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(ubicacion: UbicacionActivoEntity): Observable<ApiResponse> {
    this.simulation.save(UBICACION_LS_KEY, ubicacion);
    return of({ success: true, message: 'Ubicación guardada correctamente', data: ubicacion })
      .pipe(delay(400));
  }

  actualizar(ubicacion: UbicacionActivoEntity): Observable<ApiResponse> {
    const todos: UbicacionActivoEntity[] = this.simulation.list(UBICACION_LS_KEY) || [];
    const idx = todos.findIndex(a => a.ubic_codigo === ubicacion.ubic_codigo);

    if (idx !== -1) {
      todos[idx] = ubicacion;
      this.simulation.replace(UBICACION_LS_KEY, todos);
    } else {
      // Viene del JSON seed — persiste como nuevo registro en localStorage
      this.simulation.save(UBICACION_LS_KEY, ubicacion);
    }

    return of({ success: true, message: 'Ubicación actualizada correctamente', data: ubicacion })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: UbicacionActivoEntity[] = this.simulation.list(UBICACION_LS_KEY) || [];
    const filtrados = todos.filter(a => a.ubic_codigo !== codigo);
    this.simulation.replace(UBICACION_LS_KEY, filtrados);

    return of({ success: true, message: 'Ubicación eliminada correctamente', data: null })
      .pipe(delay(400));
  }
}
