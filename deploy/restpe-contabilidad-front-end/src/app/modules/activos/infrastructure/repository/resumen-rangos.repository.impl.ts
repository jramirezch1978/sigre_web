import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, forkJoin, delay, map } from 'rxjs';
import { IResumenRangosRepository } from '../../domain/repositories/iresumen-rangos.repository';
import { ResumenRangosEntity } from '../../domain/models/resumen-rangos.entity';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';
import { ACTIVO_FIJO_JSON_PATH } from '../../constants/activo-fijo.constants';

const RR_LS_KEY               = 'resumenRangos';
const CLASIFICACION_JSON_PATH = 'assets/data/activo-fijo/tabla/clasificacion-activos.json';
const CENTRO_COSTO_JSON_PATH  = 'assets/data/contabilidad/tablas/centro-de-costos.json';

@Injectable()
export class ResumenRangosRepositoryImpl extends IResumenRangosRepository {

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

  /** Mapea un ActivoFijoEntity al ResumenRangosEntity */
  private mapToRango(
    af: ActivoFijoEntity,
    clasifMap: Record<string, string>,
    ccMap: Record<string, string>
  ): ResumenRangosEntity {
    const claseNombre = clasifMap[af.activo_fijo_clasificacion || ''] || af.activo_fijo_clasificacion || '';
    const subclaseNombre = clasifMap[af.activo_fijo_subclase || ''] || af.activo_fijo_subclase || '';
    return {
      rr_codigo:       af.activo_fijo_codigo,
      rr_descripcion:  af.activo_fijo_descripcion,
      rr_clase:        [claseNombre, subclaseNombre].filter(Boolean).join(' / '),
      rr_fecha_adqui:  af.activo_fijo_fecha_adquisicion,
      rr_costo_ac:     af.activo_fijo_valor_adquisicion,
      rr_depre_ac:     af.activo_fijo_depreciacion_acumulada || 0,
      rr_valor_net:    af.activo_fijo_valor_neto_libros || af.activo_fijo_valor_neto,
      rr_ubicacion:    af.activo_fijo_ubicacion_fisica || '',
      rr_responsable:  af.activo_fijo_responsable || '',
      rr_moneda:       af.activo_fijo_moneda,
      rr_centro_costo: ccMap[af.activo_fijo_centro_costos || ''] || af.activo_fijo_centro_costos || '',
      rr_estado:       af.activo_fijo_estado,
    };
  }

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<ResumenRangosEntity[]> {
    return forkJoin({
      activos: this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH),
      clasificaciones: this.http.get<any[]>(CLASIFICACION_JSON_PATH),
      centrosCosto: this.http.get<any[]>(CENTRO_COSTO_JSON_PATH),
    }).pipe(
      delay(800),
      map(({ activos, clasificaciones, centrosCosto }) => {
        const clasifMap = this.buildClasifMap(clasificaciones);
        const ccMap = this.buildCCMap(centrosCosto);
        const mapped = activos.map(af => this.mapToRango(af, clasifMap, ccMap));
        const localItems: ResumenRangosEntity[] = (this.simulation.list(RR_LS_KEY) || [])
          .filter((a: ResumenRangosEntity) => !!a.rr_codigo);
        const codigosLocal = new Set(localItems.map((a: ResumenRangosEntity) => a.rr_codigo));
        const soloJson     = mapped.filter(a => !codigosLocal.has(a.rr_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<ResumenRangosEntity> {
    return forkJoin({
      activos: this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH),
      clasificaciones: this.http.get<any[]>(CLASIFICACION_JSON_PATH),
      centrosCosto: this.http.get<any[]>(CENTRO_COSTO_JSON_PATH),
    }).pipe(
      delay(200),
      map(({ activos, clasificaciones, centrosCosto }) => {
        const clasifMap = this.buildClasifMap(clasificaciones);
        const ccMap = this.buildCCMap(centrosCosto);
        const mapped = activos.map(af => this.mapToRango(af, clasifMap, ccMap));
        const localItems: ResumenRangosEntity[] = this.simulation.list(RR_LS_KEY) || [];
        const todos      = [...localItems, ...mapped];
        const encontrado = todos.find(a => a.rr_codigo === codigo);
        if (!encontrado) throw new Error(`Rango de activo con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: ResumenRangosEntity): Observable<ApiResponse> {
    this.simulation.save(RR_LS_KEY, item);
    return of({ success: true, message: 'Rango de activo guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: ResumenRangosEntity): Observable<ApiResponse> {
    const todos: ResumenRangosEntity[] = this.simulation.list(RR_LS_KEY) || [];
    const idx = todos.findIndex(a => a.rr_codigo === item.rr_codigo);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(RR_LS_KEY, todos);
    } else {
      this.simulation.save(RR_LS_KEY, item);
    }
    return of({ success: true, message: 'Rango de activo actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: ResumenRangosEntity[] = this.simulation.list(RR_LS_KEY) || [];
    const filtrados = todos.filter(a => a.rr_codigo !== codigo);
    this.simulation.replace(RR_LS_KEY, filtrados);
    return of({ success: true, message: 'Rango de activo eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
