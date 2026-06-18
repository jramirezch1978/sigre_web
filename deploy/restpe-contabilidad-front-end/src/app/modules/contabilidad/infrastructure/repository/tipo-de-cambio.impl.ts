import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, forkJoin } from 'rxjs';
import { map, switchMap, catchError } from 'rxjs/operators';
import { ITipoDeCambioRepository } from '../../domain/repositories/itipo-de-cambio.repository';
import { TipoDeCambioEntity } from '../../domain/models/tipo-de-cambio.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { environment } from 'src/environments/environment';

interface BackendResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }
interface PageData<T> { content: T[]; }
interface BackendTipoCambio { id?: number; monedaId: number; fecha: string; compra: number; venta: number; flagEstado?: string; }
interface BackendMoneda { id: number; codigo: string; nombre: string; }

/**
 * Repositorio de Tipo de Cambio — consume el backend real `ms-core-maestros`
 * (`/api/core/tipos-cambio`). Mapea entre el modelo del front (moneda por nombre
 * "Dólar"/"Euro", fechas DD/MM/YYYY, estado Activo/Inactivo) y el contrato del
 * backend (monedaId, fecha ISO, flagEstado). La moneda se resuelve por código
 * SUNAT (USD/EUR) contra el catálogo real `/api/core/monedas`.
 */
@Injectable()
export class TipoDeCambioRepositoryImpl implements ITipoDeCambioRepository {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/core`;

  private readonly NOMBRE_A_CODIGO: Record<string, string> = { 'Dólar': 'USD', 'Dolar': 'USD', 'Euro': 'EUR' };
  private readonly CODIGO_A_NOMBRE: Record<string, string> = { USD: 'Dólar', EUR: 'Euro' };

  obtenerTodos(): Observable<TipoDeCambioEntity[]> {
    return forkJoin({
      tc: this.http.get<BackendResp<PageData<BackendTipoCambio>>>(`${this.base}/tipos-cambio?size=1000&sort=fecha,desc`),
      mon: this.http.get<BackendResp<PageData<BackendMoneda>>>(`${this.base}/monedas?size=100`),
    }).pipe(
      map(({ tc, mon }) => {
        const monedas = mon?.data?.content ?? [];
        return (tc?.data?.content ?? []).map((r) => this.toEntity(r, monedas));
      }),
      catchError(() => of([])),
    );
  }

  guardar(item: TipoDeCambioEntity): Observable<ApiResponse<TipoDeCambioEntity>> {
    return this.conMonedas((monedas) =>
      this.http
        .post<BackendResp<BackendTipoCambio>>(`${this.base}/tipos-cambio`, this.toRequest(item, monedas))
        .pipe(map((r) => this.toApiResponse(r, monedas, 'Tipo de cambio registrado correctamente'))),
    );
  }

  actualizar(item: TipoDeCambioEntity): Observable<ApiResponse<TipoDeCambioEntity>> {
    const id = item.id;
    if (!id) {
      return of({ success: false, message: 'No se pudo determinar el id del tipo de cambio a actualizar' } as ApiResponse<TipoDeCambioEntity>);
    }
    // El PUT solo actualiza moneda/fecha/compra/venta; el estado se cambia con
    // los endpoints dedicados activar/desactivar. Por eso, tras el PUT, se
    // sincroniza el estado y se devuelve esa respuesta (trae el flagEstado real).
    const accionEstado = item.tipo_cambio_estado === 'Inactivo' ? 'desactivar' : 'activar';
    return this.conMonedas((monedas) =>
      this.http
        .put<BackendResp<BackendTipoCambio>>(`${this.base}/tipos-cambio/${id}`, this.toRequest(item, monedas))
        .pipe(
          switchMap((putResp) => {
            if (putResp && putResp.success === false) {
              throw new Error(putResp.message || putResp.errorCode || 'Error del servidor');
            }
            return this.http
              .patch<BackendResp<BackendTipoCambio>>(`${this.base}/tipos-cambio/${id}/${accionEstado}`, {})
              .pipe(map((patchResp) => this.toApiResponse(patchResp, monedas, 'Tipo de cambio actualizado correctamente')));
          }),
        ),
    );
  }

  eliminar(id: number): Observable<ApiResponse<boolean>> {
    if (!id) {
      return of({ success: false, message: 'No se pudo determinar el id del tipo de cambio a eliminar' } as ApiResponse<boolean>);
    }
    return this.http
      .delete<BackendResp<boolean>>(`${this.base}/tipos-cambio/${id}`)
      .pipe(
        map((r) => {
          if (r && r.success === false) {
            throw new Error(r.message || r.errorCode || 'Error del servidor');
          }
          return { success: true, message: r?.message || 'Tipo de cambio eliminado correctamente', data: true };
        }),
      );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  private conMonedas<T>(fn: (m: BackendMoneda[]) => Observable<T>): Observable<T> {
    return this.http
      .get<BackendResp<PageData<BackendMoneda>>>(`${this.base}/monedas?size=100`)
      .pipe(switchMap((r) => fn(r?.data?.content ?? [])));
  }

  private toEntity(r: BackendTipoCambio, monedas: BackendMoneda[]): TipoDeCambioEntity {
    const fecha = this.aDmy(r.fecha);
    const codigo = monedas.find((m) => m.id === r.monedaId)?.codigo ?? '';
    return {
      id: r.id,
      tipo_cambio_fecha_registro: fecha,
      tipo_cambio_fecha_vigencia: fecha,
      tipo_cambio_moneda: this.CODIGO_A_NOMBRE[codigo] ?? codigo,
      tipo_cambio_tc_compra: Number(r.compra),
      tipo_cambio_tc_venta: Number(r.venta),
      tipo_cambio_estado: r.flagEstado === '0' ? 'Inactivo' : 'Activo',
    };
  }

  private toRequest(item: TipoDeCambioEntity, monedas: BackendMoneda[]): BackendTipoCambio {
    const codigo = this.NOMBRE_A_CODIGO[item.tipo_cambio_moneda] ?? 'USD';
    const monedaId = monedas.find((m) => m.codigo === codigo)?.id ?? monedas[0]?.id ?? 0;
    return {
      monedaId,
      fecha: this.aIso(item.tipo_cambio_fecha_vigencia || item.tipo_cambio_fecha_registro),
      compra: Number(item.tipo_cambio_tc_compra),
      venta: Number(item.tipo_cambio_tc_venta),
    };
  }

  private toApiResponse(r: BackendResp<BackendTipoCambio>, monedas: BackendMoneda[], msg: string): ApiResponse<TipoDeCambioEntity> {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return { success: true, message: msg, data: this.toEntity(r.data, monedas) };
  }

  /** ISO (YYYY-MM-DD) → DD/MM/YYYY */
  private aDmy(iso: string): string {
    if (!iso) { return ''; }
    const [y, m, d] = iso.split('T')[0].split('-');
    return `${d}/${m}/${y}`;
  }

  /** DD/MM/YYYY → ISO (YYYY-MM-DD) */
  private aIso(dmy: string): string {
    if (!dmy) { return ''; }
    if (dmy.includes('-')) { return dmy.split('T')[0]; }
    const [d, m, y] = dmy.split('/');
    return `${y}-${(m || '').padStart(2, '0')}-${(d || '').padStart(2, '0')}`;
  }
}
