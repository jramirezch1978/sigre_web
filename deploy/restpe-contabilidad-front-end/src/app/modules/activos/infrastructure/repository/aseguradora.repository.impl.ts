import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IAseguradoraRepository } from '../../domain/repositories/iaseguradora.repository';
import { AseguradoraEntity } from '../../domain/models/aseguradora.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const ASEGURADORA_JSON_PATH = 'assets/data/activo-fijo/tabla/aseguradoras.json';
const ASEGURADORA_LS_KEY    = 'aseguradora';

/**
 * Implementación del repositorio de Aseguradoras.
 * SRP: únicamente acceso y persistencia de aseguradoras.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class AseguradoraRepositoryImpl extends IAseguradoraRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  obtenerTodos(): Observable<AseguradoraEntity[]> {
    return this.http.get<AseguradoraEntity[]>(ASEGURADORA_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: AseguradoraEntity[]) => {
        const localItems: AseguradoraEntity[] = (this.simulation.list(ASEGURADORA_LS_KEY) || [])
          .filter((a: AseguradoraEntity) => !!a.aseguradora_codigo);
        const codigosLocal = new Set(localItems.map((a: AseguradoraEntity) => a.aseguradora_codigo));
        const soloJson     = jsonItems.filter(a => !codigosLocal.has(a.aseguradora_codigo));
        const combinados   = [...localItems, ...soloJson];

        return combinados.sort((a, b) => {
          const numA = parseInt(a.aseguradora_codigo?.split('-')[1] ?? '0', 10) || 0;
          const numB = parseInt(b.aseguradora_codigo?.split('-')[1] ?? '0', 10) || 0;
          return numB - numA;
        });
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<AseguradoraEntity> {
    return this.http.get<AseguradoraEntity[]>(ASEGURADORA_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: AseguradoraEntity[]) => {
        const localItems: AseguradoraEntity[] = this.simulation.list(ASEGURADORA_LS_KEY) || [];
        const todos       = [...localItems, ...jsonItems];
        const encontrado  = todos.find(a => a.aseguradora_codigo === codigo);
        if (!encontrado) {
          throw new Error(`Aseguradora con código "${codigo}" no encontrada`);
        }
        return encontrado;
      })
    );
  }

  // ─────────────────────────────────────────────
  // Escritura (localStorage via SimulationService)
  // ─────────────────────────────────────────────

  guardar(aseguradora: AseguradoraEntity): Observable<ApiResponse<AseguradoraEntity>> {
    this.simulation.save(ASEGURADORA_LS_KEY, aseguradora);
    return of({
      success: true,
      message: 'Aseguradora guardada exitosamente',
      data: aseguradora,
    }).pipe(delay(400));
  }

  actualizar(aseguradora: AseguradoraEntity): Observable<ApiResponse<AseguradoraEntity>> {
    const localItems: AseguradoraEntity[] = this.simulation.list(ASEGURADORA_LS_KEY) || [];
    const idx = localItems.findIndex(a => a.aseguradora_codigo === aseguradora.aseguradora_codigo);

    if (idx !== -1) {
      localItems[idx] = aseguradora;
      this.simulation.replace(ASEGURADORA_LS_KEY, localItems);
    } else {
      this.simulation.save(ASEGURADORA_LS_KEY, aseguradora);
    }

    return of({
      success: true,
      message: 'Aseguradora actualizada exitosamente',
      data: aseguradora,
    }).pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    const localItems: AseguradoraEntity[] = this.simulation.list(ASEGURADORA_LS_KEY) || [];
    const filtrados = localItems.filter(a => a.aseguradora_codigo !== codigo);
    this.simulation.replace(ASEGURADORA_LS_KEY, filtrados);

    return of({
      success:  true,
      message:  'Aseguradora eliminada exitosamente',
      data:     true,
    }).pipe(delay(300));
  }
}
