import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IGeneracionAsientosDepreciacionRepository } from '../../domain/repositories/igeneracion-asientos-depreciacion.repository';
import { GeneracionAsientosDepreciacionEntity } from '../../domain/models/generacion-asientos-depreciacion.entity';
import { CalculoDepreciacionEntity } from '../../domain/models/calculo-depreciacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';

const CD_JSON_PATH  = 'assets/data/activo-fijo/tabla/calculo-depreciacion.json';
const GAD_LS_KEY    = 'generacionAsientosDepreciacion';

@Injectable()
export class GeneracionAsientosDepreciacionRepositoryImpl extends IGeneracionAsientosDepreciacionRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  /** Mapea un CalculoDepreciacionEntity a GeneracionAsientosDepreciacionEntity */
  private mapearCalculo(c: CalculoDepreciacionEntity): GeneracionAsientosDepreciacionEntity {
    const activos = c.cd_activos || [];
    return {
      id:                    c.id,
      gad_codigo:            c.cd_codigo,
      gad_periodo:           c.cd_periodo,
      gad_fecha_ejecucion:   c.cd_fecha_ejecucion,
      gad_usuario_resp:      c.cd_usuario,
      gad_activos:           activos.length,
      gad_moneda:            'Soles',
      gad_libro:             1,
      gad_dpc_total:         activos.reduce((sum: number, a: any) => sum + (a.dpcPeriodo || 0), 0),
      gad_valor_cont:        activos.reduce((sum: number, a: any) => sum + (a.costoadquisicion || 0), 0),
      gad_nro_asiento_cont:  c.cd_nro_asiento_cont || '',
      gad_estado:            c.cd_estado || 'Pendiente',
      gad_tipo_calculo:      c.cd_tipo_calculo,
      gad_tipo_depreciacion: c.cd_tipo_depreciacion,
      gad_metodo_calculo:    c.cd_metodo_calculo,
      gad_fecha_contabilizacion: c.cd_fecha_contabilizacion || '',
      gad_prefijo_doc:       c.cd_prefijo_doc || '',
      gad_observaciones:     c.cd_observaciones || '',
    };
  }

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<GeneracionAsientosDepreciacionEntity[]> {
    return this.http.get<CalculoDepreciacionEntity[]>(CD_JSON_PATH).pipe(
      delay(800),
      map((jsonItems: CalculoDepreciacionEntity[]) => {
        const fromJson = jsonItems.map(c => this.mapearCalculo(c));
        const localItems: GeneracionAsientosDepreciacionEntity[] = (this.simulation.list(GAD_LS_KEY) || [])
          .filter((a: GeneracionAsientosDepreciacionEntity) => !!a.gad_codigo);
        const codigosLocal = new Set(localItems.map(a => a.gad_codigo));
        const soloJson     = fromJson.filter(a => !codigosLocal.has(a.gad_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosDepreciacionEntity> {
    return this.http.get<CalculoDepreciacionEntity[]>(CD_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: CalculoDepreciacionEntity[]) => {
        const localItems: GeneracionAsientosDepreciacionEntity[] = this.simulation.list(GAD_LS_KEY) || [];
        const enLocal = localItems.find(a => a.gad_codigo === codigo);
        if (enLocal) return enLocal;
        const fromJson = jsonItems.map(c => this.mapearCalculo(c));
        const encontrado = fromJson.find(a => a.gad_codigo === codigo);
        if (!encontrado) throw new Error(`Asiento de depreciación con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: GeneracionAsientosDepreciacionEntity): Observable<ApiResponse> {
    this.simulation.save(GAD_LS_KEY, item);
    return of({ success: true, message: 'Asiento de depreciación guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: GeneracionAsientosDepreciacionEntity): Observable<ApiResponse> {
    const todos: GeneracionAsientosDepreciacionEntity[] = this.simulation.list(GAD_LS_KEY) || [];
    const idx = todos.findIndex(a => a.gad_codigo === item.gad_codigo);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(GAD_LS_KEY, todos);
    } else {
      this.simulation.save(GAD_LS_KEY, item);
    }
    return of({ success: true, message: 'Asiento de depreciación actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: GeneracionAsientosDepreciacionEntity[] = this.simulation.list(GAD_LS_KEY) || [];
    const filtrados = todos.filter(a => a.gad_codigo !== codigo);
    this.simulation.replace(GAD_LS_KEY, filtrados);
    return of({ success: true, message: 'Asiento de depreciación eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
