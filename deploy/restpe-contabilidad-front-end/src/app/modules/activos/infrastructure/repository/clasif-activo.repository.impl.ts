import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IClasifActivoRepository } from '../../domain/repositories/iclasif-activo.repository';
import { ClasifActivoEntity } from '../../domain/models/clasif-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const CLASIF_ACTIVO_JSON_PATH = 'assets/data/activo-fijo/tabla/clasificacion-activos.json';
const CLASIF_ACTIVO_LS_KEY    = 'clasificacionActivos';

/**
 * Implementación del repositorio de Clasificación de Activos.
 * SRP: únicamente acceso y persistencia de clasificaciones.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class ClasifActivoRepositoryImpl extends IClasifActivoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  /**
   * Devuelve todas las clasificaciones (clases + subclases):
   * 1. Datos semilla del JSON (assets) — jerarquía base.
   * 2. Registros nuevos del usuario en localStorage.
   * Los duplicados (mismo `codigo`) del JSON son ignorados si ya existen en localStorage.
   * El orden preserva la estructura árbol: clases primero, luego subclases.
   */
  obtenerTodos(): Observable<ClasifActivoEntity[]> {
    return this.http.get<ClasifActivoEntity[]>(CLASIF_ACTIVO_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: ClasifActivoEntity[]) => {
        const localItems: ClasifActivoEntity[] = (this.simulation.list(CLASIF_ACTIVO_LS_KEY) || [])
          .filter((a: ClasifActivoEntity) => !!a.clasif_activo_codigo);
        const codigosLocal = new Set(localItems.map((a: ClasifActivoEntity) => a.clasif_activo_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.clasif_activo_codigo));
        return [...soloJson, ...localItems];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<ClasifActivoEntity> {
    return this.http.get<ClasifActivoEntity[]>(CLASIF_ACTIVO_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: ClasifActivoEntity[]) => {
        const localItems: ClasifActivoEntity[] = this.simulation.list(CLASIF_ACTIVO_LS_KEY) || [];
        const todos = [...localItems, ...jsonItems];
        const encontrado = todos.find(a => a.clasif_activo_codigo === codigo);
        if (!encontrado) throw new Error(`Clasificación con código ${codigo} no encontrada`);
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(clasif: ClasifActivoEntity): Observable<ApiResponse> {
    this.simulation.save(CLASIF_ACTIVO_LS_KEY, clasif);
    return of({ success: true, message: 'Clasificación guardada correctamente', data: clasif })
      .pipe(delay(400));
  }

  actualizar(clasif: ClasifActivoEntity): Observable<ApiResponse> {
    const todos: ClasifActivoEntity[] = this.simulation.list(CLASIF_ACTIVO_LS_KEY) || [];
    const idx = todos.findIndex(a => a.clasif_activo_codigo === clasif.clasif_activo_codigo);

    if (idx !== -1) {
      todos[idx] = clasif;
      this.simulation.replace(CLASIF_ACTIVO_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(CLASIF_ACTIVO_LS_KEY, clasif);
    }

    return of({ success: true, message: 'Clasificación actualizada correctamente', data: clasif })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: ClasifActivoEntity[] = this.simulation.list(CLASIF_ACTIVO_LS_KEY) || [];
    const filtrado = todos.filter(a => a.clasif_activo_codigo !== codigo);
    this.simulation.replace(CLASIF_ACTIVO_LS_KEY, filtrado);
    return of({ success: true, message: 'Clasificación eliminada correctamente', data: true })
      .pipe(delay(300));
  }
}
