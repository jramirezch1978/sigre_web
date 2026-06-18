import { Injectable, inject } from '@angular/core';
import { Observable, of, throwError } from 'rxjs';
import { map, switchMap, catchError } from 'rxjs/operators';
import { IAlmacenRepository } from '../../domain/repositories/ialmacen.repository';
import { AlmacenEntity } from '../../domain/models/almacen.entity';
import { TipoAlmacenEntity } from '../../domain/models/tipo-almacen.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { AlmacenMapper } from '../mappers/almacen.mapper';
import { ALMACEN_ENDPOINTS } from '../http/almacen-api.config';
import { BackendAlmacenResponse } from '../../application/dto/almacen-backend.types';

/**
 * Implementación de {@link IAlmacenRepository} consumiendo `ms-almacen`
 * (`/api/almacen/almacenes`) a través de {@link AlmacenHttpService}.
 *
 * El backend identifica los almacenes por `id` numérico, no por código; las
 * operaciones de actualizar/eliminar resuelven el `id` desde la entidad o, en su
 * defecto, buscándolo por código. `obtenerPorCodigo` filtra en cliente porque el
 * backend no expone búsqueda por código (solo `GET /{id}`).
 */
@Injectable({ providedIn: 'root' })
export class AlmacenRepositoryImpl implements IAlmacenRepository {

  private readonly api = inject(AlmacenHttpService);

  obtenerTodos(): Observable<AlmacenEntity[]> {
    // Filtra por la sucursal de la sesión (la elegida en el login): solo se ven
    // los almacenes de esa sucursal.
    const sucursalId = AlmacenHttpService.getSucursalId();
    return this.api
      .getList<BackendAlmacenResponse>(ALMACEN_ENDPOINTS.almacenes, { size: 1000, sort: 'id,desc' })
      .pipe(map((list) => AlmacenMapper.toEntityList(list).filter((a) => a.sucursalId === sucursalId)));
  }

  obtenerTiposAlmacen(): Observable<TipoAlmacenEntity[]> {
    return this.api
      .getList<{ id: number; codigo?: string; nombre?: string }>(ALMACEN_ENDPOINTS.almacenTipos, { size: 1000 })
      .pipe(map((list) => (list ?? []).map((t) => ({
        id: t.id,
        codigo: t.codigo ?? '',
        nombre: t.nombre ?? '',
      }))));
  }

  obtenerPorCodigo(almacen_codigo: string): Observable<AlmacenEntity> {
    return this.obtenerTodos().pipe(
      map((almacenes) => {
        const found = almacenes.find((a) => a.almacen_codigo === almacen_codigo);
        if (!found) {
          throw new Error(`Almacén con código ${almacen_codigo} no encontrado`);
        }
        return found;
      }),
    );
  }

  guardar(almacen: AlmacenEntity): Observable<ApiResponse<AlmacenEntity>> {
    return this.api
      .post<BackendAlmacenResponse>(ALMACEN_ENDPOINTS.almacenes, AlmacenMapper.toRequest(almacen))
      .pipe(
        map((res) => this.ok(res, 'El almacén se guardó correctamente')),
        catchError((e) => this.fail(e, 'Error al guardar el almacén')),
      );
  }

  actualizar(almacen: AlmacenEntity): Observable<ApiResponse<AlmacenEntity>> {
    return this.resolverId(almacen).pipe(
      switchMap((id) =>
        this.api.put<BackendAlmacenResponse>(
          `${ALMACEN_ENDPOINTS.almacenes}/${id}`,
          AlmacenMapper.toRequest(almacen),
        ),
      ),
      map((res) => this.ok(res, 'El almacén se actualizó correctamente')),
      catchError((e) => this.fail(e, 'Error al actualizar el almacén')),
    );
  }

  eliminar(almacen_codigo: string): Observable<ApiResponse<boolean>> {
    return this.resolverIdPorCodigo(almacen_codigo).pipe(
      switchMap((id) => this.api.delete<boolean>(`${ALMACEN_ENDPOINTS.almacenes}/${id}`)),
      map((data) => ({
        success: true,
        message: 'El almacén se eliminó correctamente',
        data: data ?? true,
      })),
      catchError((e) => of({
        success: false,
        message: e?.message || 'Error al eliminar el almacén',
        data: false,
      })),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  private resolverId(almacen: AlmacenEntity): Observable<number> {
    if (almacen.id != null) {
      return of(almacen.id);
    }
    return this.resolverIdPorCodigo(almacen.almacen_codigo);
  }

  private resolverIdPorCodigo(codigo: string): Observable<number> {
    return this.obtenerPorCodigo(codigo).pipe(
      switchMap((entity) =>
        entity.id != null
          ? of(entity.id)
          : throwError(() => new Error(`No se pudo resolver el id del almacén ${codigo}`)),
      ),
    );
  }

  private ok(res: BackendAlmacenResponse, message: string): ApiResponse<AlmacenEntity> {
    return { success: true, message, data: AlmacenMapper.toEntity(res) };
  }

  private fail(e: any, fallback: string): Observable<ApiResponse<AlmacenEntity>> {
    return of({ success: false, message: e?.message || fallback });
  }
}
