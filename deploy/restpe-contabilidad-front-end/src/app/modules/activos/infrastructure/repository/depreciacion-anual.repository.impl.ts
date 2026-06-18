import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, forkJoin, delay, map } from 'rxjs';
import { IDepreciacionAnualRepository } from '../../domain/repositories/idepreciacion-anual.repository';
import { DepreciacionAnualEntity } from '../../domain/models/depreciacion-anual.entity';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';
import { ACTIVO_FIJO_JSON_PATH } from '../../constants/activo-fijo.constants';

const DEP_ANUAL_LS_KEY        = 'depreciacionAnual';
const CLASIFICACION_JSON_PATH = 'assets/data/activo-fijo/tabla/clasificacion-activos.json';
const CENTRO_COSTO_JSON_PATH  = 'assets/data/contabilidad/tablas/centro-de-costos.json';

@Injectable()
export class DepreciacionAnualRepositoryImpl extends IDepreciacionAnualRepository {

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

  /** Calcula meses transcurridos desde la fecha de inicio de depreciación */
  private calcularMesesDep(fechaInicio: string): number {
    if (!fechaInicio) return 0;
    const [dia, mes, anio] = fechaInicio.split('/').map(Number);
    const inicio = new Date(anio, mes - 1, dia);
    const hoy = new Date();
    return (hoy.getFullYear() - inicio.getFullYear()) * 12 + (hoy.getMonth() - inicio.getMonth());
  }

  /** Mapea un ActivoFijoEntity al DepreciacionAnualEntity */
  private mapToDepreciacion(
    af: ActivoFijoEntity,
    clasifMap: Record<string, string>,
    ccMap: Record<string, string>
  ): DepreciacionAnualEntity {
    const valorAdq = af.activo_fijo_valor_adquisicion || 0;
    const valorResidual = af.activo_fijo_valor_residual || 0;
    const baseDep = valorAdq - valorResidual;
    const tasaAnual = af.activo_fijo_tasa_anual || 0;
    const deprecAnual = baseDep * (tasaAnual / 100);
    const deprecMens = deprecAnual / 12;
    const deprecAcum = af.activo_fijo_depreciacion_acumulada || 0;
    const valorNeto = af.activo_fijo_valor_neto_libros || af.activo_fijo_valor_neto || 0;
    const mesesDep = this.calcularMesesDep(af.activo_fijo_fecha_inicio_depreciacion || '');
    const vidaUtil = af.activo_fijo_vida_util || 0;
    const mesesRestantes = Math.max((vidaUtil * 12) - mesesDep, 0);
    const proyeccionDep = deprecMens * mesesRestantes;

    const claseNombre = clasifMap[af.activo_fijo_clasificacion || ''] || af.activo_fijo_clasificacion || '';
    const subclaseNombre = clasifMap[af.activo_fijo_subclase || ''] || af.activo_fijo_subclase || '';

    return {
      dep_codigo:         af.activo_fijo_codigo,
      dep_descripcion:    af.activo_fijo_descripcion,
      dep_clase:          claseNombre,
      dep_subclase:       subclaseNombre,
      dep_fecha_dep:      af.activo_fijo_fecha_inicio_depreciacion || '',
      dep_valor_orig:     valorAdq,
      dep_base_dep:       baseDep,
      dep_metodo_dep:     af.activo_fijo_metodo_depreciacion || '',
      dep_tasa_anual:     `${tasaAnual}%`,
      dep_meses_dep:      `${mesesDep}`,
      dep_deprec_mens:    Math.round(deprecMens * 100) / 100,
      dep_deprec_anual:   Math.round(deprecAnual * 100) / 100,
      dep_deprec_acum:    deprecAcum,
      dep_valor_neto:     valorNeto,
      dep_proyeccion_dep: Math.round(proyeccionDep * 100) / 100,
      dep_moneda:         af.activo_fijo_moneda,
      dep_tipo_calculo:   'Contable',
      dep_centro_costo:   ccMap[af.activo_fijo_centro_costos || ''] || af.activo_fijo_centro_costos || '',
      dep_estado:         af.activo_fijo_estado,
    };
  }

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<DepreciacionAnualEntity[]> {
    return forkJoin({
      activos: this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH),
      clasificaciones: this.http.get<any[]>(CLASIFICACION_JSON_PATH),
      centrosCosto: this.http.get<any[]>(CENTRO_COSTO_JSON_PATH),
    }).pipe(
      delay(800),
      map(({ activos, clasificaciones, centrosCosto }) => {
        const clasifMap = this.buildClasifMap(clasificaciones);
        const ccMap = this.buildCCMap(centrosCosto);
        const mapped = activos.map(af => this.mapToDepreciacion(af, clasifMap, ccMap));
        const localItems: DepreciacionAnualEntity[] = (this.simulation.list(DEP_ANUAL_LS_KEY) || [])
          .filter((a: DepreciacionAnualEntity) => !!a.dep_codigo);
        const codigosLocal = new Set(localItems.map((a: DepreciacionAnualEntity) => a.dep_codigo));
        const soloJson     = mapped.filter(a => !codigosLocal.has(a.dep_codigo));
        return [...localItems, ...soloJson];
      })
    );
  }

  obtenerPorCodigo(codigo: string): Observable<DepreciacionAnualEntity> {
    return forkJoin({
      activos: this.http.get<ActivoFijoEntity[]>(ACTIVO_FIJO_JSON_PATH),
      clasificaciones: this.http.get<any[]>(CLASIFICACION_JSON_PATH),
      centrosCosto: this.http.get<any[]>(CENTRO_COSTO_JSON_PATH),
    }).pipe(
      delay(200),
      map(({ activos, clasificaciones, centrosCosto }) => {
        const clasifMap = this.buildClasifMap(clasificaciones);
        const ccMap = this.buildCCMap(centrosCosto);
        const mapped = activos.map(af => this.mapToDepreciacion(af, clasifMap, ccMap));
        const localItems: DepreciacionAnualEntity[] = this.simulation.list(DEP_ANUAL_LS_KEY) || [];
        const todos      = [...localItems, ...mapped];
        const encontrado = todos.find(a => a.dep_codigo === codigo);
        if (!encontrado) throw new Error(`Depreciación anual con código ${codigo} no encontrada`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: DepreciacionAnualEntity): Observable<ApiResponse> {
    this.simulation.save(DEP_ANUAL_LS_KEY, item);
    return of({ success: true, message: 'Depreciación anual guardada correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: DepreciacionAnualEntity): Observable<ApiResponse> {
    const todos: DepreciacionAnualEntity[] = this.simulation.list(DEP_ANUAL_LS_KEY) || [];
    const idx = todos.findIndex(a => a.dep_codigo === item.dep_codigo);

    if (idx !== -1) {
      todos[idx] = item;
      this.simulation.replace(DEP_ANUAL_LS_KEY, todos);
    } else {
      this.simulation.save(DEP_ANUAL_LS_KEY, item);
    }

    return of({ success: true, message: 'Depreciación anual actualizada correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: DepreciacionAnualEntity[] = this.simulation.list(DEP_ANUAL_LS_KEY) || [];
    const filtrados = todos.filter(a => a.dep_codigo !== codigo);
    this.simulation.replace(DEP_ANUAL_LS_KEY, filtrados);

    return of({ success: true, message: 'Depreciación anual eliminada correctamente', data: null })
      .pipe(delay(400));
  }
}
