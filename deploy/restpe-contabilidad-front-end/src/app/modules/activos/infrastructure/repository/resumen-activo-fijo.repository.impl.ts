import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, forkJoin, delay, map } from 'rxjs';
import { IResumenActivoFijoRepository } from '../../domain/repositories/iresumen-activo-fijo.repository';
import { ResumenActivoFijoEntity } from '../../domain/models/resumen-activo-fijo.entity';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';
import { ACTIVO_FIJO_JSON_PATH } from '../../constants/activo-fijo.constants';

const RAF_LS_KEY             = 'resumenActivoFijo';
const CLASIFICACION_JSON_PATH = 'assets/data/activo-fijo/tabla/clasificacion-activos.json';
const CENTRO_COSTO_JSON_PATH  = 'assets/data/contabilidad/tablas/centro-de-costos.json';

@Injectable()
export class ResumenActivoFijoRepositoryImpl extends IResumenActivoFijoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  /** Construye un mapa código→nombre desde el JSON de clasificaciones */
  private buildClasifMap(items: any[]): Record<string, string> {
    const mapa: Record<string, string> = {};
    for (const item of items) {
      mapa[item.clasif_activo_codigo] = item.clasif_activo_nombre;
    }
    return mapa;
  }

  /** Construye un mapa código→nombre desde el JSON de centros de costo */
  private buildCCMap(items: any[]): Record<string, string> {
    const mapa: Record<string, string> = {};
    for (const item of items) {
      mapa[item.centro_costo_codigo] = item.centro_costo_nombre;
    }
    return mapa;
  }

  /** Mapea un ActivoFijoEntity al ResumenActivoFijoEntity */
  private mapToResumen(
    af: ActivoFijoEntity,
    clasifMap: Record<string, string>,
    ccMap: Record<string, string>
  ): ResumenActivoFijoEntity {
    const claseNombre = clasifMap[af.activo_fijo_clasificacion || ''] || af.activo_fijo_clasificacion || '';
    const subclaseNombre = clasifMap[af.activo_fijo_subclase || ''] || af.activo_fijo_subclase || '';
    return {
      raf_codigo:       af.activo_fijo_codigo,
      raf_descripcion:  af.activo_fijo_descripcion,
      raf_clase:        [claseNombre, subclaseNombre].filter(Boolean).join(' / '),
      raf_ubicacion:    af.activo_fijo_ubicacion_fisica || '',
      raf_fecha_adqui:  af.activo_fijo_fecha_adquisicion,
      raf_inicio_dep:   af.activo_fijo_fecha_inicio_depreciacion || '',
      raf_valor_adqui:  af.activo_fijo_valor_adquisicion,
      raf_depre_ac:     af.activo_fijo_depreciacion_acumulada || 0,
      raf_valor_net:    af.activo_fijo_valor_neto_libros || af.activo_fijo_valor_neto,
      raf_moneda:       af.activo_fijo_moneda,
      raf_centro_costo: ccMap[af.activo_fijo_centro_costos || ''] || af.activo_fijo_centro_costos || '',
      raf_estado:       af.activo_fijo_estado,
    };
  }

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<ResumenActivoFijoEntity[]> {
    return forkJoin({
      activos: this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH),
      clasificaciones: this.http.get<any[]>(CLASIFICACION_JSON_PATH),
      centrosCosto: this.http.get<any[]>(CENTRO_COSTO_JSON_PATH),
    }).pipe(
      delay(800),
      map(({ activos, clasificaciones, centrosCosto }) => {
        const clasifMap = this.buildClasifMap(clasificaciones);
        const ccMap = this.buildCCMap(centrosCosto);
        const mapped = activos.map(af => this.mapToResumen(af, clasifMap, ccMap));
        const localItems: ResumenActivoFijoEntity[] = (this.simulation.list(RAF_LS_KEY) || [])
          .filter((a: ResumenActivoFijoEntity) => !!a.raf_codigo);
        const codigosLocal = new Set(localItems.map((a: ResumenActivoFijoEntity) => a.raf_codigo));
        const soloJson     = mapped.filter(a => !codigosLocal.has(a.raf_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<ResumenActivoFijoEntity> {
    return forkJoin({
      activos: this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH),
      clasificaciones: this.http.get<any[]>(CLASIFICACION_JSON_PATH),
      centrosCosto: this.http.get<any[]>(CENTRO_COSTO_JSON_PATH),
    }).pipe(
      delay(200),
      map(({ activos, clasificaciones, centrosCosto }) => {
        const clasifMap = this.buildClasifMap(clasificaciones);
        const ccMap = this.buildCCMap(centrosCosto);
        const mapped = activos.map(af => this.mapToResumen(af, clasifMap, ccMap));
        const localItems: ResumenActivoFijoEntity[] = this.simulation.list(RAF_LS_KEY) || [];
        const todos      = [...localItems, ...mapped];
        const encontrado = todos.find(a => a.raf_codigo === codigo);
        if (!encontrado) throw new Error(`Resumen de activo fijo con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: ResumenActivoFijoEntity): Observable<ApiResponse> {
    this.simulation.save(RAF_LS_KEY, item);
    return of({ success: true, message: 'Resumen de activo fijo guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: ResumenActivoFijoEntity): Observable<ApiResponse> {
    const todos: ResumenActivoFijoEntity[] = this.simulation.list(RAF_LS_KEY) || [];
    const idx = todos.findIndex(a => a.raf_codigo === item.raf_codigo);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(RAF_LS_KEY, todos);
    } else {
      this.simulation.save(RAF_LS_KEY, item);
    }

    return of({ success: true, message: 'Resumen de activo fijo actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: ResumenActivoFijoEntity[] = this.simulation.list(RAF_LS_KEY) || [];
    const filtrados = todos.filter(a => a.raf_codigo !== codigo);
    this.simulation.replace(RAF_LS_KEY, filtrados);

    return of({ success: true, message: 'Resumen de activo fijo eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
