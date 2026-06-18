import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, switchMap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IConceptoFinancieroRepository } from '../../domain/repositories/iconcepto-financiero.repository';
import { ConceptoFinancieroEntity } from '../../domain/models/concepto-financiero.entity';
import { BackendConceptoFinanciero } from '@modules/finanzas/application/dto/finanzas-backend.types';

/** Respuesta del backend (ms-finanzas · finanzas.concepto_financiero). */
interface ConceptoFinancieroResponse {
  id: number;
  codigo: string;
  nombre: string;
  matrizContableId?: number;
  flagEstado?: string;
  activo?: boolean;
  fecCreacion?: string;
}

/** Cuerpo de creación/actualización (ConceptoFinancieroRequest): codigo + nombre + matrizContableId. */
interface ConceptoFinancieroRequest {
  codigo: string;
  nombre: string;
  matrizContableId: number | null;
}

interface ApiResp<T> {
  success: boolean;
  message?: string;
  errorCode?: string;
  data: T;
}
interface PageData<T> {
  content: T[];
}

/**
 * Conceptos financieros — CRUD real contra ms-finanzas
 * (`/api/finanzas/conceptos-financieros`). El token/tenant los inyectan los
 * interceptores. Notas del backend:
 * - GET es paginado → la lista viene en `data.content`.
 * - El Request solo acepta `codigo` + `nombre`.
 * - El estado NO va en el Request → se aplica por PATCH `/activar` · `/desactivar`.
 */
@Injectable({ providedIn: 'root' })
export class ConceptoFinancieroRepositoryImpl implements IConceptoFinancieroRepository {
  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/conceptos-financieros`;

  obtenerTodos(): Observable<ConceptoFinancieroEntity[]> {
    return this.http
      .get<
        ApiResp<PageData<ConceptoFinancieroResponse>>
      >(`${this.base}?size=1000`)
      .pipe(
        map((r) =>
          (this.unwrap(r)?.content ?? [])
            .map((c) => this.toEntity(c))
            .sort((a, b) => a.concepto_codigo.localeCompare(b.concepto_codigo)),
        ),
      );
  }

  guardar(
    concepto: ConceptoFinancieroEntity,
  ): Observable<ConceptoFinancieroEntity> {
    return this.http
      .post<
        ApiResp<ConceptoFinancieroResponse>
      >(this.base, this.toBackendEntity(concepto))
      .pipe(
        map((response) => {
          if (response.success && response.data) {
            // return this.toDomainEntity(response.data);
            return this.toEntity(response.data);
          }
          throw new Error(
            response.message || 'Error al guardar el concepto financiero',
          );
        }),
      );
  }

  actualizar(
    codigo: string,
    cambios: Partial<ConceptoFinancieroEntity>,
  ): Observable<ConceptoFinancieroEntity> {
    return this.http
      .put<
        ApiResp<ConceptoFinancieroResponse>
      >(`${this.base}/${codigo}`, this.toBackendEntity({ concepto_codigo: codigo, ...cambios } as ConceptoFinancieroEntity))
      .pipe(
        map((response) => {
          if (response.success && response.data) {
            // return this.toDomainEntity(response.data);
            return this.toEntity(response.data);
          }
          throw new Error(
            response.message || 'Error al actualizar el concepto financiero',
          );
        }),
      );
  }

  eliminar(id: number): Observable<{ success: boolean }> {
    return this.http
      .delete<ApiResp<boolean>>(`${this.base}/${id}`)
      .pipe(map((r) => ({ success: this.unwrap(r) !== false })));
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /** Aplica el estado (activo/inactivo) por PATCH si difiere del actual; el Request no lo soporta. */
  private aplicarEstado(
    c: ConceptoFinancieroResponse,
    estado?: string,
  ): Observable<ConceptoFinancieroResponse> {
    if (!estado) {
      return of(c);
    }
    const quiereActivo = estado === 'Activo' || estado === 'activo';
    const yaActivo = c.flagEstado === '1' || c.activo === true;
    if (quiereActivo === yaActivo) {
      return of(c);
    }
    const accion = quiereActivo ? 'activar' : 'desactivar';
    return this.http
      .patch<
        ApiResp<ConceptoFinancieroResponse>
      >(`${this.base}/${c.id}/${accion}`, {})
      .pipe(map((r) => this.unwrap(r)));
  }

  private toEntity(c: ConceptoFinancieroResponse): ConceptoFinancieroEntity {
    return {
      concepto_id: c.id,
      concepto_codigo: c.codigo,
      concepto_nombre: c.nombre,
      concepto_matriz_contable_id: c.matrizContableId,
      concepto_estado:
        c.flagEstado === '1' || c.activo === true ? 'Activo' : 'Inactivo',
      concepto_fecha_creacion: c.fecCreacion ?? '',
      concepto_activo: c.flagEstado === '1',
      concepto_estado_flag: c.flagEstado,
      // Campos no soportados por el backend (concepto_financiero): vacíos.
      concepto_tipo_movimiento: '',
      concepto_categoria: '',
      concepto_naturaleza_contable: '',
      concepto_cuenta_contable: '',
      concepto_origen: '',
      concepto_destino: '',
      concepto_numero_documento: '',
    };
  }

  private toBackendEntity(
    concepto: ConceptoFinancieroEntity,
  ): BackendConceptoFinanciero {
    return {
      id: concepto.concepto_id,
      codigo: concepto.concepto_codigo,
      nombre: concepto.concepto_nombre,
      matrizContableId: concepto.concepto_matriz_contable_id || 0,
      flagEstado:
        concepto.concepto_estado ||
        (concepto.concepto_estado === 'Activo' ? '1' : '0'),
      activo: concepto.concepto_activo,
      updatedBy: concepto.concepto_updated_by || '',
      createdBy: concepto.concepto_created_by || '',
      fecCreacion: concepto.concepto_fecha_creacion,
      fecModificacion: concepto.concepto_fec_modificacion,
      createdAt: concepto.concepto_created_at || null,
      updatedAt: concepto.concepto_updated_at || null,
    };
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
